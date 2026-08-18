---
domain: entities
type: facts

game-version:
  - "1.02"

confidence: high
verified: true

discovered-by: Sandevistan

evidence:
  - kind: decompiled-game-code
    symbol: "fe.unit::UnitZombie.animate / control（aiState==5/6 分支）; fe.Obj.levitPoss"
  - kind: runtime-experiment
    summary: "Sandevistan v1.132 实测：回放重跑 AI 会把僵尸推入 burrow（aiState=5），回放结束残留隐形+不可念力抓取"

date-updated: 2026-08-18
---

## 僵尸（UnitZombie）的钻地/隐身状态（aiState==5/6）

僵尸有钻地（burrow）伪装状态，由 AI 状态机驱动：

- **aiState==5（钻地隐藏）**：控制层置 `vis.visible=false`（animate 分支）、
  `invis=true`、**`levitPoss=false`**、`fixed=true`、`scY=0`、`overLook=true`、
  `activateTrap=0`、`stealthMult=0`。视觉完全消失，且**不可被念力抓取**
  （`levitPoss=false` 直接挡住抓取判定，见 telekinesis-grab-rules）。
- **aiState==6（出土）**：`vis.visible=true`，播放 "dig" 出土动画。
- 动画状态还含 aiState==4（"pre" 预攻击）、==7（"super" 大招）等。
- `digger` 字段（0-3）来自房间 XML（`param3.@dig`）或随机决定该僵尸是否
  会钻地；`loc.active==false`（离开房间）时 digger 会切换状态。

## 对模组的意义（重要）

- 僵尸可见性**不是由 vis 直接控制的**：`aiState` 是 internal，模组无法
  读写。`vis.visible=false` 只是钻地状态的**结果**。
- 任何会**重跑/冻结 AI** 的机制（时停冻结、回放重演、慢速）都可能让 AI
  分歧：把僵尸推入 aiState==5（玩家被钉住/距离判定异常时尤其容易），
  状态会**残留到回放结束后**——表现为"偶发隐身的尸鬼"，并且因为
  `levitPoss=false` 连带**无法念力抓取**。
- 可用的恢复手段（公开字段）：`vis.visible`、`invis`（public Boolean）、
  `levitPoss`（public Boolean，fe.Obj 默认 true）都可在每帧按快照强压；
  `fixed`/`aiState` 无法直接改，但 `Unit.step` 不检查 fixed——只要世界正常
  步进，AI 会自行重新评估并在玩家靠近时走 aiState==6 出土。
- 怪物族谱：UnitZombie extends UnitPon（小马形僵尸）；辐射蝎等其他怪物
  是 UnitMonstrik（见 monster-blit-animation.md），无 burrow 但同为贴图动画。
