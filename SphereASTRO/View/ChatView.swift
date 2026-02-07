//
//  ChatView.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import SwiftUI

/// 選択中チャットルームのメッセージ表示と投稿入力を担うビュー。
struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    @State private var draftText = ""

    var body: some View {
        VStack(spacing: 0) {
            messageList
            Divider()
            composer
        }
        .navigationTitle(viewModel.selectedRoom?.title ?? "チャット")
    }

    private var messageList: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 8) {
                if let messages = viewModel.selectedRoom?.messages, !messages.isEmpty {
                    ForEach(messages) { message in
                        MessageRow(message: message, currentSenderID: viewModel.currentSenderID)
                    }
                } else {
                    Text("まだメッセージはありません")
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 24)
                }
            }
            .padding()
        }
    }

    private var composer: some View {
        HStack(spacing: 8) {
            TextField("メッセージを入力", text: $draftText, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(1...4)

            Button("送信") {
                send()
            }
            .buttonStyle(.borderedProminent)
            .disabled(draftText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
        .padding()
    }

    private func send() {
        viewModel.sendMessage(draftText)
        draftText = ""
    }
}

#Preview {
    NavigationStack {
        ChatView(viewModel: .preview)
    }
}
