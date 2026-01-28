//
//  SwipeableView.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 27/01/2026.
//

import SwiftUI

struct SwipeAction: Identifiable {
    let id = UUID()
    let icon: String
    let label: String?
    let foreground: Color
    let background: Color
    let action: () -> Void
    
    init(icon: String, label: String? = nil, foreground: Color = .black, background: Color, action: @escaping () -> Void) {
        self.icon = icon
        self.label = label
        self.foreground = foreground
        self.background = background
        self.action = action
    }
}

struct SwipeableView<Content:View> : View {
    let content: Content
    let actions : [SwipeAction]
    let actionCount : Int // number of buttons
    let singleActionWidth : CGFloat // the width of one button
    let cornerRadius : CGFloat
    
    init(singleActionWidth : CGFloat = 64, cornerRadius : CGFloat = 0, @ViewBuilder content : () -> Content, actions : [SwipeAction]) {
        self.content = content()
        self.actions = actions
        self.actionCount = self.actions.count
        self.singleActionWidth = singleActionWidth
        self.cornerRadius = cornerRadius
    }
    
    var maxSwipe: CGFloat { -(singleActionWidth * CGFloat(actionCount)) } // width of the actions
    
    @State private var dragGesture: CGFloat = 0
    @State private var finalDragGesture: CGFloat = 0
    @State private var isExpanded: Bool = false
    @State private var dynamicActionStackWidth : CGFloat = 0
    @State private var containerSize : CGSize = .zero
    
    enum swipeStatus {
        case open, closed
    }
    
    func handleSwipe(state : swipeStatus) {
        switch state {
            case .open:
                finalDragGesture = maxSwipe
                isExpanded = true
                dynamicActionStackWidth = abs(finalDragGesture)
            case .closed:
                finalDragGesture = 0
                isExpanded = false
                dynamicActionStackWidth = abs(finalDragGesture)
        }
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            HStack(spacing: 0) {
                ForEach(actions) { item in
                    Button {
                        item.action()
                        handleSwipe(state: .closed)
                    } label: {
                        VStack {
                            Image(systemName: item.icon)
                            if let label = item.label {
                                Text(label)
                                    .fixedSize(horizontal: true, vertical: false)
                                    .fontWeight(.medium)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .foregroundStyle(item.foreground)
                    .frame(width: dynamicActionStackWidth / CGFloat(actionCount))
                    .frame(maxHeight: .infinity)
                    .clipped()
                    .background(item.background)
                }
            }
            .frame(width: dynamicActionStackWidth, alignment: .trailing)
            .clipped()
            .mask {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            }
            
            content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(BrandColors.Gray100)
            .mask {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            }
            .offset(x: finalDragGesture + dragGesture)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        isExpanded = true
                        if finalDragGesture == maxSwipe { // if it's already open
                            dragGesture = max(min(gesture.translation.width, abs(maxSwipe) + 24), -24)
                            // moves 24 units and then snaps back
                            dynamicActionStackWidth = min(abs(maxSwipe) + 24, abs(maxSwipe) - gesture.translation.width)
                            
                        } else {
                            dragGesture = max(maxSwipe - 24, min(24, gesture.translation.width))
                            // essentially, go 24 units beyond the action buttons before snapping into place when released
                            dynamicActionStackWidth = abs(max(maxSwipe-24, min(0, gesture.translation.width)))
                        }
                    }
                    .onEnded { gesture in
                        dragGesture = 0 // reset the gesture value
                        let totalOffset = finalDragGesture + gesture.translation.width
                        let velocity = gesture.predictedEndTranslation.width
                        
                        if totalOffset <= maxSwipe * 0.65 || velocity < -200 {
                            // expand if the gesture goes beyond 65% of the actions
                            // or if the user swipes really quick
                            handleSwipe(state: .open)
                            
                        } else {
                            handleSwipe(state: .closed)
                        }
                    }
            )
            .readSize {
                containerSize = $0
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .frame(height: containerSize.height) // height of the content
//        .background(BrandColors.Gray200)
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 1), value: isExpanded)
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 1), value: [dragGesture, finalDragGesture])
        .clipped()
        .mask {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
        }
    }
}

#Preview {
    VStack {
        SwipeableView(singleActionWidth: 80, content: {
            HStack {
                Image("AppLogo")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.green)
                    .transition(.blurReplace)
                Text("Swipe here to view")
                    .font(.system(size: 19, weight: .semibold))
            }
            .padding()
            .frame(height: 64)
        }, actions: [
            SwipeAction(icon: "trash.fill", label: "Delete", foreground: .red, background: Color(hex: "#FFE4E4")) {
                
            },
            SwipeAction(icon: "pencil", label: "Edit", foreground: .white, background: Color(hex: "#8F00FF")) {
                
            },
            SwipeAction(icon: "pin.fill", label: "Pin", foreground: Color(hex: "#000080"), background: Color(hex: "#87CEFA")) {
                
            }
                   ])
        SwipeableView(singleActionWidth: 80, cornerRadius: 16, content: {
            HStack {
                Image("AppLogo")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundStyle(.green)
                    .transition(.blurReplace)
                Text("Swipe here to view")
                    .font(.system(size: 19, weight: .semibold))
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(.red)
        }, actions: [
            SwipeAction(icon: "trash.fill", label: "Delete", foreground: .red, background: Color(hex: "#FFE4E4")) {
                
            },
            SwipeAction(icon: "pencil", label: "Edit", foreground: .white, background: Color(hex: "#8F00FF")) {
                
            }
                   ])
    }
    .padding()
}
