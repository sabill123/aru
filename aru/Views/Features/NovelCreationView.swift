import SwiftUI

struct NovelCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var novelTitle = ""
    @State private var novelGenre = "판타지"
    @State private var novelSetting = ""
    @State private var characters = ""
    @State private var plotOutline = ""
    @State private var isGenerating = false
    @State private var generatedNovel = ""
    
    let genres = ["판타지", "로맨스", "추리", "SF", "무협", "현대물", "역사물", "스릴러"]
    
    var body: some View {
        ZStack {
            // 배경
            SpaceBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // 상단 헤더
                    NovelHeaderView(
                        dismissAction: { presentationMode.wrappedValue.dismiss() }
                    )
                    
                    // 입력 폼
                    NovelInputFormView(
                        novelTitle: $novelTitle,
                        novelGenre: $novelGenre,
                        novelSetting: $novelSetting,
                        characters: $characters,
                        plotOutline: $plotOutline,
                        genres: genres,
                        isGenerating: isGenerating,
                        generateAction: generateNovel
                    )
                    
                    // 생성된 소설 표시
                    if !generatedNovel.isEmpty {
                        NovelOutputView(generatedNovel: generatedNovel)
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func generateNovel() {
        isGenerating = true
        
        // 실제로는 API 호출이 이루어져야 함
        // 여기서는 간단한 생성 예시로 대체
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.generatedNovel = """
            **\(novelTitle)**
            
            *\(novelGenre) 장르의 웹소설*
            
            서막:
            
            \(novelSetting.isEmpty ? "먼 미래, 과학과 마법이 공존하는 세계에서" : novelSetting)
            
            주인공 \(characters.isEmpty ? "루나" : characters.split(separator: ",").first ?? "루나")는 평화로운 일상을 살아가고 있었다. 그러던 어느 날, 갑작스러운 사건이 그의 삶을 뒤흔들기 시작한다.
            
            \(plotOutline.isEmpty ? "신비한 유물을 발견한 주인공은 자신에게 숨겨진 특별한 힘이 있음을 깨닫게 된다. 그는 이 힘을 통제하고 세상을 위협하는 어둠의 세력에 맞서기 위한 모험을 시작한다." : plotOutline)
            
            (이야기는 계속됩니다...)
            """
            self.isGenerating = false
        }
    }
}

// MARK: - 헤더 뷰
struct NovelHeaderView: View {
    let dismissAction: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        HStack {
            // 트렌디한 뒤로가기 버튼
            Button(action: dismissAction) {
                ZStack {
                    Circle()
                        .fill(Color.darkBackgroundSecondary.opacity(0.8))
                        .frame(width: 38, height: 38)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: "chevron.left")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                }
                .scaleEffect(isPressed ? 0.95 : 1.0)
            }
            .pressEffect(intensity: 0.95)
            
            Spacer()
            
            // 중앙 타이틀과 아이콘 - 현대적 스타일
            HStack(spacing: 8) {
                Image(systemName: "book.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "5E72EB"))
                
                Text("웹소설 생성")
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.darkBackgroundSecondary.opacity(0.3))
                    .shadow(color: Color(hex: "5E72EB").opacity(0.2), radius: 8, x: 0, y: 4)
            )
            
            Spacer()
            
            // 도움말 버튼
            Button(action: {
                // 도움말
            }) {
                ZStack {
                    Circle()
                        .fill(Color.darkBackgroundSecondary.opacity(0.8))
                        .frame(width: 38, height: 38)
                        .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                    
                    Image(systemName: "sparkles")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(Color(hex: "5E72EB"))
                }
            }
            .pressEffect(intensity: 0.95)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

// MARK: - 입력 폼 뷰
struct NovelInputFormView: View {
    @Binding var novelTitle: String
    @Binding var novelGenre: String
    @Binding var novelSetting: String
    @Binding var characters: String
    @Binding var plotOutline: String
    let genres: [String]
    let isGenerating: Bool
    let generateAction: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            // 제목 입력
            TitleInputView(title: $novelTitle)
            
            // 장르 선택
            GenreSelectionView(selectedGenre: $novelGenre, genres: genres)
            
            // 배경 설정
            TextAreaInputView(
                label: "배경 설정",
                text: $novelSetting,
                height: 100
            )
            
            // 등장인물
            TextAreaInputView(
                label: "등장인물",
                text: $characters,
                height: 100
            )
            
            // 줄거리 개요
            TextAreaInputView(
                label: "줄거리 개요",
                text: $plotOutline,
                height: 150
            )
            
            // 생성 버튼
            NovelGenerateButtonView(
                isGenerating: isGenerating,
                generateAction: generateAction
            )
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 제목 입력 뷰
struct TitleInputView: View {
    @Binding var title: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("제목")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            TextField("소설 제목을 입력하세요", text: $title)
                .font(.system(size: 16))
                .padding(16)
                .background(Color(hex: "1A1A32"))
                .cornerRadius(12)
                .foregroundColor(.white)
        }
    }
}

// MARK: - 장르 선택 뷰
struct GenreSelectionView: View {
    @Binding var selectedGenre: String
    let genres: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("장르")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(genres, id: \.self) { genre in
                        GenreButton(
                            genre: genre,
                            isSelected: selectedGenre == genre,
                            action: { selectedGenre = genre }
                        )
                    }
                }
            }
        }
    }
}

// MARK: - 장르 버튼
struct GenreButton: View {
    let genre: String
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            Text(genre)
                .font(.system(size: 15, weight: isSelected ? .semibold : .medium))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    ZStack {
                        if isSelected {
                            // 선택된 상태 배경
                            RoundedRectangle(cornerRadius: 20)
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(hex: "6A11CB"), Color(hex: "2575FC")]),
                                        startPoint: .leading, 
                                        endPoint: .trailing
                                    )
                                )
                                .shadow(color: Color(hex: "6A11CB").opacity(0.5), radius: 10, x: 0, y: 4)
                            
                            // 글로우 효과
                            RoundedRectangle(cornerRadius: 20)
                                .stroke(Color.white.opacity(0.3), lineWidth: 1)
                        } else {
                            // 비선택 상태 배경 - 유리 효과
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(hex: "1A1A32").opacity(isHovered ? 0.7 : 0.5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 20)
                                        .stroke(
                                            LinearGradient(
                                                gradient: Gradient(colors: [
                                                    Color.white.opacity(0.2),
                                                    Color.white.opacity(0.05)
                                                ]),
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            ),
                                            lineWidth: 1
                                        )
                                )
                        }
                    }
                )
                .foregroundColor(.white)
                .scaleEffect(isHovered ? 1.05 : 1.0)
                .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isHovered)
        }
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .pressEffect(intensity: 0.95)
    }
}

// MARK: - 텍스트 영역 입력 뷰
struct TextAreaInputView: View {
    let label: String
    @Binding var text: String
    let height: CGFloat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            TextEditor(text: $text)
                .frame(height: height)
                .padding(16)
                .background(Color(hex: "1A1A32"))
                .cornerRadius(12)
                .foregroundColor(.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(hex: "2A2A42"), lineWidth: 1)
                )
        }
    }
}

// MARK: - 생성 버튼 뷰
struct NovelGenerateButtonView: View {
    let isGenerating: Bool
    let generateAction: () -> Void
    @State private var isPressed = false
    @State private var pulsateAnimation = false
    
    var body: some View {
        Button(action: generateAction) {
            ZStack {
                // 기본 배경
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "6A11CB"), Color(hex: "2575FC")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 60)
                    .shadow(color: Color(hex: "6A11CB").opacity(0.5), radius: 10, x: 0, y: 5)
                    .overlay(
                        // 글로우 오버레이
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(pulsateAnimation ? 0.4 : 0.2), lineWidth: 1)
                    )
                    .scaleEffect(isPressed ? 0.97 : 1.0)
                
                // 로딩 or 텍스트
                if isGenerating {
                    // 커스텀 로딩 UI
                    HStack(spacing: 12) {
                        // 로딩 인디케이터
                        ZStack {
                            Circle()
                                .stroke(Color.white.opacity(0.2), lineWidth: 3)
                                .frame(width: 24, height: 24)
                            
                            Circle()
                                .trim(from: 0, to: 0.7)
                                .stroke(Color.white, lineWidth: 3)
                                .frame(width: 24, height: 24)
                                .rotationEffect(Angle(degrees: pulsateAnimation ? 360 : 0))
                                .animation(
                                    Animation.linear(duration: 1)
                                        .repeatForever(autoreverses: false),
                                    value: pulsateAnimation
                                )
                        }
                        
                        Text("웹소설 생성 중...")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    }
                } else {
                    // 트렌디한 버튼 텍스트
                    HStack(spacing: 10) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        Text("AI 웹소설 생성하기")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                    }
                    .opacity(pulsateAnimation ? 1.0 : 0.9)
                    .scaleEffect(pulsateAnimation ? 1.02 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: pulsateAnimation
                    )
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isGenerating)
        .onAppear {
            withAnimation {
                pulsateAnimation = true
            }
        }
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if !isGenerating {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isPressed = true
                        }
                    }
                }
                .onEnded { _ in
                    if !isGenerating {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                            isPressed = false
                        }
                    }
                }
        )
        .padding(.top, 8)
    }
}

// MARK: - 생성된 소설 출력 뷰
struct NovelOutputView: View {
    let generatedNovel: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("생성된 웹소설")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            
            Text(generatedNovel)
                .font(.system(size: 16))
                .foregroundColor(.white)
                .lineSpacing(4)
                .padding(16)
                .background(Color(hex: "1A1A32"))
                .cornerRadius(12)
        }
        .padding(.horizontal, 20)
    }
}