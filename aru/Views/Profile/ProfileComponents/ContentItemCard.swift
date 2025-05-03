import SwiftUI

struct ContentItemCard: View {
    let type: String
    let title: String
    let icon: String
    let iconColor: Color
    let likes: Int
    let time: String
    let onEditTap: () -> Void
    let onShareTap: () -> Void
    
    @State private var isPressed = false
    
    var body: some View {
        HStack {
            // 썸네일
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(iconColor)
                    .frame(width: 80, height: 80)
                
                Image(systemName: icon)
                    .font(.system(size: 30))
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 5) {
                // 게시물 타입 태그
                Text(type)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(iconColor.opacity(0.3))
                    .cornerRadius(4)
                
                // 게시물 제목
                Text(title)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                
                // 좋아요 정보
                HStack(spacing: 5) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 12))
                        .foregroundColor(.pink)
                    
                    Text("\(likes)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            Spacer()
            
            // 날짜 및 액션 버튼
            VStack(alignment: .trailing, spacing: 8) {
                Text(time)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    Button(action: onEditTap) {
                        Image(systemName: "pencil")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                    
                    Button(action: onShareTap) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 15)
        .background(Color.darkBackgroundSecondary.opacity(isPressed ? 0.7 : 1))
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .cornerRadius(12)
        .padding(.horizontal, 20)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                
                // 여기에 탭 액션 추가 가능
            }
        }
    }
}