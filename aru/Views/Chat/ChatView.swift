import SwiftUI

struct ChatView: View {
    // 상태 변수
    @State private var messageText = ""
    @State private var messages: [ChatMessageData] = []
    @State private var isTyping = false
    @State private var showSidebar = false
    @State private var selectedCategory = "AI 어시스턴트"
    @State private var showQuickTools = false
    
    // 카테고리
    let categories = ["AI 어시스턴트", "패션 조언", "코디 추천", "트렌드", "쇼핑"]
    
    // 샘플 메시지 생성 - ChatGPT 스타일 첫 메시지
    private let welcomeMessage = ChatMessageData(
        id: 1, 
        text: "안녕하세요! 오늘 어떤 도움이 필요하신가요?", 
        isFromMe: false, 
        timestamp: Date()
    )
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 헤더
                chatHeaderView
                
                // 메시지 영역
                ScrollViewReader { scrollView in
                    ScrollView {
                        VStack(spacing: 18) {
                            // 상단 카테고리 선택 영역
                            categoryScrollView
                                .padding(.vertical, 10)
                                .padding(.horizontal, 10)
                            
                            // 메시지 목록
                            LazyVStack(spacing: 18) {
                                if messages.isEmpty {
                                    // 웰컴 카드 - 첫 방문 시
                                    welcomeCardView
                                        .padding(.horizontal, 16)
                                        .padding(.top, 10)
                                } else {
                                    // 메시지 버블
                                    ForEach(messages) { message in
                                        MessageBubble(message: message, chatColor: .primaryPurple)
                                            .id(message.id)
                                    }
                                }
                                
                                // 입력 중 표시
                                if isTyping {
                                    HStack(alignment: .bottom, spacing: 8) {
                                        // 아바타 아이콘
                                        ZStack {
                                            Circle()
                                                .fill(
                                                    LinearGradient(
                                                        gradient: Gradient(colors: [Color.primaryPurple, Color.primaryPurple.opacity(0.7)]),
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing
                                                    )
                                                )
                                                .frame(width: 32, height: 32)
                                            
                                            Image(systemName: "bubble.left.fill")
                                                .font(.system(size: 16))
                                                .foregroundColor(.white)
                                        }
                                        
                                        // 입력 중 애니메이션
                                        HStack(spacing: 4) {
                                            ForEach(0..<3) { i in
                                                Circle()
                                                    .fill(Color.gray)
                                                    .frame(width: 7, height: 7)
                                                    .opacity(0.6)
                                                    .scaleEffect(isTyping ? 1.2 : 0.8)
                                                    .animation(Animation.easeInOut(duration: 0.6).repeatForever().delay(Double(i) * 0.2), value: isTyping)
                                            }
                                        }
                                        .padding(.vertical, 14)
                                        .padding(.horizontal, 18)
                                        .background(Color.darkBackgroundSecondary)
                                        .cornerRadius(20)
                                        
                                        Spacer()
                                    }
                                    .padding(.horizontal, 16)
                                    .id("typing")
                                }
                                
                                // 스크롤 위치 조정을 위한 빈 뷰
                                Color.clear
                                    .frame(height: 1)
                                    .id("bottomID")
                            }
                            .padding(.horizontal, 4)
                            
                            Spacer(minLength: 60)
                        }
                    }
                    .onAppear {
                        // 메시지가 추가되면 스크롤 아래로
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation {
                                scrollView.scrollTo("bottomID", anchor: .bottom)
                            }
                        }
                    }
                    .onChange(of: messages.count) { _ in
                        // 새 메시지가 추가되면 스크롤 아래로
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            withAnimation {
                                scrollView.scrollTo("bottomID", anchor: .bottom)
                            }
                        }
                    }
                }
                
                // 퀵 액세스 툴바 (확장 시)
                if showQuickTools {
                    quickAccessToolbarView
                        .transition(.move(edge: .bottom))
                }
                
                // 입력 영역
                messageInputView
            }
            
            // 사이드 메뉴
            sideMenuView
        }
        .animation(.spring(), value: showQuickTools)
        .animation(.spring(), value: showSidebar)
        .onAppear {
            // 웰컴 메시지 표시
            if messages.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    isTyping = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        withAnimation {
                            isTyping = false
                            messages.append(welcomeMessage)
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 컴포넌트 뷰
    
    // 채팅 헤더 뷰
    var chatHeaderView: some View {
        HStack {
            // 타이틀
            Text("채팅")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .padding(.leading, 16)
            
            Spacer()
            
            // 메뉴 버튼
            Button(action: {
                withAnimation(.spring()) {
                    showSidebar.toggle()
                }
            }) {
                Image(systemName: "line.horizontal.3")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.darkBackgroundSecondary.opacity(0.8))
                    .clipShape(Circle())
            }
            .padding(.trailing, 16)
        }
        .padding(.vertical, 14)
        .background(Color.darkBackground)
    }
    
    // 카테고리 스크롤 뷰
    var categoryScrollView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(categories, id: \.self) { category in
                    Button(action: {
                        withAnimation {
                            selectedCategory = category
                            // 카테고리 변경 시 새 프롬프트 추가
                            messages = []
                            isTyping = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                withAnimation {
                                    isTyping = false
                                    messages.append(ChatMessageData(
                                        id: 1, 
                                        text: "\(category)입니다. 무엇을 도와드릴까요?", 
                                        isFromMe: false, 
                                        timestamp: Date()
                                    ))
                                }
                            }
                        }
                    }) {
                        Text(category)
                            .font(.system(size: 15, weight: selectedCategory == category ? .semibold : .regular))
                            .foregroundColor(selectedCategory == category ? .white : .gray)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                selectedCategory == category ?
                                    Capsule().fill(Color.primaryPurple.opacity(0.3)) :
                                    Capsule().fill(Color.darkBackgroundSecondary)
                            )
                    }
                }
            }
            .padding(.horizontal, 6)
        }
    }
    
    // 메시지 입력 뷰
    var messageInputView: some View {
        VStack(spacing: 0) {
            // 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 0.5)
            
            HStack(spacing: 12) {
                // 첨부 버튼
                Button(action: {
                    withAnimation {
                        showQuickTools.toggle()
                    }
                }) {
                    Image(systemName: showQuickTools ? "chevron.down" : "plus.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.primaryPurple)
                        .frame(width: 32, height: 32)
                }
                .padding(.leading, 4)
                
                // 텍스트 입력
                ZStack(alignment: .trailing) {
                    TextField("메시지 입력...", text: $messageText)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.darkBackgroundSecondary)
                        .cornerRadius(20)
                    
                    if !messageText.isEmpty {
                        Button(action: {
                            messageText = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 14)
                        }
                    }
                }
                
                // 전송 버튼
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(messageText.isEmpty ? .gray : .primaryPurple)
                }
                .disabled(messageText.isEmpty)
                .padding(.trailing, 8)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color.darkBackground)
        }
    }
    
    // 웰컴 카드 뷰
    var welcomeCardView: some View {
        VStack(spacing: 16) {
            // 아이콘 및 제목
            VStack(spacing: 12) {
                Image(systemName: "bubble.left.and.bubble.right.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.primaryPurple)
                
                Text("ARU 챗 어시스턴트")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
                
                Text("AI를 통해 패션, 쇼핑, 스타일링에 대한 도움을 받아보세요")
                    .font(.system(size: 15))
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            .padding(.vertical, 20)
            
            // 주요 기능 소개
            VStack(spacing: 16) {
                featureRow(icon: "tshirt", title: "맞춤 스타일링", description: "당신의 스타일과 체형에 맞는 패션 조언을 받아보세요")
                featureRow(icon: "cart", title: "쇼핑 도우미", description: "원하는 아이템을 찾고 합리적인 가격으로 구매하세요")
                featureRow(icon: "chart.bar", title: "트렌드 분석", description: "최신 패션 트렌드와 인기 아이템을 확인하세요")
            }
            .padding(.vertical, 10)
            
            // 시작 버튼
            Button(action: {
                // 아무것도 안함 - 사용자가 메시지를 입력하도록 유도
            }) {
                Text("메시지를 입력하여 시작하세요")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.vertical, 12)
                    .padding(.horizontal, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.primaryPurple.opacity(0.8))
                    )
            }
            .padding(.top, 10)
            .padding(.bottom, 20)
        }
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.darkBackgroundSecondary.opacity(0.8))
        )
    }
    
    // 기능 소개 행
    func featureRow(icon: String, title: String, description: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(.primaryPurple)
                .frame(width: 34, height: 34)
                .background(Color.primaryPurple.opacity(0.2))
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                Text(description)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                    .lineLimit(2)
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
    
    // 퀵 액세스 툴바
    var quickAccessToolbarView: some View {
        VStack(spacing: 0) {
            // 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 0.5)
            
            // 툴바 버튼들
            HStack(spacing: 20) {
                quickToolButton(icon: "photo", label: "이미지")
                quickToolButton(icon: "camera", label: "카메라")
                quickToolButton(icon: "doc", label: "파일")
                quickToolButton(icon: "location", label: "위치")
                quickToolButton(icon: "paintpalette", label: "스타일")
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color.darkBackground)
        }
    }
    
    // 퀵 툴 버튼
    func quickToolButton(icon: String, label: String) -> some View {
        Button(action: {
            // 각 도구 기능 구현
            withAnimation {
                showQuickTools = false
            }
        }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.primaryPurple.opacity(0.2))
                    .clipShape(Circle())
                
                Text(label)
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    // 사이드 메뉴 뷰
    var sideMenuView: some View {
        ZStack(alignment: .trailing) {
            if showSidebar {
                // 배경 오버레이
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation(.spring()) {
                            showSidebar = false
                        }
                    }
                
                // 사이드 메뉴 패널
                VStack(spacing: 0) {
                    // 헤더
                    HStack {
                        Text("설정")
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                        
                        Spacer()
                        
                        Button(action: {
                            withAnimation(.spring()) {
                                showSidebar = false
                            }
                        }) {
                            Image(systemName: "xmark")
                                .font(.system(size: 20))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    
                    // 구분선
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 0.5)
                    
                    // 메뉴 항목
                    ScrollView {
                        VStack(spacing: 0) {
                            menuItem(icon: "person.crop.circle", title: "프로필 설정")
                            menuItem(icon: "gear", title: "앱 설정")
                            menuItem(icon: "bell", title: "알림 설정")
                            menuItem(icon: "lock", title: "개인정보 및 보안")
                            menuItem(icon: "ellipsis.bubble", title: "챗 기록 관리")
                            menuItem(icon: "square.and.arrow.up", title: "대화 내보내기")
                            menuItem(icon: "trash", title: "대화 초기화")
                        }
                    }
                    
                    Spacer()
                    
                    // 앱 버전
                    VStack(spacing: 5) {
                        Text("ARU 챗 버전 1.0.2")
                            .font(.system(size: 14))
                            .foregroundColor(.gray)
                        
                        Text("© 2025 ARU Inc. All rights reserved.")
                            .font(.system(size: 12))
                            .foregroundColor(.gray.opacity(0.7))
                    }
                    .padding(.bottom, 30)
                }
                .frame(width: UIScreen.main.bounds.width * 0.75)
                .background(Color.darkBackground)
                .transition(.move(edge: .trailing))
            }
        }
    }
    
    // 메뉴 항목
    func menuItem(icon: String, title: String) -> some View {
        Button(action: {
            // 메뉴 항목 액션
        }) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                    .frame(width: 24, height: 24)
                
                Text(title)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
        }
    }
    
    // MARK: - 기능 메서드
    
    // 메시지 전송
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // 사용자 메시지 추가
        let userMessage = ChatMessageData(
            id: (messages.last?.id ?? 0) + 1,
            text: messageText,
            isFromMe: true,
            timestamp: Date()
        )
        
        withAnimation {
            messages.append(userMessage)
            messageText = ""
        }
        
        // AI 응답 시뮬레이션
        isTyping = true
        
        // 챗봇 응답 후 타이핑 표시기 제거
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let responseText: String
            
            // 카테고리별 응답
            switch selectedCategory {
            case "패션 조언":
                responseText = "패션에 관한 질문이군요! 당신의 스타일과 체형에 맞는 제안을 해드릴게요. 더 구체적인 정보를 알려주시면 더 정확한 조언이 가능합니다."
            case "코디 추천":
                responseText = "코디 추천을 원하시는군요! 어떤 상황이나 분위기에 맞는 코디를 찾고 계신가요? TPO에 맞는 최적의 스타일을 제안해 드릴게요."
            case "트렌드":
                responseText = "최신 트렌드에 관심이 있으시군요! 현재 2025년 패션 트렌드는 지속가능한 패션과 Y2K 스타일의 재해석이 주목받고 있어요. 어떤 트렌드에 관심이 있으신가요?"
            case "쇼핑":
                responseText = "쇼핑 도움이 필요하신가요? 어떤 아이템을 찾고 계신지 알려주시면, 합리적인 가격대와 품질이 좋은 제품을 추천해 드릴게요."
            default:
                responseText = "질문해 주셔서 감사합니다! 패션, 스타일링, 트렌드, 쇼핑 등 다양한 주제에 대해 도움을 드릴 수 있어요. 더 구체적인 질문이 있으시면 언제든지 물어보세요."
            }
            
            withAnimation {
                isTyping = false
                messages.append(ChatMessageData(
                    id: (messages.last?.id ?? 0) + 1,
                    text: responseText,
                    isFromMe: false,
                    timestamp: Date()
                ))
            }
        }
    }
}

// 메시지 버블 뷰
struct MessageBubble: View {
    let message: ChatMessageData
    let chatColor: Color
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromMe {
                Spacer()
                
                // 사용자 메시지
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.text)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.primaryPurple, Color.primaryBlue]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(18, corners: [.topLeft, .topRight, .bottomLeft])
                        .cornerRadius(4, corners: [.bottomRight])
                    
                    Text(formatTime(date: message.timestamp))
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }
            } else {
                // AI 메시지
                HStack(alignment: .bottom, spacing: 8) {
                    // 아바타 아이콘
                    ZStack {
                        Circle()
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [chatColor, chatColor.opacity(0.7)]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 32, height: 32)
                        
                        Image(systemName: "bubble.left.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.text)
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.darkBackgroundSecondary)
                            .cornerRadius(18, corners: [.topRight, .bottomRight, .bottomLeft])
                            .cornerRadius(4, corners: [.topLeft])
                        
                        Text(formatTime(date: message.timestamp))
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 16)
    }
    
    // 시간 포맷팅
    private func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// MARK: - Extensions
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect, 
            byRoundingCorners: corners, 
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

// MARK: - 프리뷰
struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
            .preferredColorScheme(.dark)
    }
}