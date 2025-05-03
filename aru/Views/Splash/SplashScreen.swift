import SwiftUI

struct SplashScreen: View {
    @Binding var showLoginView: Bool
    @State private var animate = false
    
    // 행성 그라데이션 정의
    let planetGradients: [[Color]] = [
        [Color(hex: "6A11CB"), Color(hex: "2575FC")],   // 보라/파랑
        [Color(hex: "FF36A3"), Color(hex: "FF61D2")],   // 핑크
        [Color(hex: "12E2A3"), Color(hex: "0AC99E")],   // 민트
        [Color(hex: "FFD60A"), Color(hex: "FFC107")],   // 노랑
        [Color(hex: "BF5AF2"), Color(hex: "9945DB")]    // 보라
    ]
    
    var body: some View {
        ZStack {
            // 우주 배경
            SpaceBackground()
            
            VStack(spacing: 40) {
                Spacer()
                
                // 로고 영역
                ZStack {
                    // 중앙 ARU 로고
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "6A11CB"), Color(hex: "2575FC")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .shadow(color: Color(hex: "6A11CB").opacity(0.6), radius: 15)
                    
                    Text("ARU")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(.white)
                    
                    // 행성 애니메이션
                    ForEach(0..<5) { i in
                        let size = 20 + CGFloat(i * 5)
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: planetGradients[i]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: size, height: size)
                            .offset(
                                x: animate ? planetOrbitX(angle: Angle(degrees: Double(i) * 72 + 240)) * 120 : 0,
                                y: animate ? planetOrbitY(angle: Angle(degrees: Double(i) * 72 + 240)) * 120 : 0
                            )
                            .animation(
                                Animation.easeInOut(duration: 2.0)
                                    .delay(Double(i) * 0.1),
                                value: animate
                            )
                    }
                }
                
                // 슬로건 텍스트
                VStack(spacing: 12) {
                    Text("모든 AI 창작을")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(animate ? 1 : 0)
                        .animation(Animation.easeIn(duration: 0.8).delay(1.0), value: animate)
                    
                    Text("우주에서 탐험하세요")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                        .opacity(animate ? 1 : 0)
                        .animation(Animation.easeIn(duration: 0.8).delay(1.5), value: animate)
                }
                
                Spacer()
            }
        }
        .onAppear {
            // 애니메이션 시작
            animate = true
            
            // 타이머로 3초 후 로그인 화면으로 자동 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                withAnimation {
                    showLoginView = true
                }
            }
        }
    }
    
    // 행성 궤도 계산 함수
    private func planetOrbitX(angle: Angle) -> CGFloat {
        return CGFloat(cos(angle.radians))
    }
    
    private func planetOrbitY(angle: Angle) -> CGFloat {
        return CGFloat(sin(angle.radians))
    }
}