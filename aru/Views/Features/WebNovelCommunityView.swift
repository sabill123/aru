import SwiftUI

struct WebNovelCommunityView: View {
    // 상태 변수
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedCategory = "추천"
    @State private var showNovelDetail = false
    @State private var selectedNovel: NovelItem? = nil
    @State private var isLoading = true
    
    // 카테고리
    let categories = ["추천", "판타지", "로맨스", "SF", "미스터리", "호러", "역사"]
    
    // 넷플릭스 스타일 - 카테고리별 추천 모음
    let featuredCollections = [
        "새로운 인기 웹소설",
        "지금 가장 인기있는 작품",
        "이번 주 추천 작품",
        "판타지 인기작",
        "로맨스 베스트",
        "완결 명작",
        "SF 스릴러"
    ]
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 상단 헤더
                headerView
                    .padding(.horizontal)
                    .padding(.top, 10)
                    .padding(.bottom, 10)
                
                // 카테고리 선택
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(categories, id: \.self) { category in
                            Button(action: {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                    selectedCategory = category
                                }
                            }) {
                                Text(category)
                                    .font(.system(size: 14, weight: selectedCategory == category ? .bold : .medium))
                                    .foregroundColor(selectedCategory == category ? .white : .gray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(selectedCategory == category ? 
                                                  Color.primaryPurple : Color.darkBackgroundSecondary)
                                    )
                            }
                            .pressEffect()
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                }
                
                if isLoading {
                    // 로딩 화면
                    loadingView
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .onAppear {
                            // 로딩 상태 시뮬레이션
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                withAnimation {
                                    isLoading = false
                                }
                            }
                        }
                } else {
                    // 넷플릭스 스타일 스크롤 뷰
                    ScrollView {
                        VStack(spacing: 24) {
                            // 메인 추천 배너
                            featuredNovelBanner
                                .padding(.bottom, 10)
                            
                            // 카테고리별 컬렉션
                            ForEach(Array(featuredCollections.enumerated()), id: \.offset) { index, title in
                                NovelCollectionView(
                                    title: title,
                                    novels: generateNovels(for: index),
                                    onNovelTap: { novel in
                                        selectedNovel = novel
                                        showNovelDetail = true
                                    }
                                )
                            }
                            
                            // 하단 여백
                            Spacer()
                                .frame(height: 100)
                        }
                    }
                }
            }
        }
        .sheet(isPresented: $showNovelDetail) {
            if let novel = selectedNovel {
                NovelDetailView(novel: novel)
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
            
            // 타이틀
            Text("웹소설 커뮤니티")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            // 검색 버튼
            Button(action: {
                // 검색 기능
            }) {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.darkBackgroundSecondary)
                    .clipShape(Circle())
            }
            .pressEffect()
        }
    }
    
    // 로딩 뷰
    var loadingView: some View {
        VStack(spacing: 20) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color.primaryPurple))
                .scaleEffect(1.5)
            
            Text("웹소설을 불러오는 중...")
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
    }
    
    // 메인 추천 배너
    var featuredNovelBanner: some View {
        ZStack(alignment: .bottomLeading) {
            // 배경 이미지
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.primaryPurple, Color.primaryPurple.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(height: 220)
                .cornerRadius(12)
            
            // 텍스트 오버레이와 그라디언트
            VStack(alignment: .leading, spacing: 8) {
                // 태그
                Text("이 달의 추천")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.accentPink)
                    .cornerRadius(8)
                
                Spacer().frame(height: 8)
                
                // 타이틀
                Text("별들의 전쟁: 우주 전설")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                // 설명
                Text("은하계의 운명이 소년의 손에 달렸다")
                    .font(.system(size: 16))
                    .foregroundColor(.white.opacity(0.8))
                
                // 정보
                HStack(spacing: 12) {
                    // 평점
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 12))
                            .foregroundColor(.yellow)
                        
                        Text("4.9")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white)
                    }
                    
                    // 구분자
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 4, height: 4)
                    
                    // 작가
                    Text("별빛작가")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                    
                    // 구분자
                    Circle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 4, height: 4)
                    
                    // 장르
                    Text("SF 판타지")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                }
                
                Spacer().frame(height: 12)
                
                // 버튼
                HStack(spacing: 12) {
                    // 읽기 버튼
                    Button(action: {
                        // 읽기 액션
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "book.fill")
                                .font(.system(size: 12))
                            
                            Text("읽기")
                                .font(.system(size: 14, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color.accentPink)
                        .cornerRadius(8)
                    }
                    .pressEffect()
                    
                    // 상세 버튼
                    Button(action: {
                        // 상세 정보 액션
                        let featuredNovel = NovelItem(
                            id: 0,
                            title: "별들의 전쟁: 우주 전설",
                            author: "별빛작가",
                            coverColor: Color.primaryPurple,
                            rating: 4.9,
                            genres: ["SF", "판타지", "액션"],
                            description: "은하계의 운명이 소년의 손에 달렸다. 우주를 위협하는 어둠의 세력에 맞서 싸우는 영웅들의 이야기."
                        )
                        selectedNovel = featuredNovel
                        showNovelDetail = true
                    }) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.3))
                            .clipShape(Circle())
                    }
                    .pressEffect()
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                // 텍스트 가독성을 위한 그라디언트 오버레이
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color.black.opacity(0.7),
                        Color.black.opacity(0.3),
                        Color.clear
                    ]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
        }
        .padding(.horizontal)
        .shadow(color: Color.primaryPurple.opacity(0.3), radius: 10, x: 0, y: 5)
    }
    
    // MARK: - 헬퍼 함수
    
    // 웹소설 데이터 생성
    func generateNovels(for categoryIndex: Int) -> [NovelItem] {
        let colors: [Color] = [
            .primaryPurple, .accentPink, .accentTeal, .primaryBlue, .accentYellow
        ]
        
        var result: [NovelItem] = []
        
        // 카테고리에 맞는 웹소설 데이터 생성
        let titles = getNovelTitles(for: categoryIndex)
        let authors = getNovelAuthors(for: categoryIndex)
        
        for i in 0..<min(titles.count, 8) {
            let novel = NovelItem(
                id: categoryIndex * 100 + i,
                title: titles[i],
                author: authors[i % authors.count],
                coverColor: colors[i % colors.count],
                rating: 4.0 + Double(i % 10) / 10.0,
                genres: getRandomGenres(),
                description: "메타버스 시대의 새로운 판타지 웹소설. 현실과 가상의 경계에서 펼쳐지는 대모험."
            )
            result.append(novel)
        }
        
        return result
    }
    
    // 카테고리별 웹소설 타이틀
    func getNovelTitles(for categoryIndex: Int) -> [String] {
        switch categoryIndex {
        case 0:
            return ["별들의 전쟁", "마법사의 시간", "네온 도시", "황혼의 기사", "사이버 판타지", "얼음과 불의 노래", "로봇의 꿈", "미궁의 공주"]
        case 1:
            return ["세계수의 미스터리", "이세계 모험", "천공의 성", "사이버펑크 2077", "메타버스 대전", "암흑 기사", "시간여행자", "용의 자손"]
        case 2:
            return ["그녀의 비밀일기", "첫사랑의 추억", "운명의 만남", "비밀의 화원", "로맨틱 판타지", "별빛 아래서", "두 번째 기회", "천년의 사랑"]
        case 3:
            return ["우주로 가는 기차", "로봇의 시간", "화성의 왕자", "행성 X의 비밀", "은하수 여행자", "안드로이드의 꿈", "타임머신", "우주 전사"]
        case 4:
            return ["살인자의 흔적", "그림자 탐정", "밤의 방문자", "비밀의 문", "심야의 전화", "고요한 섬", "미스터리 하우스", "사라진 기억"]
        case 5:
            return ["공포의 관", "악몽의 집", "어둠의 속삭임", "공포 호텔", "해골 기사", "저주받은 인형", "죽음의 미로", "그림자 속의 눈"]
        case 6:
            return ["조선의 검", "로마의 영광", "삼국지 영웅들", "바이킹의 복수", "이집트의 왕", "아테네의 신", "무사도", "고대 왕국"]
        default:
            return ["별들의 전쟁", "마법사의 시간", "네온 도시", "황혼의 기사", "사이버 판타지", "얼음과 불의 노래", "로봇의 꿈", "미궁의 공주"]
        }
    }
    
    // 카테고리별 작가
    func getNovelAuthors(for categoryIndex: Int) -> [String] {
        switch categoryIndex {
        case 0:
            return ["별빛작가", "시간마법사", "네온펜", "황혼기사", "사이버작가"]
        case 1:
            return ["판타지킹", "이세계여행자", "천공의신", "사이버펑크", "메타버스작가"]
        case 2:
            return ["로맨스퀸", "첫사랑", "운명의글", "비밀의정원", "별빛로맨스"]
        case 3:
            return ["우주작가", "로봇마스터", "행성X", "은하수", "타임머신"]
        case 4:
            return ["미스터리헌터", "그림자", "밤의작가", "비밀키퍼", "탐정물"]
        case 5:
            return ["호러마스터", "악몽", "공포작가", "저주받은펜", "그림자글"]
        case 6:
            return ["역사학자", "고대문명", "시간여행자", "왕국의펜", "역사소설가"]
        default:
            return ["별빛작가", "시간마법사", "네온펜", "황혼기사", "사이버작가"]
        }
    }
    
    // 랜덤 장르 선택
    func getRandomGenres() -> [String] {
        let allGenres = ["판타지", "SF", "로맨스", "미스터리", "액션", "모험", "호러", "역사", "드라마"]
        var selectedGenres: [String] = []
        
        // 2-3개의 장르 랜덤 선택
        let count = Int.random(in: 2...3)
        for _ in 0..<count {
            if let genre = allGenres.randomElement(), !selectedGenres.contains(genre) {
                selectedGenres.append(genre)
            }
        }
        
        return selectedGenres.isEmpty ? ["판타지"] : selectedGenres
    }
}

// MARK: - 데이터 모델

struct NovelItem: Identifiable {
    let id: Int
    let title: String
    let author: String
    let coverColor: Color
    let rating: Double
    let genres: [String]
    let description: String
}

// MARK: - 컬렉션 뷰 컴포넌트

struct NovelCollectionView: View {
    let title: String
    let novels: [NovelItem]
    let onNovelTap: (NovelItem) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // 섹션 제목
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal)
            
            // 가로 스크롤 소설 목록
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    ForEach(novels) { novel in
                        NovelCard(novel: novel)
                            .onTapGesture {
                                onNovelTap(novel)
                            }
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 5)
            }
        }
    }
}

// MARK: - 소설 카드 컴포넌트

struct NovelCard: View {
    let novel: NovelItem
    @State private var isPressed = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 소설 커버
            ZStack(alignment: .bottomLeading) {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                novel.coverColor,
                                novel.coverColor.opacity(0.7)
                            ]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 120, height: 180)
                    .cornerRadius(8)
                    .shadow(color: novel.coverColor.opacity(0.3), radius: 5, x: 0, y: 3)
                
                // 텍스트 오버레이 (소설 제목)
                VStack(alignment: .leading, spacing: 4) {
                    // 평점
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                        
                        Text(String(format: "%.1f", novel.rating))
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.white)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(4)
                }
                .padding(8)
            }
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isPressed)
            
            // 제목
            Text(novel.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
                .frame(width: 120, alignment: .leading)
            
            // 작가
            Text(novel.author)
                .font(.system(size: 11))
                .foregroundColor(.gray)
                .lineLimit(1)
                .frame(width: 120, alignment: .leading)
        }
        .pressEffect()
    }
}

// MARK: - 소설 상세 뷰

struct NovelDetailView: View {
    let novel: NovelItem
    @Environment(\.presentationMode) var presentationMode
    @State private var showFullDescription = false
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // 소설 커버와 정보
                    HStack(alignment: .top, spacing: 20) {
                        // 커버
                        ZStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [
                                            novel.coverColor,
                                            novel.coverColor.opacity(0.7)
                                        ]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 140, height: 200)
                                .cornerRadius(10)
                                .shadow(color: novel.coverColor.opacity(0.3), radius: 10, x: 0, y: 5)
                        }
                        
                        // 정보
                        VStack(alignment: .leading, spacing: 8) {
                            Text(novel.title)
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(novel.author)
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                            
                            // 평점
                            HStack(spacing: 5) {
                                ForEach(0..<5) { i in
                                    Image(systemName: i < Int(novel.rating) ? "star.fill" : (novel.rating - Double(i) >= 0.5 ? "star.leadinghalf.fill" : "star"))
                                        .font(.system(size: 14))
                                        .foregroundColor(.yellow)
                                }
                                
                                Text(String(format: "%.1f", novel.rating))
                                    .font(.system(size: 14, weight: .medium))
                                    .foregroundColor(.white)
                                    .padding(.leading, 5)
                            }
                            
                            // 장르 태그
                            HStack {
                                ForEach(novel.genres, id: \.self) { genre in
                                    Text(genre)
                                        .font(.system(size: 12))
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 5)
                                        .background(Color.darkBackgroundSecondary)
                                        .cornerRadius(5)
                                        .foregroundColor(.white)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // 버튼 행동
                    HStack(spacing: 15) {
                        // 읽기 버튼
                        Button(action: {
                            // 읽기 액션
                        }) {
                            HStack {
                                Image(systemName: "book.fill")
                                    .font(.system(size: 14))
                                Text("읽기")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.accentPink)
                            )
                        }
                        .pressEffect()
                        
                        // 저장 버튼
                        Button(action: {
                            // 저장 액션
                        }) {
                            HStack {
                                Image(systemName: "bookmark")
                                    .font(.system(size: 14))
                                Text("저장")
                                    .font(.system(size: 16, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.darkBackgroundSecondary)
                            )
                        }
                        .pressEffect()
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(Color.darkBackgroundSecondary)
                        .padding(.vertical, 10)
                    
                    // 소설 설명
                    VStack(alignment: .leading, spacing: 10) {
                        Text("소개")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        Text(novel.description + (showFullDescription ? 
                            " 인간과 AI가 공존하는 미래 사회에서 펼쳐지는 모험. 주인공은 특별한 능력을 가졌지만 그것이 축복인지 저주인지 아직 알지 못한다. 미지의 세계를 탐험하며 자신의 정체성을 찾아가는 여정이 시작된다." : ""))
                            .font(.system(size: 14))
                            .foregroundColor(.white.opacity(0.8))
                            .lineSpacing(4)
                            .animation(.spring(), value: showFullDescription)
                        
                        Button(action: {
                            showFullDescription.toggle()
                        }) {
                            Text(showFullDescription ? "접기" : "더 보기")
                                .font(.system(size: 14))
                                .foregroundColor(Color.accentPink)
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider()
                        .background(Color.darkBackgroundSecondary)
                        .padding(.vertical, 10)
                    
                    // 비슷한 작품 추천
                    VStack(alignment: .leading, spacing: 10) {
                        Text("비슷한 작품")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 15) {
                                ForEach(0..<5) { i in
                                    RelatedNovelCard(
                                        title: getRelatedTitle(i),
                                        author: getRelatedAuthor(i),
                                        color: getRelatedColor(i)
                                    )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    
                    // 댓글 및 평가 섹션
                    VStack(alignment: .leading, spacing: 15) {
                        Text("댓글 및 평가")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.white)
                        
                        // 평점 요약
                        HStack(spacing: 20) {
                            // 전체 평점
                            VStack(spacing: 5) {
                                Text(String(format: "%.1f", novel.rating))
                                    .font(.system(size: 36, weight: .bold))
                                    .foregroundColor(.white)
                                
                                // 별점
                                HStack(spacing: 2) {
                                    ForEach(0..<5) { i in
                                        Image(systemName: i < Int(novel.rating) ? "star.fill" : (novel.rating - Double(i) >= 0.5 ? "star.leadinghalf.fill" : "star"))
                                            .font(.system(size: 12))
                                            .foregroundColor(.yellow)
                                    }
                                }
                                
                                Text("823개의 평가")
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }
                            
                            // 평점 분포
                            VStack(spacing: 5) {
                                ForEach((1...5).reversed(), id: \.self) { rating in
                                    HStack(spacing: 5) {
                                        Text("\(rating)")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                            .frame(width: 10)
                                        
                                        // 분포 바
                                        ZStack(alignment: .leading) {
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.darkBackgroundSecondary)
                                                .frame(width: 150, height: 6)
                                            
                                            RoundedRectangle(cornerRadius: 2)
                                                .fill(Color.yellow)
                                                .frame(width: getRatingWidth(rating), height: 6)
                                        }
                                        
                                        Text("\(getRatingPercentage(rating))%")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                            .frame(width: 30)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        
                        // 댓글 목록
                        VStack(spacing: 15) {
                            ForEach(0..<3) { i in
                                CommentView(
                                    username: ["독서광", "책벌레", "물망초"][i],
                                    rating: 5 - (i % 2),
                                    comment: ["정말 재미있게 읽었어요! 특히 주인공의 성장과정이 공감됩니다.", 
                                            "처음엔 좀 지루했지만 뒤로 갈수록 흡입력이 대단해요.", 
                                            "작가의 세계관 구축 능력이 뛰어납니다. 다음 작품도 기대해요!"][i],
                                    time: ["\(2 * (i+1))일 전", "1주일 전", "2주일 전"][i]
                                )
                                
                                if i < 2 {
                                    Divider()
                                        .background(Color.darkBackgroundSecondary)
                                }
                            }
                            
                            // 더보기 버튼
                            Button(action: {
                                // 모든 댓글 보기
                            }) {
                                Text("댓글 모두 보기")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color.accentPink)
                                    .padding(.vertical, 10)
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 10)
                    
                    // 하단 여백
                    Spacer()
                        .frame(height: 30)
                }
                .padding(.top, 20)
            }
            
            // 닫기 버튼
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(12)
                            .background(Color.black.opacity(0.6))
                            .clipShape(Circle())
                    }
                    .pressEffect()
                    
                    Spacer()
                }
                Spacer()
            }
            .padding()
        }
    }
    
    // MARK: - 헬퍼 함수
    
    // 유사 작품 타이틀
    func getRelatedTitle(_ index: Int) -> String {
        let titles = ["마법의 성", "로봇의 꿈", "시간여행자", "별빛 아래서", "은하계의 비밀"]
        return titles[index % titles.count]
    }
    
    // 유사 작품 작가
    func getRelatedAuthor(_ index: Int) -> String {
        let authors = ["마법사", "로봇킹", "시간여행자", "별빛작가", "은하수"]
        return authors[index % authors.count]
    }
    
    // 유사 작품 색상
    func getRelatedColor(_ index: Int) -> Color {
        let colors: [Color] = [.primaryPurple, .accentPink, .accentTeal, .primaryBlue, .accentYellow]
        return colors[index % colors.count]
    }
    
    // 평점 분포 너비 계산
    func getRatingWidth(_ rating: Int) -> CGFloat {
        let percentages = [5: 75.0, 4: 45.0, 3: 30.0, 2: 15.0, 1: 5.0]
        return 150 * (percentages[rating] ?? 0) / 100.0
    }
    
    // 평점 분포 퍼센트 계산
    func getRatingPercentage(_ rating: Int) -> Int {
        let percentages = [5: 75, 4: 45, 3: 30, 2: 15, 1: 5]
        return percentages[rating] ?? 0
    }
}

// 관련 소설 카드
struct RelatedNovelCard: View {
    let title: String
    let author: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // 커버
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [color, color.opacity(0.7)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 100, height: 150)
                .cornerRadius(8)
                .shadow(color: color.opacity(0.2), radius: 5, x: 0, y: 3)
            
            // 정보
            Text(title)
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(author)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: 100)
        .pressEffect()
    }
}

// 댓글 컴포넌트
struct CommentView: View {
    let username: String
    let rating: Int
    let comment: String
    let time: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                // 프로필과 이름
                HStack(spacing: 8) {
                    Circle()
                        .fill(Color.darkBackgroundSecondary)
                        .frame(width: 32, height: 32)
                        .overlay(
                            Text(String(username.prefix(1)))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                        )
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(username)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Text(time)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                // 평점
                HStack(spacing: 2) {
                    ForEach(0..<rating, id: \.self) { _ in
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                    }
                    
                    ForEach(0..<(5-rating), id: \.self) { _ in
                        Image(systemName: "star")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                    }
                }
            }
            
            // 댓글 내용
            Text(comment)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.9))
                .lineSpacing(3)
            
            // 좋아요/답글 버튼
            HStack(spacing: 15) {
                Button(action: {
                    // 좋아요
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "hand.thumbsup")
                            .font(.system(size: 12))
                        
                        Text("좋아요")
                            .font(.system(size: 12))
                    }
                    .foregroundColor(.gray)
                }
                
                Button(action: {
                    // 답글
                }) {
                    Text("답글 달기")
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            }
        }
    }
}