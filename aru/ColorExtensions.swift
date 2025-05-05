import SwiftUI

// 참고: 색상 정의는 aruApp.swift 파일에 정의되어 있음
// 아래는 aruApp.swift에 정의된 색상 참조:
/*
static let primaryPurple = Color(hex: "6A11CB")
static let primaryBlue = Color(hex: "2575FC")
static let accentTeal = Color(hex: "12E2A3")
static let accentPink = Color(hex: "FF36A3")
static let accentYellow = Color(hex: "FFD60A")
static let darkBackground = Color(hex: "0A0A14")
static let darkBackgroundSecondary = Color(hex: "1A1A32")
*/

// 그라데이션 색상 유틸리티 함수
extension Color {
    // 그라데이션 색상 모음
    static func gradient(index: Int) -> LinearGradient {
        let gradients = [
            LinearGradient(gradient: Gradient(colors: [.primaryPurple, .primaryBlue]), startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(gradient: Gradient(colors: [.accentTeal, .accentTeal.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(gradient: Gradient(colors: [.accentPink, .accentPink.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(gradient: Gradient(colors: [.accentYellow, .accentYellow.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing),
            LinearGradient(gradient: Gradient(colors: [.purple, .purple.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        ]
        
        return gradients[index % gradients.count]
    }
}