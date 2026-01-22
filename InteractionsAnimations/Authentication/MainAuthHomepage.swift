//
//  MainAuthHomepage.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 20/01/2026.
//

import SwiftUI
import Combine

struct MainAuthHomepage: View {
    let words = "Welcome to LeafTeract".components(separatedBy: .whitespaces)
    let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
    
    @State private var visibleWords: [String] = []
    @State private var currentIndex = 0
    @State private var finishedAnimating = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            
            Image("AppLogo")
                .resizable()
                .frame(width: 56, height: 56)
                .foregroundStyle(.green)
                .transition(.blurReplace)
            
            FlowLayout(spacing: 4, alignment: .center) {
                ForEach(Array(visibleWords.enumerated()), id: \.offset) { index, word in
                    Text(word)
                        .id(word + "\(index)")  // Unique ID per word position
                        .font(.system(size: 44))
                        .fontWeight(.bold)
                        .kerning(-0.5)
                        .lineHeight(.tight)
                        .transition(.push(from: .bottom).combined(with: .blurReplace))
                        .contentTransition(.interpolate)
                }
            }
            .onReceive(timer) { _ in
                guard currentIndex < words.count else { return }
                withAnimation(.easeInOut(duration: 0.4)) {
                    visibleWords.append(words[currentIndex])
                    currentIndex += 1
                    if currentIndex == words.count {
                        finishedAnimating = true
                    }
                }
            }
            .onAppear {
                visibleWords = []
                currentIndex = 0
                finishedAnimating = false
            }

            
            Button("Get started") {
                
            }
            .buttonStyle(.glassProminent)
            .disabled(!finishedAnimating)
            

            
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainAuthHomepage()
}
