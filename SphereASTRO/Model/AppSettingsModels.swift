//
//  AppSettingsModels.swift
//  SphereASTRO
//
//  Created by Codex on 2026/02/07.
//

import Foundation

struct UserProfile {
    var displayName: String
    var socialID: String
    var iconName: String
    var bio: String

    static let sample = UserProfile(
        displayName: "オペレーター",
        socialID: "@sphere_operator",
        iconName: "person.crop.circle.fill",
        bio: "人格と責任の境界を明示しながら、御霊と共に作業します。"
    )
}

struct YorishiroConfig: Identifiable {
    let id = UUID()
    var displayName: String
    var kind: String
    var endpoint: String
    var isEnabled: Bool

    static let samples: [YorishiroConfig] = [
        YorishiroConfig(displayName: "ローカル Ollama", kind: "Ollama", endpoint: "http://localhost:11434", isEnabled: true),
        YorishiroConfig(displayName: "研究用 AAE", kind: "AAE", endpoint: "http://localhost:8080", isEnabled: false),
        YorishiroConfig(displayName: "OpenAI 互換", kind: "OpenAI", endpoint: "https://api.openai.example", isEnabled: false),
        YorishiroConfig(displayName: "xAI 互換", kind: "xAI", endpoint: "https://api.xai.example", isEnabled: false)
    ]
}

struct MitamaProfile: Identifiable {
    let id = UUID()
    var name: String
    var detail: String
    var imageName: String
    var famDefinition: String
    var isEnabled: Bool

    init(name: String, detail: String, imageName: String = "sparkles", famDefinition: String, isEnabled: Bool = true) {
        self.name = name
        self.detail = detail
        self.imageName = imageName
        self.famDefinition = famDefinition
        self.isEnabled = isEnabled
    }

    static let samples: [MitamaProfile] = [
        MitamaProfile(
            name: "マキナ",
            detail: "守護者寄りの伴走御霊。仕様整理と要件確認を担当。",
            imageName: "leaf.fill",
            famDefinition: "目的: 人間主権を守る\n制約: 推論処理は依代に委譲\n出力: 構造化された提案"
        ),
        MitamaProfile(
            name: "アストラ",
            detail: "探索寄りの御霊。アイデア展開と比較検討を支援。",
            imageName: "moon.stars.fill",
            famDefinition: "目的: 選択肢の拡張\n価値: 説明可能性\n記録: Foldネストを維持"
        )
    ]
}
