//
//  SwipeNotifications.swift
//  InteractionsAnimations
//
//  Created by Gdwn16 on 30/01/2026.
//

import SwiftUI

struct SwipeNotifications: View {
    
    
    @Namespace private var glassify
    
    @State private var showNotification : Bool = false
    @State private var notifCollection : [NotificationContent] = NotificationContent.defaultPosts
    
    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Text("Notifications")
                    .font(.system(size: 32, weight: .bold))
                    .kerning(-0.5)
                Spacer()
                
                GlassEffectContainer {
                    HStack(spacing: 8) {
                        Group {
                            Image(systemName: "magnifyingglass")
                            Image(systemName: "ellipsis")
                        }
                        .font(.system(size: 22))
                        .frame(width: 56, height: 48)
                        .glassEffect(.regular.interactive())
                    }
                }
            }
            
            Button("Do something") {
             handleSeeMoreNotification()
            }
            .buttonStyle(.glassProminent)
            
            ScrollView(showsIndicators: false) {
                ForEach(notifCollection) { notif in
                    SwipeableView(singleActionWidth: 96, cornerRadius: 24, content: {
                        notifCard(content: notif)
                    }, actions: [
                        SwipeAction(icon: "eye.fill", label: "See more", foreground: Color(hex: "#606c38"), background: Color(hex: "#e9edc9")) {
                            // when tapped
//                            handleSeeMoreNotification()
                        },
                        
                        SwipeAction(icon: "eye.half.closed.fill", label: "See less", foreground: .white, background: Color(hex: "#99582a")) {
                            // when tapped
                            
                        },
                        
                        SwipeAction(icon: "trash.fill", label: "Delete", foreground: .white, background: Color(hex: "#dd2d4a")) {
                            handleDelete(content: notif)
                        }
                    ])
                    .transition(.push(from: .trailing).combined(with: .blurReplace))
                }
            }
            .scrollIndicatorsFlash(trigger: notifCollection)

        }
        .padding()
        .background(BrandColors.Gray100)
        .ignoresSafeArea(edges: .bottom)
        .overlay(alignment: .bottom) {
            if showNotification {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                    Text("You'll see more of this")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal)
                .frame(height: 48)
                .glassEffect(.regular.tint(.green.opacity(0.1)))
                .compositingGroup()
                .shadow(color: .green.opacity(0.5), radius: 24)
                .transition(.move(edge: .bottom).combined(with: .blurReplace))
            }
        }
        .animation(.smooth, value: showNotification)
        .animation(.smooth, value: notifCollection)
    }
    
    func handleDelete(content : NotificationContent) {
        if let idx = notifCollection.firstIndex(where: { $0.id == content.id }) {
            notifCollection.remove(at: idx)
        }
    }
    
    func handleSeeMoreNotification() {        
        showNotification = true
        Task {
            try? await Task.sleep(for: .seconds(2))
            showNotification = false
        }
    }
    
    
    @ViewBuilder
    func notifCard(content : NotificationContent) -> some View {
        HStack (alignment: .top) {
            if let image = content.image {
                image
                    .resizable()
                    .frame(width: 56, height: 56)
            } else {
                Image("Placeholder")
                    .resizable()
                    .frame(width: 56, height: 56)
            }
            
            Text("\(Text(content.author).bold()) \(Text(content.action.description).foregroundStyle(BrandColors.Gray500)): \(content.content)")
                .font(.system(size: 17))
                .lineSpacing(2)
            
            Text(content.date.formatted(date: .omitted, time: .shortened))
                .font(.system(size: 14))
                .foregroundStyle(BrandColors.Gray500)
            
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 100)
        .background(BrandColors.Gray0, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
    
}

#Preview {
    SwipeNotifications()
}


struct NotificationContent : Identifiable, Equatable {
    var id = UUID()
    var author : String
    var content : String
    var date : Date
    var image : Image?
    var action : actions
    
    enum actions {
        case posted
        case reposted
        case liked
        case commented
        case viewProfile
        
        var description : String {
            switch self {
            case .posted:
                return "posted"
            case .reposted:
                return "reposted"
            case .liked:
                return "liked"
            case .commented:
                return "commented"
            case .viewProfile:
                return "viewed your profile"
            }
        }
    }
    
    static var defaultPosts : [NotificationContent] {
            [
                NotificationContent(author: "Godwin John", content: "Just finished an amazing workout session at the gym today! Feeling stronger than ever. Remember, consistency is key when it comes to fitness. Don't give up on your goals, keep pushing forward every single day!", date: Date(), image: Image("IMG_1"), action: .posted),
                
                NotificationContent(author: "Sarah Mitchell", content: "Breaking news in the tech world! The latest smartphone release is absolutely mind-blowing. The camera quality is unreal and the battery life lasts for days. I've been testing it all week and I'm thoroughly impressed with the innovations they've brought to the table.", date: Date().addingTimeInterval(-3600), image: nil, action: .commented),
                
                NotificationContent(author: "Mike Anderson", content: "Captured this breathtaking sunset at the beach yesterday. Nature never ceases to amaze me with its beauty. The colors were so vibrant and the waves were perfectly calm. This is why I love photography - freezing these moments in time forever.", date: Date().addingTimeInterval(-7200), image: Image("IMG_3"), action: .posted),
                
                NotificationContent(author: "Emma Rodriguez", content: "Just tried this incredible new restaurant downtown and I have to say, their pasta carbonara is to die for! The chef really knows what they're doing. The ambiance was perfect, the service was excellent, and every dish we ordered was absolutely delicious. Highly recommend!", date: Date().addingTimeInterval(-10800), image: Image("IMG_4"), action: .liked),
                
                NotificationContent(author: "Alex Thompson", content: "Finally beat that boss level I've been stuck on for weeks! The feeling of accomplishment is unreal. Gaming has taught me so much about perseverance and problem-solving. Sometimes you just need to take a break and come back with a fresh perspective.", date: Date().addingTimeInterval(-14400), image: Image("IMG_5"), action: .reposted),
                
                NotificationContent(author: "Jessica Parker", content: "Exploring the beautiful streets of Paris has been a dream come true! The architecture here is absolutely stunning, the food is incredible, and the people are so welcoming. Every corner you turn reveals something magical. Can't wait to share more photos from this trip!", date: Date().addingTimeInterval(-18000), image: Image("IMG_6"), action: .posted),
                
                NotificationContent(author: "David Williams", content: "Just dropped my new single and the response has been overwhelming! Thank you all so much for the support. This song means everything to me - I poured my heart and soul into every lyric. Music is my passion and sharing it with you all makes it even more special.", date: Date().addingTimeInterval(-21600), image: nil, action: .commented),
                
                NotificationContent(author: "Lily Chen", content: "Finished my latest painting today after weeks of work. Art is such a therapeutic process for me - it allows me to express emotions I can't put into words. This piece represents a journey of self-discovery and growth. Hope you all enjoy it as much as I enjoyed creating it!", date: Date().addingTimeInterval(-25200), image: Image("IMG_8"), action: .liked),
                
                NotificationContent(author: "Tom Harrison", content: "Hit a new personal record on my deadlift today! All those early morning sessions and strict meal prep are finally paying off. Remember, progress isn't always linear but consistency will always win. Keep grinding and trust the process, the results will come!", date: Date().addingTimeInterval(-28800), image: Image("IMG_9"), action: .posted),
                
                NotificationContent(author: "Sophia Martinez", content: "Just finished reading the most incredible novel and I'm emotionally devastated in the best way possible. The character development was phenomenal and the plot twists kept me up all night. If you're looking for a book that will completely consume you, this is it! Highly recommend to all book lovers.", date: Date().addingTimeInterval(-32400), image: Image("IMG_10"), action: .viewProfile),
                
                NotificationContent(author: "Chris Taylor", content: "Successfully deployed my first full-stack application today! The journey from complete beginner to this moment has been challenging but incredibly rewarding. Coding has opened up a whole new world of possibilities for me. To anyone learning to code: don't give up, it gets easier!", date: Date().addingTimeInterval(-36000), image: Image("IMG_11"), action: .reposted),
                
                NotificationContent(author: "Olivia Brown", content: "Attended the most amazing fashion show last night! The creativity and craftsmanship on display was absolutely breathtaking. Fashion is such a powerful form of self-expression and art. Every outfit told a unique story and the designers really pushed boundaries with their innovative designs.", date: Date().addingTimeInterval(-39600), image: Image("IMG_12"), action: .commented),
                
                NotificationContent(author: "Ryan Cooper", content: "Spent the entire weekend hiking through the mountains and disconnecting from technology. The views were spectacular and the fresh air was exactly what I needed. Nature has this amazing ability to reset your mind and put everything into perspective. Already planning my next adventure!", date: Date().addingTimeInterval(-43200), image: Image("IMG_2"), action: .posted),
                
                NotificationContent(author: "Nina Patel", content: "Baked my grandmother's secret recipe chocolate cake today and it turned out perfect! Baking is more than just following recipes - it's about creating memories and bringing people together. The smell of fresh baked goods filling the house is pure comfort. Can't wait to share this with family!", date: Date().addingTimeInterval(-46800), image: Image("IMG_7"), action: .liked),
                
                NotificationContent(author: "Mark Sullivan", content: "Mind-blowing discovery in the lab today! Science never stops amazing me with its endless possibilities. We've been working on this research project for months and seeing it all come together is incredibly satisfying. The potential applications of this could change so many lives for the better!", date: Date().addingTimeInterval(-50400), image: nil, action: .posted),
                
                NotificationContent(author: "Grace Johnson", content: "Completed my 100th yoga session this year and feeling absolutely amazing! Yoga has transformed not just my body but my entire mindset and approach to life. The practice teaches patience, mindfulness, and self-compassion. If you're thinking about starting, just do it - your future self will thank you!", date: Date().addingTimeInterval(-54000), image: nil, action: .commented),
                
                NotificationContent(author: "Jake Robinson", content: "What an incredible game last night! The energy in the stadium was electric and the comeback in the final quarter was legendary. Sports have this unique ability to bring people together from all walks of life. Moments like these remind me why I fell in love with the game in the first place!", date: Date().addingTimeInterval(-57600), image: Image("IMG_17"), action: .reposted),
                
                NotificationContent(author: "Amy Foster", content: "My garden is finally blooming and it's more beautiful than I ever imagined! Gardening has taught me so much about patience and nurturing. Watching these plants grow from tiny seeds into flourishing flowers is magical. There's something deeply satisfying about creating life with your own hands.", date: Date().addingTimeInterval(-61200), image: Image("IMG_18"), action: .viewProfile),
                
                NotificationContent(author: "Ben Carter", content: "Adopted the most adorable puppy today and my heart is so full! Pets bring such unconditional love and joy into our lives. This little guy is already making every day brighter. Can't wait for all the adventures we'll have together. If you're thinking about adopting, I highly encourage it!", date: Date().addingTimeInterval(-64800), image: Image("IMG_19"), action: .posted),
                
                NotificationContent(author: "Rachel Davis", content: "Completed my biggest home renovation project yet! Transforming this space from scratch has been a labor of love. DIY projects are challenging but so rewarding when you see the final result. My hands are covered in paint and sawdust but my heart is full of pride. Home truly is where you make it!", date: Date().addingTimeInterval(-68400), image: Image("IMG_20"), action: .liked),
                
                NotificationContent(author: "Kevin Lee", content: "Discovered the perfect coffee shop today with the most incredible atmosphere! The barista is a true artist and every cup is crafted with such care and precision. Coffee culture is about more than just caffeine - it's about community, conversation, and taking a moment to slow down in our busy lives.", date: Date().addingTimeInterval(-72000), image: nil, action: .commented)
            ]
        }
}
