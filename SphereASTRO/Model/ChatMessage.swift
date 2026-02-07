//
//  ChatMessage.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

struct ChatMessage: Identifiable {
    let id: UUID
    let roomID: UUID
    let senderID: ParticipantID
    let body: MessageBody
    let timestamp: Date
}

