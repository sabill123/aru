import SwiftUI

struct SectionHeaderView: View {
    let title: String
    let icon: String
    let iconColor: Color
    var showMoreAction: (() -> Void)? = nil
    @State private var isHovered = false
    @State private var isPressed = false
    
    var body: some View {
        HStack(alignment: .center) {
            // Enhanced title and icon with gradient overlay
            HStack(spacing: 8) {
                // Icon with subtle background
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.15))
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: icon)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                // Title with optional gradient
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // 더보기 버튼 - 오른쪽에 위치
            if let action = showMoreAction {
                Button(action: action) {
                    Text("더보기")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.darkBackgroundSecondary.opacity(isHovered ? 0.8 : 0.5))
                        )
                        .scaleEffect(isPressed ? 0.95 : 1.0)
                }
                .buttonStyle(PlainButtonStyle())
                .onHover { hovering in
                    isHovered = hovering
                }
                .simultaneousGesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { _ in isPressed = true }
                        .onEnded { _ in isPressed = false }
                )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}