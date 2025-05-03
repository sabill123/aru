import SwiftUI

struct ProfileSettingsView: View {
    @State private var notifications = true
    @State private var darkMode = true
    @State private var language = "한국어"
    var onSettingsTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("설정")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            
            ScrollView {
                VStack(spacing: 16) {
                    // 계정 섹션
                    ProfileSettingsSectionView(title: "계정") {
                        ProfileSettingsRow(icon: "person.fill", title: "계정 정보 수정") {
                            // 계정 정보 수정 액션
                        }
                        
                        ProfileSettingsRow(icon: "lock.fill", title: "비밀번호 변경") {
                            // 비밀번호 변경 액션
                        }
                        
                        ProfileSettingsRow(icon: "bell.fill", title: "알림 설정", hasToggle: true, isOn: $notifications)
                    }
                    
                    // 앱 설정 섹션
                    ProfileSettingsSectionView(title: "앱 설정") {
                        ProfileSettingsRow(icon: "moon.fill", title: "다크 모드", hasToggle: true, isOn: $darkMode)
                        
                        ProfileSettingsRow(icon: "globe", title: "언어", hasValue: true, value: language) {
                            // 언어 설정 액션
                        }
                        
                        ProfileSettingsRow(icon: "icloud.fill", title: "데이터 백업") {
                            // 데이터 백업 액션
                        }
                        
                        ProfileSettingsRow(icon: "gearshape.fill", title: "전체 설정", hasValue: true, value: "더 보기") {
                            onSettingsTap?()
                        }
                    }
                    
                    // 기타 섹션
                    ProfileSettingsSectionView(title: "기타") {
                        ProfileSettingsRow(icon: "questionmark.circle.fill", title: "도움말") {
                            // 도움말 액션
                        }
                        
                        ProfileSettingsRow(icon: "exclamationmark.triangle.fill", title: "문제 신고") {
                            // 문제 신고 액션
                        }
                        
                        ProfileSettingsRow(icon: "info.circle.fill", title: "앱 정보") {
                            // 앱 정보 액션
                        }
                    }
                    
                    // 로그아웃 버튼
                    Button(action: {
                        // 로그아웃 액션
                    }) {
                        Text("로그아웃")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(12)
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                    }
                }
                .padding(.bottom, 100) // 하단 여유 공간
            }
            .padding(.horizontal, 20)
        }
    }
}

// 설정 섹션 뷰
struct ProfileSettingsSectionView<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.gray)
                .padding(.horizontal, 10)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color.darkBackgroundSecondary)
            .cornerRadius(12)
        }
    }
}

// 설정 아이템 행 뷰
struct ProfileSettingsRow: View {
    let icon: String
    let title: String
    var hasToggle: Bool = false
    var hasValue: Bool = false
    var value: String = ""
    var action: (() -> Void)? = nil
    @Binding var isOn: Bool
    
    // toggle이 없는 경우를 위한 이니셜라이저
    init(icon: String, title: String, hasToggle: Bool = false, hasValue: Bool = false, value: String = "", action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.hasToggle = hasToggle
        self.hasValue = hasValue
        self.value = value
        self.action = action
        self._isOn = .constant(false) // 더미 바인딩
    }
    
    // toggle이 있는 경우를 위한 이니셜라이저
    init(icon: String, title: String, hasToggle: Bool = true, isOn: Binding<Bool>) {
        self.icon = icon
        self.title = title
        self.hasToggle = hasToggle
        self._isOn = isOn
        self.hasValue = false
    }
    
    var body: some View {
        Button(action: {
            if !hasToggle && action != nil {
                action?()
            }
        }) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 30)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                if hasToggle {
                    Toggle("", isOn: $isOn)
                        .labelsHidden()
                } else if hasValue {
                    Text(value)
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 15)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(hasToggle)
        .background(Color.darkBackgroundSecondary)
    }
}