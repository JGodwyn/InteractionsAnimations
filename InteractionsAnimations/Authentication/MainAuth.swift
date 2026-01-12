//
//  MainAuth.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 12/01/2026.
//

import SwiftUI

struct MainAuth: View {
    
    @State private var userDetails : UserInformation = .defaultValue
    @State private var secureText : Bool = true
    @State private var expandDropdown : Bool = false
    @State private var selectedCountry : String = ""
    
    var body: some View {
        ZStack {
            Color(BrandColors.Gray0)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing: 16) {
                logo
                    .wiggle(trigger: userDetails) // wiggle whenever userdetails change
                Text("Enter your information to continue…")
                    .font(.system(size: 32, weight: .bold))
                    .kerning(-0.5)
                
                Group {
                    // input fields
                    TextField("Username", text: $userDetails.username)
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
                    
                    // dropdown
                    HStack {
                        HStack {
                            Image(systemName: "globe")
                            Text("Where?")
                        }
                        .foregroundStyle(.gray)
                        Spacer()
                        Picker("Country", selection: $selectedCountry) {
                            ForEach(Country.allCases) { country in
                                Text(country.rawValue).tag(country)
                            }
                        }
                        .pickerStyle(.menu)
                        
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
                    
                    // Main dropdown
                    HStack {
                        HStack {
                            Image(systemName: "globe")
                            Text("Where?")
                        }
                        .foregroundStyle(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 24)
                    .onTapGesture {
                        withAnimation(.smooth) {
                            expandDropdown = true
                        }
                    }
                }
                .fontWeight(.medium)
                .padding()
                .background(BrandColors.Gray100, in: .rect(cornerRadius: .infinity, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(BrandColors.Gray200.opacity(0.5), lineWidth: 1)
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(.black.opacity(0.1), lineWidth: 2)
                        .blur(radius: 6)
                        .offset(x: 1, y: 1)
                        .mask(RoundedRectangle(cornerRadius: .infinity))
                }
                
                Button {
            
                } label: {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                .buttonStyle(.glassProminent)
            }
            .padding()
        }
        .animation(.smooth, value: userDetails)
        .overlay {
            
        }
    }
    
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
}


enum Country: String, CaseIterable, Identifiable {
    case usa = "United States"
    case canada = "Canada"
    case uk = "United Kingdom"
    
    var id: String { rawValue }
}
