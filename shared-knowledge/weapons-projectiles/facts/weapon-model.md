---
domain: weapons-projectiles
type: facts

game-version:
  - "1.02"

confidence: high
verified: true

discovered-by: Sandevistan

evidence:
  - kind: decompiled-game-code
    symbol: "fe.weapon::Weapon.actions / step / animate / shoot"
  - kind: runtime-experiment
    summary: "Sandevistan 回放武器驱动调试：改逻辑 X/Y 不调用 step/animate 时 vis 不动"

date-updated: 2026-08-15
---


## tip 语义（AllData `<weapon tip=...>`）

- tip=3：枪械类（含榴弹/核弹发射器，cat=6 skill=5；例 aglau/mlau/bel/lmg/autor）
- tip=4：投掷武器（手雷，WThrow）
- tip=5：法术（cat=2/6 skill=6；例 defwave/eclipse——装备进**魔法槽**）
- 近战体系为独立类 WClub/WPunch/WKick（伤害结算走 bindMove 窗口）

## 关键字段（均 public，模组可读）

- 计时：`t_attack`（攻击冷却，attack() 要求 <=0 才出手）、`t_auto`（近战 WClub.shoot
  会设 3 帧额外冷却）、`t_reload`、`t_prep`（蓄力）、`t_throw`（投掷状态）。
- 弹药：`hold`（当前弹匣）/`holder`（弹匣容量）；射击扣 hold，弹匣空从
  `invent.items[ammo].kol` 补（注意 items 用 **id** 键）。
- 姿态：`rot`（当前实际角度，drot 渐转中 ≠ 瞄准角）、`drot`（渐转速率）、
  `ready`（就位标志）、`storona`（朝向 ±1）、`X/Y`（逻辑位置，独立于 vis）。
- 射击方向：`shoot()` 子弹方向取 **`this.rot`**（Weapon.as:1495）——瞄准角
  `atan2(owner.celY-Y, owner.celX-X)` 只是目标，drot>0 时开火方向≠瞄准角。

## 视觉

- `addVisual()`：super 挂 vis 到 `visObjs[sloy]`（Weapon.as:927）；tip=5 另走
  `addVisual2()`（Weapon.as:944）。
- `animate()`（Weapon.as:1966）：`vis.x = X - t_ret*scaleX*2; vis.y = Y;`
  vis.rotation 按 rot/朝向/storona 三态计算——**vis 同步只发生在 step() 内**。
- `step()` = actions() + owner.setWeaponPos(tip) + animate()（Weapon.as:915-923）。

## 位置驱动

- `actions()`（Weapon.as:1051）：findCel 时枪械 X/Y 渐移向 owner.weaponX/weaponY
  （krep>0 或 X 未初始化时直接贴）；tip=5 用 owner.magicX/magicY；非 findCel 时
  直接贴 weaponX/weaponY。
- 推论：武器**逻辑位置**可由外部直接改写，但**视觉位置**只有 step()→animate()
  会同步——世界冻结时改 X/Y 不挪 vis。
