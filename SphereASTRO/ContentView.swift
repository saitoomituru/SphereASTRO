//
//  ContentView.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import SwiftUI

/// アプリ全体のルートビュー。部屋一覧とチャット本文を分離表示する。
struct ContentView: View {
    @StateObject private var viewModel: ChatViewModel

    init(viewModel: ChatViewModel = ChatViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationSplitView {
            ChatRoomListView(viewModel: viewModel)
        } detail: {
            if viewModel.selectedRoom != nil {
                ChatView(viewModel: viewModel)
            } else {
                ContentUnavailableView("チャットを選択", systemImage: "bubble.left.and.bubble.right")
            }
        }
    }
}

#Preview {
    ContentView(viewModel: .preview)
}
