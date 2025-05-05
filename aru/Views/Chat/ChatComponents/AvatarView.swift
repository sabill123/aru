import SwiftUI

struct AvatarView: View {
    let avatar: AvatarData
    let action: () -> Void
    
    var body: some View {
        VStack(spacing: 6) {
            Button(action: action) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [avatar.color, avatar.color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 60, height: 60)
                        .shadow(color: avatar.color.opacity(0.4), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: avatar.icon)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                }
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(avatar.name)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(width: 70)
            
            Text(avatar.lastUsed)
                .font(.system(size: 10))
                .foregroundColor(.gray.opacity(0.8))
        }
    }
}