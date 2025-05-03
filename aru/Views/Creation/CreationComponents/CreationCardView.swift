import SwiftUI

struct CreationCardView: View {
    let title: String
    let author: String
    let views: String
    let likes: String
    let timeAgo: String
    let gradient: [Color]
    let icon: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 썸네일
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: gradient),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 200)
                    .cornerRadius(16)
                
                // 아이콘
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: icon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    )
            }
            
            // 컨텐츠 정보
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                HStack {
                    Text(author)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Label(views, systemImage: "eye")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Label(likes, systemImage: "heart")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Text(timeAgo)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
    }
}