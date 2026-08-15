---
domain: weapons-projectiles
type: discoveries

game-version:
  - "1.02"

confidence: high
verified: true

discovered-by: Sandevistan

evidence:
  - kind: runtime-experiment
    summary: "Sandevistan v1.32-1.65 回放武器调试 + v1.108 日志分析（visaglau 钉在时停结束位置）"
  - kind: decompiled-game-code
    symbol: "fe.weapon::Weapon.step"

date-updated: 2026-08-15
---


## 发现

在冻结/慢速世界里：

1. 武器的**逻辑位置**（Weapon.X/Y）可以被外部直接改写并生效于后续逻辑
   （开火点、碰撞等）。
2. 武器的**视觉位置**（vis.x/y）只在 `Weapon.step()→animate()` 里同步——
   冻结世界里武器不 step，改 X/Y **不会挪 vis**。
3. 玩家魔法槽法术的视觉靠 `UnitPlayer.control()` 里的 `magicWeapon.actions()+
   animate()` 跟随——玩家每帧手动 step 时它跟随；不 step 时冻结。
4. 时停/回放切换武器时，若沿用游戏 changeWeaponNow 的条件怪癖（tip==5 切枪
   不 remVisual），旧法术视觉会留在原地（见 weapon-switch-flow.md）。

## 对模组的启示

- 回放/冻结场景中要"武器跟着角色走"，必须显式驱动视觉：对枪械每帧
  `wv.X/Y=weaponX/weaponY` 后补一次 `wv.animate()`（或等价地手动同步 vis.x/y/rotation），
  或允许武器 step。
- 排查"某视觉钉死"类问题先区分：逻辑位置动没动（数据）vs 视觉动没动（画面）——
  两者同步路径可能完全不同。
