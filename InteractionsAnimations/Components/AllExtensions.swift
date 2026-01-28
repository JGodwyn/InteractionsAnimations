//
//  AllExtensions.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 28/01/2026.
//

import Foundation
import SwiftUI

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { proxy in
                Color.clear
                    .onAppear { onChange(proxy.size) }
                    .onChange(of: proxy.size) { onChange($1) }
            }
        )
    }
}
