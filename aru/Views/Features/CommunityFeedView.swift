import SwiftUI

struct CommunityFeedView: View {
    // 상태 변수
    let category: String
    @State private var currentTab = 0
    @State private var currentIndex = 0
    @State private var isLoading = true
    @State private var showOptions = false
    @State private var searchText = ""
    @State private var isSearching = false
    @State private var showPostDetail = false
    @State private var selectedPostIndex: Int? = nil
    @State private var showShareSheet = false
    @Environment(\.presentationMode) var presentationMode
    
    // 카테고리에 따른 색상 지정
    var categoryColor: Color {
        switch category {
        case "추천": return .accentTeal
        case "웹소설": return .primaryPurple
        case "이미지": return .accentPink
        case "피팅": return .accentYellow
        case "트렌드": return .primaryBlue
        default: return .accentTeal
        }
    }
    
    // 샘플 포스트 데이터
    let postTitles = [
        "AI로 생성한 우주 풍경", 
        "새로운 스타일의 초상화", 
        "사이버펑크 스타일 아바타", 
        "미래도시 풍경", 
        "판타지 캐릭터",
        "레트로 웨이브 일러스트"
    ]
    
    let postDescriptions = [
        "우주의 깊은 곳을 탐험하는 느낌을 AI로 표현했습니다. 별과 성운의 조합으로 신비로운 우주 공간을 구현했습니다.",
        "인물 사진에 새로운 스타일을 적용한 결과입니다. 다양한 아트 스타일을 조합하여 독특한 분위기를 연출했습니다.",
        "사이버펑크 2077에서 영감을 받은 캐릭터 디자인입니다. 네온 조명과 미래적인 느낌의 의상이 특징입니다.",
        "2077년의 서울을 상상하여 만든 이미지입니다. 미래의 건축물과 도시 풍경을 AI로 생성했습니다.",
        "판타지 소설에 등장할 법한 캐릭터를 디자인했습니다. 중세 판타지 세계관의 마법사 컨셉으로 제작했습니다.",
        "80년대 레트로 웨이브 스타일로 만든 일러스트입니다. 선명한 네온 컬러와 그리드 패턴이 특징입니다."
    ]
    
    let postCreators = [
        "우주탐험가", "아트디자이너", "사이버펑크마스터", "미래도시", "판타지작가", "레트로웨이브"
    ]
    
    let postLikes = [1290, 854, 2345, 768, 1542, 932]
    let postComments = [78, 42, 156, 35, 85, 63]
    let postTimes = ["2시간 전", "4시간 전", "1일 전", "3일 전", "1주일 전", "2주일 전"]
    
    var tabItems = ["추천", "인기", "최신", "팔로잉"]
    
    // 소셜 정렬 옵션
    var sortOptions = ["인기순", "최신순", "조회순", "댓글순"]
    @State private var selectedSortOption = 0
    
    // 필터링 및 검색 상태
    @State private var showFilterMenu = false
    @State private var activeFilters: [String] = []
    
    // 애니메이션 네임스페이스
    @Namespace private var animation
    
    // 필터 카테고리
    let filterCategories = ["AI생성", "인공지능", "아트", "디자인", "미래", "우주", "사이버펑크", "픽셀아트", "3D"]
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 상단 헤더
                headerView
                    .padding(.horizontal)
                    .padding(.top, 8)
                    .padding(.bottom, 8)
                
                // 검색 바 (검색 모드일 때만 표시)
                ZStack {
                    if isSearching {
                        searchBar
                            .padding(.horizontal)
                            .padding(.bottom, 8)
                            .transition(.move(edge: .top).combined(with: .opacity))
                    }
                }
                .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isSearching)
                
                // 탭 메뉴 및 필터
                VStack(spacing: 5) {
                    // 탭 메뉴
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(Array(tabItems.enumerated()), id: \.offset) { index, tab in
                                Button(action: {
                                    currentTab = index
                                }) {
                                    VStack(spacing: 8) {
                                        Text(tab)
                                            .font(.system(size: 14, weight: currentTab == index ? .bold : .medium))
                                            .foregroundColor(currentTab == index ? .white : .gray)
                                        
                                        // 선택 인디케이터
                                        ZStack {
                                            if currentTab == index {
                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(categoryColor)
                                                    .frame(width: 25, height: 3)
                                                    .matchedGeometryEffect(id: "TAB", in: animation)
                                            } else {
                                                RoundedRectangle(cornerRadius: 2)
                                                    .fill(Color.clear)
                                                    .frame(width: 25, height: 3)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentTab)
                    }
                    
                    // 활성 필터 표시
                    if !activeFilters.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach(activeFilters, id: \.self) { filter in
                                    FilterPill(text: filter, color: categoryColor) {
                                        // 필터 제거
                                        if let index = activeFilters.firstIndex(of: filter) {
                                            activeFilters.remove(at: index)
                                        }
                                    }
                                }
                                
                                // 모든 필터 지우기 버튼
                                Button(action: {
                                    activeFilters.removeAll()
                                }) {
                                    Text("초기화")
                                        .font(.system(size: 12))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.darkBackgroundSecondary)
                                        .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 5)
                        }
                        .transition(.opacity)
                        .animation(.spring(), value: activeFilters)
                    }
                    
                    // 정렬 및 필터 컨트롤
                    HStack {
                        // 정렬 옵션
                        Menu {
                            ForEach(Array(sortOptions.enumerated()), id: \.offset) { index, option in
                                Button(action: {
                                    selectedSortOption = index
                                }) {
                                    HStack {
                                        Text(option)
                                        if selectedSortOption == index {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack(spacing: 4) {
                                Text(sortOptions[selectedSortOption])
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color.darkBackgroundSecondary)
                            .cornerRadius(12)
                        }
                        
                        Spacer()
                        
                        // 필터 버튼
                        Button(action: {
                            showFilterMenu.toggle()
                        }) {
                            HStack(spacing: 4) {
                                Image(systemName: "line.3.horizontal.decrease")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                                
                                Text("필터")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color.darkBackgroundSecondary)
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 5)
                    .padding(.bottom, 8)
                }
                
                // 필터 메뉴
                ZStack {
                    if showFilterMenu {
                        FilterMenu(
                            categories: filterCategories,
                            activeFilters: $activeFilters,
                            categoryColor: categoryColor,
                            onClose: {
                                showFilterMenu = false
                            }
                        )
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .zIndex(1)
                    }
                }
                .animation(.spring(), value: showFilterMenu)
                
                // 메인 콘텐츠 영역
                ZStack {
                    if isLoading {
                        // 로딩 화면
                        loadingView
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .onAppear {
                                // 로딩 상태 시뮬레이션
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                    isLoading = false
                                }
                            }
                    } else if isSearching && !searchText.isEmpty {
                        // 검색 결과
                        searchResultsView
                    } else {
                        // 틱톡 스타일 전체화면 수직 스크롤
                        feedView
                    }
                }
                .animation(.spring(), value: isLoading)
                .animation(.spring(), value: isSearching)
            }
            
            // 포스트 상세 모달
            ZStack {
                if showPostDetail, let index = selectedPostIndex {
                    Color.black.opacity(0.8)
                        .edgesIgnoringSafeArea(.all)
                        .onTapGesture {
                            showPostDetail = false
                        }
                    
                    postDetailView(index: index)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            .animation(.spring(), value: showPostDetail)
            
            // 생성 버튼 (플로팅 액션 버튼)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        // 새 포스트 생성
                    }) {
                        Image(systemName: "plus")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 56, height: 56)
                            .background(
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.8)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .shadow(color: categoryColor.opacity(0.3), radius: 10, x: 0, y: 5)
                            )
                    }
                    .pressEffect()
                    .padding()
                    .padding(.bottom, 60)
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            // 공유 시트 (iOS 시스템 공유 UI)
            if let index = selectedPostIndex {
                ActivityView(text: "\(postTitles[index]) - \(postDescriptions[index])")
            }
        }
    }
    
    // MARK: - 컴포넌트 뷰
    
    // 헤더 뷰
    var headerView: some View {
        HStack {
            // 뒤로가기 버튼
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.darkBackgroundSecondary)
                    .clipShape(Circle())
            }
            .pressEffect()
            
            Spacer()
            
            // 카테고리 타이틀
            Text("\(category) 커뮤니티")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // 검색 버튼
            Button(action: {
                isSearching.toggle()
                if !isSearching {
                    searchText = ""
                }
            }) {
                Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.darkBackgroundSecondary)
                    .clipShape(Circle())
            }
            .pressEffect()
        }
    }
    
    // 검색 바
    var searchBar: some View {
        HStack {
            // 검색 아이콘
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            // 텍스트 필드
            TextField("게시물 검색", text: $searchText)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .autocapitalization(.none)
                .disableAutocorrection(true)
            
            // 취소 버튼
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 8)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .background(Color.darkBackgroundSecondary)
        .cornerRadius(10)
    }
    
    // 필터 메뉴
    struct FilterMenu: View {
        let categories: [String]
        @Binding var activeFilters: [String]
        let categoryColor: Color
        let onClose: () -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                // 헤더
                HStack {
                    Text("카테고리 필터")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .padding(8)
                            .background(Color.darkBackgroundSecondary)
                            .clipShape(Circle())
                    }
                    .pressEffect()
                }
                
                // 카테고리 그리드
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        Button(action: {
                            if activeFilters.contains(category) {
                                activeFilters.removeAll { $0 == category }
                            } else {
                                activeFilters.append(category)
                            }
                        }) {
                            Text(category)
                                .font(.system(size: 13))
                                .foregroundColor(activeFilters.contains(category) ? .white : .gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: .infinity)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(
                                            activeFilters.contains(category) ?
                                            categoryColor.opacity(0.4) :
                                            Color.darkBackgroundSecondary
                                        )
                                )
                        }
                    }
                }
                
                // 적용 버튼
                Button(action: onClose) {
                    Text("적용하기")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 44)
                        .background(
                            RoundedRectangle(cornerRadius: 22)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.8)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                        )
                }
                .padding(.top, 8)
                .pressEffect()
            }
            .padding(20)
            .background(Color.darkBackground)
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
            .padding(.horizontal)
        }
    }
    
    // 필터 알약
    struct FilterPill: View {
        let text: String
        let color: Color
        let onRemove: () -> Void
        
        var body: some View {
            HStack(spacing: 6) {
                Text(text)
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                
                Button(action: onRemove) {
                    Image(systemName: "xmark")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 5)
            .background(
                Capsule()
                    .fill(color.opacity(0.4))
            )
        }
    }
    
    // 로딩 뷰
    var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: categoryColor))
                .scaleEffect(1.5)
            
            Text("콘텐츠를 불러오는 중...")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
    
    // 피드 뷰 (인스타그램 스타일 세로 스크롤)
    var feedView: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 0) {
                ForEach(0..<postTitles.count, id: \.self) { index in
                    FeedPostCard(
                        title: postTitles[index],
                        description: postDescriptions[index],
                        creator: postCreators[index],
                        time: postTimes[index],
                        likes: postLikes[index],
                        comments: postComments[index],
                        categoryColor: categoryColor,
                        index: index,
                        getIconForIndex: { idx in self.getIconForIndex(idx) },
                        generateTags: { idx in self.generateTags(for: idx) },
                        currentIndex: $currentIndex,
                        postTitlesCount: postTitles.count,
                        onLike: { isLiked in
                            // 좋아요 업데이트 로직
                        },
                        onComment: {
                            selectedPostIndex = index
                            showPostDetail = true
                        },
                        onShare: {
                            selectedPostIndex = index
                            showShareSheet = true
                        },
                        onProfile: {
                            // 프로필 보기
                        }
                    )
                    .padding(.bottom, 12)
                    
                    // 구분선
                    if index < postTitles.count - 1 {
                        Divider()
                            .background(Color.darkBackgroundSecondary)
                            .padding(.vertical, 8)
                    }
                }
                
                // 하단 여백
                Spacer()
                    .frame(height: 80)
            }
        }
        .background(Color.darkBackground)
    }
    
    // 새로운 인스타그램 스타일 피드 카드
    struct FeedPostCard: View {
        let title: String
        let description: String
        let creator: String
        let time: String
        let likes: Int
        let comments: Int
        let categoryColor: Color
        let index: Int
        let getIconForIndex: (Int) -> String
        let generateTags: (Int) -> [String]
        @Binding var currentIndex: Int
        let postTitlesCount: Int
        let onLike: (Bool) -> Void
        let onComment: () -> Void
        let onShare: () -> Void
        let onProfile: () -> Void
        
        @State private var isLiked = false
        @State private var showLikeAnimation = false
        @State private var dragOffset: CGFloat = 0
        @State private var previousScrollOffset: CGFloat = 0
        @State private var contentHeight: CGFloat = 0
        
        var body: some View {
            VStack(spacing: 12) {
                // 상단 헤더 - 작성자 정보
                HStack(spacing: 10) {
                    // 프로필 이미지
                    Button(action: onProfile) {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 38, height: 38)
                                .overlay(
                                    Circle()
                                        .strokeBorder(Color.white, lineWidth: 1)
                                )
                            
                            Text(String(creator.prefix(1)))
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    // 작성자 정보
                    VStack(alignment: .leading, spacing: 2) {
                        Text(creator)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(time)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // 옵션 버튼
                    Button(action: {
                        // 더보기 메뉴
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                
                // 메인 콘텐츠 - 이미지
                GeometryReader { geometry in
                    ZStack {
                        // 메인 이미지
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        categoryColor.opacity(0.8), 
                                        categoryColor.opacity(0.5),
                                        categoryColor.opacity(0.3)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: geometry.size.width, height: geometry.size.width)
                        
                        // 콘텐츠 오버레이
                        VStack(spacing: 16) {
                            Image(systemName: getIconForIndex(index))
                                .font(.system(size: 50))
                                .foregroundColor(.white.opacity(0.9))
                            
                            Text(title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        
                        // 좋아요 더블탭 애니메이션
                        if showLikeAnimation {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 80))
                                .foregroundColor(.white)
                                .opacity(showLikeAnimation ? 0.8 : 0)
                                .scaleEffect(showLikeAnimation ? 1 : 0.5)
                                .animation(.easeInOut(duration: 0.3), value: showLikeAnimation)
                        }
                    }
                    .onTapGesture(count: 2) {
                        // 더블 탭 좋아요
                        isLiked = true
                        showLikeAnimation = true
                        onLike(true)
                        
                        // 애니메이션 타이머
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                            showLikeAnimation = false
                        }
                    }
                    .onAppear {
                        contentHeight = geometry.size.width
                    }
                }
                .frame(height: UIScreen.main.bounds.width)
                .clipped()
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            self.dragOffset = value.translation.height
                        }
                        .onEnded { value in
                            // 스크롤 속도가 빠를 때 스냅 효과
                            let velocity = value.predictedEndTranslation.height - value.translation.height
                            if abs(velocity) > 300 {
                                if velocity < 0 {
                                    // 아래로 스크롤하면 다음 포스트로
                                    withAnimation(.spring()) {
                                        if currentIndex < postTitlesCount - 1 {
                                            currentIndex += 1
                                        }
                                    }
                                } else {
                                    // 위로 스크롤하면 이전 포스트로
                                    withAnimation(.spring()) {
                                        if currentIndex > 0 {
                                            currentIndex -= 1
                                        }
                                    }
                                }
                            }
                            self.dragOffset = 0
                        }
                )
                
                // 액션 버튼 영역
                HStack(spacing: 16) {
                    // 좋아요 버튼
                    Button(action: {
                        isLiked.toggle()
                        onLike(isLiked)
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .font(.system(size: 22))
                            .foregroundColor(isLiked ? .red : .white)
                    }
                    .animation(.spring(), value: isLiked)
                    
                    // 댓글 버튼
                    Button(action: onComment) {
                        Image(systemName: "bubble.right")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    
                    // 공유 버튼
                    Button(action: onShare) {
                        Image(systemName: "paperplane")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    // 저장 버튼
                    Button(action: {
                        // 저장하기
                    }) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
                
                // 좋아요 카운트
                HStack {
                    Text("좋아요 \(likes)개")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
                
                // 설명
                HStack(alignment: .top, spacing: 6) {
                    Text(creator)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(description)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                }
                .padding(.horizontal, 16)
                .padding(.top, 2)
                
                // 태그
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(generateTags(index), id: \.self) { tag in
                            Text("#\(tag)")
                                .font(.system(size: 13))
                                .foregroundColor(categoryColor)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                }
                
                // 댓글 보기 링크
                Button(action: onComment) {
                    HStack {
                        Text("\(comments)개의 댓글 모두 보기")
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 6)
                }
            }
            .background(Color.darkBackground)
            .id(index) // 각 포스트마다 고유한 ID 지정
        }
    }
    
    // 포스트 상세 뷰
    func postDetailView(index: Int) -> some View {
        VStack(spacing: 0) {
            // 헤더
            HStack {
                // 제목
                Text(postTitles[index])
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // 닫기 버튼
                Button(action: {
                    showPostDetail = false
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.black.opacity(0.5))
                        .clipShape(Circle())
                }
                .pressEffect()
            }
            .padding()
            .background(
                ZStack {
                    // 그라디언트 배경
                    LinearGradient(
                        gradient: Gradient(colors: [
                            categoryColor.opacity(0.8), 
                            categoryColor.opacity(0.5)
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                }
            )
            
            // 콘텐츠
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // 이미지
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        categoryColor.opacity(0.7), 
                                        categoryColor.opacity(0.3)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(height: 300)
                        
                        // 샘플 아이콘 오버레이
                        VStack(spacing: 20) {
                            // Using local icon selection based on index
                            let icons = ["sparkles.square", "photo", "paintpalette", "camera.filters", "cube", "wand.and.stars"]
                            let iconName = icons[index % icons.count]
                            Image(systemName: iconName)
                                .font(.system(size: 80))
                                .foregroundColor(.white.opacity(0.9))
                        }
                    }
                    
                    // 작성자 정보
                    HStack(spacing: 12) {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                            .overlay(
                                Text(String(postCreators[index].prefix(1)))
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 3) {
                            Text(postCreators[index])
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(postTimes[index])
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            // 팔로우 액션
                        }) {
                            Text("팔로우")
                                .font(.system(size: 13, weight: .medium))
                                .foregroundColor(.white)
                                .padding(.horizontal, 14)
                                .padding(.vertical, 6)
                                .background(
                                    Capsule()
                                        .fill(categoryColor)
                                )
                        }
                        .pressEffect()
                    }
                    .padding(.horizontal)
                    
                    // 설명
                    VStack(alignment: .leading, spacing: 12) {
                        Text(postDescriptions[index])
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        
                        // 태그
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                // Using local tag generation
                                let allTags = ["AI생성", "인공지능", "아트", "디자인", "미래", "우주", "사이버펑크", "픽셀아트", "3D", "모션그래픽", "갤럭시", "판타지"]
                                let count = 3 + (index % 3)
                                let tags = (0..<count).map { i in 
                                    allTags[(index * 2 + i) % allTags.count]
                                }
                                
                                ForEach(tags, id: \.self) { tag in
                                    Text("#\(tag)")
                                        .font(.system(size: 13))
                                        .foregroundColor(categoryColor)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(categoryColor.opacity(0.15))
                                        )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // 좋아요, 댓글 등 통계
                    HStack(spacing: 16) {
                        // 좋아요
                        HStack(spacing: 6) {
                            Image(systemName: "heart.fill")
                                .font(.system(size: 15))
                                .foregroundColor(.red)
                            
                            Text("\(postLikes[index])")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        
                        // 댓글
                        HStack(spacing: 6) {
                            Image(systemName: "bubble.right.fill")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                            
                            Text("\(postComments[index])")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        
                        // 조회수
                        HStack(spacing: 6) {
                            Image(systemName: "eye.fill")
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                            
                            Text("\(index * 321 + 1000)")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color.darkBackgroundSecondary.opacity(0.5))
                    
                    // 댓글 섹션
                    VStack(alignment: .leading, spacing: 15) {
                        Text("댓글")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                        
                        // 댓글 리스트
                        ForEach(0..<min(5, postComments[index]/8), id: \.self) { i in
                            CommentView(
                                username: "사용자\(i+1)",
                                comment: "정말 멋진 작품이네요! 어떤 프롬프트를 사용하셨나요?",
                                time: "\(i+1)시간 전",
                                likes: (i+1) * 12,
                                categoryColor: categoryColor
                            )
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // 비슷한 콘텐츠
                    VStack(alignment: .leading, spacing: 15) {
                        Text("비슷한 콘텐츠")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(.white)
                        
                        // 관련 콘텐츠 스크롤
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<3, id: \.self) { i in
                                    let relatedIndex = (index + i + 1) % postTitles.count
                                    RelatedContentCard(
                                        title: postTitles[relatedIndex],
                                        creator: postCreators[relatedIndex],
                                        index: relatedIndex,
                                        categoryColor: categoryColor,
                                        onTap: {
                                            selectedPostIndex = relatedIndex
                                        }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            
            // 하단 댓글 입력 바
            HStack(spacing: 12) {
                // 댓글 입력
                HStack {
                    TextField("댓글 작성...", text: .constant(""))
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .frame(height: 40)
                        .background(Color.darkBackgroundSecondary)
                        .cornerRadius(20)
                }
                
                // 좋아요, 북마크, 공유 버튼
                HStack(spacing: 15) {
                    Button(action: {
                        // 좋아요
                    }) {
                        Image(systemName: "heart")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        // 북마크
                    }) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                    
                    Button(action: {
                        // 공유
                        showShareSheet = true
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.darkBackground)
            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: -3)
        }
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.9)
        .background(Color.darkBackground)
        .aruCornerRadius(20, corners: [.topLeft, .topRight])
    }
    
    // 댓글 뷰
    struct CommentView: View {
        let username: String
        let comment: String
        let time: String
        let likes: Int
        let categoryColor: Color
        @State private var isLiked = false
        
        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                // 프로필 이미지
                Circle()
                    .fill(Color.darkBackgroundSecondary)
                    .frame(width: 36, height: 36)
                    .overlay(
                        Text(String(username.prefix(1)))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    )
                
                VStack(alignment: .leading, spacing: 3) {
                    // 유저명과 시간
                    HStack {
                        Text(username)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        Text(time)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    // 댓글 내용
                    Text(comment)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.9))
                        .lineSpacing(3)
                    
                    // 좋아요, 답글
                    HStack(spacing: 15) {
                        Button(action: {
                            isLiked.toggle()
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: isLiked ? "heart.fill" : "heart")
                                    .font(.system(size: 12))
                                    .foregroundColor(isLiked ? .red : .gray)
                                
                                Text("\(likes + (isLiked ? 1 : 0))")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            .animation(.spring(), value: isLiked)
                        }
                        
                        Button(action: {
                            // 답글 작성
                        }) {
                            Text("답글")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 3)
                }
                
                Spacer()
            }
            .padding(.vertical, 6)
        }
    }
    
    // 관련 콘텐츠 카드
    struct RelatedContentCard: View {
        let title: String
        let creator: String
        let index: Int
        let categoryColor: Color
        let onTap: () -> Void
        
        // Local icon selection function
        private func getIconForIndex(_ index: Int) -> String {
            let icons = ["sparkles.square", "photo", "paintpalette", "camera.filters", "cube", "wand.and.stars"]
            return icons[index % icons.count]
        }
        
        var body: some View {
            Button(action: onTap) {
                VStack(alignment: .leading, spacing: 8) {
                    // 썸네일
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        categoryColor.opacity(0.7), 
                                        categoryColor.opacity(0.4)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 140, height: 140)
                            .cornerRadius(10)
                        
                        // 아이콘
                        Image(systemName: getIconForIndex(index))
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    }
                    
                    // 텍스트
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Text(creator)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 140)
                }
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // 검색 결과 뷰
    var searchResultsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            // 검색 결과 헤더
            Text("'\(searchText)' 검색 결과")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // 결과 리스트
            ScrollView {
                LazyVStack(spacing: 15) {
                    ForEach(0..<3, id: \.self) { index in
                        SearchResultRow(
                            title: postTitles[index],
                            description: postDescriptions[index],
                            creator: postCreators[index],
                            likes: postLikes[index],
                            comments: postComments[index],
                            categoryColor: categoryColor,
                            onTap: {
                                selectedPostIndex = index
                                showPostDetail = true
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 80)
            }
        }
        .padding(.top, 10)
    }
    
    // 검색 결과 행
    struct SearchResultRow: View {
        let title: String
        let description: String
        let creator: String
        let likes: Int
        let comments: Int
        let categoryColor: Color
        let onTap: () -> Void
        
        var body: some View {
            Button(action: onTap) {
                HStack(spacing: 12) {
                    // 썸네일
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        categoryColor.opacity(0.7), 
                                        categoryColor.opacity(0.4)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 80, height: 80)
                        
                        // 아이콘
                        Image(systemName: "photo")
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    // 콘텐츠
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.white)
                            .lineLimit(1)
                        
                        Text(description)
                            .font(.system(size: 13))
                            .foregroundColor(.gray)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                        
                        // 작성자 및 통계
                        HStack(spacing: 8) {
                            Text(creator)
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.gray)
                            
                            // 구분자
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 3, height: 3)
                            
                            // 좋아요
                            HStack(spacing: 3) {
                                Image(systemName: "heart.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.red.opacity(0.8))
                                
                                Text("\(likes)")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                            
                            // 구분자
                            Circle()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 3, height: 3)
                            
                            // 댓글
                            HStack(spacing: 3) {
                                Image(systemName: "bubble.right.fill")
                                    .font(.system(size: 10))
                                    .foregroundColor(.gray.opacity(0.8))
                                
                                Text("\(comments)")
                                    .font(.system(size: 11))
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .padding(12)
                .background(Color.darkBackgroundSecondary.opacity(0.5))
                .cornerRadius(12)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    // MARK: - Helper Methods
    
    // 인덱스에 따른 아이콘
    private func getIconForIndex(_ index: Int) -> String {
        let icons = ["sparkles.square", "photo", "paintpalette", "camera.filters", "cube", "wand.and.stars"]
        return icons[index % icons.count]
    }
    
    // 태그 생성
    private func generateTags(for index: Int) -> [String] {
        let allTags = ["AI생성", "인공지능", "아트", "디자인", "미래", "우주", "사이버펑크", "픽셀아트", "3D", "모션그래픽", "갤럭시", "판타지"]
        var result: [String] = []
        
        // 인덱스를 기반으로 랜덤하지만 일관된 태그 선택
        let count = 3 + (index % 3)
        for i in 0..<count {
            let tagIndex = (index * 2 + i) % allTags.count
            result.append(allTags[tagIndex])
        }
        
        return result
    }
    
    // Animation namespace is already declared at the top of the file
}

// 인스타그램/틱톡 스타일 피드 아이템
struct FeedItemView: View {
    let title: String
    let description: String
    let creator: String
    let likes: Int
    let comments: Int
    let time: String
    let categoryColor: Color
    let index: Int
    
    let onLike: (Bool) -> Void
    let onComment: () -> Void
    let onShare: () -> Void
    let onDetail: () -> Void
    
    @State private var isLiked = false
    @State private var showLikeAnimation = false
    @State private var isDoubleTap = false
    
    var body: some View {
        // 틱톡 스타일을 위한 회전된 컨테이너
        ZStack {
            // 메인 컨텐츠 (회전 시켜서 원래 방향으로 표시)
            VStack(spacing: 0) {
                // 배경 영역 - 클릭 가능한 영역
                ZStack {
                    // 배경 이미지 (샘플용 색상 배경)
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    categoryColor.opacity(0.8), 
                                    categoryColor.opacity(0.5),
                                    categoryColor.opacity(0.3)
                                ]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .overlay(
                            // 샘플 아이콘 오버레이
                            VStack(spacing: 20) {
                                Image(systemName: getIconForIndex(index))
                                    .font(.system(size: 70))
                                    .foregroundColor(.white.opacity(0.9))
                                
                                VStack(spacing: 5) {
                                    Text(title)
                                        .font(.system(size: 20, weight: .bold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .padding(.horizontal, 20)
                                }
                            }
                        )
                    
                    // 인터랙션 버튼들 (우측)
                    VStack(alignment: .trailing, spacing: 30) {
                        Spacer()
                        
                        // 유저 프로필
                        VStack(spacing: 8) {
                            // 프로필 이미지
                            ZStack {
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.7)]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 48, height: 48)
                                    .overlay(
                                        Circle()
                                            .strokeBorder(Color.white, lineWidth: 2)
                                    )
                                
                                Text(String(creator.prefix(1)))
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            
                            // 팔로우 버튼
                            Button(action: {}) {
                                Image(systemName: "plus.circle.fill")
                                    .font(.system(size: 22))
                                    .foregroundColor(.white)
                                    .background(Circle().fill(categoryColor).frame(width: 18, height: 18))
                            }
                        }
                        
                        // 좋아요 버튼
                        VStack(spacing: 6) {
                            Button(action: {
                                isLiked.toggle()
                                onLike(isLiked)
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: isLiked ? "heart.fill" : "heart")
                                        .font(.system(size: 28))
                                        .foregroundColor(isLiked ? .red : .white)
                                    
                                    Text("\(likes + (isLiked ? 1 : 0))")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                }
                                .animation(.spring(), value: isLiked)
                            }
                        }
                        
                        // 댓글 버튼
                        VStack(spacing: 6) {
                            Button(action: onComment) {
                                VStack(spacing: 4) {
                                    Image(systemName: "bubble.right")
                                        .font(.system(size: 26))
                                        .foregroundColor(.white)
                                    
                                    Text("\(comments)")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        // 공유 버튼
                        VStack(spacing: 6) {
                            Button(action: onShare) {
                                VStack(spacing: 4) {
                                    Image(systemName: "paperplane")
                                        .font(.system(size: 26))
                                        .foregroundColor(.white)
                                    
                                    Text("공유")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        // 더 보기 버튼
                        VStack(spacing: 6) {
                            Button(action: onDetail) {
                                VStack(spacing: 4) {
                                    Image(systemName: "ellipsis")
                                        .font(.system(size: 26))
                                        .foregroundColor(.white)
                                    
                                    Text("더보기")
                                        .font(.system(size: 13))
                                        .foregroundColor(.white)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .padding(.trailing, 20)
                    .padding(.vertical, 30)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    // 좋아요 애니메이션
                    if showLikeAnimation {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                            .scaleEffect(isDoubleTap ? 1.0 : 0.5)
                            .opacity(isDoubleTap ? 0.9 : 0)
                            .animation(.easeInOut(duration: 0.5), value: isDoubleTap)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle()) // 전체 영역 터치 가능하게
                .onTapGesture(count: 2) {
                    // 더블 탭 좋아요
                    isLiked = true
                    showLikeAnimation = true
                    isDoubleTap = true
                    onLike(true)
                    
                    // 애니메이션 종료 후 숨기기
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                        isDoubleTap = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            showLikeAnimation = false
                        }
                    }
                }
                
                // 하단 정보 영역
                VStack(alignment: .leading, spacing: 10) {
                    // 작성자 정보
                    HStack(spacing: 10) {
                        // 프로필 이미지 (작은 사이즈)
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [categoryColor, categoryColor.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 30, height: 30)
                            .overlay(
                                Text(String(creator.prefix(1)))
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        // 작성자 이름
                        Text(creator)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        // 게시 시간
                        Text("•")
                            .foregroundColor(.gray)
                        
                        Text("\(time)")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                        
                        Spacer()
                    }
                    
                    // 설명 텍스트
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.9))
                        .lineLimit(2)
                        .padding(.vertical, 3)
                    
                    // 태그 스크롤
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(generateTags(for: index), id: \.self) { tag in
                                Text("#\(tag)")
                                    .font(.system(size: 12))
                                    .foregroundColor(categoryColor)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(categoryColor.opacity(0.15))
                                    )
                            }
                        }
                    }
                }
                .padding(15)
                .background(
                    // 하단 그라디언트 오버레이
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.black.opacity(0.5),
                            Color.black.opacity(0.3),
                            Color.black.opacity(0.2)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                )
            }
            .rotationEffect(.degrees(-90)) // 컨텐츠를 반대 방향으로 회전
            .frame(
                width: UIScreen.main.bounds.height - 180,
                height: UIScreen.main.bounds.width
            )
        }
    }
    
    // 인덱스에 따른 아이콘
    private func getIconForIndex(_ index: Int) -> String {
        let icons = ["sparkles.square", "photo", "paintpalette", "camera.filters", "cube", "wand.and.stars"]
        return icons[index % icons.count]
    }
    
    // 태그 생성
    private func generateTags(for index: Int) -> [String] {
        let allTags = ["AI생성", "인공지능", "아트", "디자인", "미래", "우주", "사이버펑크", "픽셀아트", "3D"]
        var result: [String] = []
        
        // 인덱스를 기반으로 태그 선택
        let count = 3 + (index % 2)
        for i in 0..<count {
            let tagIndex = (index * 2 + i) % allTags.count
            result.append(allTags[tagIndex])
        }
        
        return result
    }
}

// 활동 뷰 (시스템 공유 시트)
struct ActivityView: UIViewControllerRepresentable {
    let text: String
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(
            activityItems: [text],
            applicationActivities: nil
        )
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Note: RoundedCorner shape and cornerRadius extension are already defined elsewhere in the project