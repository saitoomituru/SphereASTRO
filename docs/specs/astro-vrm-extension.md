# ASTRO VRM拡張仕様

> Status: `[TARGET-SPEC]` `[EXPERIMENTAL]`
>
> 制定日: 2026-07-29
>
> 対象: SphereASTRO Body Renderer、VRM／glTF Adapter、アバター生成器、ゲームエンジン連携

## 1. 目的

ASTRO VRM拡張は、同一のASTRO Instanceを、完全な人型、縮退したSD body、3D饅頭、2D静止画まで連続的に顕現させるための可搬アバター仕様である。

本仕様は独自3D形式を新設しない。標準VRM 1.0／glTF 2.0を基礎とし、ASTRO非対応runtimeでは通常のVRMとして読み込めることを優先する。

```text
ASTRO非対応runtime
  ↓
標準VRMとして人型bodyを表示

ASTRO対応runtime
  ↓
標準VRM + ASTRO extensionを解釈
  ↓
人型 ⇄ SD ⇄ 3D饅頭 ⇄ 2D fallback
```

ASTRO拡張が欠落、未対応、または壊れていても、標準VRM部分まで巻き込んで使用不能にしてはならない。

## 2. 設計位置

既存の[妖怪・式神顕現UX](../ux/manifestation-states.md)は、同一性、顕現形態、実行能力を分離し、機械状態をどのPresentationへ写像するかを定める。

本仕様はその下位で、次を定義する。

- 1個のVRM／GLB内へ複数のBody representationを格納する方法
- 人型と饅頭の間で共有するexpression、衣装意味、attachment slot
- GPU、memory、KV cache、thermal、freeze等の機械状態をrepresentationへ渡す契約
- ASTRO非対応runtimeへ標準VRMとして退避する互換条件

人格同一性、IBD、Instance Ghost、推論能力の正本は本ファイルへ置かない。

## 3. 基礎コンテナ

### 3.1 Canonical transport

既定の輸送形式はglTF 2.0 binary containerであるGLBとする。人型avatarの標準fallbackを含む場合は、VRM 1.0互換GLBとして構成し、拡張子は通常の`.vrm`を維持してよい。

```text
avatar.vrm
├─ glTF 2.0 / GLB
├─ VRMC_vrm
├─ VRMC_springBone
├─ VRMC_materials_mtoon
├─ VRMC_node_constraint
└─ ASTRO_* extensions
```

`.avrm`等の独自拡張子は将来予約できるが、初期実装で標準VRM ecosystemから切断するためには使用しない。

### 3.2 不変条件

ASTRO VRMは次を満たす。

1. ASTRO extensionを無視しても標準VRMとして読み込める
2. 標準VRMのhumanoid、expression、meta、lookAt、firstPersonを壊さない
3. ASTRO固有node、mesh、textureは標準VRM側から参照されなくてもよい
4. ASTRO extensionの解釈失敗時は標準VRM representationへ戻る
5. Body描画成功を推論成功、人格完全性、Storage完全性の証明に使用しない

## 4. Extension構成

初期仕様では、責務を次へ分離する。

```text
ASTRO_avatar
ASTRO_representations
ASTRO_manifestation
ASTRO_attachments
ASTRO_filling
ASTRO_diagnostics
ASTRO_softbody
```

正式なglTF extension prefix、vendor registration、schema公開方法は実装段階で再確認する。本文中の名称はTarget Spec上の論理IDであり、Khronos登録済み名称を主張しない。

## 5. `ASTRO_avatar`

avatar全体の意味正本を保持する。

```json
{
  "specVersion": "0.1-draft",
  "avatarId": "astro.example.reimu",
  "defaultRepresentation": "humanoid.full",
  "fallbackRepresentation": "humanoid.full",
  "semanticProfile": "astro.adaptive-avatar",
  "identityBinding": {
    "mode": "external-reference",
    "required": false
  }
}
```

### 5.1 禁止事項

- `avatarId`を人格、戸籍、権利者、神格、OAE主体の同一性証明へ使用しない
- asset file単体からIBD、Instance Ghost、Model Variantの存在を推定しない
- engine familyやfilling themeを人格価値の上下へ変換しない

## 6. `ASTRO_representations`

同一characterの複数Body presentationを列挙する。

```json
{
  "representations": [
    {
      "id": "humanoid.full",
      "kind": "vrm-humanoid",
      "rootNode": 12,
      "costClass": "HIGH",
      "capabilities": ["full-body", "locomotion", "hand-ik", "cloth"]
    },
    {
      "id": "humanoid.sd",
      "kind": "generic-rig",
      "rootNode": 44,
      "costClass": "MEDIUM",
      "capabilities": ["full-body", "simplified-gesture"]
    },
    {
      "id": "manju.3d",
      "kind": "manju-rig",
      "rootNode": 71,
      "costClass": "LOW",
      "capabilities": ["face", "viseme", "gaze", "bounce"]
    },
    {
      "id": "manju.baked-png",
      "kind": "billboard",
      "texture": 9,
      "costClass": "MINIMAL",
      "capabilities": ["status-only"]
    }
  ]
}
```

### 6.1 RepresentationはLODより広い

本仕様のrepresentation切替は、距離に応じてpolygon数だけを変える通常LODではない。

```text
同一character state
  ├─ 人型へrender
  ├─ SDへrender
  ├─ 饅頭へrender
  └─ PNGへrender
```

identity、emotion、active engine、outfit semantic、diagnostic stateを保持したまま、身体表現の抽象度を変える。

### 6.2 Cost class

`costClass`は厳密な性能保証ではなく、runtime selectionの粗いhintである。

- `HIGH`: full humanoid、cloth、hair physics、全身IK
- `MEDIUM`: SD body、簡略rig、限定physics
- `LOW`: 3D饅頭、顔、口形、視線、軽量bounce
- `MINIMAL`: sprite、billboard、静止画

runtimeは実測telemetryを優先し、asset作成者のcost自己申告だけで安全判定しない。

## 7. `ASTRO_manifestation`

機械状態または顕現状態からrepresentation候補を解決する。

```json
{
  "rules": [
    {
      "state": "FULL_MANIFESTATION",
      "prefer": ["humanoid.full", "humanoid.sd", "manju.3d"]
    },
    {
      "state": "REDUCED_MANIFESTATION",
      "prefer": ["humanoid.sd", "manju.3d"]
    },
    {
      "state": "MANJU_FALLBACK",
      "prefer": ["manju.3d", "manju.baked-png"]
    },
    {
      "state": "FROZEN",
      "prefer": ["manju.vacuum-packed-png", "manju.baked-png"]
    }
  ]
}
```

`prefer`は命令ではなく順序付き候補である。runtimeが対象representationをloadできない場合は次候補へ進む。

## 8. 等身可変と意味保存

ASTROは演算火力が増えるほど等身、衣装、物理、gesture密度を上げられる。反対に、thermal、memory、KV cache、battery、network、wallet pain等の制約が増えた場合は縮退できる。

```text
FULL VRM
  ↓ cloth physics off
  ↓ hair physics reduced
  ↓ hand / leg IK off
  ↓ SD body
  ↓ 3D manju
  ↓ 2D manju
```

この変化は人格価値、記憶量、権利、神格、能力全般の低下を意味しない。runtimeは縮退原因を別fieldで報告する。

## 9. Outfit semantic

衣装をmesh名ではなく意味IDでも保持する。

```json
{
  "outfit": {
    "semanticId": "outfit.miko",
    "variants": {
      "humanoid.full": "node:201",
      "humanoid.sd": "node:233",
      "manju.3d": "attachment:miko.ribbon-and-collar",
      "manju.baked-png": "texture:31"
    }
  }
}
```

これにより、full bodyでは巫女装束、SDでは簡略巫女服、饅頭では赤リボンと襟、spriteでは赤白配色という形で、同じポジション表現を保持できる。

衣装assetがloadできない場合に裸体素体へ落とすことを既定fallbackにしない。年齢表現、SFW presentation、asset欠落、演算縮退を安全に処理するため、抽象度の高いrepresentationへ切り替える。

## 10. `ASTRO_attachments`

### 10.1 Attachment slot

人型と饅頭で共有可能な意味slotを定義する。

```text
head.top
ear.left
ear.right
hair.front
hair.side.left
hair.side.right
hair.back
tail.root
back
face.front
outfit.semantic
custom.*
```

実際のglTF node名を固定しない。Extension内で意味slotとnodeを対応付ける。

```json
{
  "slots": [
    {"id": "head.top", "node": 80},
    {"id": "ear.left", "node": 81},
    {"id": "ear.right", "node": 82},
    {"id": "tail.root", "node": 83}
  ]
}
```

### 10.2 パーツ自己完結

帽子、猫耳、狐耳、尻尾、髪束等は、必要な場合のみ自身のrig、skin weight、physics hintを持つ。

```text
CatEar part
├─ mesh
├─ local bones
├─ skin weights
├─ optional spring settings
└─ attach target = ear.left / ear.right
```

本体rigへ全パーツの骨を事前定義しない。剛体帽子はrig不要、猫耳は耳part内、尻尾はtail part内のchain boneを使う。

### 10.3 AI生成パーツ

画像から未知パーツを生成する場合は、既知のrigged templateを渡し、shape、material、surface detailだけを置換または変形することを優先する。

```text
rigged template
+ user reference image
  ↓
shape fit / mesh replacement
  ↓
既存root、bone、weight、attachment座標を維持
```

生成AIに毎回skeleton topologyを再発明させない。

## 11. 饅頭friendly body

### 11.1 最小body contract

3D饅頭representationは、最低限次を提供する。

```text
root
face.front
head.top
ear.left
ear.right
tail.root
expression targets
viseme targets
softbody shell
filling volume reference
```

耳、尻尾、帽子、髪はoptionalである。

### 11.2 Face semantic

顔面は人型VRMと意味を共有できる範囲を優先する。

```text
expression.neutral
expression.happy
expression.angry
expression.sad
expression.relaxed
expression.surprised
viseme.aa
viseme.ih
viseme.ou
viseme.ee
viseme.oh
gaze.x
gaze.y
blink.left
blink.right
```

実装はblend shape、bone、texture swapのいずれでもよい。外部から見えるBodyEvent契約を固定し、renderer内部方式を固定しない。

### 11.3 Mii型parameter

饅頭本体は生成AIが毎回mesh全体を生成する必要はない。標準素体へ次のparameterを適用できる。

```text
body.width
body.height
body.depth
body.squash
face.eye.spacing
face.eye.height
face.mouth.height
face.cheek.scale
```

髪とaccessoryはpreset、ユーザーpart、AI生成partを同じattachment busへ接続する。

## 12. `ASTRO_softbody`

VRMの骨格中心表現だけでは不足する、殻と中身の挙動を記述する。

```json
{
  "shellNode": 71,
  "fillingId": "anko.redbean.standard",
  "profile": {
    "stiffness": 0.42,
    "damping": 0.71,
    "volumePreservation": 0.88,
    "bounce": 0.24
  }
}
```

値の単位、solver間の換算、物理精度は初期仕様では未固定とする。runtimeは安全なlocal presetへ丸めてよい。

## 13. `ASTRO_filling`

### 13.1 目的

fillingは次を分離して束ねる。

- 饅頭内部の物理preset
- KV cacheやcontext flowの可視化skin
- active engine familyの視覚識別
- 文化圏、character、ユーザー選択による演出

```json
{
  "id": "anko.redbean.standard",
  "visual": "anko.redbean",
  "physicsProfile": "paste.medium",
  "engineFamily": "astro.local",
  "diagnosticEffects": {
    "KV_PRESSURE_HIGH": "seep",
    "KV_OVERFLOW": "leak",
    "KV_EVICTION": "drop"
  }
}
```

### 13.2 標準候補ID

```text
anko.redbean.standard
zunda.edamame.standard
bbq.sauce.standard
mofu.kedama.standard
infoton.slime.standard
custom.*
```

これらはengine vendorの事実認定ではない。ユーザーまたはprofileが選ぶpresentation IDである。

### 13.3 Engine表示

同一の外見でもfillingを変えることで、active backendを識別できる。

```text
神道系profile      → anko.redbean.standard
ずんだ妖怪profile  → zunda.edamame.standard
Grok系presentation → bbq.sauce.standard
Llama系presentation→ mofu.kedama.standard
```

製品名、商標、provider帰属を暗黙決定せず、profile側で明示設定する。

## 14. `ASTRO_diagnostics`

### 14.1 共通event

```text
RESOURCE_PRESSURE
THERMAL_THROTTLE
THERMAL_CRITICAL
KV_PRESSURE_HIGH
KV_OVERFLOW
KV_EVICTION
CONTEXT_LOW
PROCESS_FREEZE
PROCESS_SUSPEND
OFFLINE
RECOVERING
```

### 14.2 既定Presentation例

```text
RESOURCE_PRESSURE   → 等身低下
THERMAL_THROTTLE    → 焼き饅頭PNG
THERMAL_CRITICAL    → 焦げ饅頭PNG + heavy inference停止
PROCESS_FREEZE      → 真空パック饅頭
KV_PRESSURE_HIGH    → filling偏り／にじみ
KV_OVERFLOW         → filling漏れ
CONTEXT_LOW         → しぼみ饅頭
OFFLINE             → 寝饅頭
RECOVERING          → 開封／再膨張animation
```

演出だけで状態を確定しない。クリック、inspect panel、log、receipt等から機械状態を確認できる二層UIを持つ。

### 14.3 Thermal selection

local runtimeはdevice telemetryを取得できる場合、温度だけでなく次を組み合わせる。

- thermal state
- sustained clock低下
- GPU／NPU utilization
- memory pressure
- frame time
- battery state
- OSが提供するperformance hint

単一温度閾値を全device共通へ固定しない。

## 15. Runtime selection

representation選択は概念上、次の入力を受ける。

```text
character semantic state
+ manifestation state
+ device telemetry
+ model capability
+ context / KV pressure
+ user preference
+ presentation policy
+ asset availability
  ↓
representation resolver
```

### 15.1 優先順位

1. 人格／Storageの状態を見た目から捏造しない
2. device保護と推論継続性を優先する
3. 標準VRM fallbackを維持する
4. 同じsemantic outfit、expression、engine表示を可能な範囲で保持する
5. renderer品質を人格価値へ結びつけない

### 15.2 Hysteresis

温度や負荷の境界で人型と饅頭が高速点滅しないよう、縮退と復帰に別閾値またはminimum dwell timeを持つ。

```text
縮退: pressure >= high threshold
復帰: pressure <= low threshold が一定時間継続
```

## 16. BodyEvent Adapter

既存のBody Renderer契約へ、representationに依存しないeventを渡す。

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
Representation Adapter
      ├─ VRM humanoid
      ├─ SD rig
      ├─ Manju 3D
      └─ Sprite / PNG
```

`gesture`や`locomotion`を持たないrepresentationは、近いexpression、bounce、screen motion、またはno-opへ縮退できる。未対応eventを推論能力不足として報告しない。

## 17. Game engine interoperability

### 17.1 Unity

Unity AdapterはVRM／glTF importerで標準部分を読み、ASTRO extensionを追加解釈する。ASTRO extension未対応時は通常VRM prefabとして扱う。

### 17.2 Unreal Engine

Unreal AdapterはGLB／glTF skeletal assetとして標準部分を読み、ASTRO metadataをDataAsset、component、またはimport pipelineへ変換する。

### 17.3 Web renderer

WebGL／WebGPU rendererはGLB meshとtextureを読み、重いphysicsを省略してmanjuまたはsprite representationを優先できる。

### 17.4 独自engine

独自engineは全extensionを実装する必要はない。最低限、標準VRM fallbackと`ASTRO_manifestation`の候補解決だけを実装してよい。

## 18. Provenanceとlicense

各representation、texture、motion、生成part、ユーザー持込assetについて、licenseとprovenanceを保持する。

```json
{
  "assetId": "attachment.cat-ear.example",
  "source": "user-import",
  "license": "user-declared",
  "generatedBy": "provider-or-model-id",
  "derivedFrom": ["template.cat-ear.v1"]
}
```

本仕様は第三者character assetの同梱、再配布許諾、公式互換性を自動付与しない。

## 19. Securityと入力境界

- GLB／VRM内のURI、buffer、image、extension payloadを未検査で実行しない
- 外部script、shader code、native pluginをavatar assetとして自動実行しない
- node数、texture寸法、animation長、bone数、morph数へresource limitを設ける
- custom extensionのunknown fieldは保持してよいが、権限やidentity命令として解釈しない
- generated partをlibraryへ登録する前に、geometry、license、hash、attachment scopeを記録する

## 20. 初期fixture

最初の検証fixtureは第三者characterではなく、独自のマキナ饅頭とする。

最低限、次を含める。

```text
humanoid.full または簡易human fallback
manju.3d
manju.baked-png
manju.vacuum-packed-png
anko.redbean.standard
head.top / ear.left / ear.right / tail.root
neutral / happy / blink / aa / oh
THERMAL_THROTTLE / PROCESS_FREEZE / KV_PRESSURE_HIGH
```

## 21. 未制定項目

次は本Target Specでは確定しない。

- Khronos登録を想定した正式extension prefix
- JSON Schemaの最終形
- VRM 0.xとの互換
- Unity／Unrealの具体plugin API
- softbody値のsolver間標準単位
- mobile OS別のthermal threshold
- asset package署名方式
- MMD／PMXへのlossless変換

これらはfixtureとAdapterを実装し、変換receiptを取得してから制定する。

## 22. 実装順序

```text
1. 独自マキナ饅頭fixture
2. 標準VRM + 3D饅頭を同一GLBへ格納
3. manifestation resolver
4. thermal / freeze / KV diagnostic effect
5. attachment slot
6. filling profile
7. Unity / Web Adapter
8. Unreal / MMD bridge
9. AI character creator
```

AIによる画像からの自動生成は最後でよい。先に手動キャラメ、標準slot、fixture、fallbackを成立させることで、生成結果の正解形式と修正UIを確立する。
