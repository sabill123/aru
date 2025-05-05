import SwiftUI

struct EnhancedSplashScreen: View {
    @Binding var showLoginView: Bool
    @State private var animateLogo = false
    @State private var animateGlow = false
    @State private var animateBackground = false
    @State private var animateText = false
    @State private var animateParticles = false
    @State private var rotationAngle: Double = 0
    
    // 애니메이션 타이밍
    let animationDuration = 2.0
    
    var body: some View {
        ZStack {
            // 배경 그라데이션 (더 세련되고 현대적인 배경)
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(hex: "0A0A14"),
                    Color(hex: "1A1A2E"),
                    Color(hex: "16213E")
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // 추가적인 백그라운드 효과
            ZStack {
                // 추상적인 형태의 그라데이션 백그라운드 요소들
                ForEach(0..<3) { i in
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.primaryPurple.opacity(0.3),
                                    Color.primaryBlue.opacity(0.1)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 300 + CGFloat(i * 100), height: 300 + CGFloat(i * 100))
                        .offset(
                            x: CGFloat([80, -100, 50][i]),
                            y: CGFloat([-50, 100, -150][i])
                        )
                        .blur(radius: 80)
                        .opacity(animateBackground ? 0.6 : 0.0)
                }
                
                // 작은 파티클들 (별처럼 보이는 효과)
                ForEach(0..<30) { i in
                    let size = CGFloat.random(in: 2...5)
                    let delay = Double.random(in: 0...1.5)
                    let duration = Double.random(in: 2.0...4.0)
                    let x = CGFloat.random(in: -180...180)
                    let y = CGFloat.random(in: -300...300)
                    
                    Circle()
                        .fill(Color.white)
                        .frame(width: size, height: size)
                        .offset(x: x, y: y)
                        .opacity(animateParticles ? 0.7 : 0.0)
                        .animation(
                            Animation.easeInOut(duration: duration)
                                .repeatForever(autoreverses: true)
                                .delay(delay),
                            value: animateParticles
                        )
                }
            }
            
            VStack(spacing: 40) {
                Spacer()
                
                // 로고 영역 (더 세련되고 현대적인 로고)
                ZStack {
                    // 로고 글로우 효과
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 150, height: 150)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.primaryPurple.opacity(0.8),
                                            Color.primaryBlue.opacity(0.8),
                                            Color.primaryPurple.opacity(0.2),
                                            Color.clear
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: animateGlow ? 15 : 0
                                )
                                .blur(radius: 8)
                        )
                        .opacity(animateGlow ? 1 : 0)
                        .animation(
                            Animation.easeOut(duration: 1.5)
                                .delay(0.5),
                            value: animateGlow
                        )
                    
                    // 로고 배경 원
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.primaryPurple,
                                    Color.primaryBlue
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: animateLogo ? 110 : 20, height: animateLogo ? 110 : 20)
                        .shadow(color: Color.primaryPurple.opacity(0.5), radius: 15)
                        .animation(
                            Animation.spring(response: 0.6, dampingFraction: 0.6)
                                .delay(0.1),
                            value: animateLogo
                        )
                    
                    // 로고 텍스트 효과
                    ZStack {
                        // 로고 텍스트 배경 효과
                        Text("A")
                            .font(.custom("Avenir-Black", size: 60))
                            .foregroundColor(.white.opacity(0.15))
                            .offset(x: -18, y: 0)
                            .rotationEffect(.degrees(rotationAngle))
                            .scaleEffect(animateLogo ? 1 : 0.5)
                        
                        Text("U")
                            .font(.custom("Avenir-Black", size: 60))
                            .foregroundColor(.white.opacity(0.15))
                            .offset(x: 18, y: 0)
                            .rotationEffect(.degrees(-rotationAngle))
                            .scaleEffect(animateLogo ? 1 : 0.5)
                        
                        // 메인 로고 텍스트
                        Text("ARU")
                            .font(.custom("Avenir-Black", size: 40))
                            .fontWeight(.black)
                            .foregroundColor(.white)
                            .tracking(2) // 글자 간격 조정
                            .shadow(color: .white.opacity(0.5), radius: 1, x: 0, y: 0)
                            .scaleEffect(animateLogo ? 1 : 0.7)
                            .opacity(animateLogo ? 1 : 0)
                    }
                    .animation(
                        Animation.spring(response: 0.6, dampingFraction: 0.6)
                            .delay(0.3),
                        value: animateLogo
                    )
                    
                    // 주변 원형 요소들
                    ForEach(0..<5) { i in
                        let angle = Double(i) * (360.0 / 5.0)
                        let delay = 0.2 + Double(i) * 0.1
                        let size = 14.0 - Double(i) * 0.5
                        
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        [Color.accentPink, Color.accentTeal, Color.accentYellow, Color.primaryPurple, Color.primaryBlue][i % 5],
                                        [Color.accentPink, Color.accentTeal, Color.accentYellow, Color.primaryPurple, Color.primaryBlue][(i + 2) % 5].opacity(0.7)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: size, height: size)
                            .offset(
                                x: animateLogo ? 65 * cos(angle * .pi / 180) : 0,
                                y: animateLogo ? 65 * sin(angle * .pi / 180) : 0
                            )
                            .animation(
                                Animation.spring(response: 0.6, dampingFraction: 0.6)
                                    .delay(delay),
                                value: animateLogo
                            )
                    }
                }
                
                // 슬로건 텍스트 (세련된 레이아웃)
                VStack(spacing: 8) {
                    Text("AI 창작의 모든 우주")
                        .font(.custom("Avenir-Medium", size: 24))
                        .foregroundColor(.white)
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : 20)
                        .animation(
                            Animation.spring(response: 0.6, dampingFraction: 0.8)
                                .delay(1.0),
                            value: animateText
                        )
                    
                    Text("당신의 손끝에서 시작됩니다")
                        .font(.custom("Avenir-Light", size: 18))
                        .foregroundColor(.white.opacity(0.8))
                        .opacity(animateText ? 1 : 0)
                        .offset(y: animateText ? 0 : 20)
                        .animation(
                            Animation.spring(response: 0.6, dampingFraction: 0.8)
                                .delay(1.3),
                            value: animateText
                        )
                }
                .padding(.top, 30)
                
                Spacer()
            }
            .frame(maxHeight: .infinity)
        }
        .onAppear {
            // 로고 애니메이션 시작
            withAnimation(Animation.linear(duration: animationDuration).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
            
            // 각 요소별 애니메이션 시작
            animateBackground = true
            animateParticles = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                animateLogo = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                animateGlow = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                animateText = true
            }
            
            // 타이머로 3초 후 로그인 화면으로 자동 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                withAnimation {
                    showLoginView = true
                }
            }
        }
    }
}

// MARK: - 미리보기
struct EnhancedSplashScreen_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedSplashScreen(showLoginView: .constant(false))
    }
}