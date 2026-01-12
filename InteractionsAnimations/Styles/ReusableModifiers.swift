//
//  ReusableModifiers.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 12/01/2026.
//

import SwiftUI

struct ReusableModifiers: View {
    var body: some View {
        Rectangle().fill(.white)
            .frame(width: 100, height: 100)
            .innerShadow()
        
        Circle()
            .fill(.white)
            .frame(width: 100, height: 100)
            .innerShadow()
    }
}

#Preview {
    ReusableModifiers()
}


//struct InnerShadowModifier : ViewModifier {
//    
//    var shadowColor : Color = BrandColors.Gray1000.opacity(0.1)
//    var blurRadius : CGFloat = 6
//    var offSet : CGSize = .init(width: 1, height: 1)
//    var showStroke : Bool = false
//    var strokeColor : Color = BrandColors.Gray200.opacity(0.5)
//    
//    func body(content: Content) -> some View {
//        content
//            .overlay {
//                if showStroke {
//                    RoundedRectangle(cornerRadius: .infinity)
//                        .stroke(strokeColor, lineWidth: 1)
//                }
//                RoundedRectangle(cornerRadius: .infinity)
//                    .stroke(shadowColor, lineWidth: 2)
//                    .blur(radius: blurRadius)
//                    .offset(x: offSet.width, y: offSet.height)
//                    .mask(content)
//            }
//    }
//}

struct InnerShadow: ViewModifier {
    var color: Color = .black
    var radius: CGFloat = 10
    var x: CGFloat = 0
    var y: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                content
                    .border(.gray1000)
                    .foregroundStyle(color)
                    .blur(radius: radius)
                    .offset(x: x, y: y)
                    .mask(content)
                    .blendMode(.multiply)
            )
    }
}

extension View {
    func innerShadow(
        color: Color = .black,
        radius: CGFloat = 8,
        x: CGFloat = 0,
        y: CGFloat = 0
    ) -> some View {
        self.modifier(InnerShadow(color: color, radius: radius, x: x, y: y))
    }
}
