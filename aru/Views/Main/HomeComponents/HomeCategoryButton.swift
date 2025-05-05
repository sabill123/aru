import SwiftUI

struct HomeCategoryButton: View {
    let title: String
    let icon: String
    let isActive: Bool
    @State private var isHovered = false
    
    // Dynamic category colors based on category name
    private var categoryColor: Color {
        switch title {
        case "추천": return Color.accentTeal
        case "웹소설": return Color.primaryPurple
        case "이미지": return Color.accentPink
        case "피팅": return Color.accentYellow
        case "트렌드": return Color.primaryBlue
        default: return Color.primaryPurple
        }
    }
    
    // Secondary gradient color
    private var secondaryColor: Color {
        switch title {
        case "추천": return Color.primaryBlue
        case "웹소설": return Color.primaryBlue.opacity(0.8)
        case "이미지": return Color.accentPink.opacity(0.7)
        case "피팅": return Color.primaryPurple.opacity(0.8)
        case "트렌드": return Color.primaryPurple
        default: return Color.primaryBlue
        }
    }
    
    var body: some View {
        HStack(spacing: 8) {
            // Icon with subtle background when active
            ZStack {
                if isActive {
                    Circle()
                        .fill(Color.white.opacity(0.15))
                        .frame(width: 22, height: 22)
                }
                
                Image(systemName: icon)
                    .font(.system(size: 11, weight: isActive ? .semibold : .medium))
            }
            
            // Text with weight change when active
            Text(title)
                .font(.system(size: 13, weight: isActive ? .semibold : .medium))
        }
        .foregroundColor(isActive ? .white : .gray)
        .padding(.vertical, 6)
        .padding(.horizontal, 12)
        .background(
            ZStack {
                // Base background
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isActive ? 
                        LinearGradient(
                            gradient: Gradient(colors: [categoryColor, secondaryColor]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ) :
                        LinearGradient(
                            gradient: Gradient(colors: [Color.darkBackgroundSecondary.opacity(0.6), Color.darkBackgroundSecondary.opacity(0.6)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                // Optional glow for active state
                if isActive {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [categoryColor.opacity(0.8), secondaryColor.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.5
                        )
                        .blur(radius: 0.5)
                }
                
                // Inactive hover effect
                if !isActive && isHovered {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                }
            }
        )
        .shadow(color: isActive ? categoryColor.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
        .scaleEffect(isHovered && !isActive ? 1.03 : 1.0)
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isActive)
        .handleHover { hovering in
            isHovered = hovering
        }
        .pressEffect(intensity: 0.96)
    }
}

// Handle hover state with a conditional implementation
extension View {
    @ViewBuilder
    func handleHover(_ perform: @escaping (Bool) -> Void) -> some View {
        #if os(iOS)
        self // iOS doesn't support hover
        #else
        self.onHover(perform: perform)
        #endif
    }
}