import SwiftUI

struct CreationView: View {
    // 상태 관리
    @State private var selectedCategory = "인기"
    
    // 데이터
    let categories = ["인기", "최신", "웹소설", "이미지", "피팅"]
    let titles = [
        "마법사의 시대: 빛과 어둠의 경계",
        "미래 도시의 풍경",
        "우주 탐험 다큐멘터리",
        "판타지 세계의 모험"
    ]
    let icons = ["book.fill", "photo.fill", "video.fill", "music.note"]
    let gradientColors: [[Color]] = [
        [Color.primaryPurple, Color.primaryBlue],
        [Color.accentPink, Color.accentPink.opacity(0.7)],
        [Color.accentTeal, Color.accentTeal.opacity(0.7)],
        [Color.accentYellow, Color.orange]
    ]
    
    var body: some View {
        NavigationView {
            ZStack {
                // 배경
                SpaceBackground()
                    .ignoresSafeArea()
                
                VStack(spacing: 16) {
                    // 상단 헤더
                    CreationHeaderView(
                        title: "창작",
                        subtitle: "AI로 당신만의 웹소설을 만들어보세요"
                    )
                    
                    // 카테고리 필터
                    CreationCategoryScroll(
                        categories: categories,
                        selectedCategory: $selectedCategory
                    )
                    
                    // 창작물 목록
                    CreationListView(
                        titles: titles,
                        author: "우주탐험가",
                        icons: icons,
                        gradientColors: gradientColors
                    )
                }
            }
            .navigationBarHidden(true)
        }
    }
}