import SwiftUI

struct ProfileView: View {
    // 사용자 데이터
    let username = "민지"
    let email = "minji@example.com"
    let postCount = 47
    let followerCount = 237
    let followingCount = 142
    
    // 탭 선택
    @State private var selectedTab = 0
    @State private var currentMainTab = 4 // 프로필 탭 선택
    @State private var showSettings = false
    @State private var showProfileSettingsView = false
    
    // 탭 데이터
    let profileTabs = ["작품", "좋아요", "저장", "설정"]
    
    // 샘플 게시물 데이터
    let postTypes = ["이미지", "웹소설", "영상"]
    let postTitles = ["우주 풍경", "별들의 속삭임", "우주 여행 AI 시뮬레이션"]
    let postLikes = [85, 132, 243]
    let postTimes = ["2월 전", "1주일 전", "2주일 전"]
    let iconNames = ["photo", "book", "film"]
    let iconColors = [Color.accentTeal, Color.primaryPurple, Color.accentPink]
    
    var body: some View {
        ZStack {
            // 배경색
            Color.darkBackground.edgesIgnoringSafeArea(.all)
            
            // 인스타그램 스타일 (전체 페이지 스크롤)
            ScrollView {
                VStack(spacing: 0) {
                    // 프로필 헤더 (프로필 이미지, 사용자 정보)
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showSettings = true
                        }) {
                            Image(systemName: "gearshape.fill")
                                .font(.system(size: 22))
                                .foregroundColor(.gray)
                                .padding(8)
                                .background(Color.darkBackgroundSecondary)
                                .clipShape(Circle())
                        }
                        .padding(.trailing, 20)
                        .padding(.top, 10)
                    }
                    
                    // 프로필 정보
                    VStack(spacing: 20) {
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
                                .frame(width: 110, height: 110)
                            
                            Text(String(username.prefix(1)))
                                .font(.system(size: 50, weight: .bold))
                                .foregroundColor(.white)
                        }
                        
                        // 사용자 이름
                        Text(username)
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(.white)
                        
                        // 이메일
                        Text(email)
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 20)
                    
                    // 통계 정보
                    HStack(spacing: 40) {
                        VStack(spacing: 8) {
                            Text("\(postCount)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text("작품")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        VStack(spacing: 8) {
                            Text("\(followerCount)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text("팔로워")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                        
                        VStack(spacing: 8) {
                            Text("\(followingCount)")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            Text("팔로잉")
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // 프로필 편집 버튼
                    Button(action: {
                        // 프로필 수정 액션
                    }) {
                        Text("프로필 편집")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color.darkBackgroundSecondary)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                    
                    // 탭 메뉴
                    ProfileTabMenu(
                        selectedTab: $selectedTab,
                        tabs: profileTabs,
                        namespace: namespace
                    )
                    .padding(.bottom, 10)
                    
                    // 선택된 탭에 따른 콘텐츠
                    ZStack {
                        // 작품 탭
                        if selectedTab == 0 {
                            contentGrid(
                                types: postTypes,
                                titles: postTitles,
                                icons: iconNames,
                                iconColors: iconColors,
                                likes: postLikes,
                                times: postTimes
                            )
                        }
                        // 좋아요 탭
                        else if selectedTab == 1 {
                            contentGrid(
                                types: ["웹소설", "이미지", "영상"],
                                titles: ["기억의 흐름", "미래도시", "AI 생성 음악"],
                                icons: ["book", "photo", "music.note"],
                                iconColors: [Color.primaryBlue, Color.accentPink, Color.accentTeal],
                                likes: [142, 89, 212],
                                times: ["3일 전", "1주일 전", "2주일 전"]
                            )
                        }
                        // 저장 탭
                        else if selectedTab == 2 {
                            contentGrid(
                                types: ["이미지", "웹소설", "영상"],
                                titles: ["우주 속 지구", "사이버펑크 소설", "미래 음악"],
                                icons: ["photo", "book", "film"],
                                iconColors: [Color.accentYellow, Color.primaryPurple, Color.accentPink],
                                likes: [324, 156, 98],
                                times: ["1일 전", "4일 전", "1주일 전"]
                            )
                        }
                        // 설정 탭
                        else {
                            ProfileSettingsView(onSettingsTap: {
                                showSettings = true
                            })
                        }
                    }
                    .animation(.easeInOut(duration: 0.2), value: selectedTab)
                    
                    // 하단 여백
                    Spacer(minLength: 80)
                }
                .padding(.top, 20)
            }
        }
        .sheet(isPresented: $showSettings) {
            FullSettingsView()
        }
    }
    
    // 콘텐츠 그리드 뷰 (작품, 좋아요, 저장 탭에서 사용)
    @ViewBuilder
    func contentGrid(types: [String], titles: [String], icons: [String], iconColors: [Color], likes: [Int], times: [String]) -> some View {
        VStack(spacing: 15) {
            ForEach(0..<min(types.count, titles.count, icons.count, iconColors.count, likes.count, times.count), id: \.self) { index in
                ContentItemCard(
                    type: types[index],
                    title: titles[index],
                    icon: icons[index],
                    iconColor: iconColors[index],
                    likes: likes[index],
                    time: times[index],
                    onEditTap: {
                        // 편집 액션
                    },
                    onShareTap: {
                        // 공유 액션
                    }
                )
            }
        }
        .padding(.horizontal, 20)
    }
    
    // 애니메이션을 위한 네임스페이스
    @Namespace private var namespace
}