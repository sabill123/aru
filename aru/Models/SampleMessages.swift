import Foundation

// 샘플 메시지 생성
let sampleChatMessages: [ChatMessageData] = [
    ChatMessageData(
        id: 101,
        text: "안녕하세요! 무엇을 도와드릴까요?",
        isFromMe: false,
        timestamp: Date(timeIntervalSinceNow: -3600 * 3)
    ),
    ChatMessageData(
        id: 102,
        text: "최근 인공지능에 대해 알아보고 싶어요. 어떤 분야가 가장 발전되고 있나요?",
        isFromMe: true,
        timestamp: Date(timeIntervalSinceNow: -3600 * 2 - 300)
    ),
    ChatMessageData(
        id: 103,
        text: "최근 인공지능 분야에서는 생성형 AI 분야가 크게 발전하고 있어요. 특히 이미지 생성, 텍스트 생성, 음성 합성 등의 기술이 빠르게 발전하고 있습니다. 또한 강화학습과 멀티모달 AI 기술도 주목받고 있어요.",
        isFromMe: false,
        timestamp: Date(timeIntervalSinceNow: -3600 * 2)
    ),
    ChatMessageData(
        id: 104,
        text: "그렇군요! 생성형 AI에 대해 더 자세히 알려주실 수 있나요?",
        isFromMe: true,
        timestamp: Date(timeIntervalSinceNow: -3600 - 600)
    ),
    ChatMessageData(
        id: 105,
        text: "생성형 AI는 기존 데이터를 학습해서 새로운 콘텐츠를 창작하는 인공지능 기술입니다. 대표적으로 GPT 모델(텍스트), DALL-E, Midjourney(이미지), TTS 모델(음성) 등이 있어요. 이 기술들은 예술, 교육, 엔터테인먼트 등 다양한 분야에서 활용되고 있습니다.",
        isFromMe: false,
        timestamp: Date(timeIntervalSinceNow: -3600)
    )
]

// 채팅 옵션 데이터
let chatOptions: [ChatOption] = [
    ChatOption(icon: "star", title: "즐겨찾기에 추가", color: .yellow),
    ChatOption(icon: "bell.slash", title: "알림 끄기", color: .red),
    ChatOption(icon: "archivebox", title: "대화 보관하기", color: .blue),
    ChatOption(icon: "paintbrush", title: "대화방 꾸미기", color: .green),
    ChatOption(icon: "photo", title: "사진 및 동영상", color: .purple),
    ChatOption(icon: "trash", title: "대화 삭제", color: .red)
]