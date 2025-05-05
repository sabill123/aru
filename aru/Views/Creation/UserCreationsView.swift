import SwiftUI

struct UserCreationItem: Identifiable {
    let id: Int
    let title: String
    let type: String
    let date: String
    let thumbnail: String
    let iconName: String
    let iconColor: Color
}

struct UserCreationsView: View {
    @Binding var isPresented: Bool
    @State private var selectedCategory = 0
    @State private var searchText = ""
    @State private var isSearchActive = false
    @State private var animateContent = false
    
    // 카테고리
    let categories = ["전체", "텍스트", "이미지", "음성", "영상"]
    
    // 샘플 데이터
    let userCreations: [UserCreationItem] = [
        UserCreationItem(id: 1, title: "우주 여행 AI 시뮬레이션", type: "영상", date: "1일 전", thumbnail: "video", iconName: "film", iconColor: .accentPink),
        UserCreationItem(id: 2, title: "판타지 세계 풍경", type: "이미지", date: "2일 전", thumbnail: "image", iconName: "photo", iconColor: .accentTeal),
        UserCreationItem(id: 3, title: "별들의 속삭임", type: "텍스트", date: "3일 전", thumbnail: "text", iconName: "doc.text", iconColor: .primaryPurple),
        UserCreationItem(id: 4, title: "미래 도시의 소리", type: "음성", date: "4일 전", thumbnail: "audio", iconName: "waveform", iconColor: .accentYellow),
        UserCreationItem(id: 5, title: "사이버펑크 의상 피팅", type: "피팅", date: "1주일 전", thumbnail: "fitting", iconName: "tshirt", iconColor: .primaryBlue),
        UserCreationItem(id: 6, title: "우주 정거장 3D 모델", type: "3D 모델", date: "2주일 전", thumbnail: "3d", iconName: "cube", iconColor: .gray)
    ]
    
    var filteredCreations: [UserCreationItem] {
        if selectedCategory == 0 {
            return userCreations
        } else {
            let categoryType = categories[selectedCategory]
            return userCreations.filter { $0.type == categoryType }
        }
    }
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 상단 헤더
                headerView
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                
                // 검색바 (활성화된 경우만)
                if isSearchActive {
                    searchBarView
                        .transition(.move(edge: .top).combined(with: .opacity))
                        .padding(.horizontal, 20)
                        .padding(.bottom, 16)
                }
                
                // 카테고리 선택
                categorySelectionView
                    .padding(.bottom, 20)
                
                // 컨텐츠 리스트
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCreations) { item in
                            CreationItemRow(item: item)
                                .padding(.horizontal, 20)
                                .opacity(animateContent ? 1.0 : 0.0)
                                .offset(y: animateContent ? 0 : 20)
                                .animation(
                                    .spring(response: 0.4, dampingFraction: 0.8)
                                    .delay(Double(filteredCreations.firstIndex(where: { $0.id == item.id }) ?? 0) * 0.1),
                                    value: animateContent
                                )
                        }
                        
                        // 하단 여백
                        Spacer()
                            .frame(height: 80)
                    }
                }
            }
        }
        .onAppear {
            // 애니메이션 지연
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.easeInOut(duration: 0.4)) {
                    animateContent = true
                }
            }
        }
    }
    
    // MARK: - 컴포넌트 뷰
    
    // 헤더 뷰
    var headerView: some View {
        HStack {
            // 뒤로가기 및 타이틀
            HStack(spacing: 16) {
                // 뒤로가기 버튼
                Button(action: {
                    isPresented = false
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.darkBackgroundSecondary)
                        .clipShape(Circle())
                }
                .pressEffect()
                
                // 페이지 타이틀
                Text("나의 AI 창작")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            // 검색 버튼
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isSearchActive.toggle()
                    if !isSearchActive {
                        searchText = ""
                    }
                }
            }) {
                Image(systemName: isSearchActive ? "xmark" : "magnifyingglass")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.darkBackgroundSecondary)
                    .clipShape(Circle())
            }
            .pressEffect()
        }
        .padding(.horizontal, 20)
    }
    
    // 검색바 뷰
    var searchBarView: some View {
        HStack {
            // 검색 아이콘
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            // 텍스트 필드
            TextField("AI 창작물 검색", text: $searchText)
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
    
    // 카테고리 선택 뷰
    var categorySelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<categories.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedCategory = index
                        }
                    }) {
                        Text(categories[index])
                            .font(.system(size: 13, weight: selectedCategory == index ? .semibold : .regular))
                            .foregroundColor(selectedCategory == index ? .white : .gray)
                            .padding(.vertical, 6)
                            .padding(.horizontal, 14)
                            .background(
                                Capsule()
                                    .fill(selectedCategory == index ? categoryColor(for: index) : Color.darkBackgroundSecondary.opacity(0.5))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // 카테고리 색상
    func categoryColor(for index: Int) -> Color {
        switch categories[index] {
        case "전체": return Color.primaryPurple
        case "텍스트": return Color.primaryBlue
        case "이미지": return Color.accentTeal
        case "음성": return Color.accentYellow
        case "영상": return Color.accentPink
        default: return Color.primaryPurple
        }
    }
}

// MARK: - 창작물 아이템 행
struct CreationItemRow: View {
    let item: UserCreationItem
    
    var body: some View {
        HStack(spacing: 16) {
            // 썸네일
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.darkBackgroundSecondary)
                    .frame(width: 80, height: 80)
                
                // 타입 아이콘
                Image(systemName: item.iconName)
                    .font(.system(size: 28))
                    .foregroundColor(item.iconColor)
            }
            
            // 텍스트 정보
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                Text(item.type)
                    .font(.system(size: 13))
                    .foregroundColor(item.iconColor)
                
                Text(item.date)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // 액션 버튼
            Button(action: {
                // 항목 상세 보기
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
                    .rotationEffect(.degrees(90))
                    .frame(width: 32, height: 32)
                    .background(Color.darkBackgroundSecondary)
                    .clipShape(Circle())
            }
            .pressEffect()
        }
        .padding(12)
        .background(Color.darkBackgroundSecondary.opacity(0.3))
        .cornerRadius(16)
    }
}

#Preview {
    UserCreationsView(isPresented: .constant(true))
        .preferredColorScheme(.dark)
}