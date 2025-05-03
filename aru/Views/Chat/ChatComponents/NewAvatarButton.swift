import SwiftUI

struct NewAvatarButton: View {
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            VStack {
                ZStack {
                    Circle()
                        .strokeBorder(Color.gray.opacity(0.5), style: StrokeStyle(lineWidth: 2, dash: [5]))
                        .frame(width: 64, height: 64)
                    
                    Image(systemName: "plus")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                
                Text("새로 만들기")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}