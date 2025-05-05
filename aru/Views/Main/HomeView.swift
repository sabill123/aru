import SwiftUI

struct HomeView: View {
    // 탭 바 관련
    @Binding var selectedTab: Int
    
    // 상태 관리
    @State private var selectedCategoryIndex: Int = 0
    @State private var showTrendingFeed = false
    @State private var showCommunityFeed = false
    @State private var showWebNovelCommunity = false
    @State private var selectedCategory = "추천"
    @State private var communityCategory = ""
    
    // 초기화
    init(selectedTab: Binding<Int> = .constant(2)) {
        self._selectedTab = selectedTab
    }
    
    // 애니메이션 상태
    @State private var isRefreshing = false
    @Namespace private var animation
    
    // 카테고리 데이터
    let categories = [
        (title: "추천", icon: "sparkles"),
        (title: "웹소설", icon: "book"),
        (title: "이미지", icon: "photo"),
        (title: "피팅", icon: "tshirt"),
        (title: "트렌드", icon: "chart.line.uptrend.xyaxis")
    ]
    
    // 카테고리별 데이터
    // 추천 카테고리
    let recommendedVideoTitles = ["우주 여행 AI 시뮬레이션", "사이버펑크 도시 AI 투어", "AI 패션쇼 하이라이트", "AI 작곡 뮤직비디오"]
    let recommendedVideoCreators = ["별빛지기", "네온사이버", "패션피플", "음악천재"]
    
    // 웹소설 카테고리
    let novelTitles = ["별들의 전쟁: 우주 전설", "사이버펑크 2077", "판타지 세계의 마법사", "시간의 문"]
    let novelAuthors = ["별빛작가", "네온해커", "마법구슬", "시간여행자"]
    
    // 이미지 카테고리
    let imageTitles = ["네온 도시의 야경", "우주 탐험", "판타지 세계", "미래 패션"]
    let imageCreators = ["도시화가", "별빛사진가", "판타지아트", "트렌드세터"]
    
    // 피팅 카테고리
    let fittingTitles = ["가상 패션쇼", "우주복 컬렉션", "사이버펑크 옷장", "빈티지 미래주의"]
    let fittingCreators = ["패션디자이너", "스페이스패션", "네온스타일", "타임스타일"]
    
    // 트렌드 카테고리
    let trendTitles = ["2025 AI 트렌드", "메타버스의 부상", "디지털 노마드 라이프", "기후 기술의 발전"]
    let trendCreators = ["트렌드분석가", "가상세계연구소", "디지털유목민", "그린테크"]
    
    var body: some View {
        ZStack {
            // 메인 홈 화면
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // 헤더 - 스크롤 시 고정
                    HomeHeaderView(username: "민지")
                        .background(Color.darkBackground)
                        .zIndex(1)
                    
                    // 카테고리 스크롤
                    CategoryScrollView(
                        categories: categories,
                        selectedCategoryIndex: $selectedCategoryIndex
                    )
                    .onChange(of: selectedCategoryIndex) { oldValue, newValue in
                        // 카테고리가 변경되면 카테고리 이름 업데이트
                        selectedCategory = categories[newValue].title
                        
                        // 카테고리 변경 시 향상된 애니메이션 효과
                        withAnimation(.spring(response: 0.35, dampingFraction: 0.65)) {
                            isRefreshing = true
                        }
                        
                        // 약간의 딜레이 후 애니메이션 종료 (자연스러운 전환을 위해 타이밍 조정)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                                isRefreshing = false
                            }
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("categoryChanged"))) { notification in
                        if let index = notification.userInfo?["index"] as? Int {
                            selectedCategoryIndex = index
                        }
                    }
                    
                    // 카테고리별 콘텐츠 표시
                    Group {
                        // NOVA 트렌딩 비디오 섹션
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeaderView(
                                title: "\(categoryTitle()) 트렌딩 비디오",
                                icon: "film",
                                iconColor: Color.accentPink,
                                showMoreAction: {
                                    communityCategory = categoryTitle()
                                    if categoryTitle() == "웹소설" {
                                        showWebNovelCommunity = true
                                    } else {
                                        showCommunityFeed = true
                                    }
                                }
                            )
                            
                            VideoGridView(
                                titles: videoTitlesByCategory(),
                                creators: videoCreatorsByCategory(),
                                onSeeMoreTapped: {
                                    communityCategory = categoryTitle()
                                    if categoryTitle() == "웹소설" {
                                        showWebNovelCommunity = true
                                    } else {
                                        showCommunityFeed = true
                                    }
                                }
                            )
                            .scaleEffect(isRefreshing ? 0.96 : 1.0)
                            .opacity(isRefreshing ? 0.7 : 1.0)
                            .blur(radius: isRefreshing ? 2 : 0)
                            .offset(y: isRefreshing ? 10 : 0)
                        }
                        
                        // 카테고리별 추천 섹션
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeaderView(
                                title: "\(selectedCategory) 추천 콘텐츠",
                                icon: categoryIcon(),
                                iconColor: categoryColor(),
                                showMoreAction: {
                                    communityCategory = selectedCategory
                                    if selectedCategory == "웹소설" {
                                        showWebNovelCommunity = true
                                    } else {
                                        showCommunityFeed = true
                                    }
                                }
                            )
                            
                            CategoryContentView(
                                category: selectedCategory,
                                onItemTap: {
                                    communityCategory = selectedCategory
                                    if selectedCategory == "웹소설" {
                                        showWebNovelCommunity = true
                                    } else {
                                        showCommunityFeed = true
                                    }
                                }
                            )
                            .scaleEffect(isRefreshing ? 0.96 : 1.0)
                            .opacity(isRefreshing ? 0.7 : 1.0)
                            .blur(radius: isRefreshing ? 2 : 0)
                            .offset(y: isRefreshing ? 10 : 0)
                        }
                        
                        // 오늘의 창작 영감 (모든 카테고리에 표시)
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeaderView(
                                title: "오늘의 창작 영감",
                                icon: "sparkles",
                                iconColor: Color.accentTeal
                            )
                            
                            VStack {
                                InspirationCard()
                                
                                Button {
                                    // 영감 더보기 액션 - 창작 영감 페이지로 이동
                                    selectedTab = 1  // 창작 탭으로 이동
                                    NotificationCenter.default.post(name: NSNotification.Name("showInspirations"), object: nil)
                                } label: {
                                    Text("영감 더 보기")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.accentTeal)
                                        .padding(.vertical, 8)
                                        .padding(.horizontal, 20)
                                        .background(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(Color.accentTeal, lineWidth: 1.5)
                                        )
                                }
                                .pressEffect()
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 12)
                            }
                            .scaleEffect(isRefreshing ? 0.96 : 1.0)
                            .opacity(isRefreshing ? 0.7 : 1.0)
                            .blur(radius: isRefreshing ? 2 : 0)
                            .offset(y: isRefreshing ? 10 : 0)
                        }
                    }
                    .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedCategoryIndex)
                    
                    Spacer()
                        .frame(height: 80) // 탭바 공간
                }
            }
            .background(Color.darkBackground)
            .fullScreenCover(isPresented: $showTrendingFeed) {
                TrendingFeedView(category: selectedCategory)
            }
            .fullScreenCover(isPresented: $showCommunityFeed) {
                CommunityFeedView(category: communityCategory)
            }
            .fullScreenCover(isPresented: $showWebNovelCommunity) {
                WebNovelCommunityView()
            }
        }
    }
    
    // 선택된 카테고리에 따른 타이틀 반환
    private func categoryTitle() -> String {
        return categories[selectedCategoryIndex].title
    }
    
    // 선택된 카테고리에 따른 아이콘 반환
    private func categoryIcon() -> String {
        return categories[selectedCategoryIndex].icon
    }
    
    // 선택된 카테고리에 따른 색상 반환
    private func categoryColor() -> Color {
        switch selectedCategoryIndex {
        case 0: return Color.accentTeal
        case 1: return Color.primaryPurple
        case 2: return Color.accentPink
        case 3: return Color.accentYellow
        case 4: return Color.primaryBlue
        default: return Color.accentTeal
        }
    }
    
    // 선택된 카테고리에 따른 비디오 타이틀 반환
    private func videoTitlesByCategory() -> [String] {
        switch selectedCategoryIndex {
        case 0: return recommendedVideoTitles
        case 1: return novelTitles
        case 2: return imageTitles
        case 3: return fittingTitles
        case 4: return trendTitles
        default: return recommendedVideoTitles
        }
    }
    
    // 선택된 카테고리에 따른 비디오 크리에이터 반환
    private func videoCreatorsByCategory() -> [String] {
        switch selectedCategoryIndex {
        case 0: return recommendedVideoCreators
        case 1: return novelAuthors
        case 2: return imageCreators
        case 3: return fittingCreators
        case 4: return trendCreators
        default: return recommendedVideoCreators
        }
    }
}

// 카테고리별 콘텐츠 뷰
struct CategoryContentView: View {
    let category: String
    let onItemTap: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                // 카테고리별 콘텐츠 표시
                ForEach(0..<4) { index in
                    CategoryItemView(
                        category: category,
                        index: index,
                        onTap: onItemTap
                    )
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
}

// 카테고리 아이템 뷰
struct CategoryItemView: View {
    let category: String
    let index: Int
    let onTap: () -> Void
    
    // 샘플 이미지 및 제목
    var itemTitle: String {
        switch category {
        case "추천":
            let titles = ["AI가 그린 우주", "내면의 여행", "미래 도시", "꿈속의 세계"]
            return titles[index % titles.count]
        case "웹소설":
            let titles = ["별자리 전설", "마법의 성", "로봇의 꿈", "시간 여행자"]
            return titles[index % titles.count]
        case "이미지":
            let titles = ["네온 풍경", "초현실 초상화", "미래 건축물", "감정의 색채"]
            return titles[index % titles.count]
        case "피팅":
            let titles = ["우주복 컬렉션", "사이버펑크 룩", "미니멀 퓨처", "홀로그램 액세서리"]
            return titles[index % titles.count]
        case "트렌드":
            let titles = ["AI 인플루언서", "가상 현실 여행", "바이오테크", "스마트 홈"]
            return titles[index % titles.count]
        default:
            return "콘텐츠 \(index + 1)"
        }
    }
    
    // 카테고리에 따른 색상
    var itemColor: Color {
        switch category {
        case "추천": return [Color.accentTeal, Color.primaryPurple, Color.accentPink, Color.accentYellow][index % 4]
        case "웹소설": return [Color.primaryPurple, Color.primaryPurple.opacity(0.8), Color.primaryBlue, Color.primaryBlue.opacity(0.8)][index % 4]
        case "이미지": return [Color.accentPink, Color.accentPink.opacity(0.8), Color.accentTeal, Color.accentTeal.opacity(0.8)][index % 4]
        case "피팅": return [Color.accentYellow, Color.accentYellow.opacity(0.8), Color.accentPink, Color.accentPink.opacity(0.8)][index % 4]
        case "트렌드": return [Color.primaryBlue, Color.primaryBlue.opacity(0.8), Color.primaryPurple, Color.primaryPurple.opacity(0.8)][index % 4]
        default: return Color.accentTeal
        }
    }
    
    // 카테고리에 따른 아이콘
    var itemIcon: String {
        switch category {
        case "추천": return "sparkles"
        case "웹소설": return "book.fill"
        case "이미지": return "photo.fill"
        case "피팅": return "tshirt.fill"
        case "트렌드": return "chart.line.uptrend.xyaxis"
        default: return "sparkles"
        }
    }
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // 콘텐츠 이미지
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [itemColor, itemColor.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 150, height: 150)
                    
                    // 카테고리 아이콘
                    VStack(spacing: 10) {
                        Image(systemName: itemIcon)
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                        
                        Text(itemTitle)
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 10)
                    }
                }
                
                // 아이템 정보
                VStack(alignment: .leading, spacing: 4) {
                    Text(itemTitle)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text("\(1500 + index * 500)명이 좋아합니다")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .padding(.horizontal, 4)
            }
            .frame(width: 150)
        }
        .buttonStyle(PlainButtonStyle())
    }
}