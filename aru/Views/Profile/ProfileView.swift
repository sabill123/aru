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
    @State private var isEditingProfile = false
    @State private var showSettings = false
    
    // 컨텐츠 필터링
    @State private var selectedFilter = "전체"
    @State private var selectedSortOption = "최신순"
    
    // 필터 옵션
    let filters = ["전체", "이미지", "영상", "패션", "스타일", "아트"]
    let sortOptions = ["최신순", "인기순", "오래된순"]
    
    // 샘플 아이템 데이터
    let itemTypes = ["이미지", "패션", "영상", "스타일", "아트"]
    let itemColors: [Color] = [.accentPink, .primaryPurple, .accentTeal, .primaryBlue, .accentYellow]
    
    var body: some View {
        ZStack {
            // 배경색
            Color.darkBackground.edgesIgnoringSafeArea(.all)
            
            // 메인 컨텐츠
            VStack(spacing: 0) {
                // 프로필 헤더
                profileHeaderView
                
                // 필터 및 컨텐츠 영역
                VStack(spacing: 0) {
                    // 탭 선택 영역
                    tabSelectionView
                    
                    // 필터 영역
                    if selectedTab == 0 || selectedTab == 1 || selectedTab == 2 {
                        filterView
                    }
                    
                    // 컨텐츠 영역
                    contentAreaView
                }
            }
            
            // 설정 시트
            if showSettings {
                settingsOverlay
            }
        }
        .animation(.spring(), value: selectedTab)
        .animation(.spring(), value: showSettings)
    }
    
    // MARK: - 컴포넌트 뷰
    
    // 프로필 헤더
    var profileHeaderView: some View {
        VStack(spacing: 0) {
            // 상단 버튼 영역
            HStack {
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showSettings = true
                    }
                }) {
                    Image(systemName: "gearshape")
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .padding(8)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            
            // 프로필 정보
            VStack(spacing: 24) {
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
                        .frame(width: 100, height: 100)
                        .shadow(color: Color.primaryPurple.opacity(0.3), radius: 5, x: 0, y: 2)
                    
                    Text(String(username.prefix(1)))
                        .font(.system(size: 44, weight: .bold))
                        .foregroundColor(.white)
                    
                    // 편집 버튼
                    Circle()
                        .fill(Color.accentPink)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Image(systemName: "pencil")
                                .font(.system(size: 12))
                                .foregroundColor(.white)
                        )
                        .offset(x: 35, y: 35)
                }
                .padding(.top, 6)
                
                // 사용자 이름
                Text(username)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                
                // 소개글
                Text("AI 패션 크리에이터 | 디지털 아티스트")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .padding(.top, -10)
                
                // 통계 정보 행
                HStack(spacing: 40) {
                    // 작품 수
                    statItem(count: postCount, label: "작품")
                    
                    // 팔로워 수
                    statItem(count: followerCount, label: "팔로워")
                    
                    // 팔로잉 수
                    statItem(count: followingCount, label: "팔로잉")
                }
                .padding(.vertical, 10)
                
                // 버튼 행
                HStack(spacing: 12) {
                    // 프로필 편집 버튼
                    Button(action: {
                        isEditingProfile = true
                    }) {
                        Text("프로필 편집")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.primaryPurple, lineWidth: 1.5)
                                    .background(Color.darkBackgroundSecondary.cornerRadius(6))
                            )
                    }
                    
                    // 공유 버튼
                    Button(action: {
                        // 공유 기능
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                            .frame(width: 44, height: 44)
                            .background(
                                RoundedRectangle(cornerRadius: 6)
                                    .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                                    .background(Color.darkBackgroundSecondary.cornerRadius(6))
                            )
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
            }
        }
    }
    
    // 통계 아이템
    func statItem(count: Int, label: String) -> some View {
        VStack(spacing: 8) {
            Text("\(count)")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(label)
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
    
    // 탭 선택 뷰
    var tabSelectionView: some View {
        HStack(spacing: 0) {
            // 작품 탭
            tabButton(title: "작품", index: 0)
            
            // 좋아요 탭
            tabButton(title: "좋아요", index: 1)
            
            // 저장 탭
            tabButton(title: "저장", index: 2)
            
            // 팔로워 탭
            tabButton(title: "팔로워", index: 3)
        }
        .padding(.top, 6)
        .background(
            VStack(spacing: 0) {
                // 상단 구분선
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 1)
                
                Spacer()
                
                // 선택 인디케이터
                ZStack(alignment: .bottomLeading) {
                    // 하단 구분선
                    Rectangle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 1)
                    
                    // 선택된 탭 인디케이터
                    Rectangle()
                        .fill(Color.primaryPurple)
                        .frame(width: UIScreen.main.bounds.width / 4, height: 2)
                        .offset(x: CGFloat(selectedTab) * UIScreen.main.bounds.width / 4)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: selectedTab)
                }
            }
        )
    }
    
    // 탭 버튼
    func tabButton(title: String, index: Int) -> some View {
        Button(action: {
            selectedTab = index
        }) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: selectedTab == index ? .semibold : .regular))
                    .foregroundColor(selectedTab == index ? .white : .gray)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        }
    }
    
    // 필터 뷰
    var filterView: some View {
        VStack(spacing: 0) {
            // 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 6)
            
            // 필터 영역
            HStack {
                // 카테고리 필터
                Menu {
                    ForEach(filters, id: \.self) { filter in
                        Button(action: {
                            selectedFilter = filter
                        }) {
                            HStack {
                                Text(filter)
                                if selectedFilter == filter {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedFilter)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.darkBackgroundSecondary)
                    .cornerRadius(6)
                }
                
                Spacer()
                
                // 정렬 옵션
                Menu {
                    ForEach(sortOptions, id: \.self) { option in
                        Button(action: {
                            selectedSortOption = option
                        }) {
                            HStack {
                                Text(option)
                                if selectedSortOption == option {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(selectedSortOption)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Image(systemName: "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 12)
                    .background(Color.darkBackgroundSecondary)
                    .cornerRadius(6)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.darkBackground)
    }
    
    // 컨텐츠 영역
    var contentAreaView: some View {
        ScrollView {
            switch selectedTab {
            case 0: // 작품
                contentGridView(isLiked: false)
            case 1: // 좋아요
                contentGridView(isLiked: true)
            case 2: // 저장
                contentGridView(withSaved: true)
            case 3: // 팔로워
                followersListView
            default:
                contentGridView(isLiked: false)
            }
        }
    }
    
    // 컨텐츠 그리드 뷰
    func contentGridView(isLiked: Bool = false, withSaved: Bool = false) -> some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 14) {
            ForEach(0..<12, id: \.self) { index in
                let adjustedIndex = isLiked ? (index * 3) % 5 : (index * 2) % 5
                let adjustedIndex2 = withSaved ? (index * 7) % 5 : adjustedIndex
                
                contentItemView(
                    index: index,
                    type: itemTypes[adjustedIndex2],
                    color: itemColors[adjustedIndex2],
                    isLiked: isLiked || index % 3 == 0,
                    isSaved: withSaved || index % 4 == 0
                )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .padding(.bottom, 80) // 하단 여백
    }
    
    // 컨텐츠 아이템 뷰
    func contentItemView(index: Int, type: String, color: Color, isLiked: Bool, isSaved: Bool) -> some View {
        VStack(spacing: 6) {
            // 이미지 영역
            ZStack(alignment: .topTrailing) {
                // 배경
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color, color.opacity(0.7)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(10)
                
                // 아이콘
                Image(systemName: iconFor(type: type))
                    .font(.system(size: 30))
                    .foregroundColor(.white.opacity(0.5))
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 북마크 아이콘
                if isSaved {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.3))
                        .clipShape(Circle())
                        .padding(8)
                }
            }
            
            // 타이틀 및 좋아요
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 2) {
                    Text("\(titleFor(type: type)) \(index + 1)")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text("오늘")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 좋아요 버튼
                Button(action: {
                    // 좋아요 토글
                }) {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .font(.system(size: 18))
                        .foregroundColor(isLiked ? .accentPink : .gray)
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    // 팔로워 리스트 뷰
    var followersListView: some View {
        VStack(spacing: 0) {
            ForEach(0..<10, id: \.self) { index in
                followerRowView(index: index)
                
                if index < 9 {
                    Divider()
                        .background(Color.gray.opacity(0.2))
                        .padding(.leading, 70)
                }
            }
        }
        .padding(.vertical, 10)
    }
    
    // 팔로워 행 뷰
    func followerRowView(index: Int) -> some View {
        HStack(spacing: 14) {
            // 프로필 이미지
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [itemColors[index % 5], itemColors[(index + 2) % 5]]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 50, height: 50)
                
                Text(String("사용자\(index + 1)".prefix(1)))
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // 사용자 정보
            VStack(alignment: .leading, spacing: 4) {
                Text("사용자\(index + 1)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text("AI 패션 분야 크리에이터")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(1)
            }
            
            Spacer()
            
            // 팔로우 버튼
            Button(action: {
                // 팔로우 토글
            }) {
                Text(index % 3 == 0 ? "팔로잉" : "팔로우")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(index % 3 == 0 ? .gray : .white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(index % 3 == 0 ? Color.darkBackgroundSecondary : Color.primaryPurple)
                    )
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    // 설정 오버레이
    var settingsOverlay: some View {
        ZStack(alignment: .trailing) {
            // 배경 오버레이
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        showSettings = false
                    }
                }
            
            // 설정 패널
            VStack(spacing: 0) {
                // 헤더
                HStack {
                    Text("설정")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation {
                            showSettings = false
                        }
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 22))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                // 구분선
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                
                // 설정 항목들
                ScrollView {
                    VStack(spacing: 0) {
                        settingsGroupHeader(title: "계정")
                        settingsItem(icon: "person.crop.circle", title: "개인정보 설정")
                        settingsItem(icon: "bell", title: "알림 설정")
                        settingsItem(icon: "lock", title: "보안 설정")
                        
                        settingsGroupHeader(title: "앱 설정")
                        settingsItem(icon: "globe", title: "언어 설정")
                        settingsItem(icon: "moon", title: "다크 모드")
                        settingsItem(icon: "square.and.pencil", title: "테마 설정")
                        
                        settingsGroupHeader(title: "지원")
                        settingsItem(icon: "questionmark.circle", title: "도움말")
                        settingsItem(icon: "exclamationmark.bubble", title: "문제 신고")
                        settingsItem(icon: "arrow.up.doc", title: "이용약관")
                        
                        settingsGroupHeader(title: "계정 관리")
                        settingsItem(icon: "arrow.right.square", title: "로그아웃", textColor: .red)
                    }
                    .padding(.bottom, 50)
                }
            }
            .frame(width: UIScreen.main.bounds.width * 0.8)
            .background(Color.darkBackground)
            .edgesIgnoringSafeArea(.vertical)
        }
    }
    
    // 설정 그룹 헤더
    func settingsGroupHeader(title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .padding(.top, 8)
        .background(Color.darkBackground)
    }
    
    // 설정 항목
    func settingsItem(icon: String, title: String, textColor: Color = .white) -> some View {
        Button(action: {
            // 설정 항목 실행
        }) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(textColor)
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background(Color.darkBackgroundSecondary.opacity(0.3))
        }
    }
    
    // MARK: - 헬퍼 함수
    
    func iconFor(type: String) -> String {
        switch type {
        case "이미지": return "photo"
        case "패션": return "tshirt.fill"
        case "영상": return "film"
        case "스타일": return "person.fill"
        case "아트": return "paintpalette"
        default: return "doc"
        }
    }
    
    func titleFor(type: String) -> String {
        switch type {
        case "이미지": return "이미지"
        case "패션": return "패션 아이템"
        case "영상": return "영상"
        case "스타일": return "스타일 세트"
        case "아트": return "아트워크"
        default: return "콘텐츠"
        }
    }
}

// MARK: - 프리뷰
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .preferredColorScheme(.dark)
    }
}