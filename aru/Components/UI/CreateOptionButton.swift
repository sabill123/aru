import SwiftUI

struct CreateOptionButton: View {
    var title: String
    var icon: String
    var color: String
    
    var body: some View {
        VStack(spacing: 12) {
            // 아이콘 부분
            ZStack {
                Circle()
                    .fill(Color(hex: color).opacity(0.15))
                    .frame(width: 72, height: 72)
                
                Circle()
                    .fill(Color(hex: color).opacity(0.5))
                    .frame(width: 56, height: 56)
                
                Image(systemName: icon)
                    .font(.system(size: 24, weight: .medium))
                    .foregroundColor(.white)
            }
            
            // 텍스트
            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
        }
        .frame(height: 110)
    }
}