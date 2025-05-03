import SwiftUI

struct VideoGridView: View {
    let titles: [String]
    let creators: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // 비디오 그리드
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                ForEach(0..<min(4, titles.count), id: \.self) { i in
                    VideoCard(
                        title: titles[i % titles.count],
                        creator: creators[i % creators.count],
                        likes: Int.random(in: 1500...3500)
                    )
                }
            }
            .padding(.horizontal)
            
            Button {
                // 더 보기 액션
            } label: {
                Text("더 보기")
                    .font(.subheadline)
                    .foregroundColor(Color.accentPink)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.accentPink, lineWidth: 1)
                    )
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}