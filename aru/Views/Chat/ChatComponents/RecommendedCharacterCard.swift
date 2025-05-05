import SwiftUI

struct RecommendedCharacterCard: View {
    let character: AvatarData
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                // 아이콘
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [character.color, character.color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 46, height: 46)
                        .shadow(color: character.color.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    Image(systemName: character.icon)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
                
                // 텍스트
                VStack(alignment: .leading, spacing: 4) {
                    Text(character.name)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(character.lastUsed)
                        .font(.system(size: 12))
                        .foregroundColor(.gray.opacity(0.8))
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.darkBackgroundSecondary.opacity(0.6))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Color.gray.opacity(0.2), lineWidth: 0.5)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .padding(.horizontal, 2)
    }
}