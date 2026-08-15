# 武器切换流程（changeWeapon/changeWeaponNow）

---
domain: weapons-projectiles
type: facts
source: UnitPlayer.as:3587/3670、control:2401、:442、:686、:1210（1.02 反编译）
game-version: 1.02
mod: -
confidence: high
verified: true
date: 2026-08-15
---

## 切换流程

1. `changeWeapon(id)` → 设 `work="change"`、`t_work`（切换动画倒计时）、`newWeapon`。
2. `t_work` 归零 → `changeWeaponNow(1)`（**卸旧**）→ `changeWeaponNow(2)`（**装新**）。
   - `(1)`：`currentWeapon.remVisual()` **除非** `currentWeapon.tip==5 且 newWeapon
     不是 tip==5`（UnitPlayer.as:3670-3681 的怪条件：从法术切到枪时**不摘除**法术
     视觉——游戏自身行为）；然后 currentWeapon=null、childObjs[0]=null。
   - `(2)`：currentWeapon=newWeapon、childObjs[0] 同步；`addVisual() + setNull() +
     setPers() + weaponLevit()`；tip==4 且 fav[29] 空 → 兼任 throwWeapon；
     tip==5 且 fav[30] 空 → 兼任 magicWeapon；最后 `gui.setWeapon()`。
3. 过程中 `vision` 按武器 visionMult 更新。

## 武器槽（UnitPlayer）

- `currentWeapon` / `throwWeapon` / `magicWeapon` / `psyWeapon`（天角兽，internal）。
- 魔法槽=快捷栏第 30 格：`magicWeapon = invent.weapons[invent.fav[30]]`（:442-444）。
- 每个 control() 帧：magicWeapon/throwWeapon（非 currentWeapon 时）跑
  `actions()`，tip==5 再加 `animate()`（:1210-1215）——**法术视觉跟随玩家靠这条路径**。
- `setWeaponPos(tip)`：UnitPlayer 版按 tip 更新 weaponX/weaponY（:3514）。

## 快捷槽与疾跑重映射

- 数字键 `useFav(N)` 取第一组快捷槽；**疾跑（keyRun）时映射到第二组
  `useFav(N+kolHK)`**（control:2401）——第二组通常为空=疾跑中切不了枪
  （Sandevistan mod 的 swaprun 功能即为此而做）。

## 对模组的启示

- 外部模拟切换要复刻 changeWeaponNow(1)+(2) 全套（remVisual/addVisual/setNull/
  setPers/gui.setWeapon），否则视觉/GUI/属性缺位。
- 世界冻结期间 t_work 倒计时随世界步推进——减速世界里切换动画可能整个时停都
  完不成（currentWeapon 保持旧枪）。
