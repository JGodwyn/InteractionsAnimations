//
//  ShowcaseSwipe.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 28/01/2026.
//

import SwiftUI

struct ShowcaseSwipe: View {
    
    @Namespace private var placeHolderNamespace
    @State private var tokenPriceMovement1 : Double = 0.2
    @State private var tokenPriceMovement2 : Double = 0.5
    @State private var simulatePriceMovement : Bool = true
    
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
                
                SwipeableView(singleActionWidth: 80, cornerRadius: 24, content: {
                    tokenCard3
                }, actions: [
                    SwipeAction(icon: "chevron.down.dotted.2", label: "Short", foreground: .white, background: .red) {
                        
                    },
                    SwipeAction(icon: "chevron.up.dotted.2", label: "Long", foreground: .black, background: Color(hex: "#30E630")) {
                        
                    }
                    
                ])
                
                SwipeableView(singleActionWidth: 80, content: {
                    tokenCard4
                }, actions: [
                    SwipeAction(icon: "chevron.down.dotted.2", label: "Short", foreground: .red, background: Color(hex: "#FFE4E4")) {
                        
                    },
                    SwipeAction(icon: "chevron.up.dotted.2", label: "Long", foreground: Color(hex: "#00A550"), background: Color(hex: "#ABFDAB")) {
                        
                    }
                    
                ])
                
                SwipeableView(singleActionWidth: 80, content: {
                    tokenCard4
                        .mask{
                            LinearGradient(
                                stops: [
                                    .init(color: Color.black.opacity(0), location: 0),
                                    .init(color: Color.black.opacity(0.5), location: 0.3),
                                    .init(color: Color.black.opacity(1), location: 1)
                                ],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        }
                }, actions: [
                    SwipeAction(icon: "chevron.down.dotted.2", label: "Short", foreground: .red, background: Color(hex: "#FFE4E4")) {
                        
                    },
                    SwipeAction(icon: "chevron.up.dotted.2", label: "Long", foreground: Color(hex: "#00A550"), background: Color(hex: "#ABFDAB")) {
                        
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
    
    var tokenCard3 : some View {
        HStack(alignment: .top) {
            HStack(alignment: .top) {
                Image("BTC")
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack (alignment: .leading) {
                    Text("BTC")
                        .fontWeight(.semibold)
                    Text("Bitcoin")
                        .foregroundStyle(BrandColors.Gray400)
                }
            }
            Spacer()
            VStack (alignment: .trailing) {
                
                let movement = tokenPriceMovement1
                
                Text("$88,190.13")
                    .foregroundStyle(BrandColors.Gray800)
                    .monospaced()
                HStack (alignment: .center, spacing: 4) {
                    Image(systemName: movement >= 0 ? "arrowtriangle.up.fill" :"arrowtriangle.down.fill")
                        .font(.system(size: 15))
                        .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp)))
                    
                    Text(String(format: "%.2f%%", abs(tokenPriceMovement1)))
                        .fontWeight(.semibold)
                        .monospaced()
                        .contentTransition(.numericText())
                }
                .foregroundStyle(movement >= 0 ? .green : .red)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrandColors.Gray0)
        .task {
            while simulatePriceMovement {
                tokenPriceMovement1 = await generatePriceMovement(delay: 5)
            }
        }
        .animation(.easeOut, value: tokenPriceMovement1)
    }
    
    var tokenCard4 : some View {
        HStack(alignment: .top) {
            HStack(alignment: .top) {
                Image("ETH")
                    .resizable()
                    .frame(width: 40, height: 40)
                VStack (alignment: .leading) {
                    Text("ETH")
                        .fontWeight(.semibold)
                        .foregroundStyle(BrandColors.Gray0)
                    Text("Ethereum")
                        .foregroundStyle(BrandColors.Gray400)
                }
            }
            Spacer()
            VStack (alignment: .trailing) {
                
                let movement = tokenPriceMovement2
                
                Text("$2,949.48")
                    .foregroundStyle(BrandColors.Gray100)
                    .monospaced()
                HStack (alignment: .center, spacing: 4) {
                    Image(systemName: movement >= 0 ? "arrowtriangle.up.fill" :"arrowtriangle.down.fill")
                        .font(.system(size: 15))
                        .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp)))
                    
                    Text(String(format: "%.2f%%", abs(tokenPriceMovement2)))
                        .fontWeight(.semibold)
                        .monospaced()
                        .contentTransition(.numericText())
                }
                .foregroundStyle(movement >= 0 ? .green : .red)
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 80)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(BrandColors.Gray700)
        .task {
            while simulatePriceMovement {
                tokenPriceMovement2 = await generatePriceMovement(delay: 10)
            }
        }
        .animation(.easeOut, value: tokenPriceMovement2)
    }
}

#Preview {
    ShowcaseSwipe()
}


extension ShowcaseSwipe {
    func generatePriceMovement(volatility: Double = 2.0, delay: Double = 0) async -> Double {
        // Occasional large movements (10% chance of 3x volatility)
        let isVolatileMove = Double.random(in: 0...1) < 0.1
        let effectiveVolatility = isVolatileMove ? volatility * 3 : volatility
        
        // Use normal distribution for more realistic clustering around 0
        let random1 = Double.random(in: 0...1)
        let random2 = Double.random(in: 0...1)
        let normalRandom = sqrt(-2 * log(random1)) * cos(2 * .pi * random2)
        
        try? await Task.sleep(for: .seconds(delay))
        
        return normalRandom * effectiveVolatility
    }
    
}

