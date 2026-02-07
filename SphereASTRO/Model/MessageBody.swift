//
//  MessageBody.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

/// 将来の拡張ポイントとして残す軽量メッセージ本文型。
/// 現フェーズではテキストのみを使用する。
enum MessageBody: Codable, Hashable {
    case text(String)
}
