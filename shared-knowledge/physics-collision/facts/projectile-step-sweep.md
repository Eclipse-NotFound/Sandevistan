---
domain: physics-collision
type: facts

game-version:
  - "1.02"

confidence: high
verified: true

discovered-by: Sandevistan

evidence:
  - kind: runtime-experiment
    summary: "Sandevistan v1.83-1.92 stepProjHits 实现与调试（相对速度扫掠 R(t)=O+t·RV）"
  - kind: decompiled-game-code
    symbol: "fe.weapon::Bullet.step"

date-updated: 2026-08-15
---


## 步进粒度问题

- 抛射物每**世界步**移动一次（速度=px/步，如 aglau 榴弹 45、lmg 子弹 200），
  碰撞检测按步进行——高速弹整步穿越小目标（28px 手雷半径 < 200px 步长）会漏判。
- 对"子弹 vs 投掷物"这类**双方都在动**的判定，只用段端点检测仍不可靠（高速
  相向时两条段整段交叉错过）。

## 相对速度扫掠（已验证的通用解法）

把两个运动体化为同一时间参数 t∈[0,1] 的相对运动：

```
O  = 起步相对位置差（子弹起点 - 目标起点）
RV = 相对速度（子弹位移 - 目标位移，各取本步位移）
R(t) = O + t·RV
命中判定：|R(t*)| ≤ 命中半径（t* = 最近点参数，钳制到 [0,1]）
```

- 钳制端点自然覆盖"相向/追尾/静止/侧面"全部情形。
- 相向高速时最近点可能在段中（两段交叉点），只有参数化扫描能抓到。

## 同源与自伤守卫（投掷物可击落场景）

- 出生距离守卫：投掷物距发射者 <200px 时不判定（防刚出手被自己连射炸脸）。
- 自测防护：爆炸弹同时出现在弹表与物表时 `b==p` 跳过（防刚出膛自爆）。
- 近战体（vel<1）排除在可击落判定外（防手雷被"拳击"引爆、近战体被误移除）。

## 引爆后的统一清理

- 击中引爆后置 `p.liv=0`——Bullet/PhisBullet/SmartBullet 的 step 对 liv<=0 均
  走 vse→remObj 出链，避免"已爆的弹继续飞"的视觉鬼影（游戏常规行为本就如此）。
