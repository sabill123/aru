import SwiftUI

struct ChatHeaderView: View {
    @Binding var searchText: String
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                Text("채팅")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                Button(action: {
                    // 새 채팅 생성
                }) {
                    Image(systemName: "square.and.pencil")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(10)
                }
            }
            .padding(.horizontal)
            
            // 검색창
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                    .padding(.leading, 8)
                
                TextField("친구나 메시지 검색하기", text: $searchText)
                    .font(.system(size: 14))
                    .foregroundColor(.white)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                            .padding(.trailing, 8)
                    }
                }
            }
            .padding(8)
            .background(Color.darkBackgroundSecondary)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.3), lineWidth: 0.5)
            )
            .padding(.horizontal)
        }
        .padding(.top, 8)
        .padding(.bottom, 8)
    }
}