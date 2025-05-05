import SwiftUI

// 채팅 데이터 모델
struct ChatData: Identifiable {
    let id: Int
    let name: String
    let avatarIcon: String
    let preview: String
    let time: String
    let color: Color
    let unreadCount: Int
    let isOnline: Bool
}

// 아바타 데이터 모델
struct AvatarData: Identifiable {
    let id: Int
    let name: String
    let icon: String
    let color: Color
    let lastUsed: String
}

// 채팅 옵션 모델
struct ChatOption: Identifiable {
    var id: String { title }
    let icon: String
    let title: String
    let color: Color
}