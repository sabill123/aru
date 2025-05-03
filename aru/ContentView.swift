//
//  ContentView.swift
//  aru
//
//  Created by Jaeseok Han on 5/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var showLoginView = false
    @State private var showMainApp = false
    
    var body: some View {
        ZStack {
            if showMainApp {
                // 메인 앱 화면 (메인 탭 뷰)
                ZStack(alignment: .top) {
                    // 메인 콘텐츠
                    MainTabView()
                    
                    // 상단 상태바 배경
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [Color(hex: "0A0A14").opacity(0.98), Color(hex: "0A0A14").opacity(0.95)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(height: 50) // 상태바 높이 조금 더 크게 (safe area 포함)
                        .ignoresSafeArea(.all, edges: .top) // 상단 안전 영역까지 확장
                }
            } else if showLoginView {
                // 로그인 화면
                LoginView(showMainApp: $showMainApp)
            } else {
                // 스플래시 화면
                SplashScreen(showLoginView: $showLoginView)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
