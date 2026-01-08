//
//  CardExpandEffect.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 05/01/2026.
//

import SwiftUI

struct CardExpandEffect: View {
    
    @Namespace private var expandContentNS
    @Namespace private var expandRectNS
    @State private var expandContent : Bool = false
    @State private var expandRect : Bool = false
    
    var body: some View {
        ZStack {
            ScrollView {
                if expandContent {
                    collapsedContentView
//                        .transition(.scale.combined(with: .blurReplace))
                        .onTapGesture {
                            expandContent = false
                        }
                } else {
                    expandedContentView
//                        .transition(.scale.combined(with: .blurReplace))
                        .onTapGesture {
                            expandContent = true
                        }
                }
            }
            expandRectView()
        }
        .padding()
        .animation(.smooth(duration: 0.3), value: expandContent)
        .animation(.spring(duration: 0.3), value: expandRect)
    }
}

#Preview {
    CardExpandEffect()
}

private extension CardExpandEffect {
    var collapsedContentView : some View {
        HStack(alignment: .top, spacing: 16) {
            Rectangle().fill(.green)
                .matchedGeometryEffect(id: "rectShape", in: expandContentNS)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            VStack (alignment: .leading, spacing: 8) {
                Text("Tap to expand")
                    .font(.system(size: 22, weight: .bold))
                Text("This should provide some description")
                    .lineLimit(2)
            }
            .matchedGeometryEffect(id: "textParagraph", in: expandContentNS, anchor: .topLeading)
        }
        .padding()
        .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    var expandedContentView : some View {
        VStack(alignment: .leading, spacing: 16) {
            Rectangle().fill(.green)
                .matchedGeometryEffect(id: "rectShape", in: expandContentNS)
                .frame(maxWidth: .infinity)
                .frame(height: 120)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            VStack (alignment: .leading, spacing: 8) {
                Text("Tap to collapse")
                    .font(.system(size: 22, weight: .bold))
                Text("This should provide some description about this stack and could keep expanding for a long time")
                    .lineLimit(2)
            }
            .matchedGeometryEffect(id: "textParagraph", in: expandContentNS, properties: .frame, anchor: .topLeading)
        }
        .padding()
        .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
    
    @ViewBuilder
    private func expandRectView () -> some View {
        if expandRect {
            ZStack {
                Rectangle().fill(.blue)
                    .matchedGeometryEffect(id: "expandRect", in: expandRectNS)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .ignoresSafeArea()
                    .onTapGesture {
                        expandRect = false
                    }
            }
            .transition(.scale)
        }
        
        // expand image to fill screen
        if !expandRect {
            Rectangle().fill(.green)
                .matchedGeometryEffect(id: "expandRect", in: expandRectNS)
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .transition(.scale)
                .onTapGesture {
                    expandRect = true
                }
        }
    }
}
