# Godot Reference Runtime／GAND Frame SDK Alpha選定

> Status: `[TARGET-SPEC]` `[ALPHA-CANDIDATE]` `[NOT IMPLEMENTED]`
>
> 制定日: 2026-07-29
>
> 横断方針: ZeroRoomLab-manifest `docs/projects/sphere-renderer-runtime-selection-20260729.ja.md`

## 1. 決定

SphereASTROのAlpha実装におけるReference Presentation RuntimeをGodotとする。

```text
SphereASTRO Core contracts
        ↓
BodyEvent／Telemetry／Avatar state
        ↓
GAND Frame SDK候補
        ↓
Godot Reference Runtime
        ↓
Desktop／mobile／AR／XR presentation
```

GodotをSphere Coreまたは人格runtimeの正本へしない。GodotはGUI、avatar、scene、AR／XR等を表示するPresentation Vesselである。

## 2. 現行Swift／SwiftUIとの関係

現行READMEが示すSwift／SwiftUI、iPhone／iPad fixtureは観測済み資産として保持する。

本決定は、既存実装を未検証のまま削除する指示ではない。Alphaでは次を比較可能にする。

- Swift／SwiftUIで確認済みの責任境界
- Godotで新設するcross-platform Presentation
- ASTRO RunnerとBody Rendererの接続契約
- iOS実機、desktop、将来のAR／XRでの差

Godot bootstrapが動いたことを、ASTRO Runner、推論接続、人格Storage、AR実機の完成証明へ使用しない。

## 3. Godot側の責務

- Chat／Voice／管理slotのGUI
- GLB／VRM avatar表示
- ASTRO avatar extensionの解釈
- 人型、SD、3D饅頭、2D／PNG fallbackの切替
- expression、viseme、gaze、gesture、manifestationのPresentation
- thermal、memory、KV、context、offline、freeze等の診断演出
- AR anchorへのavatar配置
- inputとUI eventを上位contractへ渡す

次はGodot側の責務へ自動的に含めない。

- 人格同一性の制定
- World Stateの正本
- model選択authority
- OAE因果の自動統合
- archive integrityの判定正本
- provider／LLM接続の唯一実装

## 4. GAND Frame SDK候補

過去のGAND-linked式神format／pipeline名称を受け継ぐGodot Presentation SDK候補として、次を予約する。

> **GAND Frame SDK**

現時点では正式な歴史互換仕様ではない。過去資料のデーターマイニングが完了するまで、namespaceと最小責務だけを予約する。

```text
status: HISTORICAL-DATA-MINING-WAIT
historical_oae: historical-oae-unavailable
compatibility_claim: NOT TESTED
```

### 4.1 Alphaで予約する責務

```text
GandFrame
  ├─ AvatarLoader
  ├─ BodyEventBus
  ├─ RepresentationResolver
  ├─ ExpressionDriver
  ├─ VisemeDriver
  ├─ GazeDriver
  ├─ GestureDriver
  ├─ ManifestationController
  ├─ DiagnosticPresentation
  ├─ AttachmentResolver
  └─ ResourcePressureAdapter
```

これらは候補名であり、過去GAND formatに同名fieldが存在したと主張しない。

## 5. Input／Output契約候補

### Input

- `BodyEvent`
- `AvatarState`
- `ManifestationState`
- `ResourceTelemetry`
- `CapabilityReceipt`
- `AssetReference`

### Output

- Godot scene state
- animation／expression state
- avatar representation selection
- user interaction event
- Presentation receipt

概念例:

```json
{
  "event": "manifestation.update",
  "character_id": "<stable-character-id>",
  "state": "MANJU_FALLBACK",
  "cause": "THERMAL_THROTTLE",
  "representation": "manju.png.baked",
  "telemetry_ref": "<receipt-ref>"
}
```

Presentationはcauseを勝手に生成せず、上位telemetryまたはruntime receiptを参照する。

## 6. Avatar pipeline

```text
GLB／VRM asset
  + ASTRO extension／manifest
        ↓
GAND Frame AvatarLoader
        ↓
representation set
  ├─ humanoid
  ├─ SD
  ├─ manju-3d
  └─ png-fallback
        ↓
Godot scene
```

普通のVRM readerでは標準人型として読める互換を優先する。ASTRO対応runtimeでは、同じcharacter stateから端末火力、thermal、context、TPO等に応じたrepresentationを選択する。

## 7. Resource-aware manifestation

Alpha fixtureでは少なくとも次を表現する。

```text
NORMAL
  → humanoidまたはselected representation

RESOURCE_PRESSURE
  → SD／3D饅頭

THERMAL_THROTTLE
  → 焼き饅頭PNG

PROCESS_FREEZE
  → 真空パック饅頭

KV_PRESSURE
  → filling漏れ

CONTEXT_LOW
  → しぼみ饅頭

OFFLINE
  → 寝饅頭
```

演出だけでなく実際の描画・physics・animation負荷も下げることを目標とする。見た目だけ饅頭へ変えて重い処理を継続する実装はfallback成功と扱わない。

## 8. Filling／engine presentation

`filling`は文化圏skinとengine family表示を分離する。

```text
engine family
  = 実行backendを識別する技術metadata

filling skin
  = あんこ、ずんだ、BBQ sauce、毛玉、情報子slime等のPresentation
```

両者を一対一固定しない。利用者が文化圏skinを変更してもengine identity receiptは失わない。

## 9. AR／XR

Godot Reference Runtimeでは、avatarを現実空間またはXR sceneへ配置するPresentationを射程に入れる。

Alphaの最小fixture:

1. camera／XR capabilityを検出する
2. anchorまたは固定座標へavatarを置く
3. capability不在時は通常3D viewへfallbackする
4. thermal上昇時はrepresentationを縮退する
5. AR session失敗を人格停止へ誤変換しない

ARはWorld Stateの自然科学的正本ではなく、選択されたPresentation／projectionである。

## 10. Atlantis／USADとの境界

AtlantisはWorld StateとUSAD SDKを担当し、UPBGEをReference World Driver対象とする。SphereASTROはUSAD for UPBGEを直接依存へしない。

共有候補:

- stable World／Entity／Character ID
- GLB／VRM asset
- engine-neutral event
- capability receipt
- explicit asset provenance

Godot sceneとUPBGE sceneは別projectionであり、同じscene fileまたはobject pointerを共有正本にしない。

## 11. Alpha実装順

1. Godot project bootstrap
2. 2D／3D scene切替fixture
3. GLB avatar表示
4. BodyEventBus最小実装
5. 3D饅頭とPNG fallback
6. resource telemetryのfixture入力
7. manifestation切替と負荷低下の計測
8. VRM互換経路の選定と試験
9. desktopまたはmobile実機一系統
10. AR anchor最小fixture
11. receiptと未試験範囲の記録

## 12. 過去データーマイニング待ち

過去のGAND、式神format、GAND-linked pipelineには回収対象が残っている。

現時点で確認できるのは、SphereASTROの既存agent定義に`GAND同期`および`astral_entity_gand_linked`のlineage表示が残っていることだけである。これを旧formatの完全仕様として扱わない。

発掘後は次を記録する。

- sourceとrevision
- 当時のfield／pipeline
- 現GAND Frame候補との対応
- 採用／非採用理由
- migration
- fixture
- historical OAEが取れない範囲

## 13. Non-goals

- Godotを人格modelまたはWorld authorityにしない
- Swift実装を即時削除しない
- Unity／Unreal／Web等を禁止しない
- 全platformをAlphaで同時完成させない
- 過去GAND仕様を現在の推論で補完しない
- avatar描画成功を推論成功または人格同一性の証明にしない
