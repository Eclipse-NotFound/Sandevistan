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
    symbol: "fe.unit::UnitZombie.animate; fe.unit::UnitMonstrik.animate; fe.unit::Unit.blit"
  - kind: runtime-experiment
    summary: "Sandevistan v1.71-1.132 敌人回放实测：贴图怪在回放中偶发僵死；按位移喂 dx+补 animate() 后恢复"

date-updated: 2026-08-18
---

## 怪物贴图动画架构（Blit 动画）

僵尸（UnitZombie）、辐射蝎等怪物（UnitMonstrik）不使用 MovieClip 身体动画，
而是**贴图（blit）动画**：

- 每个怪物持有一张 `anims` 表：`anims[animState]` → `BlitAnim`
  （internal，模组读不到）。状态名示例：`stay / walk / trot / run / jump /
  attack / die / death / pre / super / dig / plav`。
- `animate()` 每帧：根据 `stay`、`dx`、`aiState`、`sost` **重新推导
  animState**（如：stay 且 dx≈0 → "stay"；dx>6 → "trot"；aiState==3 → "run"），
  状态变化时 `anims[s].restart()`；然后 `anims[s].step()` 推进内部帧 f、
  `blit(anims[s].id, f)` 把纹理块画到 vis。
- **帧号不可读**：`vis.osn.body.currentFrame` 对这类怪物恒为 -1（没有 MC
  身体）——不要像小马类那样做逐帧录像，唯一公开驱动入口是 `animate()`。

## 关键陷阱：位置钉住 → AI 停步 → 动画僵死

- `animState` 每帧由 `stay`/`dx` 重新推导。任何把怪物**位置钉死**的重放/
  慢放机制都会让控制层算出 `dx≈0`（AI 认为已到达目标），于是 animate()
  恒走 "stay" 且 `anims["stay"].st==true`（非循环态）——**贴图不再推进，
  怪物原地定住**（表现为"回放中尸鬼/蝎子动画僵死"）。
- 修复模式：按记录位移折算 `dx`/`dy`（public）喂给怪物后再调一次
  `animate()`，动画即按真实移动档位（run/trot/walk）重现；步后仍需重钉
  位置（step 内 run() 会真移动）。
- 同帧内 AI 的 `control()` 会重算 dx，所以喂入是瞬时值（每帧都要喂）。

## 衍生事实

- `UnitZombie extends UnitPon`（小马形僵尸），但 animate 重写为 blit；
  僵尸的 `vis` 是承载 `visData` BitmapData 的容器，`vis.visible` 由 aiState==5
  分支控制（见 unit-zombie-burrow.md）。
- UnitMonstrik 按 `cid` 区分品种（scorp/肉食灵等共用一套 `anims` 状态机），
  aiState 0/1/2/3 对应潜伏/移动/攻击等，无 burrow/vis.visible 隐藏。
