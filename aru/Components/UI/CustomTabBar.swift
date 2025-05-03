import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<5) { index in
                if index == 2 {
                    // 중앙 메인 버튼
                    Button {
                        selectedTab = index
                    } label: {
                        ZStack {
                            // Outer glow
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 70, height: 70) // 크기 키움
                                .background(
                                    Circle()
                                        .fill(Color.clear)
                                        .shadow(color: Color(hex: "6A11CB").opacity(0.3), radius: 12)
                                )
                            
                            // Main circle
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "6A11CB"), Color(hex: "2575FC")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                                .frame(width: 58, height: 58) // 크기 키움
                                
                            // Plus icon
                            Image(systemName: "plus")
                                .font(.system(size: 26, weight: .bold)) // 아이콘 크기 키움
                                .foregroundColor(.white)
                                .background(Color.clear) // Ensures no grid lines appear
                        }
                    }
                } else {
                    // 일반 탭 버튼
                    Button {
                        selectedTab = index
                    } label: {
                        VStack(spacing: 6) { // 간격 다시 늘림
                            Image(systemName: tabIcon(index))
                                .font(.system(size: 20))
                                .foregroundColor(selectedTab == index ? .white : .gray)
                            
                            Text(tabTitle(index))
                                .font(.system(size: 10))
                                .foregroundColor(selectedTab == index ? .white : .gray)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 20) // 하단 여백 포함
        .frame(height: 80) // 하단 여백을 포함한 높이
        .background(
            Color(hex: "0A0A14")
                .opacity(0.95)
        )
        .clipShape(
            Rectangle() // 직사각형 모양으로 클리핑
        )
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(Color(hex: "1a1a2e")),
            alignment: .top
        )
    }
    
    private func tabIcon(_ index: Int) -> String {
        switch index {
        case 0: return "house"
        case 1: return "film"
        case 3: return "message"
        case 4: return "person"
        default: return ""
        }
    }
    
    private func tabTitle(_ index: Int) -> String {
        switch index {
        case 0: return "홈"
        case 1: return "창작"
        case 3: return "채팅"
        case 4: return "프로필"
        default: return ""
        }
    }
}