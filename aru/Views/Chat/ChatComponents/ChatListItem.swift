import SwiftUI

struct ChatListItem: View {
    let chat: ChatData
    let action: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        Button(action: {
            action()
        }) {
            HStack(spacing: 12) {
                // 프로필 이미지
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [chat.color, chat.color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 52, height: 52)
                        .shadow(color: chat.color.opacity(0.3), radius: 2, x: 0, y: 1)
                    
                    Image(systemName: chat.avatarIcon)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    // 온라인 상태 표시
                    if chat.isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 14, height: 14)
                            .overlay(
                                Circle()
                                    .stroke(Color.black, lineWidth: 2)
                            )
                            .position(x: 40, y: 40)
                    }
                }
                
                // 채팅 정보
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center) {
                        Text(chat.name)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(chat.time)
                            .font(.system(size: 12))
                            .foregroundColor(.gray.opacity(0.8))
                    }
                    
                    HStack(alignment: .center) {
                        Text(chat.preview)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        
                        Spacer()
                        
                        if chat.unreadCount > 0 {
                            Text("\(chat.unreadCount)")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundColor(.white)
                                .frame(minWidth: 18, minHeight: 18)
                                .background(
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [chat.color, chat.color.opacity(0.8)]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(isPressed ? Color.darkBackgroundSecondary.opacity(0.8) : Color.clear)
            )
            .contentShape(Rectangle())
            .scaleEffect(isPressed ? 0.98 : 1.0)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 10, pressing: { pressing in
            withAnimation(.easeInOut(duration: 0.2)) {
                isPressed = pressing
            }
        }, perform: {})
    }
}