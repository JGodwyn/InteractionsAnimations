//
//  OTP.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 15/01/2026.
//

import SwiftUI

struct OTP: View {

    let userDetails: UserInformation
    
    @State private var showNotification: Bool = false
    @State private var expandBanner: Bool = false
    @State private var contentHeight: CGFloat = 0
    @State private var thereIsError: Bool = false
    @State private var OTPCodes : [String] = ["", "", "", ""]
    @State private var buttonIsLoading : Bool = false
    
    @FocusState private var focusedField: Int?
    
    let usedOTPCodes : [[String]] = [
        ["1", "2", "3", "4"],
        ["9", "8", "7", "6"],
        ["0", "0", "0", "0"],
        ["5", "5", "5", "5"]
    ]
    
    // if they enter the wrong code 3 times
    // expand the error and tell them to resend

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
                    
                    // error message
                    if thereIsError {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                            Text("This code is incorrect. Try again")
                                .fontWeight(.semibold)
                        }
                        .foregroundStyle(.red)
                        .transition(.move(edge: .top).combined(with: .blurReplace))
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

                    
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .leading)
                .onAppear {
                    focusedField = 0
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .animation(.easeOut, value: OTPCodes)
            .onAppear {
                Task {
                    try? await Task.sleep(for: .seconds(0.3))
                    showNotification = true
                }
            }
        }
        .navigationBarBackButtonHidden()
        .animation(.smooth, value: showNotification)
        .animation(.easeOut, value: thereIsError)
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
            Task {
                try? await Task.sleep(for: .seconds(1))
                thereIsError = true
                buttonIsLoading = false
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
