//
//  SettingsView.swift
//  SphereASTRO
//
//  Created by Codex on 2026/02/07.
//

import SwiftUI

/// アプリ設定と御霊設定を切り替える設定ビュー。
struct SettingsView: View {
    @ObservedObject var viewModel: ChatViewModel

    var body: some View {
        VStack(spacing: 0) {
            Picker("設定カテゴリ", selection: $viewModel.settingsCategory) {
                ForEach(SettingsCategory.allCases) { category in
                    Text(category.rawValue).tag(category)
                }
            }
            .pickerStyle(.segmented)
            .padding()

            Divider()

            ScrollView {
                switch viewModel.settingsCategory {
                case .app:
                    appSettings
                case .mitama:
                    mitamaSettings
                }
            }
        }
        .navigationTitle("設定")
    }

    private var appSettings: some View {
        VStack(alignment: .leading, spacing: 24) {
            profileSection
            yorishiroSection
        }
        .padding(24)
    }

    private var profileSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ユーザープロファイル")
                .font(.title3.bold())

            HStack(spacing: 16) {
                Image(systemName: viewModel.userProfile.iconName)
                    .font(.system(size: 44))
                    .foregroundStyle(.blue)
                    .frame(width: 64, height: 64)
                    .background(.quaternary, in: Circle())

                VStack(alignment: .leading) {
                    Text("アイコン画像（ダミー）")
                    TextField("SF Symbols名", text: $viewModel.userProfile.iconName)
                        .textFieldStyle(.roundedBorder)
                }
            }

            TextField("表示名", text: $viewModel.userProfile.displayName)
                .textFieldStyle(.roundedBorder)

            TextField("ソーシャルID", text: $viewModel.userProfile.socialID)
                .textFieldStyle(.roundedBorder)

            TextField("自己紹介", text: $viewModel.userProfile.bio, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...6)
        }
    }

    private var yorishiroSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("依代設定")
                .font(.title3.bold())

            ForEach($viewModel.yorishiros) { $yorishiro in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        TextField("表示名", text: $yorishiro.displayName)
                            .textFieldStyle(.roundedBorder)
                        Toggle("有効", isOn: $yorishiro.isEnabled)
                            .toggleStyle(.switch)
                            .frame(width: 120)
                    }

                    TextField("種別", text: $yorishiro.kind)
                        .textFieldStyle(.roundedBorder)
                    TextField("エンドポイント", text: $yorishiro.endpoint)
                        .textFieldStyle(.roundedBorder)
                }
                .padding(12)
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var mitamaSettings: some View {
        VStack(alignment: .leading, spacing: 24) {
            mitamaManagementSection
            mitamaEditorSection
        }
        .padding(24)
    }

    private var mitamaManagementSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("御霊管理")
                .font(.title3.bold())

            ForEach($viewModel.mitamas) { $mitama in
                HStack {
                    Button {
                        viewModel.editingMitamaID = mitama.id
                    } label: {
                        HStack {
                            Image(systemName: mitama.imageName)
                            Text(mitama.name)
                        }
                    }
                    .buttonStyle(.plain)

                    Spacer()
                    Toggle("有効", isOn: $mitama.isEnabled)
                        .labelsHidden()
                }
                .padding(.vertical, 4)
            }

            HStack {
                Button("インポート（UIのみ）") {}
                Button("エクスポート（UIのみ）") {}
            }
            .buttonStyle(.bordered)
        }
    }

    private var mitamaEditorSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("御霊作成・編集")
                .font(.title3.bold())

            if let editingMitama = viewModel.editingMitama,
               let binding = bindingForMitama(id: editingMitama.id) {
                TextField("御霊名", text: binding.name)
                    .textFieldStyle(.roundedBorder)
                TextField("説明文", text: binding.detail, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(2...4)

                HStack {
                    Image(systemName: binding.imageName.wrappedValue)
                        .font(.title2)
                    TextField("画像 (SF Symbols)", text: binding.imageName)
                        .textFieldStyle(.roundedBorder)
                }

                TextField("人格FAM定義", text: binding.famDefinition, axis: .vertical)
                    .textFieldStyle(.roundedBorder)
                    .lineLimit(6...12)
            } else {
                ContentUnavailableView("編集対象の御霊を選択", systemImage: "person.text.rectangle")
            }
        }
    }

    private func bindingForMitama(id: MitamaProfile.ID) -> (name: Binding<String>, detail: Binding<String>, imageName: Binding<String>, famDefinition: Binding<String>)? {
        guard let index = viewModel.mitamas.firstIndex(where: { $0.id == id }) else {
            return nil
        }

        return (
            name: $viewModel.mitamas[index].name,
            detail: $viewModel.mitamas[index].detail,
            imageName: $viewModel.mitamas[index].imageName,
            famDefinition: $viewModel.mitamas[index].famDefinition
        )
    }
}

#Preview {
    SettingsView(viewModel: .preview)
}
