import SwiftUI

struct ProfileHeaderView: View {
    let username: String
    let email: String
    let postCount: Int
    let followerCount: Int
    let followingCount: Int
    let onEditProfileTap: () -> Void
    var onSettingsTap: (() -> Void)? = nil
    
    var body: some View {
        VStack(spacing: 20) {
            // 설정 버튼
            HStack {
                Spacer()
                
                Button(action: {
                    onSettingsTap?()
                }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.gray)
                        .padding(8)
                        .background(Color.darkBackgroundSecondary)
                        .clipShape(Circle())
                }
                .padding(.trailing, 20)
            }
            
            // 프로필 이미지
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 110, height: 110)
                
                Text(String(username.prefix(1)))
                    .font(.system(size: 50, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // 사용자 이름
            Text(username)
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.white)
            
            // 이메일
            Text(email)
                .font(.system(size: 16))
                .foregroundColor(.gray)
                .padding(.bottom, 5)
            
            // 통계 정보
            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("\(postCount)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("작품")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 8) {
                    Text("\(followerCount)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("팔로워")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                
                VStack(spacing: 8) {
                    Text("\(followingCount)")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    Text("팔로잉")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
            }
            
            // 프로필 수정 버튼
            Button(action: onEditProfileTap) {
                Text("프로필 편집")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .background(Color.darkBackgroundSecondary)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
        }
        .padding(.top, 20)
    }
}