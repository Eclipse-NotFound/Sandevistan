# 单位核心（Unit）

---
domain: entities
type: facts
source: Unit.as/UnitPlayer.as（1.02 反编译 build/game-src/src102）+ Sandevistan mod
game-version: 1.02
mod: -
confidence: high
verified: true
date: 2026-08-15
---

## 状态与 AI

- `sost`：1=正常活动，3=死亡姿态（不真死：control 早退、animate 播 die 动画），
  4=尸体（explGas 等遍历跳过）。
- `enemyAct`：全局 AI 门控（模组可写）——`findCel` 需 >1（寻敌），攻击需 >=3；
  =1 时 AI 状态机运行但既不寻敌也不攻击（可用来"只播动画"）。
- `control()` 开头 `if(!ggControl) return;`——对话/死亡等触发 controlOff()；
  对应 controlOn()。
- 动画体系：小马类（Raider/Slaver/Zebra/UnitPon/Merc）动画由 `aiState` 驱动
  （`dx==0||aiState==7` 恒 stay 分支——AI 状态冻结时动画僵死）；怪物类用
  `anims/BlitAnim`（**internal，模组读不到**），只能驱动公开的 `animate()` 让
  游戏自身动画管线按状态渲染。
- `storona`：朝向 ±1；`Unit.rot` 是**朝向角**（`storona>0?0:PI`），与攻击体的
  飞行方向角 rot **同名不同义**——视觉恢复按对象类型隔离（v1.50 教训）。

## 位置 API

- `setPos(x,y)` 更新位置+碰撞边界；`setVisPos()` 同步视觉（含 storona 翻转）——
  两者都是 **Unit 独有**（密封类陷阱见 world-objects/facts/object-containers.md）。
- 外部改单位位置不调 setVisPos → 视觉留在原地（"敌人固定不动"类假象的常见来源）。

## 死亡与预判死亡

- 真死走 `die()`（掉落武器/物品、timerDie）；`disabled=true` 使 Unit.step 早退
  （炮塔类预判死亡可视化可用，且无死亡动画的 Turret/Bloat/Robot/Msp 的 animate
  不检查 sost）。
- 受击相关：`invulner`（完全打不中）、`godMode`（掉血即复位——见
  physics-collision/facts/knockback-invulnerability.md）、`unres`（无伤单位）。
