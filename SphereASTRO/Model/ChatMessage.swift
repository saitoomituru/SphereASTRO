//
//  ChatMessage.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

/// GUIレイヤー専用のメッセージモデル。
/// 思考処理(FAM)と切り離し、記録データとして扱う。
struct ChatMessage: Identifiable, Codable, Hashable {
    let id: UUID
    let senderID: ParticipantID
    let body: String
    let timestamp: Date

    init(
        id: UUID = UUID(),
        senderID: ParticipantID,
        body: String,
        timestamp: Date = Date()
    ) {
        self.id = id
        self.senderID = senderID
        self.body = body
        self.timestamp = timestamp
    }
}
