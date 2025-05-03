import SwiftUI

struct SpaceBackgroundView: View {
    let starCount = 100
    @State private var animateBg = false
    
    var body: some View {
        ZStack {
            Color(hex: "030305")
                .ignoresSafeArea()
            
            // 별 생성
            ForEach(0..<starCount, id: \.self) { i in
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.1...0.5)))
                    .frame(width: randomStarSize(), height: randomStarSize())
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(animateBg ? Double.random(in: 0.1...0.5) : 0)
                    .animation(
                        Animation.easeInOut(duration: Double.random(in: 2...4))
                            .repeatForever(autoreverses: true)
                            .delay(Double.random(in: 0...2)),
                        value: animateBg
                    )
            }
            
            // 성운 효과 1
            RadialGradient(
                gradient: Gradient(colors: [Color(hex: "10051d").opacity(0.4), Color.clear]),
                center: .topLeading,
                startRadius: 100,
                endRadius: UIScreen.main.bounds.width
            )
            .ignoresSafeArea()
            .opacity(animateBg ? 1 : 0)
            .animation(Animation.easeIn(duration: 1.5), value: animateBg)
            
            // 성운 효과 2
            RadialGradient(
                gradient: Gradient(colors: [Color(hex: "051a26").opacity(0.3), Color.clear]),
                center: .bottomTrailing,
                startRadius: 100,
                endRadius: UIScreen.main.bounds.width
            )
            .ignoresSafeArea()
            .opacity(animateBg ? 1 : 0)
            .animation(Animation.easeIn(duration: 1.5).delay(0.5), value: animateBg)
        }
        .onAppear {
            animateBg = true
        }
    }
    
    private func randomStarSize() -> CGFloat {
        return CGFloat.random(in: 1...3)
    }
}

// 이전 코드와의 호환성을 위한 별칭
typealias SpaceBackground = SpaceBackgroundView