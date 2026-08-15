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
    symbol: "fe.graph::Part.setNull / Part.step / Pt.remVisual / Emitter.cast"
  - kind: runtime-experiment
    summary: "Sandevistan v1.108 killPartsDeep 实测：Part.setNull 后 vis 仍留在显示树（需自行 remVisual）"

date-updated: 2026-08-15
---


## 类结构与生成

- `fe.graph.Part extends Pt extends Obj`；由 `Emitter.emit(id, loc, x, y, opts)` →
  `Emitter.cast()` 创建（`new Part()`，按 AllData `<part>` 定义配置字段）。
- 生成上限：`Emitter.kol2 > World.maxParts && imp==0` 时拒绝生成；`maxkol` 型粒子
  同屏数量受限（kols[] 计数，setNull 时递减）。
- AllData 定义两类粒子（AllData.as:6899-7034）：
  - **Blit 型**（`blit='sprX'`）：vis=裸 MovieClip + 内嵌 Bitmap（visBmp，居中），
    `blitFrame` 随 step 从 blitData 拷贝像素帧。
  - **MC 型**（`vis='visualX'`）：vis=具名影片剪辑，`initVis` 后 `gotoAndPlay`。

## 生命周期与关键字段

- `liv` 每 step 递减 1；`otklad`>0 时 vis 隐藏并 stop()（延迟出现）。
- `step()`：延迟→（解除隐藏+play）→ isMove 位移/旋转→ alpha 处理（isAlph：liv<9 淡出；
  isPreAlph：前 9 帧淡入）→ blit 帧推进 → 水属性处理 → `--liv`，`liv<=0 → setNull()`
  （Part.as:141-204）。

## setNull 的陷阱（重要，本游戏真实 bug）

- `Part.setNull()`（Part.as:66-77）只做：`visData.dispose()`（Blit 型位图数据释放）、
  `loc.remObj(this)`（出对象链）、maxkol 计数递减、`delete global[this]`。
- **从不调用 `Pt.remVisual()`**——粒子死后其 vis 仍留在 `grafon.visObjs[sloy]` 图层上，
  冻结在死亡时的帧/透明度。
- Blit 型死后 vis 渲染空白（visData 已 dispose），MC 型死后**冻结在死亡帧**——
  若动画未播完（如死亡帧是亮帧）就是一团钉死的光。
- 正常游戏里这些孤儿靠 `Grafon.setLight→drawAllObjs` 重建图层抹掉（见
  visobj-layer-system.md）；冻结/慢速世界里会长时间可见（见 discoveries/
  part-vis-orphan-ghost.md）。
- **外部代码清粒子时必须自行 `remVisual()`**（Sandevistan mod v1.108 的
  killPartsDeep 即此模式），否则复制出同样的孤儿。
