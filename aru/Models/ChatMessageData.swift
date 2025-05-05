import SwiftUI

// 채팅 상세 화면용 메시지 데이터 모델
struct ChatMessageData: Identifiable {
    let id: Int
    let text: String
    let isFromMe: Bool
    let timestamp: Date
    var isRead: Bool = true
    
    // 추가 기능을 위한 옵션 필드들
    var attachments: [String] = []
    var replyTo: Int? = nil
    var reactions: [String: Int] = [:]
    
    // 메시지 포맷팅 헬퍼
    func formattedTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: timestamp)
    }
    
    func formattedDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: timestamp)
    }
    
    // 오늘, 어제 등의 상대적 날짜 표시
    func relativeDate() -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(timestamp) {
            return "오늘"
        } else if calendar.isDateInYesterday(timestamp) {
            return "어제"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "M월 d일"
            return formatter.string(from: timestamp)
        }
    }
}