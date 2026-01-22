//
//  FlowLayout.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 14/01/2026.
//

import Foundation
import SwiftUI

struct FlowLayout: Layout {
    var spacing: CGFloat = 8
    
    enum HorizontalAlignment {
        case leading
        case center
        case trailing
    }
    
    var alignment: HorizontalAlignment = .leading
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing,
            alignment: alignment
        )
        return result.size
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing,
            alignment: alignment
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: CGPoint(x: bounds.minX + result.frames[index].minX,
                                     y: bounds.minY + result.frames[index].minY),
                         proposal: .unspecified)
        }
    }
    
    struct FlowResult {
        var frames: [CGRect] = []
        var size: CGSize = .zero
        var lineXOffsets: [CGFloat] = []
        
        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat, alignment: HorizontalAlignment) {
            var lines: [[(index: Int, size: CGSize)]] = []
            var currentLine: [(index: Int, size: CGSize)] = []
            var currentLineWidth: CGFloat = 0
            var currentLineHeight: CGFloat = 0

            // Measure and break into lines
            for (idx, subview) in subviews.enumerated() {
                let sz = subview.sizeThatFits(.unspecified)
                let nextWidth = currentLine.isEmpty ? sz.width : currentLineWidth + spacing + sz.width
                if nextWidth > maxWidth && !currentLine.isEmpty {
                    lines.append(currentLine)
                    currentLine = [(idx, sz)]
                    currentLineWidth = sz.width
                    currentLineHeight = sz.height
                } else {
                    currentLine.append((idx, sz))
                    currentLineWidth = nextWidth
                    currentLineHeight = max(currentLineHeight, sz.height)
                }
            }
            if !currentLine.isEmpty {
                lines.append(currentLine)
            }

            // Compute frames with alignment per line
            frames = Array(repeating: .zero, count: subviews.count)
            lineXOffsets = []

            var y: CGFloat = 0
            var totalHeight: CGFloat = 0

            for line in lines {
                // Line metrics
                let lineHeights = line.map { $0.size.height }
                let lineHeight = lineHeights.max() ?? 0
                let totalContentWidth: CGFloat = line.reduce(0) { partial, item in
                    partial + item.size.width
                } + CGFloat(max(0, line.count - 1)) * spacing

                let xOffset: CGFloat
                switch alignment {
                case .leading:
                    xOffset = 0
                case .center:
                    xOffset = max(0, (maxWidth - totalContentWidth) / 2)
                case .trailing:
                    xOffset = max(0, maxWidth - totalContentWidth)
                }
                lineXOffsets.append(xOffset)

                var x: CGFloat = xOffset
                for (index, size) in line {
                    frames[index] = CGRect(x: x, y: y, width: size.width, height: size.height)
                    x += size.width + spacing
                }

                y += lineHeight + spacing
                totalHeight = y
            }

            // Remove extra spacing after last line
            if !lines.isEmpty {
                totalHeight -= spacing
            }

            self.size = CGSize(width: maxWidth, height: max(totalHeight, 0))
        }
    }
}
