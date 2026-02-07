//
//  ChatViewModel.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

/// メインペインの表示状態。
enum MainPane: Hashable {
    case home
    case chat
    case settings
}

/// 設定画面の論理区分。
enum SettingsCategory: String, CaseIterable, Identifiable {
    case app = "アプリ設定"
    case mitama = "御霊設定"

    var id: String { rawValue }
}

/// チャット画面の状態管理を担当するViewModel。
/// AI応答は扱わず、GUIの状態遷移のみを責務とする。
final class ChatViewModel: ObservableObject {
    @Published private(set) var rooms: [ChatRoom]
    @Published var selectedRoomID: ChatRoom.ID?
    @Published var mainPane: MainPane
    @Published var settingsCategory: SettingsCategory

    @Published var userProfile: UserProfile
    @Published var yorishiros: [YorishiroConfig]
    @Published var mitamas: [MitamaProfile]
    @Published var editingMitamaID: MitamaProfile.ID?

    let currentSenderID: ParticipantID

    init(
        rooms: [ChatRoom] = ChatViewModel.defaultRooms,
        selectedRoomID: ChatRoom.ID? = nil,
        currentSenderID: ParticipantID = "me",
        mainPane: MainPane? = nil,
        settingsCategory: SettingsCategory = .app,
        userProfile: UserProfile = .sample,
        yorishiros: [YorishiroConfig] = YorishiroConfig.samples,
        mitamas: [MitamaProfile] = MitamaProfile.samples,
        editingMitamaID: MitamaProfile.ID? = nil
    ) {
        self.rooms = rooms
        self.selectedRoomID = selectedRoomID ?? rooms.first?.id
        self.currentSenderID = currentSenderID
        self.mainPane = mainPane ?? (rooms.isEmpty ? .home : .chat)
        self.settingsCategory = settingsCategory
        self.userProfile = userProfile
        self.yorishiros = yorishiros
        self.mitamas = mitamas
        self.editingMitamaID = editingMitamaID ?? mitamas.first?.id
    }

    var selectedRoom: ChatRoom? {
        guard let selectedRoomID else { return nil }
        return rooms.first(where: { $0.id == selectedRoomID })
    }

    var editingMitama: MitamaProfile? {
        guard let editingMitamaID else { return nil }
        return mitamas.first(where: { $0.id == editingMitamaID })
    }

    func openHome() {
        mainPane = .home
    }

    func openSettings() {
        mainPane = .settings
    }

    func openChat(roomID: ChatRoom.ID) {
        selectedRoomID = roomID
        mainPane = .chat
    }

    func sendMessage(_ rawText: String) {
        let trimmed = rawText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              let roomIndex = rooms.firstIndex(where: { $0.id == selectedRoomID }) else {
            return
        }

        let message = ChatMessage(senderID: currentSenderID, body: trimmed)
        rooms[roomIndex].messages.append(message)
    }

    func updateMitama(_ updated: MitamaProfile) {
        guard let index = mitamas.firstIndex(where: { $0.id == updated.id }) else { return }
        mitamas[index] = updated
    }

    func addMitamaDraft() {
        let newMitama = MitamaProfile(name: "新しい御霊", detail: "説明を入力", famDefinition: "人格FAM定義を入力")
        mitamas.append(newMitama)
        editingMitamaID = newMitama.id
        mainPane = .settings
        settingsCategory = .mitama
    }
}

extension ChatViewModel {
    static var preview: ChatViewModel {
        ChatViewModel(rooms: [
            ChatRoom(
                title: "個人メモ",
                messages: [
                    ChatMessage(senderID: "me", body: "今日の作業メモをここに残す"),
                    ChatMessage(senderID: "me", body: "GUI設計の確認OK")
                ]
            ),
            ChatRoom(title: "雑談ログ")
        ])
    }

    private static var defaultRooms: [ChatRoom] {
        [
            ChatRoom(title: "メイン")
        ]
    }
}
