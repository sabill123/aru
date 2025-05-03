import SwiftUI

struct ChatHeaderView: View {
    var searchAction: () -> Void
    
    var body: some View {
        HStack {
            Text("AI 채팅")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Button(action: searchAction) {
                Circle()
                    .fill(Color.darkBackgroundSecondary)
                    .frame(width: 40, height: 40)
                    .overlay(
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                    )
            }
        }
        .padding(.horizontal)
        .padding(.top)
    }
}