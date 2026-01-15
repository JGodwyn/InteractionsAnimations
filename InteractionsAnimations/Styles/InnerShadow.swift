//
//  ReusableModifiers.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 12/01/2026.
//

import SwiftUI

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

#Preview {
    VStack {
        Rectangle().fill(.white)
            .frame(width: 100, height: 100)
            .innerShadow()
        
        Circle()
            .fill(.white)
            .frame(width: 100, height: 100)
            .innerShadow()
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
