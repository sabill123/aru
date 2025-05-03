import SwiftUI

struct ChatAvatarView: View {
    let icon: String
    let name: String
    let gradientIndex: Int
    let isOnline: Bool = true
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .fill(
                        [
                            LinearGradient(gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            LinearGradient(gradient: Gradient(colors: [Color.accentTeal, Color.accentTeal.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                            LinearGradient(gradient: Gradient(colors: [Color.accentPink, Color.accentPink.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                        ][gradientIndex % 3]
                    )
                    .frame(width: 64, height: 64)
                
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                // 상태 표시
                if isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .background(
                            Circle()
                                .fill(Color.darkBackground)
                                .frame(width: 16, height: 16)
                        )
                        .position(x: 50, y: 50)
                }
            }
            
            Text(name)
                .font(.caption)
                .foregroundColor(.white)
        }
    }
}