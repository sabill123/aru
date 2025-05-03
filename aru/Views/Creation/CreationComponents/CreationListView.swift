import SwiftUI

struct CreationListView: View {
    let titles: [String]
    let author: String
    let icons: [String]
    let gradientColors: [[Color]]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 24) {
                ForEach(0..<titles.count, id: \.self) { i in
                    CreationCardView(
                        title: titles[i],
                        author: author,
                        views: "\(Int.random(in: 5...20)).\(Int.random(in: 1...9))천",
                        likes: "\(Int.random(in: 1...5)).\(Int.random(in: 1...9))천",
                        timeAgo: "\(Int.random(in: 1...7))일 전",
                        gradient: gradientColors[i % gradientColors.count],
                        icon: icons[i % icons.count]
                    )
                }
                
                // 하단 여백
                Spacer()
                    .frame(height: 120) // Increased for raised tab bar
            }
        }
    }
}