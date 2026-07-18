# FAMレイヤ設計

> 本書のLayerは、PresentationからPersistenceまでの技術依存・変更影響順序`L`である。上位Registryが束ねるContext Dimension `D`／D Fold、FAMの`λ=出力層`、legacy `Q.layer`とは別軸である。共通定義は[Sphere Context Dimension OSアーキテクチャ](https://github.com/saitoomituru/ZeroRoomLab-manifest/blob/main/docs/theory/sphere-context-dimension-os.ja.md)を参照する。

## 目的
SwiftUI実装と判断ロジック実装を分離し、変更影響範囲を限定する。

## レイヤ構成
1. Presentation Layer（GUI）
   - 画面描画、入力受付、表示状態遷移を担当する。
2. Interaction Layer（ViewModel / UseCase）
   - UIイベントをFAM要求へ変換し、結果を表示用状態へ戻す。
3. FAM Layer（判断構造）
   - 観測・文脈化・判断・監査メタデータ生成を担当する。
4. Engine Adapter Layer（依代接続）
   - 依代差異を吸収し、統一入出力形式へ正規化する。
5. Persistence / Audit Layer（保存・監査）
   - 会話ログ、Sleep Bake成果、EdoHAGE台帳を管理する。

## 依存規則
- 上位レイヤは直下レイヤにのみ依存する。
- GUIはEngine Adapterへ直接依存しない。
- FAM Layerは特定ベンダーSDKを直接参照しない。
- Context Dimensionの列挙順、D数、OAEのAgency roleから、この技術依存順を推定しない。
- GUIはOAEのObserver、Initiator、Executor、Causal Agencyを表示できても、自動的に一主体へ統合・確定しない。

## 変更指針
- 表示要件の変更はPresentation Layerで閉じる。
- 判断規範の変更はFAM Layerで閉じる。
- 依代追加はEngine Adapter Layerで閉じる。
