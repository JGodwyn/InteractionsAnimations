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
    var cornerRadius : CGFloat
    var strokeWidth : CGFloat
    var shadowDepth : CGFloat
    var showShadow : Bool
    var showSymbol : Bool
    @FocusState private var isFocused
    
    func body(content: Content) -> some View {
        var effectiveState : TextFieldStates {
            // i want to have it check that the current state is not
            // success or error. if it is, don't change to focus, else ...
            // if the item is focused, change to focus
            guard self.state.stripMessage() != "success" && self.state.stripMessage() != "error" else {
                return state
            }
            
            if isFocused {
                return .focused(message: "")
            }
            
            return state
            
        }
        
        VStack(alignment: .leading) {
            content
                .focused($isFocused)
                .padding(.horizontal)
                .frame(height: height)
                .background(effectiveState.backgroundColor, in: .rect(cornerRadius: cornerRadius, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke(effectiveState.strokeColor, lineWidth: strokeWidth)
                    
                    if showShadow {
                        RoundedRectangle(cornerRadius: cornerRadius)
                            .stroke(.black.opacity(0.2), lineWidth: shadowDepth)
                            .blur(radius: 6)
                            .offset(x: 1, y: 1)
                            .mask(RoundedRectangle(cornerRadius: cornerRadius))
                    }
                }
                .overlay(alignment: .trailing) {
                    if showSymbol {
                        if let theImage = effectiveState.symbol {
                            Image(systemName: theImage)
                                .foregroundStyle(effectiveState.helperTextColor)
                                .font(.system(size: 22))
                                .padding(.horizontal, 12)
                                .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp)))
                                .transition(.blurReplace)
                        }
                    }
                    
                }
            if !effectiveState.helperText.isEmpty {
                Text(effectiveState.helperText)
                    .foregroundStyle(effectiveState.helperTextColor)
                    .fontWeight(.medium)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: state)
        .animation(.easeInOut(duration: 0.3), value: effectiveState)
    }
}

#Preview {
    ZStack {
        Color(BrandColors.Gray100)
            .ignoresSafeArea()
        TextField("Name", text: .constant(""))
            .customRoundedTextField(state: .success(message: "this is the helper text"), height: 48, strokeWidth: 2)
            .padding()
    }
}


enum TextFieldStates : Equatable {
    case base(message : String)
    case focused(message : String)
    case error(message : String)
    case success(message : String)
    
    func stripMessage() -> String {
        switch self {
        case .base:
            return "base"
        case .error:
            return "error"
        case .success:
            return "success"
        case .focused:
            return "focused"
        }
    }
    
    var backgroundColor : Color {
        switch self {
        case .base:
            return BrandColors.Gray100
        case .error:
            return .red.opacity(0.1)
        case .success:
            return .green.opacity(0.1)
        case .focused:
            return .blue.opacity(0.1)
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
        case .focused:
            return .blue.opacity(0.5)
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
        case .focused(let message):
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
        case .focused:
            return BrandColors.Gray500
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
        case .focused:
            return nil
        }
    }
}



extension View {
    func customRoundedTextField(
        state : TextFieldStates = .base(message: ""),
        height : CGFloat = 40,
        cornerRadius : CGFloat = .infinity,
        strokeWidth : CGFloat = 2,
        shadowDepth : CGFloat = 2,
        showShadow : Bool = true,
        showSymbol : Bool = true,
    ) -> some View {
        self.modifier(CustomRoundedTextField(state: state, height: height, cornerRadius: cornerRadius, strokeWidth: strokeWidth, shadowDepth: shadowDepth, showShadow: showShadow, showSymbol: showSymbol))
    }
}
