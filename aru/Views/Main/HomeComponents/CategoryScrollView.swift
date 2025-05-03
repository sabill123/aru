import SwiftUI

struct CategoryScrollView: View {
    let categories: [(title: String, icon: String)]
    @Binding var selectedCategoryIndex: Int
    @State private var animateIndicator = false
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            // Main category scroll area
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<categories.count, id: \.self) { index in
                        HomeCategoryButton(
                            title: categories[index].title,
                            icon: categories[index].icon,
                            isActive: index == selectedCategoryIndex
                        )
                        .onTapGesture {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                selectedCategoryIndex = index
                                // Trigger indicator animation
                                animateIndicator = false
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        animateIndicator = true
                                    }
                                }
                            }
                        }
                        .overlay(
                            ZStack {
                                if index == selectedCategoryIndex {
                                    // Custom matched geometry indicator
                                    Capsule()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    getCategoryColor(for: index),
                                                    getCategoryColor(for: index).opacity(0.7)
                                                ]),
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .frame(width: 20, height: 3)
                                        .offset(y: 20)
                                        .matchedGeometryEffect(id: "categoryIndicator", in: animation)
                                        .opacity(animateIndicator ? 1 : 0)
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
            .padding(.bottom, 2)
            
            // Decorative element (optional)
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.darkBackgroundSecondary.opacity(0.5),
                            Color.darkBackgroundSecondary.opacity(0.2),
                            Color.clear
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(height: 1)
                .padding(.horizontal)
        }
        .onAppear {
            // Initialize indicator animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    animateIndicator = true
                }
            }
        }
    }
    
    // Helper function to get category-specific colors
    private func getCategoryColor(for index: Int) -> Color {
        let title = categories[index].title
        switch title {
        case "추천": return Color.accentTeal
        case "웹소설": return Color.primaryPurple
        case "이미지": return Color.accentPink
        case "피팅": return Color.accentYellow
        case "트렌드": return Color.primaryBlue
        default: return Color.primaryPurple
        }
    }
}