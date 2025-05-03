import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var previousTab = 0
    @State private var showCreateOptions = false
    @State private var showNovelCreation = false
    @State private var showImageGeneration = false
    @State private var showVirtualFitting = false
    @State private var showSettings = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .padding(.top, 1) // 상태바 배경과 잘 맞도록 미세 패딩
                
                CreationView()
                    .tag(1)
                    .padding(.top, 1)
                
                Color.clear
                    .tag(2)
                
                ChatView()
                    .tag(3)
                    .padding(.top, 1)
                
                ProfileView()
                    .tag(4)
                    .padding(.top, 1)
            }
            .onChange(of: selectedTab) { oldValue, newValue in
                if newValue == 2 {
                    // 중앙 '우주생성' 버튼을 누른 경우 이전 탭으로 복귀하고 옵션 표시
                    DispatchQueue.main.async {
                        selectedTab = previousTab
                        withAnimation(.spring()) {
                            showCreateOptions = true
                        }
                    }
                } else {
                    previousTab = newValue
                }
            }
            
            // 탭바 영역 터치시 옵션 닫기 위한 투명 배경
            if showCreateOptions {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showCreateOptions = false
                        }
                    }
                    .transition(.opacity)
            }
            
            // 우주생성 옵션
            if showCreateOptions {
                VStack {
                    Spacer()
                    
                    HStack(spacing: 20) {
                        Button(action: {
                            showCreateOptions = false
                            showNovelCreation = true
                        }) {
                            CreateOptionButton(title: "웹소설", icon: "book.fill", color: "5E72EB")
                        }
                        
                        Button(action: {
                            showCreateOptions = false
                            showImageGeneration = true
                        }) {
                            CreateOptionButton(title: "이미지", icon: "photo.fill", color: "FF5A92")
                        }
                        
                        Button(action: {
                            showCreateOptions = false
                            showVirtualFitting = true
                        }) {
                            CreateOptionButton(title: "피팅", icon: "tshirt.fill", color: "FFD60A")
                        }
                    }
                    .padding(.bottom, 120) // Increased bottom padding to accommodate raised tab bar
                }
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
            
            // 커스텀 탭바
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showNovelCreation) {
            NovelCreationView()
        }
        .sheet(isPresented: $showImageGeneration) {
            ImageGenerationView()
        }
        .sheet(isPresented: $showVirtualFitting) {
            VirtualFittingView()
        }
        .sheet(isPresented: $showSettings) {
            FullSettingsView()
        }
    }
}