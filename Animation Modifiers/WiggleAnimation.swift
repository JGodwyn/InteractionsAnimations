//
//  WiggleEffect.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 10/01/2026.
//

import SwiftUI

struct WiggleAnimation: View {
    
    @State private var shouldWiggle : Bool = false
    
    var body: some View {
        Button("Wiggle me") {
            shouldWiggle.toggle()
        }
        
        Rectangle()
            .frame(width: 100, height: 100)
            .wiggle(trigger: shouldWiggle)
        
        Image("TrashCan")
            .resizable()
            .frame(width: 48, height: 48)
            .padding(12)
            .wiggle(trigger: shouldWiggle, duration: 0.3)
        

    }
}

#Preview {
    WiggleAnimation()
}

// View modifier for wiggle animation
struct WiggleModifier: ViewModifier {
    @State private var isWiggling = false
    @State private var increaseScale: Bool = false
    let trigger: Bool
    let duration: Double
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .rotationEffect(.degrees(isWiggling ? 10 : 0))
                .animation(
                    isWiggling ?
                    Animation.easeOut(duration: 0.1)
                        .repeatCount(1000, autoreverses: true) :
                            .default,
                    value: isWiggling
                )
                .animation(.smooth, value: increaseScale)
                .onChange(of: trigger) { _, _ in
                    isWiggling = true
                    increaseScale = true
                    Task {
                        try? await Task.sleep(for: .seconds(duration))
                        isWiggling = false
                        increaseScale = false
                    }
                }
        }
        .scaleEffect(increaseScale ? 1.3 : 1)
        .animation(.smooth, value: increaseScale)
    }
}

// View extension for easy usage
extension View {
    func wiggle(trigger: Bool, duration: Double = 0.3, increaseScale: Bool = false) -> some View {
        modifier(WiggleModifier(trigger: trigger, duration: duration ))
    }
}
