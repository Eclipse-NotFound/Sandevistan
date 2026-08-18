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
    symbol: "fe.unit::UnitPlayer（抓取判定/teleObj 释放）; fe.Obj.levitPoss / massa / onCursor; fe.loc::Location.celObj / celDist"
  - kind: runtime-experiment
    summary: "Sandevistan v1.129-1.132 实测：怪物隐形后无法念力抓取；恢复 vis/invis/levitPoss 后恢复可抓"

date-updated: 2026-08-18
---

## 念力抓取（telekinesis）判定规则

抓取一个单位/物体（玩家按交互键，悬停目标 `loc.celObj`）需要**同时满足**：

1. `loc.celObj != null` 且 `celObj.onCursor > 0`——悬停目标由游戏按
   `onCursor` 值挑选（不可见目标通常不会被标中）；
2. **`celObj.levitPoss == true`**（fe.Obj.levitPoss，public，默认 true）——
   死亡（exterminate/setNull）或进入特殊状态（如僵尸钻地 aiState==5）会
   置 false；
3. `loc.celDist <= pers.teleDist`（距离）；
4. `celObj.massa <= pers.maxTeleMassa`（重量上限）；
5. 视线：`loc.isLine(玩家眼点, 目标中心)`（无视线提示 "noVisible"）。

抓取成功后 `gg.teleObj = celObj`；**持握期间释放条件**：
`celDist > teleDist*1.2 || mana<=0 || !teleObj.levitPoss`（任一满足即松手）。

## 对模组的意义

- **"抓不起来"最常见的原因是目标 `levitPoss=false` 或隐形（onCursor 不成立）**，
  而不是重量/距离——排查时优先读这两个公开字段。
- 单位被持握时 `levit_r` 递增（浮空计时），`levit_r > levit_max*unitLevitMult`
  会置 `levitPoss=false` 强制松手（游戏自己的浮空耐力设计）。
- 任何会改变单位可见性/状态的机制（隐身、钻地、死亡姿态、回放重演分歧）
  都可能间接破坏抓取；恢复 `levitPoss=true` + `vis.visible=true` 即恢复可抓。
