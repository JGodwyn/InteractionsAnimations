//
//  ShowcaseSwipe.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 28/01/2026.
//

import SwiftUI

struct ShowcaseSwipe: View {
    
    @Namespace private var placeHolderNamespace
    
    var body: some View {
        NavigationStack {
            ScrollView { // put everything here
                SwipeableView(singleActionWidth: 80, content: {
                    tokenCard1
                }, actions: [
                    SwipeAction(icon: "trash.fill", label: "Delete", foreground: .red, background: Color(hex: "#FFE4E4")) {
                        
                    },
                    SwipeAction(icon: "pencil", label: "Edit", foreground: .white, background: Color(hex: "#8F00FF")) {
                        
                    }
                    
                ])
                SwipeableView(cornerRadius: 32, content: {
                    tokenCard2
                }, actions: [
                    SwipeAction(icon: "trash.fill", label: "Delete", foreground: .red, background: Color(hex: "#FFE4E4")) {
                        
                    },
                    SwipeAction(icon: "pencil", label: "Edit", foreground: Color(hex: "#008080"), background: Color(hex: "#87CEFA")) {
                        
                    },
                    SwipeAction(icon: "pin.fill", foreground: Color(hex: "#355E3B"), background: Color(hex: "#ACE1AF")) {
                        
                    }
                ])
        

                
                SwipeableView(singleActionWidth: 80, cornerRadius: 32, content: {
                    textCard(item: tempData.example[0], nameSpace: placeHolderNamespace, isDeleting: false) {
                        
                    }
                }, actions: [
                    SwipeAction(icon: "hand.thumbsup.fill", label: "Helpful", foreground: .white, background: Color(hex: "#1F75FE")) {
                        
                    },
                    
                    SwipeAction(icon: "trash.fill", label: "Delete", foreground: .white, background: .red) {
                        
                    }
                ])

                
                
                
                
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(BrandColors.Gray200)
            .navigationTitle("Swipe views")
        }
    }
    
    var tokenCard1 : some View {
        HStack {
            Group {
                Image("USDC")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("USD Coin")
                    .fontWeight(.semibold)
            }
            Spacer()
            Text("USDC")
                .foregroundStyle(BrandColors.Gray300)
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrandColors.Gray0)
    }
    
    var tokenCard2 : some View {
        HStack {
            Group {
                Image("USDC")
                    .resizable()
                    .frame(width: 24, height: 24)
                Text("USD Coin")
                    .fontWeight(.semibold)
            }
            Spacer()
            Text("USDC")
                .foregroundStyle(BrandColors.Gray300)
        }
        .padding(.horizontal, 20)
        .frame(height: 64)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrandColors.Gray0)
    }
}

#Preview {
    ShowcaseSwipe()
}
