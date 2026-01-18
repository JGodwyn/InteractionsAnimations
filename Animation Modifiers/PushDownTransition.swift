//
//  PushDownTransition.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 17/01/2026.
//

import SwiftUI

struct PushDownTransition: Transition {
    @State private var pushDown : Bool = false
    @State private var clipperHeight : CGFloat = 0
    
    func body(content: Content, phase: TransitionPhase) -> some View {
        VStack {
            content
                .background(
                    GeometryReader { reader in
                        Color.clear
                            .onAppear { clipperHeight = reader.size.height }
                            .onChange(of: reader.size.height) { _, newValue in
                                clipperHeight = newValue
                            }
                    }
                )
        }
        .frame(height: pushDown ? clipperHeight : 0)
        .clipped()
        .onAppear {
            withAnimation(.bouncy) {
                pushDown = true
            }
        }
    }
}

#Preview {
    TestPushDownTransition()
}


struct TestPushDownTransition: View {
    
    @State private var showText : Bool = false
    
    var body: some View {
        if showText {
            VStack {
                Text("Hello, World!")
            }
            .frame(height: 40)
            .background(.green)
            .pushDownTransition()
        }
        
        Button("show text") {
            withAnimation {
                showText.toggle()
            }
        }
        .buttonStyle(.glassProminent)
        
        VStack {
            Text("Hello, World!")
        }
        .pushDownTransition()
        
    }
}


struct PushDownModifier: ViewModifier {
    @State private var contentHeight: CGFloat = 0
    @State private var expandBanner: Bool = false
    
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    Color.clear
                        .onAppear {
                            contentHeight = geo.size.height
                        }
                        .onChange(of: geo.size.height) { _, newValue in
                            contentHeight = newValue
                        }
                }
            )
            .frame(height: expandBanner ? contentHeight : 0)
            .clipped()
            .onAppear {
                    withAnimation {
                        expandBanner = true
                    }
            }
    }
}


extension View {
    func pushDownTransition() -> some View {
        modifier(PushDownModifier())
    }
}
