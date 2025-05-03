import SwiftUI

struct CreationCategoryScroll: View {
    let categories: [String]
    @Binding var selectedCategory: String
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Text(category)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(category == selectedCategory ? 
                                 LinearGradient(
                                     gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                     startPoint: .leading,
                                     endPoint: .trailing
                                 ) : 
                                 LinearGradient(
                                     gradient: Gradient(colors: [Color.darkBackgroundSecondary.opacity(0.5), Color.darkBackgroundSecondary.opacity(0.5)]),
                                     startPoint: .leading,
                                     endPoint: .trailing
                                 ))
                        .foregroundColor(.white)
                        .cornerRadius(20)
                        .onTapGesture {
                            withAnimation {
                                selectedCategory = category
                            }
                        }
                }
            }
            .padding(.horizontal, 16)
        }
    }
}