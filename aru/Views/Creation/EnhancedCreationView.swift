import SwiftUI

// MARK: - 데이터 모델
struct EnhancedCreationFeature: Identifiable {
    let id: Int
    let title: String
    let description: String
    let iconName: String
    let category: String
    let mainColor: Color
    let gradientColors: [Color]
    let content: String
    let tags: [String]
}

struct EnhancedCreationView: View {
    // 상태 관리
    @State private var selectedCategory = 0
    @State private var searchText = ""
    @State private var showCreateOptions = false
    @State private var showNovelCreation = false
    @State private var showImageGeneration = false
    @State private var showVirtualFitting = false
    @State private var activeCard: Int? = nil
    @State private var animateContent = false
    @State private var showFeatureDetail = false
    @State private var selectedFeature: EnhancedCreationFeature? = nil
    @State private var isSearching = false
    @State private var showUserCreations = false // 사용자 AI 결과 페이지
    
    // 카테고리
    let categories = ["전체", "텍스트", "이미지", "음성", "영상"]
    
    // 피처 데이터
    let features: [EnhancedCreationFeature] = [
        EnhancedCreationFeature(
            id: 1,
            title: "웹소설 작가",
            description: "당신의 이야기를 AI 기술로 웹소설로 만들어보세요",
            iconName: "doc.text.image",
            category: "텍스트",
            mainColor: .primaryPurple,
            gradientColors: [Color.primaryPurple, Color.primaryBlue],
            content: "소설을 작성할 때 원하는 장르와 주제를 선택하세요. 판타지, SF, 로맨스 등 다양한 장르를 지원합니다.",
            tags: ["인기", "웹소설", "AI 글쓰기"]
        ),
        EnhancedCreationFeature(
            id: 2,
            title: "이미지 생성",
            description: "텍스트 프롬프트로 원하는 이미지를 생성하세요",
            iconName: "photo.on.rectangle.angled",
            category: "이미지",
            mainColor: .accentPink,
            gradientColors: [Color.accentPink, Color.accentPink.opacity(0.7)],
            content: "텍스트 프롬프트를 입력하여 원하는 이미지를 생성할 수 있습니다. 스타일, 색상, 구도 등을 지정할 수 있습니다.",
            tags: ["인기", "이미지", "AI 아트"]
        ),
        EnhancedCreationFeature(
            id: 3,
            title: "가상 피팅",
            description: "다양한 옷을 가상으로 입어보세요",
            iconName: "tshirt",
            category: "이미지",
            mainColor: .accentYellow,
            gradientColors: [Color.accentYellow, Color.orange.opacity(0.8)],
            content: "다양한 옷을 선택하여 가상으로 착용해볼 수 있습니다. 사진이나 아바타에 적용 가능합니다.",
            tags: ["패션", "피팅", "AI 스타일"]
        ),
        EnhancedCreationFeature(
            id: 4,
            title: "음악 작곡",
            description: "간단한 분위기 설정으로 나만의 음악 만들기",
            iconName: "music.note",
            category: "음성",
            mainColor: .accentTeal,
            gradientColors: [Color.accentTeal, Color.accentTeal.opacity(0.7)],
            content: "원하는 장르와 분위기를 선택하면 AI가 음악을 작곡합니다. 다양한 악기와 스타일을 지원합니다.",
            tags: ["음악", "작곡", "AI 오디오"]
        ),
        EnhancedCreationFeature(
            id: 5,
            title: "AI 비디오",
            description: "텍스트에서 짧은 영상을 생성하세요",
            iconName: "video.badge.plus",
            category: "영상",
            mainColor: .primaryBlue,
            gradientColors: [Color.primaryBlue, Color.primaryBlue.opacity(0.7)],
            content: "텍스트 설명을 기반으로 짧은 영상을 생성합니다. 애니메이션이나 실사 스타일 선택 가능합니다.",
            tags: ["비디오", "영상", "애니메이션"]
        ),
        EnhancedCreationFeature(
            id: 6,
            title: "3D 모델링",
            description: "텍스트에서 3D 모델을 쉽게 만들어보세요",
            iconName: "cube",
            category: "이미지",
            mainColor: .gray,
            gradientColors: [Color.gray, Color.gray.opacity(0.7)],
            content: "텍스트 설명을 입력하면 AI가 3D 모델을 생성합니다. 게임, AR, VR 용도로 활용할 수 있습니다.",
            tags: ["3D", "모델링", "AR/VR"]
        ),
        EnhancedCreationFeature(
            id: 7,
            title: "텍스트 요약",
            description: "긴 문서를 간결하게 요약해드립니다",
            iconName: "text.redaction",
            category: "텍스트",
            mainColor: .primaryPurple,
            gradientColors: [Color.primaryPurple.opacity(0.7), Color.primaryPurple],
            content: "긴 문서나 기사를 AI가 핵심 내용만 추출하여 요약해 드립니다. 길이와 스타일을 조절할 수 있습니다.",
            tags: ["텍스트", "요약", "생산성"]
        ),
        EnhancedCreationFeature(
            id: 8,
            title: "음성 변환",
            description: "당신의 목소리를 다양한 목소리로 변환",
            iconName: "waveform",
            category: "음성",
            mainColor: .accentTeal,
            gradientColors: [Color.accentTeal, Color.primaryBlue.opacity(0.7)],
            content: "녹음된 목소리를 다양한 캐릭터나 유명인의 목소리로 변환합니다. 다양한 스타일과 감정 선택 가능합니다.",
            tags: ["음성", "변환", "보이스"]
        )
    ]
    
    // 최근 사용 항목
    let recentlyUsed = [2, 1, 4] // 아이디 참조
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 헤더
                headerView
                    .padding(.top, 15)
                    .padding(.bottom, 5)
                
                // 검색 바 (확장 시 표시)
                if isSearching {
                    searchBarView
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.horizontal, 20)
                        .padding(.top, 5)
                        .padding(.bottom, 15)
                }
                
                // 카테고리 선택
                categorySelectionView
                    .padding(.bottom, 15)
                
                // 콘텐츠 영역
                if isSearching && !searchText.isEmpty {
                    // 검색 결과
                    SearchResultsView(
                        searchText: searchText,
                        features: searchResults,
                        onSelect: { feature in
                            selectedFeature = feature
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showFeatureDetail = true
                            }
                        }
                    )
                } else {
                    // 메인 콘텐츠
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            // 빠른 접근 버튼
                            quickAccessView
                                .padding(.horizontal, 20)
                                .padding(.top, 5)
                            
                            // 추천 AI 기능 섹션
                            featuredSection
                                .padding(.horizontal, 20)
                            
                            // 카테고리별 AI 기능 목록
                            filteredFeaturesSection
                                .padding(.horizontal, 20)
                                .padding(.bottom, 80)
                        }
                    }
                }
            }
            
            // 피처 상세 모달
            if showFeatureDetail, let feature = selectedFeature {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                    .transition(.opacity)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            showFeatureDetail = false
                        }
                    }
                
                featureDetailView(feature: feature)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onAppear {
            // 애니메이션 지연
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    animateContent = true
                }
            }
        }
        .fullScreenCover(isPresented: $showUserCreations) {
            // 사용자 AI 기능 결과 페이지
            UserCreationsView(isPresented: $showUserCreations)
        }
    }
    
    // MARK: - 헤더 뷰
    var headerView: some View {
        HStack(spacing: 15) {
            // 앱 타이틀
            Text("CREATE ARU")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // 검색 버튼
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isSearching.toggle()
                    if !isSearching {
                        searchText = ""
                    }
                }
            }) {
                Image(systemName: isSearching ? "xmark" : "magnifyingglass")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.darkBackgroundSecondary)
                    .clipShape(Circle())
            }
            .pressEffect()
            
            // 프로필 버튼 - 사용자 AI 기능 결과 페이지로 연결
            Button(action: {
                withAnimation(.spring()) {
                    showUserCreations = true
                }
            }) {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 34, height: 34)
                    .overlay(
                        Text("M")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                    )
            }
            .pressEffect()
        }
        .padding(.horizontal, 20)
    }
    
    // MARK: - 검색 바
    var searchBarView: some View {
        HStack {
            // 검색 아이콘
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            // 텍스트 필드
            TextField("AI 기능 검색", text: $searchText)
                .font(.system(size: 14))
                .foregroundColor(.white)
                .padding(10)
                .accentColor(.accentTeal)
            
            // 취소 버튼
            if !searchText.isEmpty {
                Button(action: {
                    searchText = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
                .transition(.scale.combined(with: .opacity))
            }
        }
        .background(Color.darkBackgroundSecondary.opacity(0.7))
        .cornerRadius(12)
    }
    
    // MARK: - 카테고리 선택 뷰
    var categorySelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedCategory = index
                        }
                    }) {
                        Text(category)
                            .font(.system(size: 13, weight: selectedCategory == index ? .semibold : .regular))
                            .foregroundColor(selectedCategory == index ? .white : .gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                ZStack {
                                    if selectedCategory == index {
                                        Capsule()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        categoryColor(for: category).opacity(0.7),
                                                        categoryColor(for: category).opacity(0.4)
                                                    ]),
                                                    startPoint: .leading,
                                                    endPoint: .trailing
                                                )
                                            )
                                            .matchedGeometryEffect(id: "categoryBackground", in: animation)
                                    } else {
                                        Capsule()
                                            .fill(Color.darkBackgroundSecondary.opacity(0.5))
                                    }
                                }
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
        }
    }
    
    // MARK: - 빠른 접근 버튼
    var quickAccessView: some View {
        HStack(spacing: 12) {
            // 추가할 수 있는 더 많은 빠른 접근 버튼
            ForEach(features.filter { $0.id <= 4 }, id: \.id) { feature in
                Button(action: {
                    selectedFeature = feature
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showFeatureDetail = true
                    }
                }) {
                    VStack(spacing: 8) {
                        // 아이콘
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: feature.gradientColors),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 50, height: 50)
                                .shadow(color: feature.mainColor.opacity(0.2), radius: 5, x: 0, y: 3)
                            
                            Image(systemName: feature.iconName)
                                .font(.system(size: 20))
                                .foregroundColor(.white)
                        }
                        
                        // 텍스트
                        Text(feature.title.components(separatedBy: " ").first ?? "")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.9))
                            .fixedSize(horizontal: true, vertical: false)
                    }
                    .frame(maxWidth: .infinity)
                }
                .pressEffect()
                .scaleEffect(animateContent ? 1.0 : 0.8)
                .opacity(animateContent ? 1.0 : 0.0)
                .animation(.easeInOut(duration: 0.5).delay(Double(feature.id) * 0.1), value: animateContent)
            }
        }
    }
    
    // MARK: - 추천 AI 기능 섹션
    var featuredSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 섹션 헤더
            Text("추천 AI 기능")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            // 메인 추천 기능 카드
            FeaturedCard(
                feature: features[1],
                onTap: {
                    selectedFeature = features[1]
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                        showFeatureDetail = true
                    }
                }
            )
            .scaleEffect(animateContent ? 1.0 : 0.95)
            .opacity(animateContent ? 1.0 : 0.0)
            .animation(.easeInOut(duration: 0.5).delay(0.2), value: animateContent)
        }
    }
    
    // MARK: - 카테고리별 기능 목록
    var filteredFeaturesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 섹션 헤더
            HStack {
                Text(sectionTitle)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // 모두 보기 버튼
                Button(action: {
                    // 모두 보기 액션
                }) {
                    Text("모두 보기")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.gray)
                }
            }
            
            // 아이템 그리드
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                ForEach(filteredFeatures) { feature in
                    SmallFeatureCard(
                        feature: feature,
                        onTap: {
                            selectedFeature = feature
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showFeatureDetail = true
                            }
                        }
                    )
                    .scaleEffect(animateContent ? 1.0 : 0.9)
                    .opacity(animateContent ? 1.0 : 0.0)
                    .animation(.easeInOut(duration: 0.5).delay(Double(feature.id) * 0.1), value: animateContent)
                }
            }
        }
    }
    
    // MARK: - 검색 결과 뷰
    struct SearchResultsView: View {
        let searchText: String
        let features: [EnhancedCreationFeature]
        let onSelect: (EnhancedCreationFeature) -> Void
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                // 검색 결과 헤더
                Text("'\(searchText)' 검색 결과")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                
                // 결과가 없는 경우
                if features.isEmpty {
                    VStack(spacing: 15) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 36))
                            .foregroundColor(.gray)
                            .padding(.top, 50)
                        
                        Text("검색 결과가 없습니다")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.gray)
                        
                        Text("다른 키워드로 검색해보세요")
                            .font(.system(size: 14))
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 50)
                } else {
                    // 검색 결과 목록
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(features) { feature in
                                SearchResultCard(feature: feature)
                                    .onTapGesture {
                                        onSelect(feature)
                                    }
                                    .padding(.horizontal, 20)
                            }
                        }
                        .padding(.bottom, 80)
                    }
                }
            }
        }
    }
    
    // MARK: - 검색 결과 카드
    struct SearchResultCard: View {
        let feature: EnhancedCreationFeature
        @State private var isPressed = false
        
        var body: some View {
            HStack(spacing: 15) {
                // 아이콘
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: feature.gradientColors),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: feature.iconName)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                }
                
                // 텍스트 정보
                VStack(alignment: .leading, spacing: 4) {
                    Text(feature.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    Text(feature.description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                
                Spacer()
                
                // 카테고리 태그
                Text(feature.category)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(feature.mainColor)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 4)
                    .background(feature.mainColor.opacity(0.15))
                    .cornerRadius(8)
            }
            .padding(12)
            .background(Color.darkBackgroundSecondary.opacity(isPressed ? 0.8 : 0.5))
            .cornerRadius(12)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 50, pressing: { pressing in
                withAnimation {
                    isPressed = pressing
                }
            }, perform: {})
            .pressEffect()
        }
    }
    
    // MARK: - 피처 상세 모달 뷰
    func featureDetailView(feature: EnhancedCreationFeature) -> some View {
        VStack(spacing: 0) {
            // 헤더
            ZStack(alignment: .top) {
                // 배경
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: feature.gradientColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 130)
                
                // 헤더 내용
                VStack(spacing: 8) {
                    HStack {
                        // 닫기 버튼
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                                showFeatureDetail = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                        
                        Spacer()
                        
                        // 공유 버튼
                        Button(action: {
                            // 공유 액션
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.3))
                                .clipShape(Circle())
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    
                    Spacer()
                }
                .frame(height: 130)
            }
            
            // 콘텐츠
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    // 타이틀 및 아이콘 영역
                    HStack(spacing: 16) {
                        // 아이콘
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: feature.gradientColors),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 60, height: 60)
                                .shadow(color: feature.mainColor.opacity(0.2), radius: 10, x: 0, y: 5)
                            
                            Image(systemName: feature.iconName)
                                .font(.system(size: 24))
                                .foregroundColor(.white)
                        }
                        
                        // 타이틀 및 태그
                        VStack(alignment: .leading, spacing: 8) {
                            // 타이틀
                            Text(feature.title)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            // 카테고리 태그
                            HStack(spacing: 8) {
                                Text(feature.category)
                                    .font(.system(size: 11, weight: .medium))
                                    .foregroundColor(feature.mainColor)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(feature.mainColor.opacity(0.15))
                                    .cornerRadius(8)
                                
                                ForEach(feature.tags.prefix(2), id: \.self) { tag in
                                    Text(tag)
                                        .font(.system(size: 11))
                                        .foregroundColor(.gray)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 4)
                                        .background(Color.gray.opacity(0.15))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.top, 5)
                    
                    // 설명
                    VStack(alignment: .leading, spacing: 8) {
                        Text(feature.description)
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(.white)
                            .lineSpacing(4)
                        
                        Text(feature.content)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineSpacing(4)
                            .padding(.top, 5)
                    }
                    
                    // 기능 예시
                    VStack(alignment: .leading, spacing: 12) {
                        Text("이런 것을 만들 수 있어요")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(0..<3) { i in
                                    // 예시 아이템
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 12)
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [
                                                        feature.mainColor.opacity(0.7),
                                                        feature.mainColor.opacity(0.4)
                                                    ]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 150, height: 150)
                                        
                                        VStack(spacing: 10) {
                                            Image(systemName: feature.iconName)
                                                .font(.system(size: 30))
                                                .foregroundColor(.white)
                                            
                                            Text("예시 \(i+1)")
                                                .font(.system(size: 14, weight: .medium))
                                                .foregroundColor(.white)
                                        }
                                    }
                                    .pressEffect()
                                }
                            }
                        }
                    }
                    
                    // 팁과 가이드
                    VStack(alignment: .leading, spacing: 12) {
                        Text("사용 팁")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        // 팁 목록
                        VStack(spacing: 10) {
                            ForEach(1...3, id: \.self) { i in
                                HStack(alignment: .top, spacing: 12) {
                                    // 숫자
                                    ZStack {
                                        Circle()
                                            .fill(Color.darkBackgroundSecondary)
                                            .frame(width: 26, height: 26)
                                        
                                        Text("\(i)")
                                            .font(.system(size: 14, weight: .semibold))
                                            .foregroundColor(feature.mainColor)
                                    }
                                    
                                    // 팁 텍스트
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(getTipTitle(feature: feature, index: i))
                                            .font(.system(size: 14, weight: .medium))
                                            .foregroundColor(.white)
                                        
                                        Text(getTipDescription(feature: feature, index: i))
                                            .font(.system(size: 13))
                                            .foregroundColor(.gray)
                                            .lineSpacing(2)
                                    }
                                    
                                    Spacer()
                                }
                                .padding(12)
                                .background(Color.darkBackgroundSecondary.opacity(0.3))
                                .cornerRadius(12)
                            }
                        }
                    }
                }
                .padding(20)
                .padding(.bottom, 100)
            }
            
            // 하단 버튼 영역
            VStack(spacing: 12) {
                // 메인 액션 버튼
                Button(action: {
                    withAnimation(.spring()) {
                        showFeatureDetail = false
                        
                        // 피처 실행
                        switch feature.id {
                        case 1:
                            showNovelCreation = true
                        case 2:
                            showImageGeneration = true
                        case 3:
                            showVirtualFitting = true
                        default:
                            break
                        }
                    }
                }) {
                    HStack(spacing: 8) {
                        Text("시작하기")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: feature.gradientColors),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(24)
                    .shadow(color: feature.mainColor.opacity(0.3), radius: 10, x: 0, y: 5)
                }
                .pressEffect()
                
                // 튜토리얼 버튼
                Button(action: {
                    // 튜토리얼 보기
                }) {
                    Text("튜토리얼 보기")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.darkBackgroundSecondary)
                        .cornerRadius(24)
                }
                .pressEffect()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                Rectangle()
                    .fill(Color.darkBackground)
                    .shadow(color: Color.black.opacity(0.3), radius: 15, x: 0, y: -5)
            )
        }
        .background(Color.darkBackground)
        .cornerRadius(20)
        .frame(maxWidth: .infinity, maxHeight: UIScreen.main.bounds.height * 0.85)
        .padding(.horizontal, 5)
        .padding(.bottom, 10)
    }
    
    // MARK: - Helper Methods
    
    // 카테고리별 색상
    func categoryColor(for category: String) -> Color {
        switch category {
        case "텍스트":
            return .primaryPurple
        case "이미지":
            return .accentPink
        case "음성":
            return .accentTeal
        case "영상":
            return .primaryBlue
        default:
            return .accentTeal
        }
    }
    
    // 현재 선택된 카테고리에 따른 섹션 타이틀
    var sectionTitle: String {
        switch selectedCategory {
        case 0: return "모든 AI 기능"
        case 1: return "텍스트 관련 기능"
        case 2: return "이미지 관련 기능"
        case 3: return "음성 관련 기능"
        case 4: return "영상 관련 기능"
        default: return "AI 기능"
        }
    }
    
    // 선택된 카테고리에 따른 필터링된 피처
    var filteredFeatures: [EnhancedCreationFeature] {
        if selectedCategory == 0 {
            return features
        } else {
            let category = categories[selectedCategory]
            return features.filter { $0.category == category }
        }
    }
    
    // 검색 결과
    var searchResults: [EnhancedCreationFeature] {
        if searchText.isEmpty {
            return []
        } else {
            let lowercasedQuery = searchText.lowercased()
            return features.filter {
                $0.title.lowercased().contains(lowercasedQuery) ||
                $0.description.lowercased().contains(lowercasedQuery) ||
                $0.category.lowercased().contains(lowercasedQuery) ||
                $0.tags.contains { $0.lowercased().contains(lowercasedQuery) }
            }
        }
    }
    
    // 팁 타이틀
    func getTipTitle(feature: EnhancedCreationFeature, index: Int) -> String {
        switch feature.category {
        case "텍스트":
            return ["키워드 활용하기", "장르 설정하기", "세부 스타일 조정하기"][index-1]
        case "이미지":
            return ["구체적인 프롬프트 작성", "스타일 참조 이미지 활용", "고급 설정 활용하기"][index-1]
        case "음성":
            return ["음색 설정하기", "감정 표현 조절하기", "텍스트 억양 조절하기"][index-1]
        case "영상":
            return ["장면 설명 상세화", "카메라 움직임 설정", "효과 및 전환 지정하기"][index-1]
        default:
            return ["팁 \(index)", "효율적인 사용법", "고급 기능 활용하기"][index-1]
        }
    }
    
    // 팁 설명
    func getTipDescription(feature: EnhancedCreationFeature, index: Int) -> String {
        switch feature.category {
        case "텍스트":
            return [
                "핵심 키워드를 명확하게 입력하여 원하는 주제의 텍스트를 생성할 수 있습니다.",
                "판타지, SF, 로맨스 등 원하는 장르를 지정하면 해당 분위기에 맞는 글이 생성됩니다.",
                "문체, 길이, 톤 등을 세부적으로 조정하여 더 정교한 결과물을 얻을 수 있습니다."
            ][index-1]
        case "이미지":
            return [
                "세부적이고 명확한 프롬프트를 작성할수록 원하는 이미지에 가까운 결과를 얻을 수 있습니다.",
                "참조 이미지를 업로드하여 특정 스타일이나 분위기를 쉽게 적용할 수 있습니다.",
                "해상도, 화풍, 구도 등의 고급 설정을 활용하면 더 정교한 이미지를 생성할 수 있습니다."
            ][index-1]
        case "음성":
            return [
                "다양한 음색 중에서 원하는 특성을 선택하여 목소리 톤을 조절할 수 있습니다.",
                "기쁨, 슬픔, 화남 등 감정 표현을 조절하여 상황에 맞는 음성을 생성할 수 있습니다.",
                "텍스트에 강조 표시를 하여 특정 단어나 문장의 억양을 자연스럽게 조절할 수 있습니다."
            ][index-1]
        case "영상":
            return [
                "장면을 자세히 설명할수록 원하는 화면 구성과 내용을 더 정확하게 생성할 수 있습니다.",
                "줌인, 패닝, 틸트 등의 카메라 움직임을 지정하여 영상에 역동성을 더할 수 있습니다.",
                "특수효과, 장면 전환 방식 등을 지정하여 더 전문적인 영상을 만들 수 있습니다."
            ][index-1]
        default:
            return [
                "이 기능을 효과적으로 활용하기 위한 첫 번째 팁입니다.",
                "중급 사용자를 위한 효율적인 사용법입니다.",
                "고급 기능을 활용하여 더 나은 결과물을 얻을 수 있습니다."
            ][index-1]
        }
    }
    
    // 애니메이션 네임스페이스
    @Namespace private var animation
}

// MARK: - 보조 뷰 구성요소

// 메인 추천 카드
struct FeaturedCard: View {
    let feature: EnhancedCreationFeature
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            ZStack(alignment: .bottomLeading) {
                // 배경
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: feature.gradientColors),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(height: 180)
                
                // 배경 오버레이
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.clear,
                                Color.black.opacity(0.4)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 180)
                
                // 컨텐츠
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    
                    // 아이콘
                    Image(systemName: feature.iconName)
                        .font(.system(size: 28))
                        .foregroundColor(.white)
                        .padding(15)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                    
                    // 텍스트 및 버튼
                    HStack(alignment: .bottom) {
                        // 텍스트
                        VStack(alignment: .leading, spacing: 5) {
                            Text(feature.title)
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(feature.description)
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.9))
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                        
                        // 시작 버튼
                        Image(systemName: "arrow.right.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                }
                .padding(16)
            }
            .shadow(color: feature.mainColor.opacity(0.3), radius: 10, x: 0, y: 5)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 50, pressing: { pressing in
            withAnimation {
                isPressed = pressing
            }
        }, perform: {})
    }
}

// 작은 기능 카드
struct SmallFeatureCard: View {
    let feature: EnhancedCreationFeature
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 12) {
                // 아이콘
                ZStack(alignment: .topLeading) {
                    // 아이콘 배경
                    RoundedRectangle(cornerRadius: 12)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: feature.gradientColors),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 100)
                    
                    // 아이콘
                    Image(systemName: feature.iconName)
                        .font(.system(size: 22))
                        .foregroundColor(.white)
                        .padding(10)
                }
                
                // 텍스트
                VStack(alignment: .leading, spacing: 4) {
                    Text(feature.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(feature.description)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 8)
                .padding(.bottom, 12)
            }
            .background(Color.darkBackgroundSecondary.opacity(0.5))
            .cornerRadius(12)
            .shadow(color: isPressed ? feature.mainColor.opacity(0.2) : Color.clear, radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 50, pressing: { pressing in
            withAnimation {
                isPressed = pressing
            }
        }, perform: {})
    }
}


// MARK: - 피처 카드 뷰
struct FeatureCard: View {
    let feature: EnhancedCreationFeature
    var isActive: Bool
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 10) {
                // 아이콘 헤더
                ZStack(alignment: .topLeading) {
                    // 배경
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: feature.gradientColors),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(height: 120)
                    
                    // 아이콘
                    Image(systemName: feature.iconName)
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.white.opacity(0.2))
                        .clipShape(Circle())
                        .padding(12)
                }
                
                // 텍스트 콘텐츠
                VStack(alignment: .leading, spacing: 6) {
                    Text(feature.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(feature.description)
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 16)
            }
            .background(Color.darkBackgroundSecondary)
            .cornerRadius(16)
            .shadow(color: isPressed ? feature.mainColor.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0.5, maximumDistance: 50, pressing: { pressing in
            withAnimation {
                isPressed = pressing
            }
        }, perform: {})
    }
}


// MARK: - 미리보기
struct EnhancedCreationView_Previews: PreviewProvider {
    static var previews: some View {
        EnhancedCreationView()
            .preferredColorScheme(.dark)
    }
}