//
//  AllGlassEffect.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 06/01/2026.
//

import SwiftUI

struct AllGlassEffect: View {

    @State private var removeBg = false
    @State private var glassContainerSpacing: CGFloat = 40
    @State private var expandGroupedBtns = false
    @State private var showInputField = false
    @State private var inputText = ""
    @Namespace private var joinProBtns
    @Namespace private var joinGroupedBtns
    @Namespace private var joinFields

    var body: some View {
        VStack(spacing: 16) {
            Toggle("Remove background", isOn: $removeBg)
                .padding()
                .glassEffect()

            Slider(value: $glassContainerSpacing, in: 1...80, step: 2)
                .padding()
                .glassEffect(.clear)

            // other views
//            buttonGlassEffect
//            textImageGlassEffect
//            glassContainer
//            glassUnion
//            glassTransition
            textImageGlassEffect
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            ScrollView([.horizontal, .vertical]) {
                Image(removeBg ? "" : "TestImage")
            }
            .ignoresSafeArea()
        }
        .animation(.smooth, value: glassContainerSpacing)
    }
}

#Preview {
    AllGlassEffect()
}

extension AllGlassEffect {
    var buttonGlassEffect: some View {
        VStack {
            Button("Glass") {
                // actions
            }
            .buttonStyle(.glass)

            Button("GlassProminent") {
                // actions
            }
            .buttonStyle(.glassProminent)
            .tint(.blue)
        }
    }

    var textImageGlassEffect: some View {
        VStack {
            Text("Text Glass Effect")
                .font(.title3)
                .padding()
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 24))
            Image(systemName: "applelogo")
                .font(.system(size: 48))
                .padding()
                .frame(width: 80, height: 80)
                .glassEffect(.regular.interactive())  // add click gesture
        }
    }

    var glassContainer: some View {
        // with glassContainer, you can set up merging effect when the views come together (their spacing is reduced)
        // reduce spacing using the slider
        GlassEffectContainer(spacing: glassContainerSpacing) {
            Button("GlassProminent") {
                // actions
            }
            .buttonStyle(.glassProminent)
            .tint(.blue)

            Button("Glass") {
                // actions
            }
            .buttonStyle(.glass)

            Text("Regular Glass Effect")
                .font(.title3)
                .padding()
                .glassEffect(.regular, in: .rect(cornerRadius: 24))

            Text("Clear Glass Effect")
                .font(.title3)
                .padding()
                .glassEffect(.clear, in: .rect(cornerRadius: 24))

            Image(systemName: "applelogo")
                .font(.system(size: 48))
                .padding()
                .frame(width: 80, height: 80)
                .glassEffect(.regular.interactive())  // add click gesture
        }
    }

    var glassUnion: some View {
        // with glass union, views with the same namespace are joined together
        // it has to be in a GlassContainer
        GlassEffectContainer {
            HStack {
                Button("Union1") {
                    // buttons work independently
                }
                .buttonStyle(.glassProminent)
                .tint(.blue)
                .glassEffectUnion(id: "proBtn", namespace: joinProBtns)
                
                Button("Union2") {
                    // actions
                }
                .buttonStyle(.glassProminent)
                .tint(.blue)
                .glassEffectUnion(id: "proBtn", namespace: joinProBtns)
            }
            
            Group {
                // these buttons will also join
                // because the group is receiving the union effect
                Button("GroupUnion1") {
                    
                }
                .buttonStyle(.glassProminent)
                
                Button("GroupUnion2") {
                    
                }
                .buttonStyle(.glassProminent)
            }
            .glassEffectUnion(id: "groupedBtns", namespace: joinGroupedBtns)
        }
    }
    
    var glassTransition : some View {
        GlassEffectContainer {
            
            // the effect is amazing even without adding a transition
            
            HStack {
                Image(systemName: "photo")
                    .font(.system(size: 40))
                    .padding()
                    .frame(width: 80, height: 80)
                    .glassEffect(.regular.tint(.teal).interactive())
                    .onTapGesture {
                        withAnimation {
                            expandGroupedBtns.toggle()
                        }
                    }
                
                if expandGroupedBtns {
                    // the animation is way cooler when you remove the glassEffectID
                    HStack {
                        Image(systemName: "building")
                            .font(.system(size: 40))
                            .padding()
                            .frame(width: 80, height: 80)
                            .glassEffect(.regular)
                            .glassEffectID("glassmorph", in: joinGroupedBtns)
                            .glassEffectUnion(id: "joinMe", namespace: joinGroupedBtns)
                        
                        Image(systemName: "fish")
                            .font(.system(size: 40))
                            .padding()
                            .frame(width: 80, height: 80)
                            .glassEffect(.regular)
                            .glassEffectID("glassmorph", in: joinGroupedBtns)
                            .glassEffectUnion(id: "joinMe", namespace: joinGroupedBtns)
                    }
                    .glassEffectTransition(.matchedGeometry)
                }
            }
        }
    }
    
    var textFieldTransition : some View {
        GlassEffectContainer {
            HStack {
                if showInputField {
                    TextField("Enter text here", text: $inputText)
                        .padding()
                        .glassEffect()
                        .transition(.asymmetric(insertion: .identity, removal: .scale))
                }
                
                Button {
                    withAnimation {
                        showInputField.toggle()
                    }
                } label: {
                    Image(systemName: showInputField ? "minus" : "plus")
                        .font(.system(size: 22))
                        .bold()
                        .frame(height: 40)
                        .frame(minWidth: 40)
                        .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp)))
                }
                .buttonStyle(.glassProminent)
            }
            .glassEffectUnion(id: "joinField", namespace: joinFields) // chef kiss!
        }
    }
}
