import SwiftUI

struct TrendingFeedView: View {
    // 상태 변수
    @Environment(\.presentationMode) var presentationMode
    @State private var currentPage = 0
    @State private var showDetails = false
    @State private var selectedContent: TrendingContent? = nil
    @State private var offset = CGSize.zero
    @State private var isLiked = [Bool](repeating: false, count: 10)
    
    // 카테고리
    let category: String
    
    // 가상 데이터
    let contents: [TrendingContent]
    
    // 초기화
    init(category: String) {
        self.category = category
        
        // 카테고리별 다른 콘텐츠 표시
        switch category {
        case "웹소설":
            self.contents = [
                TrendingContent(id: 1, title: "별들의 전쟁: 우주 전설", creator: "별빛작가", description: "우주를 배경으로 펼쳐지는 서사시적 모험", type: "웹소설", color: Color.primaryPurple, likes: 2845, views: 12200, comments: 342),
                TrendingContent(id: 2, title: "사이버펑크 2077: 네온의 미래", creator: "네온해커", description: "디스토피아 미래에서 싸우는 해커의 이야기", type: "웹소설", color: Color.accentPink, likes: 1532, views: 8954, comments: 213),
                TrendingContent(id: 3, title: "판타지 세계의 마법사", creator: "마법구슬", description: "마법의 세계를 탐험하는 청년의 성장기", type: "웹소설", color: Color.accentTeal, likes: 1988, views: 9872, comments: 287),
                TrendingContent(id: 4, title: "시간의 문", creator: "시간여행자", description: "시간여행을 통해 과거를 바꾸려는 여행자의 모험", type: "웹소설", color: Color.primaryBlue, likes: 2104, views: 10521, comments: 301),
                TrendingContent(id: 5, title: "안드로이드의 꿈", creator: "AI작가", description: "인공지능이 인간이 되려는 과정을 담은 SF소설", type: "웹소설", color: Color.accentYellow, likes: 1656, views: 7890, comments: 198)
            ]
        case "이미지":
            self.contents = [
                TrendingContent(id: 1, title: "네온 도시의 야경", creator: "도시화가", description: "미래 도시의 아름다운 야경을 담은 이미지", type: "이미지", color: Color.accentPink, likes: 3421, views: 15670, comments: 423),
                TrendingContent(id: 2, title: "우주 탐험", creator: "별빛사진가", description: "미지의 행성을 탐험하는 우주비행사", type: "이미지", color: Color.primaryPurple, likes: 2987, views: 13240, comments: 375),
                TrendingContent(id: 3, title: "판타지 세계", creator: "판타지아트", description: "마법과 모험이 가득한 판타지 세계", type: "이미지", color: Color.accentTeal, likes: 2543, views: 11980, comments: 312),
                TrendingContent(id: 4, title: "미래 패션", creator: "트렌드세터", description: "2050년 미래의 패션 트렌드를 예측한 이미지", type: "이미지", color: Color.primaryBlue, likes: 2198, views: 9875, comments: 287),
                TrendingContent(id: 5, title: "사이버펑크 캐릭터", creator: "사이버디자이너", description: "디스토피아 미래의 강인한 캐릭터들", type: "이미지", color: Color.accentYellow, likes: 1876, views: 8950, comments: 243)
            ]
        case "피팅":
            self.contents = [
                TrendingContent(id: 1, title: "가상 패션쇼", creator: "패션디자이너", description: "AI로 생성된 미래 패션을 입은 가상 모델", type: "피팅", color: Color.accentPink, likes: 4210, views: 18750, comments: 532),
                TrendingContent(id: 2, title: "우주복 컬렉션", creator: "스페이스패션", description: "우주 여행을 위한 스타일리시한 우주복", type: "피팅", color: Color.primaryPurple, likes: 3654, views: 16430, comments: 478),
                TrendingContent(id: 3, title: "사이버펑크 옷장", creator: "네온스타일", description: "네온과 가죽이 특징인 미래적 패션", type: "피팅", color: Color.accentTeal, likes: 3287, views: 14320, comments: 421),
                TrendingContent(id: 4, title: "빈티지 미래주의", creator: "타임스타일", description: "레트로와 미래가 결합된 독특한 패션", type: "피팅", color: Color.primaryBlue, likes: 2954, views: 12870, comments: 367),
                TrendingContent(id: 5, title: "홀로그램 액세서리", creator: "디지털패션", description: "홀로그램 효과가 있는 미래적 액세서리", type: "피팅", color: Color.accentYellow, likes: 2631, views: 11540, comments: 321)
            ]
        case "트렌드":
            self.contents = [
                TrendingContent(id: 1, title: "2025 AI 트렌드", creator: "트렌드분석가", description: "인공지능 기술의 미래를 예측한 분석", type: "트렌드", color: Color.primaryPurple, likes: 3876, views: 17650, comments: 498),
                TrendingContent(id: 2, title: "메타버스의 부상", creator: "가상세계연구소", description: "가상 세계가 현실에 미치는 영향", type: "트렌드", color: Color.accentPink, likes: 3421, views: 15320, comments: 432),
                TrendingContent(id: 3, title: "디지털 노마드 라이프", creator: "디지털유목민", description: "기술로 가능해진 새로운 라이프스타일", type: "트렌드", color: Color.accentTeal, likes: 3098, views: 14210, comments: 387),
                TrendingContent(id: 4, title: "기후 기술의 발전", creator: "그린테크", description: "기후 변화 대응을 위한 혁신적 기술들", type: "트렌드", color: Color.primaryBlue, likes: 2756, views: 12870, comments: 342),
                TrendingContent(id: 5, title: "양자 컴퓨팅의 시대", creator: "양자과학자", description: "양자 컴퓨팅이 가져올 혁명적 변화", type: "트렌드", color: Color.accentYellow, likes: 2487, views: 11320, comments: 298)
            ]
        default: // 추천 카테고리
            self.contents = [
                TrendingContent(id: 1, title: "우주 여행: 화성 탐험", creator: "별빛지기", description: "AI로 구현한 화성 탐험 가상 경험", type: "영상", color: Color.primaryPurple, likes: 5421, views: 23450, comments: 642),
                TrendingContent(id: 2, title: "네온 도시의 야경", creator: "네온사이버", description: "사이버펑크 도시의 화려한 야경", type: "이미지", color: Color.accentPink, likes: 4987, views: 21340, comments: 587),
                TrendingContent(id: 3, title: "미래 패션쇼", creator: "패션피플", description: "AI가 디자인한 미래 패션 컬렉션", type: "피팅", color: Color.accentTeal, likes: 4632, views: 19870, comments: 542),
                TrendingContent(id: 4, title: "우주 교향곡", creator: "음악천재", description: "AI가 우주의 소리에서 영감받아 작곡한 곡", type: "음악", color: Color.primaryBlue, likes: 4290, views: 18650, comments: 498),
                TrendingContent(id: 5, title: "별들의 전쟁", creator: "별빛작가", description: "우주를 배경으로 한 서사시적 SF소설", type: "웹소설", color: Color.accentYellow, likes: 3876, views: 17450, comments: 463)
            ]
        }
    }
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 헤더
                TrendingHeaderView(title: "\(category) 트렌딩", onDismiss: {
                    presentationMode.wrappedValue.dismiss()
                })
                
                // 페이지 뷰
                TabView(selection: $currentPage) {
                    ForEach(Array(contents.enumerated()), id: \.element.id) { index, content in
                        TrendingContentCardView(
                            content: content,
                            isLiked: $isLiked[index % isLiked.count],
                            onTap: {
                                selectedContent = content
                                showDetails = true
                            }
                        )
                        .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // 카테고리별 권장 아이템
                VStack(spacing: 12) {
                    Text("당신을 위한 추천")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(contents.reversed()) { content in
                                RecommendItemView(content: content) {
                                    selectedContent = content
                                    showDetails = true
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                    }
                }
                .padding(.vertical, 12)
                .background(Color.darkBackgroundSecondary.opacity(0.7))
            }
        }
        .sheet(isPresented: $showDetails) {
            if let content = selectedContent {
                ContentDetailView(content: content)
            }
        }
        .navigationBarHidden(true)
    }
}

// 트렌딩 헤더 뷰
struct TrendingHeaderView: View {
    let title: String
    let onDismiss: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onDismiss) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // 공유 액션
            }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.darkBackground.opacity(0.9), Color.darkBackground.opacity(0.7)]),
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

// 트렌딩 콘텐츠 카드 뷰
struct TrendingContentCardView: View {
    let content: TrendingContent
    @Binding var isLiked: Bool
    let onTap: () -> Void
    
    var body: some View {
        ZStack {
            // 배경
            Rectangle()
                .fill(Color.darkBackgroundSecondary)
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
            
            VStack(alignment: .leading, spacing: 0) {
                // 상단 정보
                HStack {
                    // 크리에이터 정보
                    HStack {
                        Circle()
                            .fill(content.color)
                            .frame(width: 36, height: 36)
                            .overlay(
                                Text(String(content.creator.prefix(1)))
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundColor(.white)
                            )
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text(content.creator)
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.white)
                            
                            Text(content.type)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                    }
                    
                    Spacer()
                    
                    // 더보기 버튼
                    Button(action: {
                        // 더보기 액션
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 20))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 16)
                
                // 메인 콘텐츠
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [content.color.opacity(0.7), content.color.opacity(0.4)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .aspectRatio(1, contentMode: .fit)
                    
                    VStack(spacing: 10) {
                        // 콘텐츠 타입에 따라 다른 아이콘 표시
                        Image(systemName: iconForType(content.type))
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                        
                        Text(content.title)
                            .font(.system(size: 22, weight: .bold))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                    }
                }
                .onTapGesture {
                    onTap()
                }
                
                // 콘텐츠 설명
                Text(content.description)
                    .font(.system(size: 15))
                    .foregroundColor(.white)
                    .lineLimit(2)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                
                // 액션 버튼들
                HStack(spacing: 20) {
                    // 좋아요 버튼
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: isLiked ? "heart.fill" : "heart")
                                .font(.system(size: 18))
                                .foregroundColor(isLiked ? Color.accentPink : .gray)
                            
                            Text(isLiked ? "\(content.likes + 1)" : "\(content.likes)")
                                .font(.system(size: 14))
                                .foregroundColor(isLiked ? .white : .gray)
                        }
                    }
                    
                    // 조회수
                    HStack(spacing: 6) {
                        Image(systemName: "eye")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        
                        Text("\(content.views)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    // 댓글
                    HStack(spacing: 6) {
                        Image(systemName: "bubble.left")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                        
                        Text("\(content.comments)")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    // 공유 버튼
                    Button(action: {
                        // 공유 액션
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 18))
                            .foregroundColor(.gray)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 20)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
    
    // 콘텐츠 타입에 따른 아이콘 선택
    private func iconForType(_ type: String) -> String {
        switch type {
        case "웹소설": return "book.fill"
        case "이미지": return "photo.fill"
        case "피팅": return "tshirt.fill"
        case "영상": return "film.fill"
        case "음악": return "music.note.list"
        case "트렌드": return "chart.line.uptrend.xyaxis"
        default: return "sparkles"
        }
    }
}

// 추천 아이템 뷰
struct RecommendItemView: View {
    let content: TrendingContent
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 8) {
                // 미리보기 이미지
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [content.color.opacity(0.8), content.color.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)
                        .cornerRadius(12)
                    
                    Image(systemName: iconForType(content.type))
                        .font(.system(size: 30))
                        .foregroundColor(.white)
                }
                
                // 제목
                Text(content.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .frame(width: 120, alignment: .leading)
                
                // 크리에이터
                Text(content.creator)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .frame(width: 120, alignment: .leading)
            }
        }
    }
    
    // 콘텐츠 타입에 따른 아이콘 선택
    private func iconForType(_ type: String) -> String {
        switch type {
        case "웹소설": return "book.fill"
        case "이미지": return "photo.fill"
        case "피팅": return "tshirt.fill"
        case "영상": return "film.fill"
        case "음악": return "music.note.list"
        case "트렌드": return "chart.line.uptrend.xyaxis"
        default: return "sparkles"
        }
    }
}

// 콘텐츠 상세 뷰
struct ContentDetailView: View {
    let content: TrendingContent
    @Environment(\.presentationMode) var presentationMode
    @State private var showComments = false
    @State private var comment = ""
    @State private var isLiked = false
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 헤더
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text(content.title)
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Button(action: {
                        // 공유 액션
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // 크리에이터 정보
                        HStack {
                            Circle()
                                .fill(content.color)
                                .frame(width: 40, height: 40)
                                .overlay(
                                    Text(String(content.creator.prefix(1)))
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(content.creator)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text("프로 크리에이터 • \(content.type) 전문가")
                                    .font(.system(size: 14))
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                // 팔로우 액션
                            }) {
                                Text("팔로우")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .cornerRadius(16)
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                        
                        // 콘텐츠 이미지
                        ZStack {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [content.color.opacity(0.8), content.color.opacity(0.5)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .aspectRatio(1, contentMode: .fit)
                            
                            VStack(spacing: 16) {
                                Image(systemName: iconForType(content.type))
                                    .font(.system(size: 60))
                                    .foregroundColor(.white)
                                
                                Text(content.title)
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 20)
                                
                                Text(content.description)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.9))
                                    .multilineTextAlignment(.center)
                                    .padding(.horizontal, 30)
                            }
                            .padding(.vertical, 30)
                        }
                        
                        // 액션 버튼들
                        HStack(spacing: 25) {
                            // 좋아요 버튼
                            Button(action: {
                                isLiked.toggle()
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: isLiked ? "heart.fill" : "heart")
                                        .font(.system(size: 22))
                                        .foregroundColor(isLiked ? Color.accentPink : .white)
                                    
                                    Text(isLiked ? "\(content.likes + 1)" : "\(content.likes)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // 댓글 버튼
                            Button(action: {
                                showComments = true
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "bubble.left")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                    
                                    Text("\(content.comments)")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // 북마크 버튼
                            Button(action: {
                                // 북마크 액션
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "bookmark")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                    
                                    Text("저장")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            // 공유 버튼
                            Button(action: {
                                // 공유 액션
                            }) {
                                VStack(spacing: 4) {
                                    Image(systemName: "square.and.arrow.up")
                                        .font(.system(size: 22))
                                        .foregroundColor(.white)
                                    
                                    Text("공유")
                                        .font(.system(size: 14))
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                        .padding(.horizontal, 30)
                        .padding(.top, 10)
                        
                        // 설명
                        VStack(alignment: .leading, spacing: 10) {
                            Text("상세 정보")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            Text(detailedDescription())
                                .font(.system(size: 15))
                                .foregroundColor(.gray)
                                .lineSpacing(5)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        
                        // 유사한 콘텐츠
                        VStack(alignment: .leading, spacing: 12) {
                            Text("당신이 좋아할 만한 콘텐츠")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(.white)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 12) {
                                    ForEach(1...5, id: \.self) { i in
                                        SimilarContentView(
                                            title: "추천 콘텐츠 \(i)",
                                            creator: "크리에이터\(i)",
                                            color: randomColor(i)
                                        )
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 30)
                        
                        // 댓글 입력창은 하단에 고정
                        Spacer(minLength: 80)
                    }
                }
                
                // 댓글 입력창
                if showComments {
                    VStack(spacing: 0) {
                        Divider()
                            .background(Color.gray.opacity(0.3))
                        
                        HStack {
                            TextField("댓글 작성...", text: $comment)
                                .padding(10)
                                .background(Color.darkBackgroundSecondary)
                                .cornerRadius(20)
                                .foregroundColor(.white)
                            
                            Button(action: {
                                // 댓글 작성 액션
                                comment = ""
                            }) {
                                Image(systemName: "paperplane.fill")
                                    .font(.system(size: 18))
                                    .foregroundColor(comment.isEmpty ? .gray : Color.accentTeal)
                            }
                            .disabled(comment.isEmpty)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .background(Color.darkBackground)
                }
            }
        }
    }
    
    // 콘텐츠 타입에 따른 아이콘 선택
    private func iconForType(_ type: String) -> String {
        switch type {
        case "웹소설": return "book.fill"
        case "이미지": return "photo.fill"
        case "피팅": return "tshirt.fill"
        case "영상": return "film.fill"
        case "음악": return "music.note.list"
        case "트렌드": return "chart.line.uptrend.xyaxis"
        default: return "sparkles"
        }
    }
    
    // 랜덤 색상 선택
    private func randomColor(_ seed: Int) -> Color {
        let colors = [Color.primaryPurple, Color.primaryBlue, Color.accentTeal, Color.accentPink, Color.accentYellow]
        return colors[seed % colors.count]
    }
    
    // 상세 설명 텍스트
    private func detailedDescription() -> String {
        return "\(content.title)은(는) \(content.creator)가 제작한 \(content.type) 콘텐츠입니다. \(content.description)이(가) 특징이며, 현재 \(content.views)회의 조회수와 \(content.likes)개의 좋아요를 받았습니다. 이 콘텐츠는 최신 AI 기술을 활용하여 제작되었으며, 많은 이용자들이 높은 만족도를 표시했습니다. \(content.creator)의 독특한 창작 스타일이 돋보이는 작품입니다."
    }
}

// 유사 콘텐츠 아이템
struct SimilarContentView: View {
    let title: String
    let creator: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [color.opacity(0.8), color.opacity(0.5)]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 140, height: 140)
                    .cornerRadius(12)
                
                Image(systemName: "sparkles")
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.white)
                .lineLimit(1)
            
            Text(creator)
                .font(.system(size: 12))
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: 140)
    }
}

// 트렌딩 콘텐츠 모델
struct TrendingContent: Identifiable {
    let id: Int
    let title: String
    let creator: String
    let description: String
    let type: String
    let color: Color
    let likes: Int
    let views: Int
    let comments: Int
}

// 미리보기
struct TrendingFeedView_Previews: PreviewProvider {
    static var previews: some View {
        TrendingFeedView(category: "추천")
            .preferredColorScheme(.dark)
    }
}