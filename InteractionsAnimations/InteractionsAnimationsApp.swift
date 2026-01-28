//
//  InteractionsAnimationsApp.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 05/01/2026.
//

import SwiftUI

@main
struct InteractionsAnimationsApp: App {
    var body: some Scene {
        WindowGroup {
            SwipeableView(content: {
                Text("What should i do here?")
            }, actions: [
                SwipeAction(icon: "pin.fill", label: "Pin", background: BrandColors.Gray200) {
                    
                },
                SwipeAction(icon: "pin.fill", label: "Pin", background: BrandColors.Gray300) {
                    
                },
                SwipeAction(icon: "pin.fill", label: "Pin", foreground: .white, background: BrandColors.Gray800) {
                    
                }
                       ])
        }
    }
}
