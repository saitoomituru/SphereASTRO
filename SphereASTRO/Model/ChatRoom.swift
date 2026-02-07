//
//  ChatRoom.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

struct ChatRoom: Identifiable {
    let id: UUID
    let title: String
    let participants: [ParticipantID]
}
