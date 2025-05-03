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
                        ResultView(
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
                LoadingView()
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
            Button(action: dismissAction) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Text(title)
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
    
    var body: some View {
        Button(action: action) {
            Text(gender)
                .font(.system(size: 16))
                .fontWeight(isSelected ? .semibold : .regular)
                .foregroundColor(isSelected ? .white : .gray)
                .frame(maxWidth: .infinity)
                .frame(height: 46)
                .background(isSelected ?
                          LinearGradient(
                              gradient: Gradient(colors: [Color(hex: "FFD60A"), Color(hex: "FF8A00")]),
                              startPoint: .leading,
                              endPoint: .trailing
                          ) : 
                          LinearGradient(
                              gradient: Gradient(colors: [Color(hex: "1A1A32"), Color(hex: "1A1A32")]),
                              startPoint: .leading,
                              endPoint: .trailing
                          ))
                .cornerRadius(12)
        }
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
    
    var body: some View {
        Button(action: action) {
            Text(category)
                .font(.system(size: 14))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(isSelected ?
                          LinearGradient(
                              gradient: Gradient(colors: [Color(hex: "FFD60A"), Color(hex: "FF8A00")]),
                              startPoint: .leading,
                              endPoint: .trailing
                          ) : 
                          LinearGradient(
                              gradient: Gradient(colors: [Color(hex: "1A1A32"), Color(hex: "1A1A32")]),
                              startPoint: .leading,
                              endPoint: .trailing
                          ))
                .cornerRadius(20)
                .foregroundColor(.white)
        }
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
                ItemButton(
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
struct ItemButton: View {
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
    
    var body: some View {
        VStack(spacing: 16) {
            Button(action: {
                myPhoto = true
            }) {
                HStack {
                    Image(systemName: myPhoto ? "checkmark.circle.fill" : "plus.circle")
                        .font(.system(size: 20))
                    
                    Text("내 사진 업로드")
                        .font(.system(size: 16))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color(hex: "1A1A32"))
                .cornerRadius(12)
            }
            
            // 피팅 시작 버튼
            Button(action: startFittingAction) {
                Text("가상 피팅 시작하기")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color(hex: "FFD60A"), Color(hex: "FF8A00")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(12)
            }
            .disabled(selectedItem == nil || !myPhoto)
            .opacity((selectedItem == nil || !myPhoto) ? 0.6 : 1.0)
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
    }
}

// MARK: - 로딩 뷰
struct LoadingView: View {
    var body: some View {
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

// MARK: - 결과 뷰
struct ResultView: View {
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
            RecommendedItemsView(selectedCategory: selectedCategory)
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
struct RecommendedItemsView: View {
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
                        RecommendedItemCard(selectedCategory: selectedCategory)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

// MARK: - 추천 아이템 카드
struct RecommendedItemCard: View {
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