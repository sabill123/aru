import SwiftUI

struct LoginView: View {
    @Binding var showMainApp: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showEmailForm: Bool = false
    @State private var isLoggingIn: Bool = false
    
    var body: some View {
        ZStack {
            // 우주 배경
            SpaceBackground()
            
            VStack(spacing: 30) {
                // 로고 - 상단에 배치하고 Spacer 제거
                VStack(spacing: 16) {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "6A11CB"), Color(hex: "2575FC")]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                        .shadow(color: Color(hex: "6A11CB").opacity(0.6), radius: 15)
                    
                    Text("ARU")
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                        .offset(y: -70)
                    
                    Text("AI 창작 도구")
                        .font(.system(size: 18))
                        .foregroundColor(.gray)
                        .offset(y: -70)
                }
                .padding(.top, 120) // Add top padding to push logo down
                
                Spacer() // Push login buttons towards bottom
                
                // 로그인 폼
                VStack(spacing: 20) {
                    // 소셜 로그인 버튼들
                    VStack(spacing: 16) {
                        // 카카오 로그인
                        Button(action: {
                            loginAction()
                        }) {
                            HStack {
                                Image(systemName: "message.fill")
                                    .foregroundColor(Color(hex: "3C1E1E"))
                                    .font(.system(size: 20))
                                    .padding(.leading, 20)
                                
                                Text("카카오로 로그인")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(hex: "3C1E1E"))
                                
                                Spacer()
                            }
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "FEE500"))
                            .cornerRadius(12)
                            .padding(.horizontal, 24)
                        }
                        
                        // 구글 로그인
                        Button(action: {
                            loginAction()
                        }) {
                            HStack {
                                Image(systemName: "g.circle.fill")
                                    .foregroundColor(Color(hex: "555555"))
                                    .font(.system(size: 20))
                                    .padding(.leading, 20)
                                
                                Text("구글로 로그인")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color(hex: "555555"))
                                
                                Spacer()
                            }
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(Color.white)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)
                        }
                        
                        // 애플 로그인
                        Button(action: {
                            loginAction()
                        }) {
                            HStack {
                                Image(systemName: "apple.logo")
                                    .foregroundColor(Color.white)
                                    .font(.system(size: 20))
                                    .padding(.leading, 20)
                                
                                Text("Apple로 로그인")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(Color.white)
                                
                                Spacer()
                            }
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(Color.black)
                            .cornerRadius(12)
                            .padding(.horizontal, 24)
                        }
                        
                        // 이메일 로그인 토글 버튼
                        Button(action: {
                            withAnimation(.spring()) {
                                showEmailForm.toggle()
                            }
                        }) {
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                                    .padding(.leading, 20)
                                
                                Text("이메일로 로그인")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                
                                Spacer()
                            }
                            .frame(height: 56)
                            .frame(maxWidth: .infinity)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "6A11CB"), Color(hex: "2575FC")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .padding(.horizontal, 24)
                        }
                    }
                    
                    // 이메일 로그인 폼
                    if showEmailForm {
                        VStack(spacing: 16) {
                            TextField("이메일", text: $email)
                                .padding()
                                .frame(height: 56)
                                .background(Color(hex: "1A1A32"))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                                .padding(.horizontal, 24)
                            
                            SecureField("비밀번호", text: $password)
                                .padding()
                                .frame(height: 56)
                                .background(Color(hex: "1A1A32"))
                                .cornerRadius(12)
                                .foregroundColor(.white)
                                .padding(.horizontal, 24)
                            
                            Button(action: {
                                loginAction()
                            }) {
                                Text("로그인")
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "6A11CB"), Color(hex: "2575FC")]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(12)
                                    .padding(.horizontal, 24)
                            }
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                    
                    // 회원가입 및 비밀번호 찾기 링크
                    HStack(spacing: 16) {
                        Button(action: {
                            // 비밀번호 찾기 액션
                        }) {
                            Text("비밀번호 찾기")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "2575FC"))
                        }
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            // 회원가입 액션
                        }) {
                            Text("회원가입")
                                .font(.system(size: 14))
                                .foregroundColor(Color(hex: "2575FC"))
                        }
                    }
                }
                .padding(.bottom, 50) // Add bottom padding
                
                Spacer()
            }
            
            // 로딩 인디케이터
            if isLoggingIn {
                Color.black.opacity(0.6)
                    .ignoresSafeArea()
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(1.5)
            }
        }
    }
    
    private func loginAction() {
        isLoggingIn = true
        
        // 테스트를 위해 1초 후 메인앱으로 이동
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            isLoggingIn = false
            withAnimation {
                showMainApp = true
            }
        }
    }
}