import SwiftUI

struct CreationHeaderView: View {
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
            
            Text(subtitle)
                .font(.system(size: 16))
                .foregroundColor(.gray)
        }
        .padding(.top, 16)
    }
}