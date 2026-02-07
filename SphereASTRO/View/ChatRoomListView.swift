//
//  ChatRoomListView.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import SwiftUI

/// メインペインの導線とチャットルーム一覧を表示するサイドバー。
struct ChatRoomListView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        List {
            Section("トップ") {
                Button {
                    viewModel.openHome()
                } label: {
                    Label("ホーム", systemImage: "house")
                }

                Button {
                    viewModel.openSettings()
                } label: {
                    Label("設定", systemImage: "gearshape")
                }
            }

            Section("チャット") {
                ForEach(viewModel.rooms) { room in
                    Button {
                        viewModel.openChat(roomID: room.id)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(room.title)
                                .font(.headline)
                            Text("\(room.messages.count)件")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 2)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .navigationTitle("SphereASTRO")
    }
}

#Preview {
    NavigationStack {
        ChatRoomListView(viewModel: .preview)
    }
}
