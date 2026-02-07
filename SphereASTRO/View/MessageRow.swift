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
        HStack {
            if message.role == .assistant {
                Spacer(minLength: 40)
            }

            content
                .padding(10)
                .background(message.role == .user ? Color.blue.opacity(0.2)
                                                   : Color.gray.opacity(0.2))
                .cornerRadius(8)

            if message.role == .user {
                Spacer(minLength: 40)
            }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch message.content {
        case .text(let text):
            Text(text)

        case .code(let code, _):
            ScrollView(.horizontal) {
                Text(code)
                    .font(.system(.body, design: .monospaced))
            }

        case .latex(let latex):
            Text(latex) // 後でMathJax/WebViewに置換
        }
    }
}

