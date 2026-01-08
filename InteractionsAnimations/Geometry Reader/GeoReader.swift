//
//  GeoReader.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 05/01/2026.
//

import SwiftUI

struct GeoReader: View {
    var body: some View {
         ex1
//        ex2
    }

    private var ex1: some View {
        VStack {
            GeometryReader { reader in
                Text("Positioned somewhere")
                    .position(y: reader.frame(in: .local).midY)
                Text("Positioned somewhere")
                    .foregroundStyle(.red)
                    .position(y: reader.frame(in: .global).midY)
            }
            .background(.green)
        }
        .frame(width: 200, height: 500)
        .background(.gray)
    }

    private var ex2: some View {
        // here's how global works…
        // it adds the space your view takes up locally
        // plus the difference btw your view and the edge of the screen
        
        VStack {
            VStack {
                GeometryReader { reader in
                    Text("My position globally first VStack")
                        .position(
                            x: reader.frame(in: .global).midX,
                            y: reader.frame(in: .global).midY
                        )
                }
            }
            .frame(height: 44)
            .background(.white)
            
            GeometryReader { reader in
                Text("My position locally")
                    .position(y: reader.frame(in: .local).midY)
                Text("My position globally")
                    .position(
                        x: reader.frame(in: .global).midX,
                        y: reader.frame(in: .global).midY
                    )
            }
            .background(.green)
        }
    }
}

#Preview {
    GeoReader()
}
