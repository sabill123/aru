import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 2 // Start with Home tab selected (center tab)
    @State private var showNovelCreation = false
    @State private var showImageGeneration = false
    @State private var showSettings = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                // 패션 탭 (Virtual Fitting)
                VirtualFittingView()
                    .tag(0)
                
                // 창작 탭
                EnhancedCreationView()
                    .tag(1)
                
                // 홈 탭 (중앙)
                HomeView(selectedTab: $selectedTab)
                    .tag(2)
                
                // 채팅 탭
                ChatView()
                    .tag(3)
                
                // 프로필 탭
                ProfileView()
                    .tag(4)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            // 커스텀 탭바
            CustomTabBar(selectedTab: $selectedTab)
        }
        .edgesIgnoringSafeArea(.bottom)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showNovelCreation) {
            NovelCreationView()
        }
        .sheet(isPresented: $showImageGeneration) {
            ImageGenerationView()
        }
        .sheet(isPresented: $showSettings) {
            FullSettingsView()
        }
    }
}