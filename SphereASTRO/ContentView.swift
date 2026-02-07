//
//  ContentView.swift
//  SphereASTRO
//
//  Created by 齋藤みつる on 2026/02/07.
//

import SwiftUI

/// アプリ全体のルートビュー。サイドバーとメインペインを分離表示する。
struct ContentView: View {
    @StateObject private var viewModel: ChatViewModel

    init(viewModel: ChatViewModel = ChatViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationSplitView {
            ChatRoomListView(viewModel: viewModel)
        } detail: {
            switch effectivePane {
            case .home:
                HomeView(viewModel: viewModel)
            case .chat:
                ChatView(viewModel: viewModel)
            case .settings:
                SettingsView(viewModel: viewModel)
            }
        }
    }

    private var effectivePane: MainPane {
        if viewModel.rooms.isEmpty {
            return .home
        }

        if viewModel.mainPane == .chat, viewModel.selectedRoom == nil {
            return .home
        }

        return viewModel.mainPane
    }
}

#Preview {
    ContentView(viewModel: .preview)
}
