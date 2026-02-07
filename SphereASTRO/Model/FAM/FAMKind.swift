//
//  FAMKind.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

enum FAMKind: String, Codable {
    case agentInit      // 人格初期化
    case chat           // 通常思考
    case component      // 自動開発・分析
    case log             // 思考ログ
}
