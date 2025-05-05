import SwiftUI

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : .gray.opacity(0.7))
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    ZStack {
                        if isSelected {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.primaryPurple.opacity(0.7), Color.primaryBlue.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: Color.primaryPurple.opacity(0.3), radius: 4, x: 0, y: 2)
                        }
                    }
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}