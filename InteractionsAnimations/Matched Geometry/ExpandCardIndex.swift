//
//  ExpandCardIndex.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 06/01/2026.
//

import SwiftUI

struct ExpandCardIndex: View {
    @Namespace private var bannerNS
    @Namespace private var bannerTextNS
    
    @Namespace private var trashAnimationNS
    
    @State private var deletingItemID : UUID? = nil
    
    @State private var expandBanner : Bool = false
    @State private var shouldWiggle : Bool = false
    @State private var shouldBinRemove : Bool = true
    @State private var showExpandedText : Bool = false
    @State private var exampleCollection : [tempData] = tempData.example
    
    var body: some View {
        GeometryReader { geometry in
            let trashPosition : CGPoint = CGPoint(x: geometry.size.width * 0.85,
                                                  y: geometry.size.height - (geometry.size.height * 0.05))
        
            ZStack {
                VStack(spacing: 12) {
                    glassContainerTextField(tempData: $exampleCollection)
                    
                    ForEach(exampleCollection.sorted {$0.date > $1.date}) { item in
//                        textCard(item: item, nameSpace: trashAnimationNS, isDeleting: deletingItemID == item.id) {
//                            handleDelete(item: item)
//                        }
                        
                        SwipeableView(cornerRadius: 32, content: {
                            textCard(item: item, nameSpace: trashAnimationNS, isDeleting: deletingItemID == item.id) {
                                handleDelete(item: item)
                            }
                        }, actions: [
                            SwipeAction(icon: "pencil", label: "Edit", foreground: .white, background: Color(hex: "#FF5800")) {
                                handleDelete(item: item)
                            },
                            
                            SwipeAction(icon: "trash.fill", label: "Delete", foreground: .red, background: Color(hex: "#FFE4E4")) {
                                handleDelete(item: item)
                            },
                            
                            SwipeAction(icon: "pin", foreground: .blue, background: Color(hex: "#A4DDED")) {
                                handleDelete(item: item)
                            }
                        ])
                        .transition(.move(edge: .top).combined(with: .scale).combined(with: .blurReplace))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.gray.opacity(0.1))
                .overlay {
                    if exampleCollection.isEmpty {
                        VStack {
                            Image("CardGameIcon")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 48, height: 48)
                                .foregroundStyle(.gray)
                            Text("No entries here. Start by adding one above")
                                .frame(width: 240)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.gray)
                        }
                        .frame(height: 256)
                        .frame(maxWidth: .infinity)
                        .mask {
                            RadialGradient(
                                stops: [
                                    .init(color: Color.black.opacity(1), location: 0),
                                    .init(color: Color.black.opacity(1), location: 0.3),
                                    .init(color: Color.black.opacity(0), location: 0.7)
                                ],
                                center: .center,
                                startRadius: 0,
                                endRadius: 200
                            )
                        }
                        .offset(y: 120)
                    }
                }
            }
            .overlay {
                Image("TrashCan")
                    .resizable()
                    .frame(width: 48, height: 48)
                    .padding(12)
                    .background(.white, in: .rect(cornerRadius: 24, style: .continuous))
                    .wiggle(trigger: deletingItemID != nil)
                    .compositingGroup()
                    .shadow(color: .black.opacity(0.1), radius: 20, y: 8)
                    .matchedGeometryEffect(id: "flyingTrash", in: trashAnimationNS, properties: .position, isSource: true)
                    .position(trashPosition)
                    .zIndex(101)
                    .offset(x: shouldBinRemove ? 100 : 0)
            }
            .animation(.smooth, value: exampleCollection)
            .animation(.smooth.delay(0.5), value: shouldBinRemove)
        }
        .onAppear {
            showBinHandler(handler: &shouldBinRemove)
        }
        .onChange(of: exampleCollection) { _, _ in
            showBinHandler(handler: &shouldBinRemove)
        }
    }
    
    func showBinHandler(handler : inout Bool) {
        if exampleCollection.isEmpty {
            handler = true
        } else {
            handler = false
        }
    }
    
    func handleDelete(item: tempData) {
        withAnimation(.easeIn) {
            deletingItemID = item.id
        }
        Task {
            try? await Task.sleep(for: .seconds(0.1))
            if let idx = exampleCollection.firstIndex(where: { $0.id == item.id }) { _ = exampleCollection.remove(at: idx) }
            deletingItemID = nil
        }
    }
}

#Preview {
    ExpandCardIndex()
}


extension ExpandCardIndex {
    
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
    
}

struct tempData : Hashable, Identifiable {
    let id = UUID()
    var name : String
    var date : Date
    
    static var example : [tempData]  = [
        .init(name: "Auto added 1", date: .now),
        .init(name: "Auto added 2", date: .now),
//        .init(name: "Auto added 3", date: .now),
//        .init(name: "Auto added 4", date: .now),
//        .init(name: "Auto added 5", date: .now),
//        .init(name: "Auto added 6", date: .now)
    ]
}

struct textCard: View {
    let item: tempData
    let nameSpace: Namespace.ID
    let isDeleting: Bool
    let tapDelete: () -> Void
    
    @Namespace private var changeFormNS
    @State private var changeForm: Bool = false
    @State private var isLifted: Bool = false
    
    var body: some View {
        Group {
            if !changeForm {
                HStack(spacing: 16) {
                    Rectangle().fill(.red.opacity(0.1))
                        .frame(width: 72, height: 72)
                        .clipShape(.rect(cornerRadius: 16))
                        .overlay {
                            Image(systemName: "trash.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(.red)
                        }
                        .onTapGesture {
                                isLifted = true
                                Task {
                                    try? await Task.sleep(for: .seconds(0.2))
                                    tapDelete()
                                }
                        }
                    
                    VStack(alignment: .leading) {
                        Text(item.name)
                            .font(.system(size: 18))
                            .fontWeight(.bold)
                        Text("\(item.date)")
                            .lineLimit(2)
                            .foregroundStyle(.gray)
                    }
                }
                .padding(12)
                .padding(.trailing, 12)
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 24, style: .continuous))
                .matchedGeometryEffect(id: "changeForm", in: changeFormNS, properties: .size, anchor: .center)
                .frame(maxWidth: .infinity)
                .onTapGesture {
                    withAnimation(.smooth(duration: 0.3)) {
                        changeForm = true
                    }
                }
            
            } else {
                HStack {
                    Rectangle().fill(.red)
                        .frame(width: 24, height: 24)
                        .clipShape(.rect(cornerRadius: 8))
                    Text(item.name)
                    Image(systemName: "chevron.up.chevron.down")
                        .foregroundStyle(.gray)
                }
                .padding(12)
                .glassEffect(.clear.interactive(), in: .rect(cornerRadius: 20, style: .continuous))
                .matchedGeometryEffect(id: "changeForm", in: changeFormNS, properties: .size, anchor: .center)
                .onTapGesture {
                    withAnimation(.smooth(duration: 0.3)) {
                        changeForm = false
                    }
                }
            }
        }
        .compositingGroup()
        .offset(x: isLifted ? 20 : 0, y: isLifted ? -40 : 0)
        // using any stack messes up the expand and contract effect
        // compositingGroup() flattens the group and adds the effect as if it's just one view
        // if not, the effect will be added to every view
        .matchedGeometryEffect(
            // Apply the matched geometry effect to the entire card
            id: isDeleting ? "flyingTrash" : "card-\(item.id)",
            // this item.id makes sure each card gets another name so they all don't appear in the same place due to their geometry matching
            in: nameSpace,
            properties: .position,
            isSource: false
        )
        .animation(.easeIn(duration: 0.2), value: isLifted)
        .animation(.easeIn(duration: 0.5), value: isDeleting)
        .scaleEffect(isDeleting ? 0 : 1)
        .onDisappear {
            isLifted = false
        }
    }
}


struct glassContainerTextField : View {
    
    @State private var showInputField : Bool = false
    @State private var inputText : String = ""
    @Namespace private var joinTextFieldsNS
    @Binding var tempData : [tempData]
    
    var body : some View {
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
                        tempData.append(.init(name: inputText, date: .now))
                        withAnimation {
                            inputText = ""
                            showInputField.toggle()
                        }
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
    
}
