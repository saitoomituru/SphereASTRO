//
//  MessageRow.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import Foundation
import SwiftUI

struct MessageRow: View {
    let message: ChatMessage

    var body: some View {
        HStack(alignment: .top) {
            if message.role == .assistant {
                Spacer(minLength: 0)
            }

            content
                .padding(10)
                .background(
                    message.role == .user
                    ? Color.blue.opacity(0.15)
                    : Color.gray.opacity(0.15)
                )
                .cornerRadius(10)

            if message.role == .user {
                Spacer(minLength: 0)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch message.content {
        case .text(let text):
            Text(text)
                .textSelection(.enabled)

        case .code(let code, _):
            Text(code)
                .font(.system(.body, design: .monospaced))
        }
    }
}
