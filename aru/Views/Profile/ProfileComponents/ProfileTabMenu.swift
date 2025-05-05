import SwiftUI

struct ProfileTabMenu: View {
    @Binding var selectedTab: Int
    let tabs: [String]
    var namespace: Namespace.ID
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<tabs.count, id: \.self) { index in
                Button(action: {
                    selectedTab = index
                }) {
                    VStack(spacing: 10) {
                        Text(tabs[index])
                            .font(.system(size: 14))
                            .foregroundColor(selectedTab == index ? .white : .gray)
                        
                        if selectedTab == index {
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(height: 2)
                                .matchedGeometryEffect(id: "tab", in: namespace)
                        } else {
                            Rectangle()
                                .fill(Color.clear)
                                .frame(height: 2)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.top, 16)
    }
}