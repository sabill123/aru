import SwiftUI

struct FullSettingsView: View {
    // 설정 상태 변수
    @State private var notificationsEnabled = true
    @State private var darkMode = true
    @State private var autoplayVideos = true
    @State private var highQualityPreview = true
    @State private var dataUsageMode = "표준"
    @State private var language = "한국어"
    @State private var selectedTheme = 0 // 0: 시스템, 1: 다크, 2: 라이트
    
    // 테마 정보
    let themes = ["시스템 기본", "다크 모드", "라이트 모드"]
    let themeIcons = ["iphone", "moon.fill", "sun.max.fill"]
    
    // 언어 선택 상태
    @State private var showLanguageSelector = false
    let languages = ["한국어", "English", "日本語", "中文"]
    
    var body: some View {
        NavigationView {
            ZStack {
                // 배경
                SpaceBackgroundView()
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // 프로필 카드
                        ProfileCard()
                            .padding(.top, 20)
                        
                        // 앱 테마 선택
                        ThemeSelector(
                            selectedTheme: $selectedTheme, 
                            themes: themes,
                            themeIcons: themeIcons
                        )
                        
                        // 일반 설정 섹션
                        SettingsSection(title: "일반 설정") {
                            // 알림 설정
                            ToggleSettingRow(
                                icon: "bell.fill", 
                                iconColor: Color.accentPink,
                                title: "알림",
                                subtitle: "새 콘텐츠와 업데이트 알림",
                                isOn: $notificationsEnabled
                            )
                            
                            // 자동 재생
                            ToggleSettingRow(
                                icon: "play.fill", 
                                iconColor: Color.accentTeal,
                                title: "동영상 자동 재생",
                                subtitle: "피드에서 동영상 자동 재생",
                                isOn: $autoplayVideos
                            )
                            
                            // 고화질 미리보기
                            ToggleSettingRow(
                                icon: "sparkles", 
                                iconColor: Color.accentYellow,
                                title: "고화질 미리보기",
                                subtitle: "더 선명한 미리보기 이미지",
                                isOn: $highQualityPreview
                            )
                            
                            // 데이터 사용량
                            NavigationSettingRow(
                                icon: "arrow.up.arrow.down", 
                                iconColor: Color.primaryBlue,
                                title: "데이터 사용량",
                                subtitle: dataUsageMode,
                                action: {}
                            )
                            
                            // 언어 설정
                            NavigationSettingRow(
                                icon: "globe", 
                                iconColor: Color.primaryPurple,
                                title: "언어",
                                subtitle: language,
                                action: {
                                    showLanguageSelector = true
                                }
                            )
                        }
                        
                        // 계정 설정 섹션
                        SettingsSection(title: "계정") {
                            // 계정 정보
                            NavigationSettingRow(
                                icon: "person.fill", 
                                iconColor: Color.accentPink,
                                title: "계정 정보",
                                subtitle: "프로필 및 개인정보 관리",
                                action: {}
                            )
                            
                            // 보안
                            NavigationSettingRow(
                                icon: "lock.fill", 
                                iconColor: Color.accentTeal,
                                title: "보안",
                                subtitle: "비밀번호 및 2단계 인증",
                                action: {}
                            )
                            
                            // 개인정보 보호
                            NavigationSettingRow(
                                icon: "hand.raised.fill", 
                                iconColor: Color.primaryBlue,
                                title: "개인정보 보호",
                                subtitle: "데이터 사용 및 쿠키 설정",
                                action: {}
                            )
                        }
                        
                        // 지원 섹션
                        SettingsSection(title: "지원 및 정보") {
                            // 도움말
                            NavigationSettingRow(
                                icon: "questionmark.circle.fill", 
                                iconColor: Color.accentYellow,
                                title: "도움말",
                                subtitle: "FAQ 및 사용 가이드",
                                action: {}
                            )
                            
                            // 문의하기
                            NavigationSettingRow(
                                icon: "envelope.fill", 
                                iconColor: Color.accentPink,
                                title: "문의하기",
                                subtitle: "피드백 및 지원 요청",
                                action: {}
                            )
                            
                            // 앱 정보
                            NavigationSettingRow(
                                icon: "info.circle.fill", 
                                iconColor: Color.primaryPurple,
                                title: "앱 정보",
                                subtitle: "버전 및 법적 정보",
                                action: {}
                            )
                        }
                        
                        // 로그아웃 버튼
                        Button(action: {
                            // 로그아웃 액션
                        }) {
                            Text("로그아웃")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 16)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(16)
                        }
                        .padding(.top, 8)
                        
                        // 계정 삭제 버튼
                        Button(action: {
                            // 계정 삭제 액션
                        }) {
                            Text("계정 삭제")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .padding(.vertical, 8)
                        }
                        
                        Spacer()
                            .frame(height: 100) // 하단 여백
                    }
                    .padding(.horizontal, 20)
                }
                
                // 언어 선택 시트
                if showLanguageSelector {
                    LanguageSelectorView(
                        isPresented: $showLanguageSelector,
                        selectedLanguage: $language,
                        languages: languages
                    )
                }
            }
            .navigationTitle("설정")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button(action: {
                    // 저장 액션
                }) {
                    Text("저장")
                        .foregroundColor(Color.accentTeal)
                }
            )
        }
    }
}

// 프로필 카드
struct ProfileCard: View {
    var body: some View {
        VStack(spacing: 16) {
            // 프로필 이미지
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 90, height: 90)
                
                Image(systemName: "person.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.white)
                
                // 편집 버튼
                Circle()
                    .fill(Color.accentTeal)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Image(systemName: "pencil")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    )
                    .offset(x: 30, y: 30)
            }
            
            // 사용자 정보
            Text("민지")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            Text("minji@example.com")
                .font(.system(size: 16))
                .foregroundColor(.gray)
            
            // 프로필 상태
            HStack(spacing: 20) {
                VStack {
                    Text("47")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("작품")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Divider()
                    .frame(height: 30)
                    .background(Color.gray.opacity(0.3))
                
                VStack {
                    Text("237")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("팔로워")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                Divider()
                    .frame(height: 30)
                    .background(Color.gray.opacity(0.3))
                
                VStack {
                    Text("142")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("팔로잉")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            .padding(.vertical, 8)
        }
        .padding(.vertical, 24)
        .padding(.horizontal, 16)
        .background(Color.darkBackgroundSecondary)
        .cornerRadius(24)
        .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// 테마 선택기
struct ThemeSelector: View {
    @Binding var selectedTheme: Int
    let themes: [String]
    let themeIcons: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("테마")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            HStack(spacing: 12) {
                ForEach(0..<themes.count, id: \.self) { index in
                    Button(action: {
                        selectedTheme = index
                    }) {
                        VStack(spacing: 8) {
                            // 아이콘
                            ZStack {
                                Circle()
                                    .fill(selectedTheme == index ? 
                                          LinearGradient(
                                            gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                          ) : 
                                          LinearGradient(
                                            gradient: Gradient(colors: [Color.darkBackgroundSecondary, Color.darkBackgroundSecondary]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                          ))
                                    .frame(width: 56, height: 56)
                                
                                Image(systemName: themeIcons[index])
                                    .font(.system(size: 24))
                                    .foregroundColor(.white)
                            }
                            
                            // 텍스트
                            Text(themes[index])
                                .font(.system(size:.minimum(CGFloat(14), CGFloat(90 / themes[index].count))))
                                .foregroundColor(selectedTheme == index ? .white : .gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 16)
        .background(Color.darkBackgroundSecondary)
        .cornerRadius(24)
    }
}

// 설정 섹션
struct SettingsSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 8)
            
            VStack(spacing: 8) {
                content
            }
            .padding(.vertical, 8)
            .background(Color.darkBackgroundSecondary)
            .cornerRadius(24)
        }
    }
}

// 토글 설정 행
struct ToggleSettingRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            // 아이콘
            ZStack {
                Circle()
                    .fill(iconColor.opacity(0.2))
                    .frame(width: 36, height: 36)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(iconColor)
            }
            
            // 텍스트
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 토글
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: Color.accentTeal))
                .labelsHidden()
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

// 네비게이션 설정 행
struct NavigationSettingRow: View {
    let icon: String
    let iconColor: Color
    let title: String
    let subtitle: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // 아이콘
                ZStack {
                    Circle()
                        .fill(iconColor.opacity(0.2))
                        .frame(width: 36, height: 36)
                    
                    Image(systemName: icon)
                        .font(.system(size: 16))
                        .foregroundColor(iconColor)
                }
                
                // 텍스트
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 화살표
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
    }
}

// 언어 선택 뷰
struct LanguageSelectorView: View {
    @Binding var isPresented: Bool
    @Binding var selectedLanguage: String
    let languages: [String]
    
    var body: some View {
        ZStack {
            // 배경 딤 처리
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
            
            // 언어 선택 패널
            VStack(spacing: 0) {
                // 헤더
                HStack {
                    Text("언어 선택")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        isPresented = false
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                // 언어 목록
                ForEach(languages, id: \.self) { language in
                    Button(action: {
                        selectedLanguage = language
                        isPresented = false
                    }) {
                        HStack {
                            Text(language)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            
                            Spacer()
                            
                            if selectedLanguage == language {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.accentTeal)
                            }
                        }
                        .padding()
                    }
                    
                    Divider()
                        .background(Color.gray.opacity(0.3))
                }
            }
            .background(Color.darkBackgroundSecondary)
            .cornerRadius(16)
            .padding(.horizontal, 20)
        }
        .transition(.opacity)
        .animation(.easeInOut, value: isPresented)
    }
}

// 미리보기 제공자
struct FullSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        FullSettingsView()
            .background(Color.darkBackground)
            .preferredColorScheme(.dark)
    }
}