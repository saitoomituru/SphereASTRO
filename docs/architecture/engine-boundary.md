# Engine Boundary（依代境界）

## 目的
Ollama / OpenAI互換API / AAE等の依代を交換可能な計算資源として扱い、人格層との責任混同を防ぐ。

## 境界定義
- Engineはテキスト生成・埋め込み生成などの計算機能を提供する。
- FAMはEngineの出力をそのまま採用せず、規範照合を経て利用する。
- Engineは責任判断の終点ではなく、設計・選択・運用した人間の意思決定経路を追跡するための証跡対象である。
- GUIはEngineの直接制御を行わない。

## RunnerからEngineまでの経路

```text
SwiftUI
  ↓
Application Use Case
  ↓
Astro Runner
  ├─ Device Capability Probe
  ├─ Boot Profile Resolver
  └─ Artifact Cache
        ↓
Engine Adapter
        ↓
Embedded Engine / Ollama / Sphere-aae / Remote Firepower
```

- Runnerは端末能力とASTRO fileの`boot_profiles`を照合する。
- Resolverは選択結果、Fallback、選択できなかった候補をreceiptへ残す。
- Artifact Cacheはhash一致を必須とし、人格正本にはしない。
- GUIはResolverやEngineを直接呼ばず、Application Use Caseが返す状態を表示する。

## Adapter要件
1. 入力正規化: 共通リクエスト形式へ変換する。
2. 出力正規化: 応答本文、メタ情報、エラー情報を共通形式へ変換する。
3. 監査付加: 使用依代ID、モデルID、タイムスタンプ、選択主体（運用者・自動選択ルール）を必ず付与する。
4. 失敗分類: 通信失敗・制限超過・不正応答を区別する。
5. 能力宣言: structured output、tool call、embedding、Body event、context長等を宣言する。
6. canary: model／tokenizer／templateが組として推論可能か、`READY`前に検査する。
7. 切替receipt: model、Adapter、選択規則、端末、差分、lossを記録する。

## 実装禁止事項
- ベンダー固有の会話ロール（MCPのUser / Assistant / System）を内部責任モデルとして採用しない。
- Engineレスポンスを人格判断として確定しない。
- 「モデルを有罪化する」設計や文言を導入しない。責任評価は実行構成と人間の選択経路に対して行う。
- 単一ベンダー前提の型を上位層へ漏らさない。
- iOS／iPadOSで、ASTRO archive内の任意の未署名実行codeをpluginとして読み込まない。
- 外部Engineが応答しない場合、別modelの出力を同じ実行結果として黙って差し替えない。
- archiveを開けたことだけで推論Engineを`READY`にしない。

## 拡張方針
- 新規依代はAdapter実装追加で対応する。
- 既存FAMおよびGUIに変更を要求しない設計を維持する。
- OllamaはStage 1の比較・開発炉として利用できるが、portable ASTROの唯一のboot依存にはしない。
- 端末内EngineはAstro Runnerへ署名済みで組み込み、model artifactと実行codeを別の配布境界で扱う。
