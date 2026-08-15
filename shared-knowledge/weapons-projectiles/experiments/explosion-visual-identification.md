# 爆炸视觉成分识别法

---
domain: weapons-projectiles
type: experiments
source: Sandevistan mod v1.98/1.105/1.108 排查流程
game-version: 1.02
mod: Sandevistan
confidence: medium
verified: true
date: 2026-08-15
---

## 目标

给定一次爆炸，确定它到底在画面上生成了哪些视觉对象、各活多久——用于区分
"正常爆炸残影"与"异常滞留"。

## 步骤

1. **查定义**：武器 `<vis visexpl=...>` 决定 explVis；爆炸类型由 tipDamage 决定
   explBlast 分支（D_EXPL→expl/flare/iskr；D_BALE→balefire+baleblast…）。
2. **查粒子定义**：AllData `<part id=...>` 的 vis/blit/minliv/anim/alph——
   哪些是 Blit（bitmap 帧）、哪些是 MC（影片剪辑）、寿命多长。
3. **运行时清点**：爆炸后立即遍历 `loc.firstObj` 链，对 `is Part` 的对象记录
   vis 类名/blit/anim/liv/坐标（Sandevistan 的 boomPart 诊断即此）。
4. **交叉验证显示树**：同时扫 `grafon.visObjs` 图层（display-tree-scan.md）——
   对象链上的"活粒子"与显示树上的"可见视觉"是两个集合，差异就是孤儿/滞留。
5. **判断**：活粒子寿命内=正常爆炸；粒子已死但 vis 可见=孤儿（Part.setNull
   不摘 vis，见 rendering/facts/part-lifecycle.md）；动画播完停在亮帧=需确认
   该资产末帧是否空白（正常游戏靠图层重建兜底）。
