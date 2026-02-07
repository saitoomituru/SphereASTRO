//
//  Participant.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

struct Participant: Identifiable {
    let id: ParticipantID
    let displayName: String
    let kind: ParticipantKind   // 表示用だけ
}

enum ParticipantKind {
    case human
    case agent
    case system
}
