//
//  HomeView.swift
//  SphereASTRO
//
//  Created by Codex on 2026/02/07.
//

import SwiftUI

/// 対話が開始されていない状態を示すホーム画面。
struct HomeView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("ホーム")
                    .font(.largeTitle.bold())

                Text("SphereASTRO は、人間の主体性を守るために御霊（人格）と依代（演算基盤）を分離して扱います。ここでは対話開始前の準備を行います。")
                    .foregroundStyle(.secondary)

                mitamaSection
                settingSection
            }
            .frame(maxWidth: 720, alignment: .leading)
            .padding(24)
        }
    }

    private var mitamaSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("御霊を選択")
                .font(.title3.bold())

            ForEach(viewModel.mitamas) { mitama in
                HStack(spacing: 12) {
                    Image(systemName: mitama.imageName)
                        .font(.title3)
                        .frame(width: 28)
                    VStack(alignment: .leading, spacing: 4) {
                        Text(mitama.name)
                            .font(.headline)
                        Text(mitama.detail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    Spacer()
                    if mitama.isEnabled {
                        Label("有効", systemImage: "checkmark.seal.fill")
                            .font(.caption)
                            .foregroundStyle(.green)
                    } else {
                        Label("無効", systemImage: "xmark.seal")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(12)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }

            Button {
                viewModel.addMitamaDraft()
            } label: {
                Label("御霊を新規作成", systemImage: "plus.circle.fill")
            }
            .buttonStyle(.borderedProminent)
        }
    }

    private var settingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("設定")
                .font(.title3.bold())

            Text("依代の有効化、ユーザープロファイル、御霊定義の編集は設定画面で行います。")
                .foregroundStyle(.secondary)

            Button {
                viewModel.openSettings()
            } label: {
                Label("設定を開く", systemImage: "gearshape.fill")
            }
            .buttonStyle(.bordered)
        }
    }
}

#Preview {
    HomeView(viewModel: .preview)
}
