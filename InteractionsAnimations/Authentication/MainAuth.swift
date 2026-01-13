//
//  MainAuth.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 12/01/2026.
//

import SwiftUI

struct MainAuth: View {
    
    @Namespace private var expandDropdownNS
    
    @State private var userDetails : UserInformation = .defaultValue
    @State private var secureText : Bool = true
    @State private var expandDropdown : Bool = false
    @State private var selectedCountry : Country?
    @State private var searchQuery : String = ""
    
    var countriesArray : [Country] {
        if searchQuery.isEmpty {
            return Country.allCases
        } else {
            return Country.allCases.filter{$0.rawValue.localizedStandardContains(searchQuery)}
        }
    }
    
    var body: some View {
        ZStack {
            Color(BrandColors.Gray0)
                .ignoresSafeArea()
            
            VStack(alignment: .leading, spacing: 16) {
                logo
                    .wiggle(trigger: userDetails)
                
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
                }
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
                
                if !expandDropdown {
                    HStack {
                        HStack {
                            Image(systemName: "globe")
                            Text("Where?")
                        }
                        .foregroundStyle(.gray)
                        Spacer()
                        
                        if let selectCountry = selectedCountry {
                            Text(selectCountry.rawValue)
                                .bold()
                        } else {
                            Text("Select country")
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
                    }
                    .transition(.blurReplace.combined(with: .opacity))
                }
                
                
                Button {
                    // main button
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
        .overlay {
            if expandDropdown {
                dropdownContent
                
            }
        }
        .animation(.smooth, value: userDetails)
        .animation(.smooth(duration: 0.3), value: countriesArray)
        .animation(.easeInOut(duration: 0.3), value: expandDropdown)
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
    
    func handleCountrySelection(item: Country) {
        if let theCountry = Country.allCases.first(where: { $0.id == item.id }) {
            selectedCountry = theCountry
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
