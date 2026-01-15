//
//  CustomRoundedTextField.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 15/01/2026.
//

import SwiftUI

struct CustomRoundedTextField : ViewModifier {
    var state : TextFieldStates
    var height : CGFloat
    var strokeWidth : CGFloat
    var shadowDepth : CGFloat
    var showShadow : Bool
    var showSymbol : Bool
    
    func body(content: Content) -> some View {
        VStack(alignment: .leading) {
            content
                .padding(.horizontal)
                .frame(height: height)
                .background(state.backgroundColor, in: .rect(cornerRadius: .infinity, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: .infinity)
                        .stroke(state.strokeColor, lineWidth: strokeWidth)
                    
                    if showShadow {
                        RoundedRectangle(cornerRadius: .infinity)
                            .stroke(.black.opacity(0.2), lineWidth: shadowDepth)
                            .blur(radius: 6)
                            .offset(x: 1, y: 1)
                            .mask(RoundedRectangle(cornerRadius: .infinity))
                    }
                }
                .overlay(alignment: .trailing) {
                    if showSymbol {
                        if let theImage = state.symbol {
                            Image(systemName: theImage)
                                .foregroundStyle(state.helperTextColor)
                                .font(.system(size: 22))
                                .padding(.horizontal, 12)
                                .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp)))
                                .transition(.blurReplace)
                        }
                    }
                    
                }
            
            if !state.helperText.isEmpty {
                Text(state.helperText)
                    .foregroundStyle(state.helperTextColor)
                    .fontWeight(.medium)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: state)
    }
}

#Preview {
    ZStack {
        Color(BrandColors.Gray100)
            .ignoresSafeArea()
        TextField("Name", text: .constant(""))
            .customRoundedTextField(state: .success(message: "this is the helper text"), height: 48, strokeWidth: 2)
    }
}


enum TextFieldStates : Equatable {
    case base(message : String)
    case error(message : String)
    case success(message : String)
    
    var backgroundColor : Color {
        switch self {
        case .base:
            return BrandColors.Gray100
        case .error:
            return .red.opacity(0.1)
        case .success:
            return .green.opacity(0.1)
        }
    }
    
    var strokeColor : Color {
        switch self {
        case .base:
            return BrandColors.Gray200.opacity(0.5)
        case .error:
            return .red
        case .success:
            return .green
        }
    }
    
    var helperText : String {
        switch self {
        case .base(let message):
            return message
        case .error(let message):
            return message
        case .success(let message):
            return message
        }
    }
    
    var helperTextColor : Color {
        switch self {
        case .base:
            return BrandColors.Gray500
        case .error:
            return .red
        case .success:
            return Color(hex: "00A600")
        }
    }
    
    var symbol : String? {
        switch self {
        case .base:
            return nil // never use this
        case .error:
            return "exclamationmark.octagon.fill"
        case .success:
            return "checkmark"
        }
    }
}



extension View {
    func customRoundedTextField(
        state : TextFieldStates = .base(message: ""),
        height : CGFloat = 40,
        strokeWidth : CGFloat = 2,
        shadowDepth : CGFloat = 2,
        showShadow : Bool = true,
        showSymbol : Bool = true,
    ) -> some View {
        self.modifier(CustomRoundedTextField(state: state, height: height, strokeWidth: strokeWidth, shadowDepth: shadowDepth, showShadow: showShadow, showSymbol: showSymbol))
    }
}
