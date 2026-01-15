//
//  ValidationChips.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 14/01/2026.
//

import SwiftUI

struct ValidationChips: View {

    @Namespace private var expandChipNS
    let label : String
    let expanded : Bool

    var body: some View {
        // the criteria might expand to show more information
        VStack(alignment: .leading) {
            if expanded {
                Text(label)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(Color(hex: "#DC0000"))
                    .padding(.horizontal, 8)
                    .frame(height: 24)
                    .glassEffect(.clear.tint(.red.opacity(0.1)).interactive())
                    .matchedGeometryEffect(
                        id: "expandChip",
                        in: expandChipNS,
                        properties: [.position]
                    )
                    .transition(.blurReplace.combined(with: .scale))


            } else {
                Circle().fill(.green)
                    .frame(width: 8, height: 8)
                    .matchedGeometryEffect(
                        id: "expandChip",
                        in: expandChipNS,
                        properties: [.position]
                    )
                    .transition(.blurReplace.combined(with: .scale))
            }
        }
        .frame(alignment: .leading)
        .animation(.easeOut(duration: 0.3), value: expanded)
    }
}

#Preview {
    ZStack {
        Color(BrandColors.Gray200)
            .ignoresSafeArea()
        testValidationChips()
    }
}


struct testValidationChips : View {
    
    @State private var testExpanded : Bool = true
    
    var body: some View {
        VStack(alignment: .leading) {
            ValidationChips(label: "At least 1 symbol", expanded: testExpanded)
            ValidationChips(label: "At least 2 characters", expanded: testExpanded)
        }
        .frame(width: 320, height: 400, alignment: .leading)
        .overlay(alignment: .bottom) {
            Button("Expand") {
                testExpanded.toggle()
            }
            .buttonStyle(.glassProminent)
            .offset(y: 120)
        }
    }
}
