//
//  OTP.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 15/01/2026.
//

import SwiftUI

struct OTP: View {

    let userDetails: UserInformation
    @Namespace private var resendCodeNS
    
    @Namespace private var navigatateToHomepageNS
    @State private var navigateToHomepage: Bool = false
    
    @State private var showNotification: Bool = false
    @State private var expandBanner: Bool = false
    @State private var contentHeight: CGFloat = 0
    @State private var thereIsError: Bool = false
    @State private var OTPCodes : [String] = ["", "", "", ""]
    @State private var buttonIsLoading : Bool = false
    @State private var OTPAttempts : Int = 0
    @State private var remainingTime : Int = 10 // for the timer
    
    @State private var resetTimer = UUID()
    @State private var newCodeSent : Bool = false
    @State private var isCountingDown = false

    
    @FocusState private var focusedField: Int?
    
    let usedOTPCodes : [[String]] = [
        ["1", "2", "3", "4"],
        ["9", "8", "7", "6"],
        ["0", "0", "0", "0"],
        ["5", "5", "5", "5"]
    ]

    var body: some View {
        GeometryReader { geo in
                VStack(alignment: .leading, spacing: 16) {
                    if showNotification {
                        HStack(alignment: .top) {
                            Image(systemName: "person.fill.checkmark")
                                .foregroundStyle(Color(hex: "00C000"))
                            Text(
                                "Account named '\(Text(userDetails.username).bold())' found."
                            )
                            .foregroundStyle(BrandColors.Gray1000)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .frame(width: geo.size.width, alignment: .leading)
                        .background(.green.opacity(0.2))
                        .background(
                            GeometryReader { reader in
                                Color.clear
                                    .onAppear { contentHeight = reader.size.height }
                                    .onChange(of: reader.size.height) {
                                        _,
                                        newValue in
                                        contentHeight = newValue
                                    }
                            }
                        )
                        .frame(height: expandBanner ? contentHeight : 0)
                        .clipped()
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(.green)
                                .frame(width: 4)
                        }
                        .onAppear {
                            withAnimation {
                                expandBanner = true
                            }
                        }
                    }
                    
                    VStack(alignment: .leading, spacing: 24) { // main stack
                        Text(
                            "Enter the code sent to \(Text("`...nn@gmail.com`").bold().foregroundStyle(BrandColors.Gray400)) to continue."
                        )
                        .font(.system(size: 28, weight: .bold))
                        .kerning(-0.5)
                        
                        countdownTimer(countdown: $remainingTime)
                        
                        HStack {
                            ForEach(0..<4, id: \.self) { index in
                                TextField("•", text: $OTPCodes[index])
                                    .customRoundedTextField(state: thereIsError ? .error(message: "") : .base(message: ""), height: 88, cornerRadius: 24, strokeWidth: 4, showSymbol: false)
                                    .font(.title.bold())
                                    .keyboardType(.numberPad)
                                    .frame(width: 72)
                                    .multilineTextAlignment(.center)
                                    .monospaced()
                                    .focused($focusedField, equals: index)
                                    .onChange(of: OTPCodes[index]) { oldValue, newValue in
                                        handleInput(at: index, oldValue: oldValue, newValue: newValue)
                                        thereIsError = false
                                    }
                            }
                        }
                        
                        // error banner
                        if thereIsError {
                            // too many OTP attempts
                            if OTPAttempts >= 3 {
                                HStack(alignment: .top) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                    Text("You've entered the wrong code multiple tiems. Try resending the code.")
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(.red)
                                .transition(.move(edge: .top).combined(with: .blurReplace))
                            } else {
                                HStack(alignment: .top) {
                                    Image(systemName: "exclamationmark.circle.fill")
                                    Text("This code is incorrect. Check your email and try again")
                                        .fontWeight(.semibold)
                                }
                                .foregroundStyle(.red)
                                .transition(.move(edge: .top).combined(with: .blurReplace))
                            }
                            
                        }
                        
                        Button {
                            handleOTPSubmission()
                        } label: {
                            if buttonIsLoading {
                                ProgressView()
                                    .tint(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                            } else {
                                Text("Continue")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                
                            }
                        }
                        .buttonStyle(.glassProminent)
                        .disabled(OTPCodes.contains("") ? true : false)
                        .matchedTransitionSource(id: "homepage", in: navigatateToHomepageNS)
                        .navigationDestination(isPresented: $navigateToHomepage) {
                            MainAuthHomepage()
                                .navigationTransition(.zoom(sourceID: "homepage", in: navigatateToHomepageNS))
                        }
                    }
                    .padding(.horizontal, 20)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onAppear {
                        focusedField = 0
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .gesture(
                    DragGesture()
                        .onChanged { _ in
                            // Intercept and do nothing - blocks the system gesture and therefore the swipe/slide to dismiss interactions
                            // feels kinda hacky though
                        }
                )
                .animation(.easeOut, value: OTPCodes)
                .onAppear {
                    Task {
                        try? await Task.sleep(for: .seconds(0.3))
                        showNotification = true
                    }
                }
                .background {
                    ZStack {
                        BrandColors.Gray0
                            .ignoresSafeArea()
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                // prevents slide interaction on any extra space
                            }
                    )
                }
        }
        .navigationBarBackButtonHidden()
        .animation(.smooth, value: showNotification)
        .animation(.easeOut, value: thereIsError)
        .animation(.easeOut, value: OTPAttempts)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8), value: remainingTime)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8), value: newCodeSent)
    }
    
    
    @ViewBuilder
    func countdownTimer (countdown: Binding<Int>) -> some View {
        var timeElapsed: Bool {
            return countdown.wrappedValue == 0
        }
        
        var timerLabel : String {
            guard !newCodeSent else {
                return "We've sent another code"
            }
            return !timeElapsed ? "You can ask for another code in" : "Didn't get the code?"
        }
        
        GlassEffectContainer(spacing: 24) {
            HStack {
                HStack(spacing: 8) {
                    if newCodeSent {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(BrandColors.Gray0)
                            .transition(.move(edge: .leading).combined(with: .blurReplace))
                    }
                    
                    Text(timerLabel)
                        .contentTransition(.interpolate)
                        .foregroundStyle(newCodeSent ? BrandColors.Gray0 : BrandColors.Gray500)
                        .fixedSize(horizontal: true, vertical: false)
                        .fontWeight(newCodeSent ? .semibold : .regular)
                    
                    if !timeElapsed && !newCodeSent {
                        Text("\(countdown.wrappedValue)s")
                            .fontWeight(.bold)
                            .contentTransition(.numericText())
                            .transition(.blurReplace)
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .glassEffect(.regular.tint(newCodeSent ? .green : BrandColors.Gray0))
                
                if timeElapsed && !newCodeSent {
                    Button("Resend") {
                        countdown.wrappedValue = 10
                        resetTimer = UUID()
                        newCodeSent = true
                    }
                    .fixedSize(horizontal: true, vertical: false)
                    .buttonStyle(.glassProminent)
                    .tint(BrandColors.Gray0)
                    .foregroundStyle(BrandColors.Gray700)
                    .transition(.blurReplace)
                    .fontWeight(.semibold)
                    .disabled(isCountingDown)
                }
            }
        }
        .task(id: resetTimer) {
            guard !isCountingDown, countdown.wrappedValue > 0 else { return }
            
            // before the timer
            isCountingDown = true
            
            while countdown.wrappedValue > 0 {
                try? await Task.sleep(for: .seconds(1))
                countdown.wrappedValue -= 1
            }
            
            // after the timer
            isCountingDown = false
        }
        .task(id: newCodeSent) {
            if newCodeSent == true {
                try? await Task.sleep(for: .seconds(4))
                newCodeSent = false
            }
        }
    }
    
    func handleInput(at index: Int, oldValue: String, newValue: String) {
        // Only allow single digit
        if newValue.count > 1 {
            OTPCodes[index] = String(newValue.last ?? Character(""))
        }
        
        // Auto-advance to next field
        if !newValue.isEmpty && index < 5 {
            focusedField = index + 1
        }
        
        // Handle backspace (move to previous field)
        // if the new value you entered is empty
        // and there was an old value (the count was == 1)
        if newValue.isEmpty && oldValue.count == 1 && index > 0 {
            focusedField = index - 1
        }
    }
    
    func handleOTPSubmission() {
        if usedOTPCodes.contains(OTPCodes) {
            buttonIsLoading = true
            thereIsError = false
            Task {
                try? await Task.sleep(for: .seconds(1))
                thereIsError = true
                buttonIsLoading = false
                OTPAttempts += 1
            }
        } else {
            buttonIsLoading = true
            Task {
                try? await Task.sleep(for: .seconds(2))
                buttonIsLoading = false
                navigateToHomepage = true
            }
        }
    }
}

#Preview {
    OTP(userDetails: .init(username: "gdwn__", password: "123456"))
}


struct OTPdata {
    var OTP : [String]
}

