import SwiftUI

struct ImageGenerationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var prompt = ""
    @State private var selectedStyle = "사실적"
    @State private var selectedRatio = "1:1"
    @State private var isGenerating = false
    @State private var generatedImage: Bool = false
    
    let styles = ["사실적", "일러스트", "애니메이션", "수채화", "유화", "픽셀아트", "3D 렌더링"]
    let ratios = ["1:1", "4:3", "16:9", "3:4", "9:16"]
    
    var body: some View {
        ZStack {
            // 배경
            SpaceBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // 상단 헤더
                    HeaderView(
                        dismissAction: { presentationMode.wrappedValue.dismiss() }
                    )
                    
                    // 입력 폼
                    FormView(
                        prompt: $prompt,
                        selectedStyle: $selectedStyle,
                        selectedRatio: $selectedRatio,
                        styles: styles,
                        ratios: ratios,
                        isGenerating: isGenerating,
                        generateAction: generateImage
                    )
                    
                    // 생성된 이미지 표시
                    if generatedImage {
                        GeneratedImageView(
                            selectedRatio: selectedRatio,
                            regenerateAction: generateImage
                        )
                    }
                    
                    Spacer(minLength: 100)
                }
            }
        }
        .navigationBarHidden(true)
    }
    
    func generateImage() {
        guard !prompt.isEmpty else { return }
        
        isGenerating = true
        
        // 실제로는 API 호출이 이루어져야 함
        // 여기서는 간단한 시뮬레이션으로 대체
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.generatedImage = true
            self.isGenerating = false
        }
    }
}

// MARK: - 헤더 뷰
struct HeaderView: View {
    let dismissAction: () -> Void
    
    var body: some View {
        HStack {
            Button(action: dismissAction) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text("이미지 생성")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
            
            Spacer()
            
            Button(action: {
                // 도움말
            }) {
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

// MARK: - 입력 폼 뷰
struct FormView: View {
    @Binding var prompt: String
    @Binding var selectedStyle: String
    @Binding var selectedRatio: String
    let styles: [String]
    let ratios: [String]
    let isGenerating: Bool
    let generateAction: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            // 프롬프트 입력
            VStack(alignment: .leading, spacing: 8) {
                Text("이미지 설명")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                PromptInputView(prompt: $prompt)
            }
            
            // 스타일 선택
            VStack(alignment: .leading, spacing: 8) {
                Text("스타일")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                StyleSelectionView(
                    selectedStyle: $selectedStyle,
                    styles: styles
                )
            }
            
            // 비율 선택
            VStack(alignment: .leading, spacing: 8) {
                Text("비율")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                
                RatioSelectionView(
                    selectedRatio: $selectedRatio,
                    ratios: ratios
                )
            }
            
            // 생성 버튼
            GenerateButtonView(
                prompt: prompt,
                isGenerating: isGenerating,
                generateAction: generateAction
            )
        }
        .padding(.horizontal, 20)
    }
}

// MARK: - 프롬프트 입력 뷰
struct PromptInputView: View {
    @Binding var prompt: String
    
    var body: some View {
        TextEditor(text: $prompt)
            .frame(height: 120)
            .padding(16)
            .background(Color(hex: "1A1A32"))
            .cornerRadius(12)
            .foregroundColor(.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color(hex: "2A2A42"), lineWidth: 1)
            )
            .overlay(
                Group {
                    if prompt.isEmpty {
                        Text("생성하고 싶은 이미지를 자세히 설명해주세요")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                            .padding(.top, 20)
                            .allowsHitTesting(false)
                    }
                }, 
                alignment: .topLeading
            )
    }
}

// MARK: - 스타일 선택 뷰
struct StyleSelectionView: View {
    @Binding var selectedStyle: String
    let styles: [String]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(styles, id: \.self) { style in
                    StyleButton(
                        style: style,
                        isSelected: selectedStyle == style,
                        action: { selectedStyle = style }
                    )
                }
            }
        }
    }
}

// MARK: - 스타일 버튼
struct StyleButton: View {
    let style: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(style)
                .font(.system(size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    isSelected ?
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "FF36A3"), Color(hex: "FF61D2")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "1A1A32"), Color(hex: "1A1A32")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .foregroundColor(.white)
        }
    }
}

// MARK: - 비율 선택 뷰
struct RatioSelectionView: View {
    @Binding var selectedRatio: String
    let ratios: [String]
    
    var body: some View {
        HStack(spacing: 10) {
            ForEach(ratios, id: \.self) { ratio in
                RatioButton(
                    ratio: ratio,
                    isSelected: selectedRatio == ratio,
                    action: { selectedRatio = ratio }
                )
            }
        }
    }
}

// MARK: - 비율 버튼
struct RatioButton: View {
    let ratio: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(ratio)
                .font(.system(size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    isSelected ?
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "FF36A3"), Color(hex: "FF61D2")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ) :
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "1A1A32"), Color(hex: "1A1A32")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(20)
                .foregroundColor(.white)
        }
    }
}

// MARK: - 생성 버튼 뷰
struct GenerateButtonView: View {
    let prompt: String
    let isGenerating: Bool
    let generateAction: () -> Void
    
    var body: some View {
        Button(action: generateAction) {
            ZStack {
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "FF36A3"), Color(hex: "FF61D2")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
                    .frame(height: 56)
                
                if isGenerating {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(1.3)
                } else {
                    Text("AI 이미지 생성하기")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                }
            }
        }
        .disabled(isGenerating || prompt.isEmpty)
        .opacity(prompt.isEmpty ? 0.6 : 1.0)
    }
}

// MARK: - 생성된 이미지 뷰
struct GeneratedImageView: View {
    let selectedRatio: String
    let regenerateAction: () -> Void
    
    var aspectRatio: CGFloat {
        switch selectedRatio {
        case "1:1": return 1.0
        case "4:3": return 4.0/3.0
        case "16:9": return 16.0/9.0
        case "3:4": return 3.0/4.0
        case "9:16": return 9.0/16.0
        default: return 1.0
        }
    }
    
    var height: CGFloat {
        switch selectedRatio {
        case "1:1": return 300
        case "4:3", "16:9": return 200
        case "3:4", "9:16": return 400
        default: return 300
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("생성된 이미지")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            // 이미지 플레이스홀더
            Rectangle()
                .fill(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: "FF36A3").opacity(0.4), Color(hex: "FF61D2").opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .aspectRatio(aspectRatio, contentMode: .fill)
                .frame(height: height)
                .cornerRadius(16)
                .overlay(
                    Image(systemName: "sparkles")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
                .padding(.horizontal, 20)
            
            // 액션 버튼들
            ImageActionButtonsView(
                regenerateAction: regenerateAction
            )
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - 이미지 액션 버튼 뷰
struct ImageActionButtonsView: View {
    let regenerateAction: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: regenerateAction) {
                ActionButtonContent(title: "다시 생성", icon: "arrow.clockwise")
            }
            
            Button(action: {
                // 저장
            }) {
                ActionButtonContent(title: "저장", icon: "square.and.arrow.down")
            }
            
            Button(action: {
                // 공유
            }) {
                ActionButtonContent(title: "공유", icon: "square.and.arrow.up")
            }
        }
    }
}

// MARK: - 액션 버튼 내용
struct ActionButtonContent: View {
    let title: String
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
            Text(title)
        }
        .font(.system(size: 14, weight: .medium))
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
        .frame(height: 46)
        .background(Color(hex: "1A1A32"))
        .cornerRadius(12)
    }
}