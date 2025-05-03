import SwiftUI

// 채팅 메시지 모델
struct ChatMessage: Identifiable {
    let id: Int
    let text: String
    let isUser: Bool
    let timestamp: Date
}

// 메시지 버블 뷰
struct MessageBubble: View {
    let message: ChatMessage
    let chatGradient: [Color]
    
    var body: some View {
        HStack {
            if message.isUser {
                Spacer()
                
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.darkBackgroundSecondary)
                    .foregroundColor(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight, .bottomLeft])
            } else {
                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [chatGradient[0].opacity(0.3), chatGradient[1].opacity(0.2)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .foregroundColor(.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight, .bottomRight])
                
                Spacer()
            }
        }
    }
}