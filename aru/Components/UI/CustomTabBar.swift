import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        VStack(spacing: 0) {
            // 상단 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 0.5)
            
            // 탭바 컨텐츠
            HStack(spacing: 0) {
                ForEach(0..<5) { index in
                    Button {
                        selectedTab = index
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: tabIcon(index, isSelected: selectedTab == index))
                                .font(.system(size: 22))
                                .foregroundColor(selectedTab == index ? .primaryPurple : .gray.opacity(0.7))
                            
                            Text(tabTitle(index))
                                .font(.system(size: 12, weight: selectedTab == index ? .medium : .regular))
                                .foregroundColor(selectedTab == index ? .primaryPurple : .gray.opacity(0.7))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            selectedTab == index ?
                            Color.primaryPurple.opacity(0.1) :
                            Color.clear
                        )
                    }
                }
            }
        }
        .background(Color.darkBackground)
        .edgesIgnoringSafeArea(.bottom)
    }
    
    private func tabIcon(_ index: Int, isSelected: Bool) -> String {
        switch index {
        case 0: return isSelected ? "tshirt.fill" : "tshirt"  // 패션 탭
        case 1: return isSelected ? "film.fill" : "film"      // 창작 탭
        case 2: return isSelected ? "house.fill" : "house"    // 홈 탭
        case 3: return isSelected ? "message.fill" : "message" // 채팅 탭
        case 4: return isSelected ? "person.fill" : "person"  // 프로필 탭
        default: return ""
        }
    }
    
    private func tabTitle(_ index: Int) -> String {
        switch index {
        case 0: return "패션"    // 패션 탭
        case 1: return "창작"    // 창작 탭
        case 2: return "홈"      // 홈 탭
        case 3: return "채팅"    // 채팅 탭
        case 4: return "프로필"  // 프로필 탭
        default: return ""
        }
    }
}