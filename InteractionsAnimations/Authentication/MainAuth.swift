//
//  MainAuth.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 12/01/2026.
//

import SwiftUI

struct MainAuth: View {
    
    @Namespace private var expandDropdownNS
    @Namespace private var navigateToOTPNS
    @FocusState private var focusState: focusFields?
    
    @State private var userDetails : UserInformation = .defaultValue
    @State private var secureText : Bool = true
    @State private var expandDropdown : Bool = false
    @State private var selectedCountry : Country?
    @State private var searchQuery : String = ""
    @State private var expandOption : Bool = true
    @State private var navigateToOTP : Bool = false
    @State private var checkingFormDetails : Bool = false
    @State private var isKeyboardVisible : Bool = false
    
    
    enum focusFields {
        case username, password
    }
    
    let symbolSet = CharacterSet.punctuationCharacters.union(.symbols)

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                    if expandDropdown || !isKeyboardVisible {
                        Spacer()
                    }
                Rectangle().fill(.clear)
                    .frame(height: isKeyboardVisible ? 120 : 0)
                
                    VStack(alignment: .leading, spacing: 16) {
                        logo
                            .wiggle(trigger: userDetails)
                        
                        Text("Enter your information to continue")
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.system(size: 32, weight: .bold))
                            .kerning(-0.5)
                        
                        // input fields
                        TextField("Username", text: $userDetails.username)
                            .customRoundedTextField(state: handleUsername(), height: 56, strokeWidth: 3)
                            .textInputAutocapitalization(.never)
                            .onChange(of: userDetails.username) {
                                userDetails.username = userDetails.username.filter {
                                    !$0.isWhitespace
                                }
                            }
                            .focused($focusState, equals: .username)
                        
                        Group {
                            ZStack {
                                if secureText {
                                    SecureField("Password", text: $userDetails.password)
                                        .frame(height: 24)
                                } else {
                                    TextField("Password", text: $userDetails.password)
                                        .frame(height: 24)
                                }
                            }
                            .overlay(alignment: .trailing) {
                                // show and hide password
                                Image(systemName: secureText ? "eyebrow" : "eye.fill")
                                    .foregroundStyle(.gray)
                                    .frame(width: 48, height: 36)
                                    .glassEffect(.clear.interactive())
                                    .offset(x: 8)
                                    .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp)))
                                    .onTapGesture {
                                        withAnimation(.smooth(duration: 0.2)) {
                                            secureText.toggle()
                                        }
                                    }
                            }
                        }
                        .customRoundedTextField(state: handlePassword(), height: 56, strokeWidth: 3, showSymbol: false)
                        .focused($focusState, equals: .password)
                        .textInputAutocapitalization(.never)
                        
                        passwordCriteriaView()
                        
                        if !expandDropdown {
                            HStack {
                                HStack {
                                    Image(systemName: "globe")
                                    Text("Where are you?")
                                }
                                .foregroundStyle(.gray)
                                Spacer()
                                
                                if let selectCountry = selectedCountry {
                                    Text(selectCountry.rawValue)
                                        .bold()
                                } else {
                                    HStack {
                                        Text("Select country")
                                    }
                                    .foregroundStyle(BrandColors.Gray300)
                                    
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 24)
                            .padding()
                            .padding(.trailing, 4)
                            .background(BrandColors.Gray100, in: .rect(cornerRadius: .infinity, style: .continuous))
                            .matchedGeometryEffect(id: "expandDropdown", in: expandDropdownNS, properties: .position)
                            .onTapGesture {
                                expandDropdown = true
                                isKeyboardVisible = false
                                focusState = nil
                            }
                            .transition(.blurReplace.combined(with: .opacity))
                        }
                        
                        Button {
                            handleFormSubmission()
                        } label: {
                            if !checkingFormDetails {
                                Text("Continue")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                            } else {
                                ProgressView()
                                    .tint(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                            }
                        }
                        .buttonStyle(.glassProminent)
                        .disabled(buttonState)
                        .matchedTransitionSource(id: "OTPScreen", in: navigateToOTPNS)
                        .navigationDestination(isPresented: $navigateToOTP) {
                            OTP(userDetails: userDetails)
                                .navigationTransition(.zoom(sourceID: "OTPScreen", in: navigateToOTPNS))
                        }
                        
                        Button("Fill all information") {
                            userDetails.username = "Godwin John"
                            userDetails.password = "John#123"
                            selectedCountry = .nigeria
                        }
                        .buttonStyle(.glassProminent)
                    }
                    .padding()
                
                    Spacer()
                
            }
            .frame(maxHeight: .infinity)
            .overlay {
                if expandDropdown {
                    dropdownContent
                        .scrollDismissesKeyboard(.interactively)
                }
            }
            .animation(.smooth, value: userDetails)
            .animation(.smooth(duration: 0.3), value: countriesArray)
            .animation(.easeInOut(duration: 0.3), value: expandDropdown)
            .animation(.easeInOut(duration: 0.3), value: isKeyboardVisible)
            .animation(.easeInOut(duration: 0.3), value: checkingFormDetails)
            .onAppear {
                userDetails = .defaultValue
                selectedCountry = nil
                focusState = .username
            }
            .ignoresSafeArea(.keyboard)
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                withAnimation { // keyboard is about to come out
                    isKeyboardVisible = true
                }
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                withAnimation { // just before keyboard disappears
                    isKeyboardVisible = false
                }
            }
        }
    }
}

extension MainAuth {
    // views
    var logo : some View {
        VStack {
            Image("AppLogo")
                .resizable()
                .frame(width: 56, height: 56)
                .foregroundStyle(.green)
            //            Text("Leafteract")
            //                .font(.system(size: 17, weight: .bold))
        }
    }
    
    var dropdownContent : some View {
        ZStack {
            Rectangle()
                .fill(Color.white.opacity(0.05))
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Where are you?")
                    .font(.system(size: 32, weight: .bold))
                    .padding(.horizontal, 8)
                
                SearchBar(inputText: $searchQuery, placeholder: "Search countries")
                    .padding(.horizontal, 8)
                    .frame(width: 360)
                    .padding(.top, 16)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 8) {
                        if !countriesArray.isEmpty {
                            ForEach(countriesArray) { item in
                                Button {
                                    isKeyboardVisible = false
                                    expandDropdown = false
                                    searchQuery = ""
                                    handleCountrySelection(item: item)
                                } label: {
                                    HStack {
                                        Image(systemName: "globe")
                                            .foregroundStyle(BrandColors.Gray400)
                                        Text(item.rawValue)
                                    }
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 12)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .buttonStyle(.glass(.clear))
                                .transition(.scale.combined(with: .blurReplace))
                            }
                        } else {
                            VStack(spacing: 24) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 27))
                                Text("No matches for \(Text(searchQuery).bold())")
                                    .font(.system(size: 20))
                            }
                            .foregroundStyle(BrandColors.Gray400)
                            .multilineTextAlignment(.center)
                            .padding(32)
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.top, 24)
                    .padding(.bottom, 48)
                }
                .frame(width: 360, height: 400)
                .mask {
                    LinearGradient(
                        stops: [
                            .init(color: Color.black.opacity(0), location: 0.01),
                            .init(color: Color.black.opacity(1), location: 0.1),
                            .init(color: Color.black.opacity(1), location: 0.8),
                            .init(color: Color.black.opacity(0), location: 1)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            }
            .frame(width: 360)
            
        }
        .matchedGeometryEffect(id: "expandDropdown", in: expandDropdownNS, properties: .position)
        .transition(.blurReplace.combined(with: .scale(2, anchor: .center)))
        .overlay(alignment: .bottom) {
            Button {
                expandDropdown = false
            } label: {
                HStack {
                    Image(systemName: "xmark")
                        .foregroundStyle(BrandColors.Gray400)
                    Text("Close")
                }
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
            }
            .buttonStyle(.glass)
        }
    }
    
    @ViewBuilder
    func passwordCriteriaView() -> some View {
        if !userDetails.password.isEmpty && !passwordChecksOut {
            FlowLayout(spacing: 4) {
                ValidationChips(label: "One number (0-9)", expanded: !passwordContainsNumber)
                
                ValidationChips(label: "One symbol (!@#$%^...)", expanded: !passwordContainsSymbol)

                ValidationChips(label: "One uppercase letter(A-Z)", expanded: !passwordContainsUppercase)
            }
            .transition(.blurReplace)
            .animation(.bouncy, value: userDetails)
        }
    }
}

extension MainAuth {
    // computed properties
    
    var buttonState : Bool {
        // true = disabled
        guard !userDetails.username.isEmpty, !userDetails.password.isEmpty, selectedCountry != nil else {
            return true
        }
        
        if passwordChecksOut && handleUsername() == .success(message: "") {
            return false
        } else {
            return true
        }
    }
    
    var countriesArray : [Country] {
        if searchQuery.isEmpty {
            return Country.allCases
        } else {
            return Country.allCases.filter{$0.rawValue.localizedStandardContains(searchQuery)}
        }
    }
    
    var passwordContainsNumber : Bool {
        userDetails.password.rangeOfCharacter(from: .decimalDigits) != nil
    }
    var passwordContainsSymbol : Bool {
        userDetails.password.rangeOfCharacter(from: symbolSet) != nil
    }
    var passwordContainsUppercase : Bool {
        userDetails.password.rangeOfCharacter(from: .uppercaseLetters) != nil
    }
    var passwordChecksOut : Bool {
        userDetails.password.count > 5 && passwordContainsNumber && passwordContainsSymbol && passwordContainsUppercase
    }
}

extension MainAuth {
    // functions
    
    func handleCountrySelection(item: Country) {
        if let theCountry = Country.allCases.first(where: { $0.id == item.id }) {
            selectedCountry = theCountry
        }
    }
    
    func handleFormSubmission() {
        checkingFormDetails = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            checkingFormDetails = false
            navigateToOTP = true
        }
    }
    
    func handlePassword() -> TextFieldStates {
        // don't check if password is empty
        guard !userDetails.password.isEmpty else {
            return .base(message: "")
        }
        
        // don't show any other error when character's less than 5
        guard userDetails.password.count > 5 else {
            return .error(message: "Password is too short")
        }

        // 1 number
        if userDetails.password.rangeOfCharacter(from: .decimalDigits) == nil {
            return .error(message: "") // message handled somewhere else
        }
        
        // 1 symbol
        if userDetails.password.rangeOfCharacter(from: symbolSet) == nil {
            return .error(message: "") // message handled somewhere else
        }
        
        // 1 uppercase letter
        if userDetails.password.rangeOfCharacter(from: .uppercaseLetters) == nil {
            return .error(message: "") // message handled somewhere else
        }
        
        // if everything works out
        return .success(message: "")
    }
    
    func handleUsername() -> TextFieldStates {
        // don't check if username is empty
        guard !userDetails.username.isEmpty else { return .base(message: "") }
        
        // not enough text
        if (userDetails.username.count < 3) {
            return .error(message: "At least 3 characters")
        }
        
        // name already exists
        if UserInformation.existingValues.contains(where: { $0.username.lowercased() == userDetails.username.lowercased() }) {
            return .error(message: "Someone else has this name")
        }
        
        // if everything works out
        return .success(message: "")
    }
    
    
}



#Preview {
    MainAuth()
}



struct UserInformation : Equatable {
    var username : String
    var password : String
    
    static var defaultValue : UserInformation {
        .init(username: "", password: "")
    }
    
    static var existingValues : [UserInformation] {
        [
            .init(username: "godwyn", password: "12345678"),
            .init(username: "godwin", password: "12345678"),
            .init(username: "john", password: "12345678"),
            .init(username: "jgodwyn", password: "12345678"),
        ]
    }
}


enum Country: String, CaseIterable, Identifiable {
    case nigeria = "Nigeria"
    case usa = "United States"
    case canada = "Canada"
    case uk = "United Kingdom"
    case southAfrica = "South Africa"
    case germany = "Germany"
    case france = "France"
    case egypt = "Egypt"
    case japan = "Japan"
    case china = "China"
    case kenya = "Kenya"
    case india = "India"
    case brazil = "Brazil"
    case ghana = "Ghana"
    case australia = "Australia"
    case mexico = "Mexico"
    case ethiopia = "Ethiopia"
    case southKorea = "South Korea"
    case italy = "Italy"
    case morocco = "Morocco"
    case spain = "Spain"
    
    var id: String { rawValue }
}
