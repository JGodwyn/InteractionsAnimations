//
//  SliderImages.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 05/01/2026.
//

import SwiftUI

struct SliderImages: View {
    @State private var sliderValue: Double = 10
    @State private var imageCount: Int = 10

    var columnCount: Int {
        guard sliderValue < 4 else { return 4 }
        return Int(sliderValue)
    }

    var body: some View {
        withOutGR
        withGR
    }
}

#Preview {
    SliderImages()
}

extension SliderImages {
    private func GridColumns(amount count: Int) -> [GridItem] {
        return Array(repeating: GridItem(.flexible()), count: count)
    }

    private var withOutGR: some View {
        ScrollView {
            Slider(value: $sliderValue, in: 1...Double(imageCount), step: 1)
            LazyVGrid(columns: GridColumns(amount: columnCount)) {
                ForEach(1...Int(sliderValue), id: \.self) { _ in
                    Rectangle()
                        .frame(height: 80)
                }
            }
        }
        .padding()
        .animation(.spring(duration: 0.2), value: columnCount)
    }

    private var withGR: some View {
        VStack {
            Slider(value: $sliderValue, in: 1...Double(imageCount), step: 1)
            GeometryReader { reader in
                let minCellWidth = reader.size.width / 4 // with of one rect
                let maxCellWidth = reader.size.width / CGFloat(imageCount) // largest size
                let optimalWidth = max(minCellWidth, maxCellWidth)
                let numberOfCol = Int(reader.size.width / optimalWidth)
                
                LazyVGrid(columns: GridColumns(amount: numberOfCol)) {
                    ForEach(1...Int(sliderValue), id: \.self) { _ in
                        Rectangle()
                            .frame(height: 80)
                    }
                }
            }
        }
        .padding()
        .animation(.spring(duration: 0.2), value: columnCount)
    }
}
