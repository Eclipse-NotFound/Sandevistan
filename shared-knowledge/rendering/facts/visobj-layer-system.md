---
domain: rendering
type: facts

game-version:
  - "1.02"

confidence: high
verified: true

discovered-by: Sandevistan

evidence:
  - kind: decompiled-game-code
    symbol: "fe.graph::Grafon.drawAllObjs / setLight / visObjs; fe.Pt.addVisual / remVisual"
  - kind: runtime-experiment
    summary: "Sandevistan ghostScan 显示树扫描实测图层用途（武器 sloy=2、特效 sloy=3、UI sloy=4/5）"

date-updated: 2026-08-15
---


## 图层结构

- `World.w.grafon` 持有 `visObjs[0..7]`（Sprite 数组，`kolObjs` 个图层），全部挂在
  `grafon.visual` 下；世界视觉按对象 `sloy` 属性挂到对应图层。
- 已确认的图层用途（实测）：sloy=2 = 武器/单位视觉（visaglau/visdefwave/
  visbulgren40 均在此层）；sloy=3 = 特效/粒子/血条（visualFlare、爆炸 MC、hpBar）；
  sloy=4/5 = UI 型粒子（伤害数字 visualNumb、标记 visualMarker、gui 光 visBulb）。

## 挂载与摘除

- `Pt.addVisual()`：`if(vis && loc && loc.active) grafon.visObjs[sloy].addChild(vis)`
  （Pt.as:38-42）。
- `Pt.remVisual()`：`vis.parent.removeChild(vis)`（Pt.as:44-48）——**存在且 public**，
  但见 part-lifecycle.md：粒子死亡路径从不调用它。
- 武器特殊路径：tip=5 法术武器的视觉经 `Weapon.addVisual2()` 挂到
  `visObjs[sloy]`（Weapon.as:944），普通武器走 `Weapon.addVisual()`（super 调用）。

## 图层重建（孤儿视觉的清扫机制）

- `Grafon.drawAllObjs()`（Grafon.as:703）：**销毁并重建全部 visObjs 图层**——
  按原 index 移除旧 Sprite、new 空 Sprite 放回，然后遍历 `loc.firstObj` 对每个存活
  对象重新 `addVisual()`，再补 `loc.gg.addVisual()` 与 signposts。
- `drawAllObjs` 由 `Grafon.setLight()`（Grafon.as:685→681）调用——即**光照重算**时
  触发（例如爆炸 `explDestroy` 破坏瓦片后）。
- 推论：任何"死了但 vis 还挂在图层上"的孤儿视觉，会在下一次光照重算时被无声清除；
  在世界冻结（onPause）或光照不重算的时段内，孤儿视觉会一直显示。

## 视觉同步的驱动源

- `Weapon.animate()` 每步把 `vis.x/y = X/Y`、`vis.rotation = rot*180/PI ± rotUp` 等
  （Weapon.as:1966-2011）——武器 vis 只在武器被 step 时跟随；冻结世界里逻辑 X/Y
  被外部改掉、vis 不会动。
