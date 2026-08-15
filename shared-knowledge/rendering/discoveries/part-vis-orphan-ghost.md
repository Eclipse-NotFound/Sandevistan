# 粒子孤儿 vis = 冻结世界里的"钉死鬼影"

---
domain: rendering
type: discoveries
source: Sandevistan mod v1.107-1.108 排查（ghostScan 日志 + 用户三方确认）
game-version: 1.02
mod: Sandevistan
confidence: high
verified: true
date: 2026-08-15
---

## 发现过程（可直接复用的排查模板）

1. **症状**：时间停止/回放类 mod 中，爆炸位置出现一团"钉死不动"的亮光（visualFlare
   类），从回放开始存在，直到回放中该位置再次爆炸才消失。
2. **显示树扫描**（见 experiments/display-tree-scan.md）：爆炸坐标 300px 内、sloy=3
   层上发现 `visualFlare` + 2 个裸 MovieClip，vis=1 alpha=1 全程可见。
3. **交叉排除**：对象链粒子计数（firstObj 链 `is Part`）≈0 → 不是活粒子本体；
   武器视觉（visaglau/visdefwave）在后续扫描中已移出范围 → 不是武器。
4. **代码定位**：`Part.setNull` 无 remVisual（Part.as:66-77）→ 粒子死后 vis 遗留在
   图层上 → 冻结世界无 `setLight→drawAllObjs` 重建 → 孤儿一直显示。
5. **消失时机的解释**：回放中 boom 重演爆炸 → `explDestroy` 破坏瓦片 → 光照重算 →
   `drawAllObjs` 重建图层 → 孤儿被抹掉。与用户"爆炸结束后鬼影消失"完全吻合。

## 结论（跨 mod 可引用）

- 在**任何冻结/慢速世界**里做"爆炸后清理"时，光杀粒子对象（setNull）不够——
  必须同步摘除 vis（remVisual），并对已自然死亡的粒子做显示树扫除。
- 该游戏粒子死亡路径不摘 vis 是引擎侧事实（不是特定 mod 引入的），正常游戏里被
  图层重建掩盖；mod 改变世界步进节奏后就会暴露。
