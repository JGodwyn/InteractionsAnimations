//
//  BasicEffect.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 05/01/2026.
//

import SwiftUI

struct BasicEffect: View {
    
    // MatchedGeometryEffect lets you match the geometry of two different objects with the same ID and namespace
    
    @Namespace private var basicNS // use to control views you want to match geometry
    @State private var changeGeometry : Bool = false // use to change values
    
    var body: some View {
        VStack {
            HStack {
                Rectangle()
                    .fill(.blue)
                    .matchedGeometryEffect(id: "shapes",
                                           in: basicNS,
                                           properties: .frame,
                                           anchor: .center,
                                           isSource: true)
                    // id can be any text, namespace is what you created above
                    // isSource determines which is the source of the animation
                    // properties determine what you want to match
                    // frame matches all, size matches size, position matches position
                    // i.e the other ID changes to fit it
                    .frame(width: 100, height: 100)
                
                Rectangle()
                    .fill(.green)
                    .matchedGeometryEffect(id: changeGeometry ? "shapes" : "",
                                           in: basicNS,
                                           properties: .frame,
                                           anchor: .topLeading,
                                           isSource: false)
                    .frame(width: 200, height: 140)
            }
            
            Button("Move shapes") {
                withAnimation(.smooth) {
                    changeGeometry.toggle()
                }
            }
        }
    }
}

#Preview {
    BasicEffect()
}
