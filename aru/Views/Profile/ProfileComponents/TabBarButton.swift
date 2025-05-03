import SwiftUI

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .white : .gray)
            
            Text(label)
                .font(.system(size: 10))
                .foregroundColor(isSelected ? .white : .gray)
        }
    }
}