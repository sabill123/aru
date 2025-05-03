import SwiftUI

struct PressEffectViewModifier: ViewModifier {
    var intensity: CGFloat = 0.94
    var pressedOpacity: CGFloat = 0.85
    @State private var isPressed = false
    
    func body(content: Content) -> some View {
        content
            .scaleEffect(isPressed ? intensity : 1.0)
            .opacity(isPressed ? pressedOpacity : 1.0)
            .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isPressed)
            .onTapGesture {
                feedback()
                simulatePress()
            }
    }
    
    private func simulatePress() {
        isPressed = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.12) {
            isPressed = false
        }
    }
    
    private func feedback() {
        #if os(iOS)
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        #endif
    }
}

extension View {
    func pressEffect(intensity: CGFloat = 0.94, opacity: CGFloat = 0.85) -> some View {
        self.modifier(PressEffectViewModifier(intensity: intensity, pressedOpacity: opacity))
    }
}