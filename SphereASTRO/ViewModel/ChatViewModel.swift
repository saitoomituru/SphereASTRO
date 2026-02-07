//
//  ChatViewModel.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

struct ChatMessage: Identifiable {
    let id = UUID()
    let role: Role
    let content: MessageContent
}

class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []

    func send(_ text: String) {
        // 1. user message を追加
        // 2. assistant message を空で追加
        // 3. ストリームで λ_chat を追記
    }
}

