import SwiftUI

struct ContentListView: View {
    let title: String
    let types: [String]
    let titles: [String]
    let icons: [String]
    let iconColors: [Color]
    let likes: [Int]
    let times: [String]
    
    @State private var isRefreshing = false
    @State private var showEmptyView = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Text(title)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .padding(.top, 20)
                .padding(.horizontal, 20)
            
            if showEmptyView {
                EmptyContentView(title: title)
            } else {
                ScrollView {
                    // 당겨서 새로고침 표시기
                    RefreshHeader(isRefreshing: $isRefreshing)
                        .offset(y: isRefreshing ? 0 : -70)
                    
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
                    .padding(.bottom, 20)
                }
                .refreshable {
                    // 당겨서 새로고침 액션
                    await refreshContent()
                }
            }
        }
    }
    
    // 콘텐츠 새로고침 함수
    func refreshContent() async {
        isRefreshing = true
        
        // 실제로는 API 호출 등을 수행
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5초 대기
        
        isRefreshing = false
    }
}

// 새로고침 헤더 뷰
struct RefreshHeader: View {
    @Binding var isRefreshing: Bool
    
    var body: some View {
        HStack {
            Spacer()
            VStack(spacing: 10) {
                if isRefreshing {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color.accentTeal))
                        .scaleEffect(1.5)
                    
                    Text("새로고침 중...")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 70)
            Spacer()
        }
    }
}

// 콘텐츠가 없을 때 표시되는 뷰
struct EmptyContentView: View {
    let title: String
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "tray")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
            
            Text("\(title)이 없습니다")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.gray)
            
            Text("새로운 작품을 만들어보세요")
                .font(.system(size: 14))
                .foregroundColor(.gray.opacity(0.7))
            
            Button(action: {
                // 새 작품 만들기 액션
            }) {
                Text("+ 새 작품 만들기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 50)
    }
}