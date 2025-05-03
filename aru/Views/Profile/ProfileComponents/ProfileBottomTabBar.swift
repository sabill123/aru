import SwiftUI

struct ProfileBottomTabBar: View {
    let currentTab: Int
    let onTabSelect: (Int) -> Void
    let onCenterButtonTap: () -> Void
    
    var body: some View {
        HStack {
            Spacer()
            
            TabBarButton(icon: "house", label: "홈", isSelected: currentTab == 0)
                .onTapGesture { onTabSelect(0) }
            
            Spacer()
            
            TabBarButton(icon: "square.grid.2x2", label: "창작", isSelected: currentTab == 1)
                .onTapGesture { onTabSelect(1) }
            
            Spacer()
            
            // 중앙 버튼
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 60, height: 60)
                    .shadow(color: Color.primaryPurple.opacity(0.5), radius: 8)
                
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
            }
            .offset(y: -15)
            .onTapGesture { onCenterButtonTap() }
            
            Spacer()
            
            TabBarButton(icon: "message", label: "채팅", isSelected: currentTab == 3)
                .onTapGesture { onTabSelect(3) }
            
            Spacer()
            
            TabBarButton(icon: "person.fill", label: "프로필", isSelected: currentTab == 4)
                .onTapGesture { onTabSelect(4) }
            
            Spacer()
        }
        .padding(.bottom, 5)
        .background(Color.black)
    }
}