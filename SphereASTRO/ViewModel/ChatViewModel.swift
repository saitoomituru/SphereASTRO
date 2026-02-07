//
//  ChatViewModel.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation

/// チャット画面の状態管理を担当するViewModel。
/// AI応答は扱わず、ユーザー投稿の記録のみを責務とする。
final class ChatViewModel: ObservableObject {
    @Published private(set) var rooms: [ChatRoom]
    @Published var selectedRoomID: ChatRoom.ID?

    let currentSenderID: ParticipantID

    init(
        rooms: [ChatRoom] = ChatViewModel.defaultRooms,
        selectedRoomID: ChatRoom.ID? = nil,
        currentSenderID: ParticipantID = "me"
    ) {
        self.rooms = rooms
        self.selectedRoomID = selectedRoomID ?? rooms.first?.id
        self.currentSenderID = currentSenderID
    }

    var selectedRoom: ChatRoom? {
        guard let selectedRoomID else { return nil }
        return rooms.first(where: { $0.id == selectedRoomID })
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
}

extension ChatViewModel {
    static var preview: ChatViewModel {
        ChatViewModel(rooms: [
            ChatRoom(
                title: "個人メモ",
                messages: [
                    ChatMessage(senderID: "me", body: "今日の作業メモをここに残す"),
                    ChatMessage(senderID: "me", body: "AI連携前のUI確認OK")
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
