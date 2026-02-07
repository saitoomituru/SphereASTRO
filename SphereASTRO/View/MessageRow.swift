//
//  MessageRow.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import SwiftUI

/// 単一メッセージの表示行。送信者IDのみで左右配置を切り替える。
struct MessageRow: View {
    let message: ChatMessage
    let currentSenderID: ParticipantID

    var body: some View {
        HStack {
            if isMine { Spacer(minLength: 40) }

            VStack(alignment: .leading, spacing: 4) {
                Text(message.body)
                    .foregroundStyle(.primary)
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .padding(10)
            .background(isMine ? Color.blue.opacity(0.18) : Color.gray.opacity(0.16))
            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))

            if !isMine { Spacer(minLength: 40) }
        }
        .frame(maxWidth: .infinity, alignment: isMine ? .trailing : .leading)
    }

    private var isMine: Bool {
        message.senderID == currentSenderID
    }
}

#Preview {
    VStack {
        MessageRow(
            message: ChatMessage(senderID: "me", body: "これは自分の発言です"),
            currentSenderID: "me"
        )
        MessageRow(
            message: ChatMessage(senderID: "other", body: "将来の拡張確認"),
            currentSenderID: "me"
        )
    }
    .padding()
}
