import SwiftUI

struct ChatListItem: View {
    let icon: String
    let name: String
    let preview: String
    let time: String
    let gradientIndex: Int
    
    @State private var isPressedDown = false
    
    var body: some View {
        Button {
            // 채팅 열기 액션
        } label: {
            HStack(spacing: 12) {
                // 프로필 이미지
                ZStack {
                    Circle()
                        .fill(
                            [
                                LinearGradient(gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                LinearGradient(gradient: Gradient(colors: [Color.accentTeal, Color.accentTeal.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                LinearGradient(gradient: Gradient(colors: [Color.accentPink, Color.accentPink.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                LinearGradient(gradient: Gradient(colors: [Color.accentYellow, Color.accentYellow.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing),
                                LinearGradient(gradient: Gradient(colors: [Color.purple, Color.purple.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                            ][gradientIndex % 5]
                        )
                        .frame(width: 48, height: 48)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                
                // 채팅 정보
                VStack(alignment: .leading, spacing: 3) {
                    HStack {
                        Text(name)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    Text(preview)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.darkBackgroundSecondary.opacity(isPressedDown ? 0.8 : 0))
                    .padding(.horizontal)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffect(isPressedDown ? 0.98 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.6), value: isPressedDown)
        .onTapGesture(count: 1) {
            withAnimation {
                isPressedDown = true
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation {
                        isPressedDown = false
                    }
                }
            }
        }
    }
}