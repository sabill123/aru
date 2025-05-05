import SwiftUI

struct QuickActionButton: View {
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(color)
                .cornerRadius(15)
        }
    }
}

struct QuickAccessToolbar: View {
    @Binding var isVisible: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            QuickActionButton(
                icon: "camera.fill",
                color: Color.accentTeal
            ) {
                // Camera action
            }
            
            QuickActionButton(
                icon: "photo.fill",
                color: Color.accentPink
            ) {
                // Gallery action
            }
            
            QuickActionButton(
                icon: "mic.fill",
                color: Color.accentYellow
            ) {
                // Voice action
            }
            
            QuickActionButton(
                icon: "doc.fill",
                color: Color.primaryPurple
            ) {
                // Document action
            }
        }
        .padding()
        .background(Color.darkBackgroundSecondary)
        .cornerRadius(20)
        .shadow(radius: 5)
        .offset(y: isVisible ? 0 : 300)
        .animation(.spring(), value: isVisible)
    }
}