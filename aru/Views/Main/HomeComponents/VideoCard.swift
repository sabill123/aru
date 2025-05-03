import SwiftUI

struct VideoCard: View {
    let title: String
    let creator: String
    let likes: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 비디오 썸네일
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.darkBackgroundSecondary)
                .aspectRatio(9/16, contentMode: .fit)
                .overlay(
                    LinearGradient(
                        gradient: Gradient(colors: [.clear, Color.black.opacity(0.5)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .cornerRadius(12)
                )
            
            // 플레이 버튼
            Circle()
                .fill(Color.black.opacity(0.5))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "play.circle")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                )
                .position(x: 70, y: 70)
            
            // 비디오 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.callout)
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                HStack {
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ))
                        .frame(width: 16, height: 16)
                    
                    Text(creator)
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Image(systemName: "heart")
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                    
                    Text("\(formatNumber(likes))")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .padding(8)
        }
    }
    
    // 숫자 포맷팅 (예: 1500 -> 1.5k)
    private func formatNumber(_ number: Int) -> String {
        if number >= 1000 {
            let formattedNumber = Double(number) / 1000.0
            return String(format: "%.1fk", formattedNumber)
        } else {
            return "\(number)"
        }
    }
}