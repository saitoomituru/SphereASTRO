# 対応実機・検証炉

> Status: Hardware Policy / 2026-07-29

## 目的

SphereASTROの品質確認を、ラボが実際に所有する実機と必要最小限のSimulatorへ限定する。端末マトリクスを無償で増殖させず、追加火力が必要な検証はCompute Requestとして分離する。

## 正式な実機

| 実機 | 主な責務 |
| --- | --- |
| iPad Pro 13-inch (M4) | 安定推論の主依代、長時間推論、M4 Metal実測 |
| iPhone 15 Pro Max | 実機クライアント、UI、軽量推論、端末間接続 |

この2機種以外は、互換性や商用品質を保証する対象に含めない。

## 必要なSimulator

- 既存環境にあるiPad Pro 13-inch (M4) Simulatorを、unit testとUI起動試験の既定とする
- iPhone 15 Pro Max Simulatorは、既存Xcode環境に存在する場合だけ補助利用する
- テストのためだけに追加runtimeや別世代Simulatorをインストールしない
- iPhone 16等の代替機種で通過した結果を、正式実機の通過として扱わない

Simulatorは画面遷移、状態管理、Adapterの失敗処理を確認する補助手段であり、Metal性能、発熱、電力、memory pressure、長時間安定性の証拠にはしない。

## 開発炉

Hackintoshは次に限定する。

- Swift / SwiftUIの編集とgeneric iOS build
- Ollama Adapterの疎通
- モデル変換および互換観測
- 実機投入前の短時間回帰試験

Hackintoshを常設の安定推論サーバーとは位置づけない。安定推論の性能receiptはiPad Pro 13-inch (M4)から採取する。

## 火力ゲート

次の作業は自動的に要求しない。

- 新しいXcode Simulator runtimeの導入
- 未所有端末の互換試験
- 大規模なDevice Farm
- GPUクラウド上の長時間試験
- 大型モデルの追加取得や再量子化

必要になった場合は、対象、必要時間、概算費用、期待成果、代替手段を火力要請として提示し、人間の承認後に実行する。

## Receipt境界

検証結果には必ず次を残す。

- `hardware_class`: `iphone-15-pro-max` または `ipad-pro-13-m4`
- 実機 / Simulatorの別
- OS、app commit、model ID、runtime ID
- cold / warm start
- peak memory、発熱またはthermal state、token速度
- 未検証事項

generic build成功、Simulator成功、実機推論成功は別々の事実として記録する。
