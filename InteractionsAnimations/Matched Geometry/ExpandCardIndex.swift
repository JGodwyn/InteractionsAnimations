//
//  ExpandCardIndex.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 06/01/2026.
//

import SwiftUI

struct ExpandCardIndex: View {
    
    // design the animation style something
    
    @Namespace fileprivate var bannerNS
    @Namespace fileprivate var bannerTextNS
    @Namespace fileprivate var joinTextFieldsNS
    
    @Namespace fileprivate var moveToBinNS
    @State private var moveToBin : Bool = false
    
    @State private var expandBanner : Bool = false
    @State private var showExpandedText : Bool = false
    @State private var showInputField : Bool = false
    @State private var inputText : String = ""
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 16) {
                
                Button("Reset") {
                    moveToBin.toggle()
                }
                
                // this has to be inside each struct
                if !moveToBin {
                    HStack {
                        Rectangle().fill(.teal)
                            .frame(width: 24, height: 24)
                            .clipShape(.rect(cornerRadius: 8))
                        Text("label")
                        Image(systemName: "chevron.up.chevron.down")
                            .foregroundStyle(.gray)
                    }
                    .padding(12)
                    .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 20, style: .continuous))
                    .onTapGesture {
                        moveToBin = true
                    }
                    .matchedGeometryEffect(id: "moveToBin", in: moveToBinNS, properties: .position)
                    .transition(.scale.combined(with: .blurReplace))
                    .zIndex(4)
                }
                
                glassContainerTextField
                    .zIndex(2)
                
                ForEach(tempData.example.sorted(by: {$0.date > $1.date}), id: \.self) { item in
                    textCard(label: item.name, date: item.date)
                        .transition(.move(edge: .top).combined(with: .scale).combined(with: .blurReplace))
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.gray.opacity(0.1))
            .animation(.smooth, value: tempData.example)
            .animation(.easeOut(duration: 0.5), value: moveToBin)
            .overlay {
                if moveToBin {
                    Image("TrashCan")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .padding(12)
                        .background(.white, in: .rect(cornerRadius: 24, style: .continuous))
                        .compositingGroup()
                        .shadow(color: .black.opacity(0.1), radius: 20, y: 8)
                        .matchedGeometryEffect(id: "moveToBin", in: moveToBinNS, properties: .position)
                        .position(x: geometry.size.width * 0.85,
                                 y: geometry.size.height - (geometry.size.height * 0.05))
                        .zIndex(4)
                } else {
                    Image("TrashCan")
                        .resizable()
                        .frame(width: 48, height: 48)
                        .padding(12)
                        .background(.white, in: .rect(cornerRadius: 24, style: .continuous))
                        .compositingGroup()
                        .shadow(color: .black.opacity(0.1), radius: 20, y: 8)
                        .position(x: geometry.size.width * 0.85,
                                 y: geometry.size.height - (geometry.size.height * 0.05))
                }
            }

        }
    }
}

#Preview {
    ExpandCardIndex()
}


extension ExpandCardIndex {
    
    var symbolName : String {
        guard showInputField else {
            return "plus"
        }
        if inputText.isEmpty {
            return "minus"
        } else {
            return "paperplane.fill"
        }
    }
    
    var collapsedBanner : some View {
        HStack(alignment: .top) {
                Image(systemName: "info.circle.fill")
                    .foregroundStyle(.teal)
                Text("Tap to view information")
                    .lineLimit(1)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .matchedGeometryEffect(id: "banner", in: bannerNS)
        .frame(alignment: .leading)
        .background(.teal.opacity(1), in: .rect(cornerRadius: 12))
        .onTapGesture {
            expandBanner = true
        }
    }
    
    var expandedBanner : some View {
        HStack(alignment: .top) {
            Image(systemName: "info.circle.fill")
                .foregroundStyle(.teal)
            Text("This is the full information contained in the banner so you should know that it can keep going for as long as possible")
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .matchedGeometryEffect(id: "banner", in: bannerNS)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.teal.opacity(1), in: .rect(cornerRadius: 12))
        .onTapGesture {
            expandBanner = false
        }
    }
    
    var glassContainerTextField : some View {
        GlassEffectContainer {
            HStack {
                if showInputField {
                    TextField("Enter text here", text: $inputText)
                        .padding()
                        .glassEffect()
                }
                
                Button {
                    if inputText.isEmpty {
                        withAnimation {
                            showInputField.toggle()
                        }
                    } else {
                        tempData.example.append(.init(name: inputText, date: .now))
                        inputText = ""
                        showInputField.toggle()
                    }
                    
                } label: {
                    HStack(spacing: 0) {
                        if !showInputField {
                            Text("Add an entry")
                                .padding(.leading, 12)
                        }
                        Image(systemName: symbolName)
                            .foregroundStyle(showInputField ? .blue : .white)
                            .font(.system(size: showInputField ? 22 : 17))
                            .bold()
                            .frame(height: 32)
                            .frame(minWidth: 40)
                            .contentTransition(.symbolEffect(.replace.magic(fallback: .downUp)))
                    }
                }
                .buttonStyle(.glassProminent)
            }
            .glassEffectUnion(id: "joinField", namespace: joinTextFieldsNS) // chef kiss!
        }
    }
    
    @ViewBuilder
    fileprivate func expandedTextView() -> some View {
        if !showExpandedText {
            Text("Tap to view information")
        } else {
            Text("This is the full information contained in the banner so you should know that it can keep going for as long as possible")
        }
        
        Button("Change this text") {
            withAnimation(.smooth(duration: 0.1)) {
                showExpandedText.toggle()
            }
        }
        .buttonStyle(.glassProminent)
        .padding()
    }
}



struct tempData : Hashable {
    var name : String
    var date : Date
    
    static var example : [tempData]  = [
        .init(name: "Auto added", date: .now)
    ]
}


struct textCard : View {
    
    var label: String
    var date: Date
    @Namespace private var changeFormNS
    @State private var changeForm : Bool = false
    
    var body: some View {
            if !changeForm {
                HStack(spacing: 16) {
                    Rectangle().fill(.teal)
                        .frame(width: 72, height: 72)
                        .clipShape(.rect(cornerRadius: 16))
                    
                    VStack(alignment: .leading) {
                        Text(label)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        Text("\(date)")
                            .lineLimit(2)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(12)
                .padding(.trailing, 12)
                .matchedGeometryEffect(id: "changeForm", in: changeFormNS, properties: .size, anchor: .topLeading)
                .frame(maxWidth: .infinity)
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 24, style: .continuous))
                .onTapGesture {
                    withAnimation(.smooth(duration: 0.3)) {
                        changeForm = true
                    }
                }

            } else {
                HStack {
                    Rectangle().fill(.teal)
                        .frame(width: 24, height: 24)
                        .clipShape(.rect(cornerRadius: 8))
                    Text(label)
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(.gray)
                }
                .padding(12)
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 20, style: .continuous))
                .matchedGeometryEffect(id: "changeForm", in: changeFormNS, properties: .size, anchor: .topLeading)
                .onTapGesture {
                    withAnimation(.smooth(duration: 0.3)) {
                        changeForm = false
                    }
                }
            }
        }
}
