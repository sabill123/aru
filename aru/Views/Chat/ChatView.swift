// ChatView.swift - 채팅 탭
import SwiftUI

struct ChatView: View {
    // 상태 변수
    @State private var activeTab = 0
    @State private var animateContent = false
    @State private var searchText = ""
    @State private var showNewChat = false
    @State private var showChatDetail = false
    @State private var selectedChat: ChatData? = nil
    @State private var isPullingToRefresh = false
    @State private var refreshComplete = false
    
    // 카테고리 데이터
    let chatCategories = ["모두", "친구", "선생님", "비서", "가상인물"]
    
    // 샘플 채팅 데이터
    let chats: [ChatData] = [
        ChatData(id: 1, name: "우주선장", avatarIcon: "person.fill", preview: "오늘은 무엇을 도와드릴까요?", time: "13:45", color: .accentPink, unreadCount: 2, isOnline: true),
        ChatData(id: 2, name: "학습코치", avatarIcon: "brain.head.profile", preview: "수학 문제 분석을 완료했습니다.", time: "어제", color: .primaryPurple, unreadCount: 0, isOnline: true),
        ChatData(id: 3, name: "영어선생님", avatarIcon: "graduationcap", preview: "영어 회화 연습을 계속할까요?", time: "화요일", color: .accentTeal, unreadCount: 3, isOnline: false),
        ChatData(id: 4, name: "비서봇", avatarIcon: "briefcase", preview: "오늘 일정을 알려드릴게요.", time: "오전 10:15", color: .primaryBlue, unreadCount: 0, isOnline: true),
        ChatData(id: 5, name: "사이버펑크", avatarIcon: "figure.wave", preview: "네온 시티의 이야기를 계속할까요?", time: "월요일", color: .accentYellow, unreadCount: 1, isOnline: false)
    ]
    
    // 내 아바타
    let myAvatars: [AvatarData] = [
        AvatarData(id: 1, name: "우주선장", icon: "person.fill", color: .accentPink, lastUsed: "오늘"),
        AvatarData(id: 2, name: "학습코치", icon: "brain.head.profile", color: .primaryPurple, lastUsed: "어제"),
        AvatarData(id: 3, name: "영어선생님", icon: "graduationcap", color: .accentTeal, lastUsed: "3일 전")
    ]
    
    var filteredChats: [ChatData] {
        if activeTab == 0 { // "모두" 카테고리
            return chats
        } else {
            // 다른 카테고리별 필터링
            return chats.filter { $0.id % (activeTab + 1) == 0 }
        }
    }
    
    var body: some View {
        ZStack {
            // 메인 뷰
            VStack(spacing: 0) {
                // 헤더
                EnhancedChatHeaderView(
                    searchText: $searchText, 
                    onSearchSubmit: {
                        // 검색 액션
                    },
                    onNewChatTap: {
                        withAnimation {
                            showNewChat = true
                        }
                    }
                )
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.1), value: animateContent)
                
                // 채팅 카테고리 탭
                EnhancedChatCategoryScroll(
                    categories: chatCategories, 
                    activeTab: $activeTab
                )
                .opacity(animateContent ? 1 : 0)
                .offset(y: animateContent ? 0 : 20)
                .animation(.easeOut(duration: 0.5).delay(0.2), value: animateContent)
                
                // 채팅 리스트 영역
                ZStack(alignment: .top) {
                    // 실제 스크롤 뷰
                    ScrollView {
                        // 당겨서 새로고침 효과
                        VStack {
                            if isPullingToRefresh {
                                RefreshingView(isComplete: $refreshComplete)
                                    .frame(height: 70)
                                    .offset(y: refreshComplete ? -30 : 0)
                                    .animation(.easeOut(duration: 0.2), value: refreshComplete)
                            }
                            
                            // 내 가상 아바타
                            VStack(spacing: 16) {
                                HStack {
                                    Text("내 가상 아바타")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        // 아바타 관리
                                    }) {
                                        Text("관리")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                                // 아바타 리스트
                                EnhancedAvatarScrollView(
                                    avatars: myAvatars,
                                    onAvatarTap: { avatar in
                                        // 아바타 탭 액션
                                    },
                                    onNewAvatarTap: {
                                        // 새 아바타 만들기
                                    }
                                )
                            }
                            .padding(.vertical, 16)
                            .background(Color.darkBackgroundSecondary.opacity(0.6))
                            .cornerRadius(16)
                            .padding(.horizontal, 16)
                            .padding(.top, 16)
                            .opacity(animateContent ? 1 : 0)
                            .offset(y: animateContent ? 0 : 20)
                            .animation(.easeOut(duration: 0.5).delay(0.3), value: animateContent)
                            
                            // 최근 대화
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    Text("최근 대화")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                    
                                    Spacer()
                                    
                                    // 정렬 옵션 버튼
                                    Button(action: {
                                        // 정렬 액션
                                    }) {
                                        Image(systemName: "arrow.up.arrow.down")
                                            .font(.system(size: 14))
                                            .foregroundColor(.gray)
                                    }
                                }
                                .padding(.horizontal, 20)
                                .padding(.top, 10)
                                
                                if filteredChats.isEmpty {
                                    // 비어있을 때 표시
                                    EmptyChatView(category: chatCategories[activeTab])
                                } else {
                                    // 채팅 리스트
                                    ForEach(filteredChats) { chat in
                                        EnhancedChatListItem(
                                            chat: chat,
                                            onTap: {
                                                selectedChat = chat
                                                showChatDetail = true
                                            }
                                        )
                                        .opacity(animateContent ? 1 : 0)
                                        .offset(y: animateContent ? 0 : 20)
                                        .animation(.easeOut(duration: 0.5).delay(0.4 + Double(filteredChats.firstIndex(where: { $0.id == chat.id }) ?? 0) * 0.1), value: animateContent)
                                    }
                                }
                            }
                            .padding(.bottom, 100) // 하단 여유 공간
                        }
                        .background(
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(key: ScrollOffsetPreferenceKey.self, value: proxy.frame(in: .named("scrollView")).minY)
                            }
                        )
                    }
                    .coordinateSpace(name: "scrollView")
                    .onPreferenceChange(ScrollOffsetPreferenceKey.self) { value in
                        // 당겨서 새로고침 감지
                        if value > 50 && !isPullingToRefresh {
                            isPullingToRefresh = true
                            
                            // 새로고침 완료 시뮬레이션
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                refreshComplete = true
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    isPullingToRefresh = false
                                    refreshComplete = false
                                }
                            }
                        }
                    }
                    
                    // 플로팅 새 채팅 버튼
                    VStack {
                        Spacer()
                        
                        HStack {
                            Spacer()
                            
                            Button(action: {
                                withAnimation {
                                    showNewChat = true
                                }
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 56, height: 56)
                                        .shadow(color: Color.primaryPurple.opacity(0.3), radius: 8, x: 0, y: 4)
                                    
                                    Image(systemName: "plus.message.fill")
                                        .font(.system(size: 24))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(20)
                            .offset(y: -80) // 탭바 위에 위치하도록
                        }
                    }
                }
            }
            .background(Color.darkBackground)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    animateContent = true
                }
            }
            
            // 새 채팅 시트
            if showNewChat {
                NewChatView(isPresented: $showNewChat)
                    .transition(.move(edge: .bottom))
                    .zIndex(2)
            }
        }
        .fullScreenCover(isPresented: $showChatDetail) {
            if let chat = selectedChat {
                ChatDetailView(chat: chat, isPresented: $showChatDetail)
            }
        }
    }
}

// 향상된 채팅 헤더 뷰
struct EnhancedChatHeaderView: View {
    @Binding var searchText: String
    let onSearchSubmit: () -> Void
    let onNewChatTap: () -> Void
    @State private var isSearchActive = false
    
    var body: some View {
        VStack(spacing: 16) {
            // 상단 헤더
            HStack {
                Text("채팅")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.white)
                
                Spacer()
                
                // 새 채팅 버튼 (검색이 활성화되지 않았을 때만 표시)
                if !isSearchActive {
                    Button(action: onNewChatTap) {
                        Image(systemName: "square.and.pencil")
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                    }
                }
            }
            .padding(.horizontal, 20)
            
            // 검색 바
            HStack {
                Image(systemName: "magnifyingglass")
                    .font(.system(size: 16))
                    .foregroundColor(isSearchActive ? .white : .gray)
                    .padding(.leading, 8)
                
                TextField("채팅 검색", text: $searchText)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .onTapGesture {
                        isSearchActive = true
                    }
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    }
                    .padding(.trailing, 8)
                }
                
                if isSearchActive {
                    Button(action: {
                        isSearchActive = false
                        searchText = ""
                        hideKeyboard()
                    }) {
                        Text("취소")
                            .font(.system(size: 16))
                            .foregroundColor(.accentTeal)
                    }
                    .padding(.trailing, 8)
                }
            }
            .padding(.horizontal, 8)
            .background(Color.darkBackgroundSecondary)
            .cornerRadius(10)
            .padding(.horizontal, 20)
            .animation(.easeInOut(duration: 0.2), value: isSearchActive)
        }
        .padding(.top, 10)
        .padding(.bottom, 8)
        .background(Color.darkBackground)
    }
    
    // 키보드 숨기기
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// 향상된 채팅 카테고리 스크롤
struct EnhancedChatCategoryScroll: View {
    let categories: [String]
    @Binding var activeTab: Int
    @Namespace private var animation
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(0..<categories.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            activeTab = index
                        }
                    }) {
                        VStack(spacing: 8) {
                            Text(categories[index])
                                .font(.system(size: 14, weight: activeTab == index ? .semibold : .regular))
                                .foregroundColor(activeTab == index ? .white : .gray)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(
                                    ZStack {
                                        if activeTab == index {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.primaryPurple.opacity(0.3), Color.primaryBlue.opacity(0.3)]),
                                                        startPoint: .leading,
                                                        endPoint: .trailing
                                                    )
                                                )
                                                .matchedGeometryEffect(id: "category", in: animation)
                                        }
                                    }
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
        }
        .background(Color.darkBackground)
    }
}

// 향상된 아바타 스크롤 뷰
struct EnhancedAvatarScrollView: View {
    let avatars: [AvatarData]
    let onAvatarTap: (AvatarData) -> Void
    let onNewAvatarTap: () -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20) {
                // 아바타 리스트
                ForEach(avatars) { avatar in
                    AvatarItem(avatar: avatar) {
                        onAvatarTap(avatar)
                    }
                }
                
                // 새 아바타 버튼
                Button(action: onNewAvatarTap) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                .frame(width: 60, height: 60)
                            
                            Image(systemName: "plus")
                                .font(.system(size: 24))
                                .foregroundColor(.gray)
                        }
                        
                        Text("새 아바타")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    .frame(width: 80)
                }
            }
            .padding(.horizontal, 20)
        }
    }
    
    // 아바타 아이템
    struct AvatarItem: View {
        let avatar: AvatarData
        let onTap: () -> Void
        
        var body: some View {
            Button(action: onTap) {
                VStack(spacing: 8) {
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [avatar.color, avatar.color.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: avatar.icon)
                            .font(.system(size: 24))
                            .foregroundColor(.white)
                    }
                    
                    Text(avatar.name)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                        .lineLimit(1)
                    
                    Text(avatar.lastUsed)
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .lineLimit(1)
                }
                .frame(width: 80)
            }
        }
    }
}

// 향상된 채팅 목록 아이템
struct EnhancedChatListItem: View {
    let chat: ChatData
    let onTap: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                // 아바타 이미지
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [chat.color, chat.color.opacity(0.7)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: chat.avatarIcon)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    // 온라인 상태 표시
                    if chat.isOnline {
                        Circle()
                            .fill(Color.green)
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle()
                                    .stroke(Color.darkBackground, lineWidth: 2)
                            )
                            .offset(x: 18, y: 18)
                    }
                }
                
                // 채팅 정보
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(chat.name)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Text(chat.time)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        Text(chat.preview)
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                            .lineLimit(1)
                        
                        Spacer()
                        
                        // 안읽은 메시지 수 표시
                        if chat.unreadCount > 0 {
                            Text("\(chat.unreadCount)")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 20, height: 20)
                                .background(chat.color)
                                .clipShape(Circle())
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.darkBackgroundSecondary.opacity(isPressed ? 0.5 : 0.3))
            )
            .scaleEffect(isPressed ? 0.98 : 1.0)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isPressed = true
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = false
                }
                onTap()
            }
        }
    }
}

// 새 채팅 뷰
struct NewChatView: View {
    @Binding var isPresented: Bool
    @State private var searchText = ""
    
    // 샘플 추천 아바타 데이터
    let recommendedAvatars: [AvatarData] = [
        AvatarData(id: 4, name: "소설작가", icon: "book.fill", color: .primaryBlue, lastUsed: "신규"),
        AvatarData(id: 5, name: "여행가이드", icon: "airplane", color: .accentPink, lastUsed: "신규"),
        AvatarData(id: 6, name: "음악코치", icon: "music.note", color: .accentTeal, lastUsed: "신규"),
        AvatarData(id: 7, name: "요리사", icon: "flame.fill", color: .accentYellow, lastUsed: "신규")
    ]
    
    var body: some View {
        ZStack {
            // 배경 블러
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            // 실제 시트 콘텐츠
            VStack(spacing: 0) {
                // 핸들
                RoundedRectangle(cornerRadius: 2.5)
                    .fill(Color.gray.opacity(0.6))
                    .frame(width: 36, height: 5)
                    .padding(.top, 10)
                    .padding(.bottom, 20)
                
                // 타이틀
                Text("새 채팅")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.bottom, 16)
                
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                        .padding(.leading, 8)
                    
                    TextField("아바타 검색", text: $searchText)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                    
                    if !searchText.isEmpty {
                        Button(action: {
                            searchText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 16))
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                    }
                }
                .background(Color.darkBackgroundSecondary)
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                // 추천 아바타
                VStack(alignment: .leading, spacing: 16) {
                    Text("추천 아바타")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.leading, 20)
                    
                    // 아바타 그리드 보기
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(recommendedAvatars) { avatar in
                            RecommendedAvatarItem(avatar: avatar)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // 커스텀 아바타 만들기 버튼
                    Button(action: {
                        // 커스텀 아바타 만들기 액션
                    }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 20))
                            
                            Text("커스텀 아바타 만들기")
                                .font(.system(size: 16, weight: .medium))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 10)
            .background(Color.darkBackground)
            .cornerRadius(24, corners: [.topLeft, .topRight])
            .frame(height: 500)
            .frame(maxWidth: .infinity)
            .transition(.move(edge: .bottom))
            .offset(y: isPresented ? 0 : 500)
        }
        .ignoresSafeArea(.all, edges: .bottom)
    }
    
    // 추천 아바타 아이템
    struct RecommendedAvatarItem: View {
        let avatar: AvatarData
        @State private var isPressed = false
        
        var body: some View {
            Button(action: {
                // 아바타 선택 액션
            }) {
                HStack(spacing: 12) {
                    // 아바타 이미지
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [avatar.color, avatar.color.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: avatar.icon)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(avatar.name)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white)
                        
                        Text(avatar.lastUsed)
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.darkBackgroundSecondary.opacity(isPressed ? 0.5 : 0.3))
                )
                .scaleEffect(isPressed ? 0.98 : 1.0)
            }
            .buttonStyle(PlainButtonStyle())
            .onTapGesture {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isPressed = true
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isPressed = false
                    }
                }
            }
        }
    }
}

// 채팅 상세 뷰
struct ChatDetailView: View {
    let chat: ChatData
    @Binding var isPresented: Bool
    @State private var messageText = ""
    @State private var messages: [MessageData] = []
    @State private var showOptions = false
    @State private var isTyping = false
    @State private var isSending = false
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // 채팅 헤더
                ChatDetailHeaderView(
                    chat: chat,
                    onBack: {
                        isPresented = false
                    },
                    onOptions: {
                        showOptions = true
                    }
                )
                
                // 메시지 리스트
                ScrollView {
                    VStack(spacing: 16) {
                        // 시스템 메시지
                        HStack {
                            Spacer()
                            
                            Text("오늘")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .padding(.vertical, 4)
                                .padding(.horizontal, 12)
                                .background(Color.darkBackgroundSecondary.opacity(0.6))
                                .cornerRadius(10)
                            
                            Spacer()
                        }
                        .padding(.vertical, 10)
                        
                        // 샘플 메시지
                        ForEach(sampleMessages) { message in
                            ChatMessageBubble(message: message, avatarColor: chat.color)
                        }
                        
                        // 실제 주고받은 메시지
                        ForEach(messages) { message in
                            ChatMessageBubble(message: message, avatarColor: chat.color)
                        }
                        
                        // 상대방 입력 중 표시
                        if isTyping {
                            HStack {
                                // 아바타 이미지
                                Circle()
                                    .fill(chat.color)
                                    .frame(width: 30, height: 30)
                                    .overlay(
                                        Image(systemName: chat.avatarIcon)
                                            .font(.system(size: 14))
                                            .foregroundColor(.white)
                                    )
                                
                                // 입력 중 애니메이션
                                HStack(spacing: 4) {
                                    ForEach(0..<3) { index in
                                        Circle()
                                            .fill(Color.gray)
                                            .frame(width: 6, height: 6)
                                            .opacity(0.5)
                                            .scaleEffect(isTyping ? 1.0 : 0.8)
                                            .animation(
                                                Animation
                                                    .easeInOut(duration: 0.4)
                                                    .repeatForever()
                                                    .delay(Double(index) * 0.2),
                                                value: isTyping
                                            )
                                    }
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.darkBackgroundSecondary)
                                .cornerRadius(16)
                                
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        // 하단 여백
                        Spacer(minLength: 60)
                    }
                    .padding(.vertical, 8)
                }
                
                // 메시지 입력 영역
                MessageInputView(
                    messageText: $messageText,
                    onSend: sendMessage
                )
            }
            
            // 채팅 옵션 시트
            if showOptions {
                ChatOptionsView(isPresented: $showOptions)
            }
        }
        .onAppear {
            // 입력 중 시뮬레이션
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isTyping = true
                
                // 메시지 응답 시뮬레이션
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    isTyping = false
                    messages.append(
                        MessageData(
                            id: UUID().uuidString,
                            content: "안녕하세요! 무엇을 도와드릴까요?",
                            isFromMe: false,
                            timestamp: Date()
                        )
                    )
                }
            }
        }
    }
    
    // 메시지 전송 함수
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // 내 메시지 추가
        let message = MessageData(
            id: UUID().uuidString,
            content: messageText,
            isFromMe: true,
            timestamp: Date()
        )
        
        messages.append(message)
        messageText = ""
        isSending = true
        
        // 상대방 응답 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            isSending = false
            isTyping = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                isTyping = false
                
                let responses = [
                    "네, 물론이죠. 더 자세히 설명해주시겠어요?",
                    "도움이 필요하신 부분이 있으신가요?",
                    "흥미로운 질문이네요. 생각해볼게요.",
                    "알겠습니다. 그에 대해 더 알려드릴게요.",
                    "좋은 질문이에요. 제가 도와드릴게요."
                ]
                
                let responseMessage = MessageData(
                    id: UUID().uuidString,
                    content: responses.randomElement() ?? "알겠습니다.",
                    isFromMe: false,
                    timestamp: Date()
                )
                
                messages.append(responseMessage)
            }
        }
    }
    
    // 샘플 메시지
    var sampleMessages: [MessageData] {
        [
            MessageData(
                id: "1",
                content: "안녕하세요!",
                isFromMe: true,
                timestamp: Date().addingTimeInterval(-3600)
            ),
            MessageData(
                id: "2",
                content: "반갑습니다! 저는 \(chat.name)입니다. 어떻게 도와드릴까요?",
                isFromMe: false,
                timestamp: Date().addingTimeInterval(-3500)
            )
        ]
    }
}

// 메시지 버블 뷰
struct ChatMessageBubble: View {
    let message: MessageData
    let avatarColor: Color
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 12) {
            if !message.isFromMe {
                // 상대방 아바타 (메시지가 내가 보낸 것이 아닐 때만)
                Circle()
                    .fill(avatarColor)
                    .frame(width: 30, height: 30)
                
                // 메시지 내용
                VStack(alignment: .leading, spacing: 4) {
                    Text(message.content)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.darkBackgroundSecondary)
                        .cornerRadius(18, corners: [.topRight, .bottomLeft, .bottomRight])
                    
                    // 시간 표시
                    Text(formattedTime(from: message.timestamp))
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .padding(.leading, 4)
                }
                
                Spacer()
            } else {
                // 내 메시지
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.content)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryPurple.opacity(0.9), Color.primaryBlue.opacity(0.9)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(18, corners: [.topLeft, .topRight, .bottomLeft])
                    
                    // 시간 표시
                    Text(formattedTime(from: message.timestamp))
                        .font(.system(size: 10))
                        .foregroundColor(.gray)
                        .padding(.trailing, 4)
                }
            }
        }
        .padding(.horizontal, 20)
        .id(message.id) // 스크롤 식별용
    }
    
    // 시간 포맷팅
    private func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// 메시지 입력 뷰
struct MessageInputView: View {
    @Binding var messageText: String
    let onSend: () -> Void
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.gray.opacity(0.3))
            
            HStack(spacing: 12) {
                // 첨부 파일 버튼
                Button(action: {
                    // 첨부 파일 액션
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray)
                }
                
                // 메시지 입력 필드
                TextField("메시지 입력...", text: $messageText)
                    .font(.system(size: 16))
                    .padding(10)
                    .background(Color.darkBackgroundSecondary)
                    .cornerRadius(18)
                    .focused($isFocused)
                
                // 전송 버튼
                Button(action: {
                    onSend()
                    isFocused = false
                }) {
                    Circle()
                        .fill(
                            messageText.isEmpty ?
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.5)]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "arrow.up")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundColor(.white)
                        )
                }
                .disabled(messageText.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .background(Color.darkBackground)
    }
}

// 채팅 상세 헤더 뷰
struct ChatDetailHeaderView: View {
    let chat: ChatData
    let onBack: () -> Void
    let onOptions: () -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            // 뒤로가기 버튼
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            // 아바타 이미지
            ZStack {
                Circle()
                    .fill(chat.color)
                    .frame(width: 36, height: 36)
                
                Image(systemName: chat.avatarIcon)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                // 온라인 상태 표시
                if chat.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 10, height: 10)
                        .overlay(
                            Circle()
                                .stroke(Color.darkBackground, lineWidth: 2)
                        )
                        .offset(x: 14, y: 14)
                }
            }
            
            // 채팅 정보
            VStack(alignment: .leading, spacing: 2) {
                Text(chat.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(chat.isOnline ? "온라인" : "오프라인")
                    .font(.system(size: 12))
                    .foregroundColor(chat.isOnline ? .green : .gray)
            }
            
            Spacer()
            
            // 음성 통화 버튼
            Button(action: {
                // 음성 통화 액션
            }) {
                Image(systemName: "phone")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .padding(8)
            }
            
            // 더보기 버튼
            Button(action: onOptions) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .rotationEffect(.degrees(90))
                    .padding(8)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.darkBackground)
    }
}

// 채팅 옵션 뷰
struct ChatOptionsView: View {
    @Binding var isPresented: Bool
    
    var body: some View {
        ZStack {
            // 배경 블러
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        isPresented = false
                    }
                }
            
            // 옵션 메뉴
            VStack(spacing: 0) {
                // 옵션 항목들
                ForEach(chatOptions, id: \.title) { option in
                    Button(action: {
                        // 옵션 실행
                        isPresented = false
                    }) {
                        HStack {
                            Image(systemName: option.icon)
                                .font(.system(size: 18))
                                .foregroundColor(option.color)
                                .frame(width: 24)
                            
                            Text(option.title)
                                .font(.system(size: 16))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                        .padding(.vertical, 14)
                        .padding(.horizontal, 20)
                    }
                    
                    if option != chatOptions.last {
                        Divider()
                            .background(Color.gray.opacity(0.2))
                            .padding(.horizontal, 20)
                    }
                }
                
                // 취소 버튼
                Button(action: {
                    withAnimation {
                        isPresented = false
                    }
                }) {
                    Text("취소")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                }
                .padding(.top, 8)
            }
            .background(Color.darkBackgroundSecondary)
            .cornerRadius(16)
            .padding(.horizontal, 20)
            .transition(.scale.combined(with: .opacity))
            .scaleEffect(isPresented ? 1.0 : 0.9)
            .opacity(isPresented ? 1.0 : 0)
        }
        .animation(.spring(response: 0.3), value: isPresented)
    }
    
    // 채팅 옵션 목록
    var chatOptions: [ChatOptionItem] {
        [
            ChatOptionItem(title: "대화 내보내기", icon: "square.and.arrow.up", color: .accentTeal),
            ChatOptionItem(title: "대화 저장", icon: "bookmark", color: .accentYellow),
            ChatOptionItem(title: "알림 끄기", icon: "bell.slash", color: .accentPink),
            ChatOptionItem(title: "아바타 편집", icon: "pencil", color: .primaryBlue),
            ChatOptionItem(title: "차단", icon: "hand.raised", color: .red)
        ]
    }
    
    // 채팅 옵션 아이템 모델
    struct ChatOptionItem: Equatable {
        let title: String
        let icon: String
        let color: Color
    }
}

// 빈 채팅 뷰
struct EmptyChatView: View {
    let category: String
    
    var body: some View {
        VStack(spacing: 20) {
            // 일러스트 이미지
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 60))
                .foregroundColor(.gray.opacity(0.5))
                .padding(.top, 40)
            
            // 설명 텍스트
            Text("\(category) 카테고리에 대화가 없습니다")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            // 액션 버튼
            Button(action: {
                // 새 채팅 시작 액션
            }) {
                Text("새 대화 시작하기")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 20)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(16)
            }
            .padding(.top, 10)
        }
        .frame(maxWidth: .infinity)
        .padding(20)
    }
}

// 당겨서 새로고침 뷰
struct RefreshingView: View {
    @Binding var isComplete: Bool
    
    var body: some View {
        HStack(spacing: 15) {
            if isComplete {
                // 완료 시 체크 표시
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(Color.accentTeal)
                
                Text("새로고침 완료")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            } else {
                // 로딩 표시
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: Color.accentTeal))
                    .scaleEffect(1.2)
                
                Text("새로고침 중...")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
        }
        .frame(height: 50)
        .frame(maxWidth: .infinity)
    }
}

// 스크롤 오프셋 프리퍼런스 키
struct ScrollOffsetPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

// Using RoundedCorner shape defined elsewhere in the app

// 아바타 데이터 모델
struct AvatarData: Identifiable {
    let id: Int
    let name: String
    let icon: String
    let color: Color
    let lastUsed: String
}

// 채팅 데이터 모델
struct ChatData: Identifiable {
    let id: Int
    let name: String
    let avatarIcon: String
    let preview: String
    let time: String
    let color: Color
    let unreadCount: Int
    let isOnline: Bool
}

// 메시지 데이터 모델
struct MessageData: Identifiable {
    let id: String
    let content: String
    let isFromMe: Bool
    let timestamp: Date
}

