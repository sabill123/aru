import SwiftUI

struct VirtualFittingView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedGender = "여성"
    @State private var selectedCategory = "상의"
    @State private var selectedItem: Int? = nil
    @State private var myPhoto: Bool = false
    @State private var isProcessing = false
    @State private var showResult = false
    
    let genders = ["여성", "남성"]
    let categories = ["상의", "하의", "원피스", "아우터", "신발", "액세서리"]
    
    // 예시 아이템 데이터
    let items = [
        ["티셔츠", "블라우스", "니트", "셔츠", "후드티", "탑"],
        ["청바지", "슬랙스", "스커트", "반바지", "트레이닝", "레깅스"],
        ["미니 원피스", "미디 원피스", "맥시 원피스", "점프수트"],
        ["코트", "자켓", "가디건", "패딩", "조끼", "후드집업"],
        ["운동화", "플랫슈즈", "힐", "부츠", "샌들", "로퍼"],
        ["목걸이", "귀걸이", "팔찌", "벨트", "가방", "모자"]
    ]
    
    var body: some View {
        ZStack {
            // 배경
            SpaceBackground()
                .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // 상단 헤더
                    FittingHeaderView(
                        title: "가상 피팅",
                        showResult: showResult,
                        dismissAction: { 
                            if showResult {
                                showResult = false
                            } else {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    )
                    
                    if showResult {
                        // 피팅 결과 화면
                        VirtualFittingResultView(
                            selectedCategory: selectedCategory,
                            backAction: { showResult = false }
                        )
                    } else {
                        // 피팅 설정 화면
                        SettingsView(
                            selectedGender: $selectedGender,
                            selectedCategory: $selectedCategory,
                            selectedItem: $selectedItem,
                            myPhoto: $myPhoto,
                            categories: categories,
                            genders: genders,
                            items: items,
                            startFittingAction: startFitting
                        )
                    }
                    
                    Spacer(minLength: 100)
                }
            }
            
            // 로딩 인디케이터
            if isProcessing {
                VirtualFittingLoadingView()
            }
        }
        .navigationBarHidden(true)
    }
    
    func startFitting() {
        isProcessing = true
        
        // 실제로는 API 호출이 이루어져야 함
        // 여기서는 간단한 시뮬레이션으로 대체
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.isProcessing = false
            self.showResult = true
        }
    }
}

// MARK: - 헤더 뷰
struct FittingHeaderView: View {
    let title: String
    let showResult: Bool
    let dismissAction: () -> Void
    
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
            }
            .pressEffect(intensity: 0.95)
            
            Spacer()
            
            // 중앙 타이틀과 아이콘 - 현대적 스타일
            HStack(spacing: 8) {
                Image(systemName: "tshirt.fill")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "FFD60A"))
                
                Text(title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.darkBackgroundSecondary.opacity(0.3))
                    .shadow(color: Color(hex: "FFD60A").opacity(0.2), radius: 8, x: 0, y: 4)
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
                        .foregroundColor(Color(hex: "FFD60A"))
                }
            }
            .pressEffect(intensity: 0.95)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

// MARK: - 설정 뷰
struct SettingsView: View {
    @Binding var selectedGender: String
    @Binding var selectedCategory: String
    @Binding var selectedItem: Int?
    @Binding var myPhoto: Bool
    
    let categories: [String]
    let genders: [String]
    let items: [[String]]
    let startFittingAction: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // 성별 선택
            GenderSelectionView(selectedGender: $selectedGender, genders: genders)
                .padding(.horizontal, 20)
            
            // 카테고리 선택
            CategorySelectionView(
                selectedCategory: $selectedCategory, 
                selectedItem: $selectedItem,
                categories: categories
            )
            
            // 아이템 그리드
            ItemsView(
                selectedCategory: selectedCategory,
                selectedItem: $selectedItem,
                categories: categories,
                items: items
            )
            
            // 내 사진 업로드 및 피팅 버튼
            FittingActionButtonsView(
                myPhoto: $myPhoto,
                selectedItem: selectedItem,
                startFittingAction: startFittingAction
            )
        }
    }
}

// MARK: - 성별 선택 뷰
struct GenderSelectionView: View {
    @Binding var selectedGender: String
    let genders: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("성별")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                ForEach(genders, id: \.self) { gender in
                    GenderButton(
                        gender: gender,
                        isSelected: selectedGender == gender,
                        action: { selectedGender = gender }
                    )
                }
            }
        }
    }
}

// MARK: - 성별 버튼
struct GenderButton: View {
    let gender: String
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovered = false
    
    // 성별에 맞는 아이콘
    var genderIcon: String {
        return gender == "여성" ? "person.crop.circle.fill.badge.plus" : "person.crop.circle.fill"
    }
    
    var body: some View {
        Button(action: action) {
            // 트렌디한 디자인
            HStack(spacing: 10) {
                Image(systemName: genderIcon)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? .white : .gray)
                
                Text(gender)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(
                ZStack {
                    if isSelected {
                        // 선택된 상태
                        RoundedRectangle(cornerRadius: 16)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "FFD60A"), Color(hex: "FF8A00")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: Color(hex: "FFD60A").opacity(0.4), radius: 8, x: 0, y: 3)
                        
                        // 글로우 효과
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    } else {
                        // 비선택 상태 - 유리 효과
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: "1A1A32").opacity(isHovered ? 0.8 : 0.6))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
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
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .pressEffect(intensity: 0.97)
    }
}

// MARK: - 카테고리 선택 뷰
struct CategorySelectionView: View {
    @Binding var selectedCategory: String
    @Binding var selectedItem: Int?
    let categories: [String]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("카테고리")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(categories, id: \.self) { category in
                        FittingCategoryButton(
                            category: category,
                            isSelected: selectedCategory == category,
                            action: {
                                selectedCategory = category
                                selectedItem = nil
                            }
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - 카테고리 버튼
struct FittingCategoryButton: View {
    let category: String
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovered = false
    
    // 카테고리별 아이콘
    var categoryIcon: String {
        switch category {
        case "상의": return "tshirt"
        case "하의": return "figure"
        case "원피스": return "person.crop.square"
        case "아우터": return "person.fill"
        case "신발": return "shoe"
        case "액세서리": return "crown"
        default: return "tag"
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if isSelected {
                    Image(systemName: categoryIcon)
                        .font(.system(size: 12))
                        .foregroundColor(.white)
                }
                
                Text(category)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(
                ZStack {
                    if isSelected {
                        // 선택된 상태 배경
                        RoundedRectangle(cornerRadius: 20)
                            .fill(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color(hex: "FFD60A"), Color(hex: "FF8A00")]),
                                    startPoint: .leading, 
                                    endPoint: .trailing
                                )
                            )
                            .shadow(color: Color(hex: "FFD60A").opacity(0.4), radius: 8, x: 0, y: 3)
                        
                        // 글로우 효과
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    } else {
                        // 비선택 상태 - 유리 효과
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(hex: "1A1A32").opacity(isHovered ? 0.8 : 0.6))
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
            .scaleEffect(isHovered ? 1.05 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isHovered)
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
        .pressEffect(intensity: 0.95)
    }
}

// MARK: - 아이템 표시 뷰
struct ItemsView: View {
    let selectedCategory: String
    @Binding var selectedItem: Int?
    let categories: [String]
    let items: [[String]]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("\(selectedCategory) 아이템")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            let categoryIndex = categories.firstIndex(of: selectedCategory) ?? 0
            let categoryItems = items[categoryIndex]
            
            ItemGridView(
                categoryItems: categoryItems,
                categoryIndex: categoryIndex,
                selectedItem: $selectedItem
            )
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - 아이템 그리드 뷰
struct ItemGridView: View {
    let categoryItems: [String]
    let categoryIndex: Int
    @Binding var selectedItem: Int?
    
    // 아이템 아이콘용 시스템 이미지 이름들
    let itemIcons = ["tshirt", "figure", "dress.fill", "square.dashed", "shoe", "bag"]
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
            ForEach(categoryItems.indices, id: \.self) { index in
                VirtualFittingItemButton(
                    itemName: categoryItems[index],
                    iconName: itemIcons[categoryIndex],
                    isSelected: selectedItem == index,
                    action: { selectedItem = index }
                )
            }
        }
    }
}

// MARK: - 아이템 버튼
struct VirtualFittingItemButton: View {
    let itemName: String
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack {
                Rectangle()
                    .fill(isSelected ?
                         LinearGradient(
                             gradient: Gradient(colors: [
                                 Color(hex: "FFD60A").opacity(0.8),
                                 Color(hex: "FF8A00").opacity(0.8)
                             ]),
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing
                         ) :
                         LinearGradient(
                             gradient: Gradient(colors: [
                                 Color(hex: "1A1A32"),
                                 Color(hex: "1A1A32")
                             ]),
                             startPoint: .topLeading,
                             endPoint: .bottomTrailing
                         ))
                    .aspectRatio(1, contentMode: .fill)
                    .cornerRadius(12)
                    .overlay(
                        Image(systemName: iconName)
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                    )
                
                Text(itemName)
                    .font(.system(size: 14))
                    .foregroundColor(isSelected ? .white : .gray)
            }
        }
    }
}

// MARK: - 피팅 액션 버튼 뷰
struct FittingActionButtonsView: View {
    @Binding var myPhoto: Bool
    let selectedItem: Int?
    let startFittingAction: () -> Void
    @State private var isHovered = false
    @State private var isPressed = false
    @State private var pulsateAnimation = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 내 사진 업로드 버튼 - 트렌디한 디자인
            Button(action: {
                withAnimation(.spring()) {
                    myPhoto.toggle()
                }
            }) {
                HStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(myPhoto ? Color(hex: "FFD60A").opacity(0.2) : Color.gray.opacity(0.2))
                            .frame(width: 30, height: 30)
                        
                        Image(systemName: myPhoto ? "checkmark.circle.fill" : "plus.circle")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(myPhoto ? Color(hex: "FFD60A") : .gray)
                    }
                    
                    Text("내 사진 업로드")
                        .font(.system(size: 16, weight: myPhoto ? .semibold : .medium))
                }
                .foregroundColor(myPhoto ? .white : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(hex: "1A1A32").opacity(0.7))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(
                                    myPhoto ? 
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color(hex: "FFD60A"), Color(hex: "FF8A00").opacity(0.7)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ) : 
                                        LinearGradient(
                                            gradient: Gradient(colors: [Color.white.opacity(0.2), Color.white.opacity(0.05)]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                    lineWidth: 1.5
                                )
                        )
                        .shadow(color: myPhoto ? Color(hex: "FFD60A").opacity(0.3) : Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                )
            }
            .pressEffect(intensity: 0.95)
            
            // 피팅 시작 버튼 - 앱스토어 스타일
            Button(action: startFittingAction) {
                ZStack {
                    // 기본 배경
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color(hex: "FFD60A"), 
                                    Color(hex: "FF8A00")
                                ]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(height: 60)
                        .shadow(color: Color(hex: "FF8A00").opacity(0.4), radius: 10, x: 0, y: 5)
                        .overlay(
                            // 글로우 오버레이
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(pulsateAnimation ? 0.4 : 0.2), lineWidth: 1)
                        )
                        .scaleEffect(isPressed ? 0.97 : 1.0)
                    
                    // 트렌디한 버튼 텍스트
                    HStack(spacing: 10) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 18))
                            .foregroundColor(.white)
                        
                        Text("가상 피팅 시작하기")
                            .font(.system(size: 17, weight: .semibold))
                    }
                    .foregroundColor(.white)
                    .opacity(pulsateAnimation ? 1.0 : 0.9)
                    .scaleEffect(pulsateAnimation ? 1.02 : 1.0)
                    .animation(
                        Animation.easeInOut(duration: 1.5)
                            .repeatForever(autoreverses: true),
                        value: pulsateAnimation
                    )
                }
            }
            .buttonStyle(PlainButtonStyle())
            .disabled(selectedItem == nil || !myPhoto)
            .opacity((selectedItem == nil || !myPhoto) ? 0.6 : 1.0)
            .onAppear {
                withAnimation {
                    pulsateAnimation = true
                }
            }
            .simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in
                        if !(selectedItem == nil || !myPhoto) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                isPressed = true
                            }
                        }
                    }
                    .onEnded { _ in
                        if !(selectedItem == nil || !myPhoto) {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.6)) {
                                isPressed = false
                            }
                        }
                    }
            )
        }
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }
}

// MARK: - 로딩 뷰
struct VirtualFittingLoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.7)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(2)
                
                Text("가상 피팅 중...")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
            }
        }
    }
}

// MARK: - 결과 뷰
struct VirtualFittingResultView: View {
    let selectedCategory: String
    let backAction: () -> Void
    
    var body: some View {
        VStack(spacing: 24) {
            // 피팅 결과 이미지
            Rectangle()
                .fill(Color(hex: "1A1A32"))
                .frame(height: 400)
                .cornerRadius(16)
                .overlay(
                    VStack {
                        Image(systemName: "person.fill")
                            .font(.system(size: 120))
                            .foregroundColor(.white)
                        
                        Text("가상 피팅 결과")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                            .padding(.top, 16)
                    }
                )
                .padding(.horizontal, 20)
            
            // 액션 버튼들
            HStack(spacing: 12) {
                ActionButton(title: "다시 시도", icon: "arrow.clockwise", action: backAction)
                ActionButton(title: "저장", icon: "square.and.arrow.down", action: {})
                ActionButton(title: "공유", icon: "square.and.arrow.up", action: {})
            }
            .padding(.horizontal, 20)
            
            // 추천 아이템
            VirtualFittingRecommendedItemsView(selectedCategory: selectedCategory)
                .padding(.top, 16)
        }
    }
}

// MARK: - 액션 버튼
struct ActionButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
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
}

// MARK: - 추천 아이템 뷰
struct VirtualFittingRecommendedItemsView: View {
    let selectedCategory: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("이런 아이템은 어떠세요?")
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<5, id: \.self) { _ in
                        VirtualFittingItemCard(selectedCategory: selectedCategory)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - 추천 아이템 카드
struct VirtualFittingItemCard: View {
    let selectedCategory: String
    
    var systemImage: String {
        switch selectedCategory {
        case "상의": return "tshirt"
        case "하의": return "figure"
        case "원피스": return "dress.fill"
        case "신발": return "shoe"
        default: return "bag"
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(Color(hex: "1A1A32"))
                .frame(width: 140, height: 140)
                .cornerRadius(12)
                .overlay(
                    Image(systemName: systemImage)
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
            
            Text("\(selectedCategory) 아이템")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white)
            
            Text("39,000원")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .frame(width: 140)
    }
}