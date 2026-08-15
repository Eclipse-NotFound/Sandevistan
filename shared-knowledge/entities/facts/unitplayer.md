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
    symbol: "fe.unit::UnitPlayer.control / setWeaponPos"
  - kind: runtime-experiment
    summary: "Sandevistan 回放玩家驱动（gg.step 手动驱动）实测"

date-updated: 2026-08-15
---


## 驱动

- `loc.gg` = 玩家；`Location.step()` 开头 `gg.step()` 驱动玩家（其余实体走
  firstObj 链）——模组在冻结世界里手动 `gg.step()` 即可让玩家单独行动。
- `ggControl=false` 时 control() 全失效（移动/攻击/念力）。

## 武器槽与快捷栏

- 槽：`currentWeapon/throwWeapon/magicWeapon/psyWeapon`；魔法槽=快捷栏第 30 格
  `invent.fav[30]`；`teleObj`=念力抓取对象。
- 快捷栏重映射：疾跑中数字键映射第二组 `fav[N+kolHK]`（详见
  weapons-projectiles/facts/weapon-switch-flow.md）。

## 手部位置与瞄准

- `weaponX/weaponY`（手上武器位置）、`magicX/magicY`（法术位）、`setWeaponPos(tip)`
  每步更新；`weaponLevit()` 念力持枪。
- 瞄准：`owner.celX/celY` = `World.w.celX/celY`（Camera.calc 每帧把鼠标屏幕坐标
  换算成世界坐标）——武器 rot 向其 atan2。

## 属性（模组常用）

- `hp/ggControl/mana/storona/dx/dy/stay/maxSpeed/runForever`（公开可写瞬时值，
  动画后需恢复）、`work/t_work`（切换动画状态）、`pers`（天赋/等级）、
  `invent`（items 按 id 键 / ammos 按 base 键派生）。
