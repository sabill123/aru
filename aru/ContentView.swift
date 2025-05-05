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
                MainTabView()
            } else if showLoginView {
                // 로그인 화면
                LoginView(showMainApp: $showMainApp)
            } else {
                // 스플래시 화면
                EnhancedSplashScreen(showLoginView: $showLoginView)
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
