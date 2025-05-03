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
                        .frame(width: 32, height: 32)
                    
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(iconColor)
                }
                
                // Title with optional gradient
                Text(title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // Enhanced "more" button
            if let action = showMoreAction {
                Button(action: action) {
                    HStack(spacing: 6) {
                        Text("더보기")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(isHovered ? .white.opacity(0.9) : .gray)
                        
                        Image(systemName: "chevron.right")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(isHovered ? .white.opacity(0.9) : .gray)
                            .offset(x: isHovered ? 2 : 0)
                            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(
                        ZStack {
                            // Base background
                            RoundedRectangle(cornerRadius: 16)
                                .fill(
                                    isHovered ? 
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            iconColor.opacity(0.3), 
                                            iconColor.opacity(0.15)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.darkBackgroundSecondary.opacity(0.5),
                                            Color.darkBackgroundSecondary.opacity(0.5)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                            
                            // Subtle border when hovered
                            if isHovered {
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                iconColor.opacity(0.5),
                                                iconColor.opacity(0.2)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        ),
                                        lineWidth: 1
                                    )
                            }
                        }
                    )
                }
                .pressEffect(intensity: 0.95)
                .handleHover { hovering in
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                        isHovered = hovering
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}