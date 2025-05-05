import SwiftUI

struct HomeHeaderView: View {
    let username: String
    @State private var isAnimating = false
    @State private var showNotification = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Left side - Welcome text with enhanced typography and animation
            VStack(alignment: .leading, spacing: 4) {
                // Username with glowing effect
                HStack(spacing: 5) {
                    Text("안녕하세요,")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(Color.white.opacity(0.9))
                    
                    Text("\(username)님")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.accentTeal, Color.primaryBlue]),
                                startPoint: .bottomLeading,
                                endPoint: .topTrailing
                            )
                            .mask(
                                Text("\(username)님")
                                    .font(.system(size: 20, weight: .bold))
                            )
                        )
                        .scaleEffect(isAnimating ? 1.02 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 1.5)
                                .repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                }
                
                // Subtext with subtle gradient and animation
                Text("오늘의 우주 트렌드를 탐험하세요")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color.gray.opacity(0.9))
                    .padding(.top, 1)
                
                // Mini category pill - latest trending topic
                HStack(spacing: 4) {
                    Circle()
                        .fill(Color.accentPink)
                        .frame(width: 6, height: 6)
                    
                    Text("사이버펑크 AI")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(Color.white.opacity(0.8))
                }
                .padding(.horizontal, 6)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.darkBackgroundSecondary.opacity(0.7))
                )
                .padding(.top, 4)
                .opacity(isAnimating ? 1.0 : 0.9)
                .scaleEffect(isAnimating ? 1.0 : 0.97)
            }
            
            Spacer()
            
            // Right side - Avatar and notifications with enhanced visuals
            HStack(spacing: 12) {
                // Notification button with indicator
                Button {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                        showNotification.toggle()
                    }
                } label: {
                    ZStack(alignment: .topTrailing) {
                        Circle()
                            .fill(Color.darkBackgroundSecondary)
                            .frame(width: 32, height: 32)
                            .overlay(
                                Image(systemName: "bell.fill")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                            )
                        
                        // Notification indicator
                        Circle()
                            .fill(Color.accentPink)
                            .frame(width: 10, height: 10)
                            .overlay(
                                Circle()
                                    .stroke(Color.darkBackground, lineWidth: 1.5)
                                    .frame(width: 8, height: 8)
                            )
                            .offset(x: 2, y: -2)
                            .opacity(showNotification ? 1 : 0)
                            .scaleEffect(showNotification ? 1 : 0.6)
                    }
                }
                .pressEffect()
                
                // Enhanced avatar with animated glow
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(Color.clear)
                        .frame(width: 42, height: 42)
                        .background(
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            Color.primaryPurple.opacity(0.5),
                                            Color.primaryBlue.opacity(0.3)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .blur(radius: isAnimating ? 6 : 4)
                                .scaleEffect(isAnimating ? 1.1 : 1.0)
                        )
                    
                    // Main avatar
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 17, weight: .medium))
                                .foregroundColor(.white)
                        )
                        .shadow(color: Color.primaryPurple.opacity(0.5), radius: 8, x: 0, y: 4)
                }
                .pressEffect()
            }
        }
        .padding(.horizontal)
        .padding(.top)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
            
            // Trigger notification after a delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation(.spring(response: 0.35, dampingFraction: 0.7)) {
                    showNotification = true
                }
            }
        }
    }
}