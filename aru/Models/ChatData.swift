import SwiftUI

// Chat message status for delivery tracking
enum MessageStatus {
    case sending
    case sent
    case delivered
    case read
    case failed
}

// Extended chat message for additional functionality
struct ExtendedChatMessage: Identifiable {
    let id: Int
    let text: String
    let isFromMe: Bool
    let timestamp: Date
    var status: MessageStatus = .sent
    
    // Links to original chat data
    var originalChatId: Int?
    
    // Media content
    var mediaURLs: [URL] = []
    var hasMedia: Bool { return !mediaURLs.isEmpty }
    
    // Reply and forward info
    var replyToMessageId: Int?
    var forwardedFrom: String?
    
    // Interactive elements
    var containsInteractive: Bool = false
    var interactiveType: String?
    
    // Helper for message grouping in UI
    func shouldGroupWithPrevious(previous: ExtendedChatMessage?) -> Bool {
        guard let previous = previous else { return false }
        
        // Group messages if they're from the same sender and within 5 minutes
        let sameUser = previous.isFromMe == self.isFromMe
        let timeThreshold: TimeInterval = 5 * 60 // 5 minutes
        let closeInTime = self.timestamp.timeIntervalSince(previous.timestamp) < timeThreshold
        
        return sameUser && closeInTime
    }
}

// Preference key to track scroll position
struct ChatScrollPositionKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}