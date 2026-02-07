//
//  ChatRoomListView.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import SwiftUI

/// チャットルーム一覧を表示するサイドバー。
struct ChatRoomListView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        List(viewModel.rooms, selection: $viewModel.selectedRoomID) { room in
            VStack(alignment: .leading, spacing: 4) {
                Text(room.title)
                    .font(.headline)
                Text("\(room.messages.count)件")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .padding(.vertical, 2)
        }
        .navigationTitle("チャット")
    }
}

#Preview {
    NavigationStack {
        ChatRoomListView(viewModel: .preview)
    }
}
