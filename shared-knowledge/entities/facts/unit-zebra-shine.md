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
    symbol: "fe.unit::UnitZebra.animate / control; fe.unit::Unit.isShoot; fe.weapon::Weapon.shine"
  - kind: runtime-experiment
    summary: "Sandevistan v1.128 实测：敌人斯安维斯坦 5× 补步后斑马恒隐形；置 isShoot=true 后立即恢复可见"

date-updated: 2026-08-18
---

## 斑马（UnitZebra）的"光泽"隐形机制

斑马的可见性完全由内部字段 `shine`（internal，模组不可直接访问）派生：

- 每帧 `animate()`：`shine--`（`shine2>0` 时先扣 shine2 不扣 shine）；随后
  `vis.alpha = shine/100`（向下直接跳变、向上每帧 +0.1 渐变）；`currentWeapon.vis.alpha`
  与 `hpbar.alpha` 同步。
- `control()`：`invis = (shine < 15)`（invis 是 public，可读）。
- **回充路径（均为游戏自身逻辑）**：
  1. 移动增益：`shine<150 && (dx>2||dx<-2||dy>2||dy<-2) && aiTCh%10==5 && showThis()`
     → 快速 +15 / 慢速 +5，并置 `shine2=20`（20 帧内不再自然衰减）；
  2. 受击/战斗：`attackerType==0 && aiAttack && shine<100` → shine=100；
  3. **开火重置**：`if(isShoot && currentWeapon) { shine = currentWeapon.shine; isShoot = false; }`
     ——`isShoot` 是 public（fe.unit::Unit.isShoot，全游戏仅 UnitZebra 消费），
     `currentWeapon.shine` 是 public（默认 500）。**外部把 isShoot 置 true，
     下一次 animate() 即把 shine 恢复到武器光泽 → 立即回亮**，且 isShoot 被
     斑马自己清零，无副作用。
- 静止且无视线（showThis=false）的斑马：纯衰减 1 点/步，约 85 世界步后
  invis=true、alpha≈0——这是**本体伪装机制**（不是 bug）。

## 对模组的意义

- 任何**加速步进**（多调 step()）的模组都会把斑马的光泽消耗按倍率放大
  （shine 是 per-step 衰减），导致斑马加速期间/结束后隐形——用上面的
  isShoot 公开路径回充即可。
- 不要试图直接读写 `shine`（internal，密封类访问抛 ReferenceError 且被
  try 吞掉）；`vis.alpha` 强置无效（下一帧 animate 立即按 shine 重算）。
- 判定斑马当前是否隐形：读 `invis`（public）或 `vis.alpha < 0.5`。
