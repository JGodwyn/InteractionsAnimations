//
//  MainAuthHomepage.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 20/01/2026.
//


import SwiftUI
import Combine

struct MainAuthHomepage2: View {
    let words = "Start designing better interactions right here".components(separatedBy: .whitespaces)
    
    @State private var timerSubscription: AnyCancellable?
    @State private var visibleWords: [String] = []
    @State private var currentIndex = 0
    @State private var animationPhase : AnimationPhase?
    
    @State private var showButton : Bool = false
    @State private var showLogo : Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            if showLogo {
                Image("AppLogo")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.green)
                    .transition(.blurReplace)
                    .wiggle(trigger: visibleWords)
                
                Text("Welcome!")
                    .transition(.blurReplace)
                    .font(.system(size: 20))
                    .fontWeight(.bold)
                    .foregroundStyle(BrandColors.Gray400)
            }
            
            FlowLayout(spacing: 8, alignment: .center) {
                ForEach(Array(visibleWords.enumerated()), id: \.offset) { index, word in
                    Text(word)
                        .id(word + "\(index)")
                        .font(.system(size: 44))
                        .fontWeight(.bold)
                        .kerning(-0.5)
                        .fixedSize(horizontal: true, vertical: false)
                        .transition(.blurReplace.combined(with: .push(from: .bottom)))
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .padding()
        .navigationBarBackButtonHidden()
        .overlay(alignment: .bottom) {
            if showButton {
                Button {
                     
                } label: {
                    Text("Get started")
                        .fontWeight(.semibold)
                        .frame(height: 32)
                        .padding(.horizontal)
                }
                .buttonStyle(.glassProminent)
                .padding(.vertical)
                .transition(.blurReplace.combined(with: .push(from: .bottom)))
            }
        }
        .animation(.easeInOut, value: showLogo)
        .animation(.easeInOut(duration: 0.4).delay(0.5), value: showButton)
        .task {
            try? await Task.sleep(for: .seconds(0.1))
            showLogo = true
            
            try? await Task.sleep(for: .seconds(0.1))
            startTimer()
        }
        .onDisappear {
            timerSubscription?.cancel()
        }
    }
    
    private func startTimer() {
        let timer = Timer.publish(every: 0.3, on: .main, in: .common).autoconnect()
        
        timerSubscription = timer.sink { _ in
            guard currentIndex < words.count else {
                timerSubscription?.cancel()
                return
            }
            
            withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.8)) {
                visibleWords.append(words[currentIndex])
                currentIndex += 1
            }
            
            if currentIndex == words.count {
                animationPhase = .end
                showButton = true
            }
        }
    }
}

struct MainAuthHomepage: View {
    
    let sentence = "Start designing better interactions right here".components(separatedBy: .whitespaces)
    
    @State private var mainArray : [String] = []
    @State private var showLogo : Bool = false
    @State private var showButton : Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
            
            if showLogo {
                Image("AppLogo")
                    .resizable()
                    .frame(width: 56, height: 56)
                    .foregroundStyle(.green)
                    .transition(.blurReplace)
                    .wiggle(trigger: mainArray)
                
                Text("Welcome")
                    .transition(.blurReplace)
                    .font(.system(size: 17))
                    .fontWeight(.bold)
                    .foregroundStyle(BrandColors.Gray400)
            }
            
            // Animated sentence with individual word transitions
            FlowLayout(spacing: 6, alignment: .center) {
                ForEach(Array(mainArray.enumerated()), id: \.offset) { index, word in
                    Text(word)
                        .id(index)
                        .font(.system(size: 44))
                        .fontWeight(.bold)
                        .kerning(-0.5)
                        .fixedSize(horizontal: true, vertical: false)
                        .transition(.scale.combined(with: .blurReplace))
//                        .transition(.blurReplace.combined(with: .push(from: .bottom)))
                }
            }
            
            if showButton {
                Button {
                     
                } label: {
                    Text("Get started")
                        .fontWeight(.semibold)
                        .frame(height: 32)
                        .padding(.horizontal)
                }
                .buttonStyle(.glassProminent)
                .padding(.vertical)
                .transition(.blurReplace)
            }
             
//            Button("Replay Animation") {
//                resetAnimation()
//            }
//            .padding()
        }
        .navigationBarBackButtonHidden()
        .padding()
        .frame(maxWidth: .infinity)
        .animation(.interactiveSpring(response: 0.6, dampingFraction: 0.8), value: mainArray)
        .animation(.easeOut.delay(0.5), value: showLogo)
        .animation(.easeOut.delay(1), value: showButton)
        .onAppear {
            showLogo = true
            Task {
                try? await Task.sleep(for: .seconds(0.7))
                animateWords()
                showButton = true
            }
        }
    }
    
    func animateWords() {
        for (index, word) in sentence.enumerated() {
            Task {
                try? await Task.sleep(for: .seconds(Double(index) * 0.15))
                mainArray.insert(word, at: index)
            }
        }
    }
    
    func resetAnimation() {
        mainArray = []
        Task {
            try? await Task.sleep(for: .seconds(0.3))
            animateWords()
        }
    }
}


#Preview {
    MainAuthHomepage()
}


enum AnimationPhase : Equatable {
    case beginning
    case middle // somewhere in the middle lol
    case end
}
