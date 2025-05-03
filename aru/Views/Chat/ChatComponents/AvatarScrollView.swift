import SwiftUI

struct AvatarScrollView: View {
    let avatars: [String]
    let names: [String]
    let onNewAvatarTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("내 가상 아바타")
                .font(.headline)
                .fontWeight(.medium)
                .padding(.horizontal)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<min(3, avatars.count), id: \.self) { i in
                        ChatAvatarView(
                            icon: avatars[i],
                            name: names[i],
                            gradientIndex: i
                        )
                    }
                    
                    // 새 아바타 추가 버튼
                    NewAvatarButton(action: onNewAvatarTap)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
            }
        }
    }
}