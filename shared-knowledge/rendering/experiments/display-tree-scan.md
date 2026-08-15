---
domain: rendering
type: experiments

game-version:
  - "1.02"

confidence: medium
verified: true

discovered-by: Sandevistan

evidence:
  - kind: runtime-experiment
    summary: "Sandevistan v1.107 ghostScan 实现与 v1.109 复盘（锚点 Dictionary 迭代序、found<4 截断、对象链≠显示树）"

date-updated: 2026-08-15
---


## 方法

在目标位置半径内逐图层枚举 `grafon.visObjs[sl].getChildAt(i)`，记录
类名（getQualifiedClassName）/坐标/visible/alpha，多帧重复扫描对比"哪些对象
钉死不动、哪些在动"。

## 关键注意（v1.107 误报教训）

1. **锚点集合的迭代顺序**：以 Dictionary（对象键）为锚点来源时，取"前 N 条"的
   结果在不同时刻可能不同——某帧"没扫到"可能是锚点根本没覆盖该区域，不是对象
   不存在。对策：锚点用数组并全部扫描，或记录每次实际使用的锚点坐标。
2. **每（锚点×图层）命中上限**：`found<4` 之类截断会静默掩盖第 5 个命中对象。
   对策：按类名聚合计数，或调高上限；至少记录"截断发生"。
3. **对象链 ≠ 显示树**：`loc.firstObj` 链上的对象计数（如 partsAlive）与显示树上
   实际可见的东西不是一回事——孤儿 vis 不在对象链上。两者必须交叉核对。
4. **先问用户再下结论**：鬼影"长什么样/在哪/动不动"三个问题的答案（本案例：
   "亮光/钉死不动"）能直接排除一半假说（武器视觉假说），比继续加诊断快得多。
