//
//  SearchBar.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 12/01/2026.
//

import SwiftUI

struct SearchBar: View {
    
    @Binding var inputText : String
    @Namespace private var searchBarUnionNS
    
    let placeholder : String
    
    var body: some View {
        GlassEffectContainer(spacing: 32) {
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 20))
                        .foregroundStyle(BrandColors.Gray500)
                    TextField(placeholder, text: $inputText)
                }
                .padding()
                .padding(.horizontal, 2)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .glassEffect(.clear.interactive())
                
                if !inputText.isEmpty {
                    Button {
                        inputText = ""
                    } label: {
                        Image(systemName: "xmark")
                            .bold()
                            .foregroundStyle(.red)
                            .frame(width: 52, height: 52)
                            .glassEffect(.clear.interactive())
                            .transition(.blurReplace)
                    }
                    
                }
                
//                if !inputText.isEmpty {
//                    VStack {
//                        Image(systemName: "xmark")
//                            .bold()
//                            .foregroundStyle(.red)
//                    }
//                    .frame(width: 52, height: 52)
//                    .glassEffect(.clear.interactive())
//                    .transition(.blurReplace)
//                    .onTapGesture {
//                        inputText = ""
//                    }
//                }
            }
            
            
        }
        .ignoresSafeArea()
        .frame(height: 64)
        .animation(.easeInOut, value: inputText)
    }
}

#Preview {
//    SearchBar(inputText: .constant(""))
    TestSearch()
}

struct TestSearch : View {
    
    @State private var searchText : String = ""
    
    var body : some View {
        ZStack {
            SearchBar(inputText: $searchText, placeholder: "Search something")
        }
        .padding()
        .padding(.vertical, 56)
        .background(.mint)
    }
    
}
