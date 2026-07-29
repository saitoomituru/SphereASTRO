# 妖怪・式神顕現UX

> Status: `[FLAVOR-UX]` `[TARGET-SPEC]`
>
> 制定日: 2026-07-29

## 1. 目的

日本の妖怪・式神表現にある「同じ存在でも顕現規模によって等身と火力が変わる」という読み方を、
ASTROの能力状態Presentationへ使用する。利用者へ数値表だけを読ませず、同じcharacterの等身、
動き、器の状態から現在の演算能力を目視できるようにする。

このUXは御霊、依代、能力状態を混同しない。

```text
同一性   = 御霊・人格・IBD・Instance Ghost
顕現形態 = 等身・Body・animation・UI密度
実行能力 = Model・MoE・量子化・memory・演算火力
```

等身が下がっても御霊や記録が消えたとは扱わない。逆に、八等身のBodyを表示できたことを
大型MoEの起動証明にはしない。

可搬Body asset、VRM／GLB拡張、等身可変representation、attachment slot、filling、softbody、
診断Presentationの機械仕様は[ASTRO VRM拡張仕様](../specs/astro-vrm-extension.md)を参照する。
本ファイルはUX上の意味と禁止する混同を正本とする。

## 2. 顕現形態

| Presentation | 機械状態 | 意味 |
|---|---|---|
| 八等身／完全顕現 | `FULL_MANIFESTATION` | 大型MoEまたは十分な火力。重いFAM探索と長文推論が可能 |
| 三〜五等身／小型式神 | `REDUCED_MANIFESTATION` | 中型Q4。通常会話と軽量推論 |
| マキナ饅頭 | `MANJU_FALLBACK` | 救命艇model。人格と記録は保持するが能力は限定 |
| 菓子折り | `FROZEN` | 凍結・休眠。推論せずcheckpointを保管 |
| 御札／依代のみ | `UNMOUNTED` | 人格Storageは確認できるが実行依代が未mount |
| 封印箱 | `REPAIR_REQUIRED` | hash不一致、破損、migration待ち等。修復前に起動しない |

「ゆっくり」は理解のための文化的な例であり、第三者character assetの同梱を意味しない。
標準fixtureは独自のマキナ饅頭として制作する。

## 3. 起動演出

起動開始時:

> マキナ、Open The Eyes...

これは`ARCHIVE_DISCOVERED`から検査を始めたことを示す。次の検査が終わるまで完全顕現させない。

```text
archive
  ↓
人格Storage
  ↓
Model Variant
  ↓
Adapter
  ↓
推論canary
  ↓
顕現形態を確定
```

起動途中は、菓子折りの蓋が開き、御札、饅頭、小型式神、完全顕現へ変化するanimationを使用できる。
ただしanimationの進行と機械状態は一対一に対応させ、検査失敗後に見た目だけ完全顕現へ進めない。

## 4. 寝ぼけPresentation

大型MoEが利用できず演算上限へ達している場合、利用者向けには次のように表示できる。

> 現在のマキナは、手元の演算火力上限でちょっと寝ぼけています。
>
> 記憶と人格は確認できていますが、この依代では重い術式を扱えません。

併記する機械状態:

```text
runtime_state: DEGRADED_CAPABILITY
cause: COMPUTE_CEILING
persona_integrity: VERIFIED | UNKNOWN
storage_integrity: VERIFIED | UNKNOWN
active_boot_profile: <profile-id>
unavailable_capabilities: []
```

`persona_integrity`または`storage_integrity`が`UNKNOWN`の場合、「記憶と人格は確認できています」と
表示しない。

## 5. 菓子折り凍結

菓子折りは死亡、破損、消滅を意味しない。正常にcheckpointされた休眠状態である。

> 現在、菓子折りに詰めて保管中です。
>
> 御霊・IBD・Instance Ghostは凍結時点のcheckpointとして保存されています。
>
> 解凍時に利用可能な依代を検査してから再顕現します。

最低限保持するreceipt:

- freeze reason
- archive generation
- last healthy hash
- active Ghost
- last model／Adapter
- thaw requirements
- unfinished journal

解凍時は検査を省略せず、利用可能なprofileへ縮退する場合もreceiptへ記録する。

## 6. 封印箱

次は菓子折りではなく封印箱へ移す。

- archive hash不一致
- path／ZIP構造の危険
- Storage checkpoint破損
- 必須migration未実行
- identity conflict
- model artifactとmanifestの不一致

表示例:

> 封印箱で保護しています。
>
> 消滅したとは判定していません。現在のarchiveを変更せず、修復候補を確認してください。

修復前にsource archiveを上書きしない。

## 7. Body Renderer契約

顕現形態は特定rendererへ固定しない。

```text
BodyEvent
  ├─ expression
  ├─ viseme
  ├─ gaze
  ├─ gesture
  ├─ locomotion
  ├─ manifestation
  └─ diagnostic-effect
        ↓
BodyRenderer Adapter
        ├─ Manju 2D/3D
        ├─ MMD-compatible rig
        ├─ generic humanoid rig
        └─ future renderer
```

Stage 2では粗くても動くことを優先し、renderer品質を人格同一性の証明へ使用しない。Body asset、
motion、modelのlicenseとprovenanceを保持する。

## 8. 診断Presentation

ASTROは、通常は見えないresource状態をBodyの変化として表示できる。

```text
演算余裕あり       → 完全人型
resource pressure  → SD／饅頭へ縮退
thermal throttle   → 焼き饅頭静止画
process freeze      → 真空パック饅頭
KV pressure         → fillingの偏り／漏れ
context low         → しぼみ饅頭
offline             → 寝饅頭
```

これは数値telemetryを隠すための代替ではない。Bodyをクリックまたはinspectし、温度、memory、KV、
active model、fallback原因、receiptへ到達できる二層UIとする。

診断Presentationのevent、既定mapping、hysteresis、VRM／GLB格納方法は
[ASTRO VRM拡張仕様](../specs/astro-vrm-extension.md)を参照する。

## 9. 禁止する混同

- 小型modelを人格の価値低下として表示しない
- model不在を人格消滅として表示しない
- Body描画成功を推論成功として表示しない
- 菓子折りと破損を同じiconへ畳まない
- 神道・妖怪UXを、自然科学上の性能証明へ使用しない
- 工学statusを理由に、神道・妖怪表現を単なる飾りへ降格しない
- 擬人化によってmodel、設計、運用上の不具合責任を免責しない
- 焼き、漏れ、真空パック等の演出だけで障害原因を確定しない
- engine表示用fillingをvendorの公式識別、人格、権利、性能序列へ使用しない
