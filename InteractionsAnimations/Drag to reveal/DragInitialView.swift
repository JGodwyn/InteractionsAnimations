//
//  DragInitialView.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 24/01/2026.
//

import SwiftUI

struct DragInitialView: View {
    var body: some View {
        VStack(spacing: 1) {
            SwipeableView(content: {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundStyle(.blue)
                    VStack(alignment: .leading) {
                        Text("Important Email")
                            .font(.headline)
                        Text("This is a preview of the message...")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                }
                .padding()
            }, actions: [
                SwipeAction(icon: "pin.fill", label: "Pin", color: .orange) {
                    print("Pin tapped")
                },
                SwipeAction(icon: "trash.fill", label: "Delete", color: .red) {
                    print("Delete tapped")
                }
            ])
            
            Divider()
            

        }
    }
}

#Preview {
//    SqueezeView()
    ZStack {
        SwipeView()
    }
    .padding()
}


struct SwipeAction: Identifiable {
    let id = UUID()
    let icon: String
    let label: String?
    let color: Color
    let action: () -> Void
}

struct SwipeableView<Content: View>: View {
    let content: Content
    let actions: [SwipeAction]
    
    @State private var offset: CGFloat = 0
    @State private var isSwiping = false
    
    let actionWidth: CGFloat = 80
    
    init(@ViewBuilder content: () -> Content, actions: [SwipeAction]) {
        self.content = content()
        self.actions = actions
    }
    
    var body: some View {
        ZStack(alignment: .trailing) {
            // Action buttons (revealed underneath)
            HStack(spacing: 0) {
                ForEach(actions) { action in
                    Button {
                        withAnimation(.spring(response: 0.3)) {
                            offset = 0
                        }
                        action.action()
                    } label: {
                        VStack(spacing: 4) {
                            Image(systemName: action.icon)
                                .font(.title3)
                            if let label = action.label {
                                Text(label)
                                    .font(.caption2)
                            }
                        }
                        .foregroundStyle(.white)
                        .frame(width: actionWidth)
                        .frame(maxHeight: .infinity)
                        .background(action.color)
                    }
                }
            }
            
            // Main content (slides over the actions)
            content
                .background(Color(.systemBackground))
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isSwiping = true
                            let translation = value.translation.width
                            
                            // Only allow left swipe (negative offset)
                            if translation < 0 {
                                let maxSwipe = -CGFloat(actions.count) * actionWidth
                                offset = max(translation, maxSwipe)
                            } else if offset < 0 {
                                // Allow dragging back
                                offset = min(0, offset + translation)
                            }
                        }
                        .onEnded { value in
                            isSwiping = false
                            let threshold: CGFloat = -40
                            
                            withAnimation(.spring(response: 0.3)) {
                                if value.translation.width < threshold {
                                    // Snap to revealed state
                                    offset = -CGFloat(actions.count) * actionWidth
                                } else {
                                    // Snap back to closed
                                    offset = 0
                                }
                            }
                        }
                )
        }
    }
}


struct testView : View {
    
    @State private var sliderValue: CGFloat = 0
    
    // absoluteCircleLoad
    @State private var CircleLocationValue : CGPoint = .init(x: 100, y: 100)
    
    // relativeCircleLoad
    @State private var dragOffset = CGSize.zero
    @State private var finalPosition = CGSize.zero // prevent snapping
    
    // swipeTest
    @State private var dragGesture : CGFloat = 0
    @State private var finalDragGesture : CGFloat = 0 // prevents initial snapback
    

    var body: some View {
        GeometryReader { geometry in
//            Slider(value: $sliderValue, in: 1...200)
//            absoluteCircleLoad
//            relativeCircleLoad
            SwipeTest

        }
        .padding()
    }
    
    var SwipeTest : some View {
        ZStack(alignment: .trailing) {
            HStack(spacing: 0) {
                Rectangle().fill(.red)
                    .frame(width: 64)
                Rectangle().fill(.blue)
                    .frame(width: 64)
                Rectangle().fill(.green)
                    .frame(width: 64)
                    .onTapGesture {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1)){
                            finalDragGesture = 0
                        }
                    }
            }
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Image(systemName: "paperplane")
                    Text("Swipe this content")
                        .fontWeight(.bold)
                }
                
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(BrandColors.Gray100)
            .offset(x: finalDragGesture + dragGesture)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        dragGesture = gesture.translation.width
                    }
                    .onEnded { gesture in
                        finalDragGesture += gesture.translation.width
                        dragGesture = 0
                        if gesture.translation.width <= -120 {
                            // SNAP NOW!!!
                            finalDragGesture = -192
                        } else {
                            finalDragGesture = 0
                        }
                    }
            )
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .frame(height: 64)
        .background(BrandColors.Gray200)
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 1), value: dragGesture)
        .clipped()
    }
    
    var absoluteCircleLoad : some View {
        Circle()
            .frame(width: 100, height: 100)
            .overlay {
                Text("Position")
                    .foregroundStyle(.white)
            }
            .position(CircleLocationValue)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        CircleLocationValue = value.location
//                        print("X: \(value.location.x.rounded()), Y: \(value.location.y.rounded())")
//                            print("location: \(value.location)")
//                            print("time: \(value.time)")
//                            print("start location: \(value.startLocation)")
//                            print("velocity: \(value.velocity)")
                    }
            )
            .animation(.interactiveSpring(response: 0.5, dampingFraction: 1), value: CircleLocationValue)
    }
    
    var relativeCircleLoad : some View {
        VStack {
            Circle()
                    .fill(Color.blue)
                    .frame(width: 80, height: 80)
                    .offset(x: finalPosition.width + dragOffset.width,
                            y: finalPosition.height + dragOffset.height)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                dragOffset = value.translation
                            }
                            .onEnded { value in
                                finalPosition.width += value.translation.width
                                finalPosition.height += value.translation.height
                                dragOffset = .zero
                            }
                    )
        }
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 1), value: [dragOffset, finalPosition])
        .frame(maxWidth: .infinity, maxHeight:  .infinity)
        .background(BrandColors.Gray200)
        
    }
}


struct SwipeView : View {
    
    let actionWidth : CGFloat = 64 // the width of one button
    let actionCount : Int = 3 // number of buttons
    
    var maxSwipe: CGFloat { -(actionWidth * CGFloat(actionCount)) } // width of the actions
    
    @State private var dragGesture: CGFloat = 0
    @State private var finalDragGesture: CGFloat = 0
    @State private var isExpanded: Bool = false
    @State private var dynamicActionStackWidth : CGFloat = 0
    
    enum swipeStatus {
        case open, closed
    }
    
    func handleSwipe(action : swipeStatus) {
        switch action {
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
            HStack(spacing: 0) { // content of the action
                Rectangle().fill(.red)
                    .frame(width: dynamicActionStackWidth/CGFloat(actionCount))
                Rectangle().fill(.yellow)
                    .frame(width: dynamicActionStackWidth/CGFloat(actionCount))
                Rectangle().fill(.green)
                    .frame(width: dynamicActionStackWidth/CGFloat(actionCount))
                    .onTapGesture {
                        handleSwipe(action: .closed)
                    }
            }
            .frame(width: dynamicActionStackWidth, alignment: .trailing)
            .clipped()
            
            VStack(alignment: .leading) { // content
                HStack(alignment: .top) {
                    Image(systemName: "paperplane")
                    Text("Swipe this content")
                        .fontWeight(.bold)
                }
                
            }
            .padding(.horizontal, 16)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(BrandColors.Gray100)
            .offset(x: finalDragGesture + dragGesture)
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        isExpanded = true
                        if finalDragGesture == maxSwipe { // if it's already open
                            dragGesture = max(min(gesture.translation.width, abs(maxSwipe) + 24), -24)
                            // moves 24 units and then snaps back
                            dynamicActionStackWidth = min(abs(maxSwipe) + 24, abs(maxSwipe) - gesture.translation.width)
                            
                            print("HStack(changing matched):\t\(dynamicActionStackWidth)")
                            
                        } else {
                            dragGesture = max(maxSwipe - 24, min(24, gesture.translation.width))
                            // essentially, go 24 units beyond the action buttons before snapping into place when released
                            dynamicActionStackWidth = abs(dragGesture)
                            
                            print("HStack(changing):\t\(dynamicActionStackWidth)")
                        }
                    }
                    .onEnded { gesture in
                        dragGesture = 0 // reset the gesture value
                        let totalOffset = finalDragGesture + gesture.translation.width
                        let velocity = gesture.predictedEndTranslation.width
                        
                        if totalOffset <= maxSwipe * 0.65 || velocity < -200 {
                            // expand if the gesture goes beyond 65% of the actions
                            // or if the user swipes really quick
                            handleSwipe(action: .open)
                            
                            print("HStack(ended):\t\(dynamicActionStackWidth)")
                            
                        } else {
                            handleSwipe(action: .closed)
                            
                            print("HStack(ended):\t\(dynamicActionStackWidth)")
                        }
                    }
            )
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .frame(height: 64)
        .background(BrandColors.Gray200)
        .clipped()
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 1), value: isExpanded)
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 1), value: [dragGesture, finalDragGesture])
    }
}
