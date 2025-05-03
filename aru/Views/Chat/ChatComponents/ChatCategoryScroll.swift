import SwiftUI

struct ChatCategoryScroll: View {
    let categories: [String]
    let icons: [String]
    @Binding var activeTab: Int
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<categories.count, id: \.self) { index in
                    ChatCategoryButton(
                        title: categories[index],
                        icon: icons[index % icons.count],
                        isActive: activeTab == index
                    )
                    .onTapGesture { 
                        withAnimation(.spring()) {
                            activeTab = index
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
    }
}