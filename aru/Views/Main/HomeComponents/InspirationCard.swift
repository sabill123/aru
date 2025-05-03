import SwiftUI

struct InspirationCard: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkBackgroundSecondary)
            
            // 별 효과
            ForEach(0..<20) { i in
                Circle()
                    .fill(Color.white.opacity(Double.random(in: 0.1...0.5)))
                    .frame(width: CGFloat.random(in: 1...2), height: CGFloat.random(in: 1...2))
                    .position(
                        x: CGFloat.random(in: 20...300),
                        y: CGFloat.random(in: 20...150)
                    )
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text("네온 사이버펑크 세계 생성")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("AI와 함께 미래적인 도시의 이야기를 만들어보세요")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Button {
                    // 시작하기 액션
                } label: {
                    HStack {
                        Text("시작하기")
                            .font(.subheadline)
                            .fontWeight(.bold)
                        
                        Image(systemName: "arrow.right")
                    }
                    .foregroundColor(.black)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.accentTeal, Color.accentTeal.opacity(0.8)]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
                }
                .padding(.top, 8)
            }
            .padding(.all, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal)
    }
}