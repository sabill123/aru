import SwiftUI

struct ChatCategoryButton: View {
    let title: String
    let icon: String
    let isActive: Bool
    
    var body: some View {
        Button(action: {}) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                
                Text(title)
                    .font(.system(size: 14))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 16)
            .foregroundColor(isActive ? .white : .gray)
            .background(isActive ? Color.darkBackgroundSecondary : Color.clear)
            .cornerRadius(20)
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isActive ? Color.white.opacity(0.2) : Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
    }
}