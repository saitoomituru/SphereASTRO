//
//  Participant.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

/// チャットUIで使う送信者ID。現フェーズでは文字列ベースの軽量表現のみを採用する。
typealias ParticipantID = String

struct Participant: Identifiable, Codable, Hashable {
    let id: ParticipantID
    let displayName: String
}
