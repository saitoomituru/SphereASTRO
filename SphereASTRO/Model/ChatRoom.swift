//
//  ChatRoom.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

/// GUIレイヤー専用のチャットルームモデル。
/// 今回は永続化を行わないため、メモリ上でメッセージ配列を保持する。
struct ChatRoom: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var messages: [ChatMessage]

    init(id: UUID = UUID(), title: String, messages: [ChatMessage] = []) {
        self.id = id
        self.title = title
        self.messages = messages
    }
}
