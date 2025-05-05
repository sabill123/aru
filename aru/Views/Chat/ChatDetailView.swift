import SwiftUI

struct ChatDetailView: View {
    let chat: ChatData
    @Binding var isPresented: Bool
    
    @State private var messageText = ""
    @State private var messages: [ChatMessageData] = []
    @State private var isTyping = false
    @State private var scrollToBottom = false
    
    // 샘플 메시지 생성
    private let sampleMessages = [
        ChatMessageData(id: 1, text: "안녕하세요! 무엇을 도와드릴까요?", isFromMe: false, timestamp: Date().addingTimeInterval(-3600)),
        ChatMessageData(id: 2, text: "요즘 유행하는 패션 스타일 알려줄래?", isFromMe: true, timestamp: Date().addingTimeInterval(-3500)),
        ChatMessageData(id: 3, text: "물론이죠! 요즘 MZ세대 사이에서는 Y2K 스타일과 미니멀한 스트리트 패션이 인기예요. 특히 오버사이즈 티셔츠, 와이드 팬츠, 크롭탑 등이 유행하고 있답니다. 어떤 스타일에 관심 있으세요?", isFromMe: false, timestamp: Date().addingTimeInterval(-3400))
    ]
    
    var body: some View {
        ZStack {
            // 배경
            Color.darkBackground.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // 헤더
                ChatDetailHeaderView(chat: chat, onBack: {
                    isPresented = false
                })
                
                // 메시지 영역
                ScrollView {
                    ScrollViewReader { scrollView in
                        VStack {
                            // 초기 환영 메시지
                            if messages.isEmpty {
                                VStack(spacing: 20) {
                                    // 아바타 아이콘
                                    ZStack {
                                        Circle()
                                            .fill(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [chat.color, chat.color.opacity(0.7)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .frame(width: 90, height: 90)
                                            .shadow(color: chat.color.opacity(0.4), radius: 6, x: 0, y: 3)
                                        
                                        Image(systemName: chat.avatarIcon)
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                    }
                                    .padding(.top, 60)
                                    
                                    Text(chat.name)
                                        .font(.system(size: 24, weight: .bold))
                                        .foregroundColor(.white)
                                    
                                    Text("AI 어시스턴트")
                                        .font(.system(size: 16))
                                        .foregroundColor(.gray)
                                    
                                    // 특성 태그
                                    HStack(spacing: 10) {
                                        ForEach(["스타일링", "트렌드", "패션조언"], id: \.self) { tag in
                                            Text(tag)
                                                .font(.system(size: 13))
                                                .foregroundColor(.white.opacity(0.9))
                                                .padding(.horizontal, 14)
                                                .padding(.vertical, 6)
                                                .background(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .fill(chat.color.opacity(0.3))
                                                )
                                        }
                                    }
                                    .padding(.vertical, 10)
                                    
                                    // 시작 버튼
                                    Button(action: {
                                        startConversation()
                                    }) {
                                        Text("대화 시작하기")
                                            .font(.system(size: 16, weight: .semibold))
                                            .foregroundColor(.white)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 30)
                                            .background(
                                                LinearGradient(
                                                    gradient: Gradient(colors: [chat.color, chat.color.opacity(0.7)]),
                                                    startPoint: .topLeading,
                                                    endPoint: .bottomTrailing
                                                )
                                            )
                                            .cornerRadius(24)
                                            .shadow(color: chat.color.opacity(0.3), radius: 4, x: 0, y: 2)
                                    }
                                    .padding(.top, 20)
                                }
                                .padding()
                            } else {
                                // 메시지 목록
                                LazyVStack(spacing: 18) {
                                    // 시스템 메시지 (날짜 표시)
                                    HStack {
                                        Spacer()
                                        Text("오늘")
                                            .font(.system(size: 12))
                                            .foregroundColor(.gray)
                                            .padding(.vertical, 5)
                                            .padding(.horizontal, 14)
                                            .background(Color.darkBackgroundSecondary)
                                            .cornerRadius(12)
                                        Spacer()
                                    }
                                    .padding(.vertical, 14)
                                    .id("dateHeader")
                                    
                                    // 메시지 버블
                                    ForEach(messages) { message in
                                        ChatDetailMessageBubble(message: message, chatColor: chat.color)
                                            .id(message.id)
                                    }
                                    
                                    // 입력 중 표시
                                    if isTyping {
                                        HStack(alignment: .bottom, spacing: 8) {
                                            // 아바타 아이콘
                                            ZStack {
                                                Circle()
                                                    .fill(
                                                        LinearGradient(
                                                            gradient: Gradient(colors: [chat.color, chat.color.opacity(0.7)]),
                                                            startPoint: .topLeading,
                                                            endPoint: .bottomTrailing
                                                        )
                                                    )
                                                    .frame(width: 32, height: 32)
                                                
                                                Image(systemName: chat.avatarIcon)
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
                                        .padding(.horizontal)
                                        .id("typing")
                                    }
                                    
                                    // 스크롤 위치 조정을 위한 빈 뷰
                                    Color.clear
                                        .frame(height: 1)
                                        .id("bottomID")
                                }
                                .padding(.horizontal, 4)
                            }
                        }
                        .onAppear {
                            // 메시지가 추가되면 스크롤 아래로
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation {
                                    scrollView.scrollTo("bottomID", anchor: .bottom)
                                }
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
                            // 키보드가 표시될 때 스크롤 아래로
                            withAnimation {
                                scrollView.scrollTo("bottomID", anchor: .bottom)
                            }
                        }
                        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ScrollToBottom"))) { _ in
                            // 메시지 추가 시 스크롤 아래로
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation {
                                    scrollView.scrollTo("bottomID", anchor: .bottom)
                                }
                            }
                        }
                    }
                }
                
                // 입력 영역
                MessageInputView(text: $messageText, onSend: sendMessage)
            }
        }
        .onAppear {
            // 타이핑 시작 애니메이션
            isTyping = messages.isEmpty
        }
    }
    
    // 대화 시작 함수
    private func startConversation() {
        isTyping = true
        
        // 2초 후 첫 메시지 표시
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isTyping = false
                messages.append(sampleMessages[0])
                NotificationCenter.default.post(name: NSNotification.Name("ScrollToBottom"), object: nil)
            }
        }
    }
    
    // 메시지 전송 함수
    private func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // 사용자 메시지 추가
        let userMessage = ChatMessageData(
            id: messages.count + 1,
            text: messageText,
            isFromMe: true,
            timestamp: Date()
        )
        
        withAnimation {
            messages.append(userMessage)
            messageText = ""
        }
        
        // 스크롤을 아래로 이동시키기 위해 노티피케이션 발송
        NotificationCenter.default.post(name: NSNotification.Name("ScrollToBottom"), object: nil)
        
        // 챗봇 응답 시뮬레이션
        isTyping = true
        
        // 1.5초 후 응답 표시
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation {
                isTyping = false
                
                // 응답 선택
                if messages.count == 1 {
                    messages.append(sampleMessages[1])
                    NotificationCenter.default.post(name: NSNotification.Name("ScrollToBottom"), object: nil)
                    
                    // 두 번째 응답을 2초 후에 보내기
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isTyping = true
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isTyping = false
                                messages.append(sampleMessages[2])
                                NotificationCenter.default.post(name: NSNotification.Name("ScrollToBottom"), object: nil)
                            }
                        }
                    }
                } else {
                    messages.append(sampleMessages[2])
                    NotificationCenter.default.post(name: NSNotification.Name("ScrollToBottom"), object: nil)
                }
            }
        }
    }
}

// 헤더 뷰
struct ChatDetailHeaderView: View {
    let chat: ChatData
    let onBack: () -> Void
    
    @State private var showOptions = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // 뒤로가기 버튼
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.darkBackgroundSecondary)
                    .clipShape(Circle())
            }
            
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
                    .frame(width: 42, height: 42)
                    .shadow(color: chat.color.opacity(0.3), radius: 2, x: 0, y: 1)
                
                Image(systemName: chat.avatarIcon)
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                
                // 온라인 상태 표시
                if chat.isOnline {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 12, height: 12)
                        .overlay(
                            Circle()
                                .stroke(Color.black, lineWidth: 2)
                        )
                        .position(x: 34, y: 34)
                }
            }
            
            // 이름 및 상태
            VStack(alignment: .leading, spacing: 2) {
                Text(chat.name)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(chat.isOnline ? "온라인" : "오프라인")
                    .font(.system(size: 12))
                    .foregroundColor(chat.isOnline ? .green : .gray)
            }
            
            Spacer()
            
            // 메뉴 버튼
            Button(action: {
                showOptions.toggle()
            }) {
                Image(systemName: "ellipsis")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.darkBackgroundSecondary)
                    .clipShape(Circle())
            }
            .actionSheet(isPresented: $showOptions) {
                ActionSheet(
                    title: Text("옵션"),
                    message: nil,
                    buttons: [
                        .default(Text("대화 내보내기")),
                        .default(Text("대화 삭제하기")),
                        .cancel(Text("취소"))
                    ]
                )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background(Color.darkBackground)
    }
}

// 메시지 입력 뷰
struct MessageInputView: View {
    @Binding var text: String
    let onSend: () -> Void
    
    @State private var showAttachOptions = false
    
    var body: some View {
        VStack {
            // 구분선
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
            
            HStack(spacing: 12) {
                // 첨부 버튼
                Button(action: {
                    showAttachOptions.toggle()
                }) {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.primaryPurple)
                }
                
                // 텍스트 입력
                ZStack(alignment: .trailing) {
                    TextField("메시지 입력...", text: $text)
                        .font(.system(size: 15))
                        .foregroundColor(.white)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(Color.darkBackgroundSecondary)
                        .cornerRadius(20)
                    
                    if !text.isEmpty {
                        Button(action: {
                            text = ""
                        }) {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 14)
                        }
                    }
                }
                
                // 전송 버튼
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 30))
                        .foregroundColor(text.isEmpty ? .gray : .primaryPurple)
                }
                .disabled(text.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.darkBackground)
        .actionSheet(isPresented: $showAttachOptions) {
            ActionSheet(
                title: Text("첨부하기"),
                message: nil,
                buttons: [
                    .default(Text("사진 첨부")),
                    .default(Text("파일 첨부")),
                    .default(Text("위치 공유")),
                    .cancel(Text("취소"))
                ]
            )
        }
    }
}

// 메시지 버블 뷰 (renamed to avoid conflict)
struct ChatDetailMessageBubble: View {
    let message: ChatMessageData
    let chatColor: Color
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromMe {
                Spacer()
                
                // 사용자 메시지
                VStack(alignment: .trailing, spacing: 4) {
                    Text(message.text)
                        .font(.system(size: 15))
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
                        .font(.system(size: 11))
                        .foregroundColor(.gray)
                }
            } else {
                // AI 메시지
                HStack(alignment: .bottom, spacing: 8) {
                    // 아바타 아이콘 (첫 메시지만 표시)
                    if message.id == 1 || message.id > 2 {
                        ZStack {
                            Circle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [chatColor, chatColor.opacity(0.7)]),
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 30, height: 30)
                            
                            Image(systemName: "tshirt")
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                        }
                    } else {
                        Spacer().frame(width: 30) // 아이콘 공간을 차지하기 위한 빈 공간
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(message.text)
                            .font(.system(size: 15))
                            .foregroundColor(.white)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 10)
                            .background(Color.darkBackgroundSecondary)
                            .cornerRadius(18, corners: [.topRight, .bottomRight, .bottomLeft])
                            .cornerRadius(4, corners: [.topLeft])
                        
                        Text(formatTime(date: message.timestamp))
                            .font(.system(size: 11))
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 12)
    }
    
    // 시간 포맷팅
    private func formatTime(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

// Helper extension for cornerRadius
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