---
domain: knowledge-validation
type: discoveries

game-version:
  - "1.02"

confidence: medium
verified: true

discovered-by: Sandevistan

evidence:
  - kind: runtime-experiment
    summary: "Sandevistan v1.107 ghostScan S 帧 vs R50 扫描差异复盘（Dictionary 对象键迭代序≠插入序）"

date-updated: 2026-08-15
---


## 发现

AVM2 的 `Dictionary` 以**对象**为键时，`for (key in dict)` 的迭代顺序不是插入序
（由哈希决定），且同一字典在不同时刻的遍历顺序可能因条目增删而变化。

## 实例

ghostScan 扫描爆炸记录字典（对象键）的"前 2 条"：S 帧取到 {f=119, f=129}（没
覆盖到 f=109 的爆炸点），R50/R100 取到 {f=109, f=119}——造成"鬼影在回放第 1-10
帧才出现"的假象，实际对象一直存在，只是 S 帧的扫描没看那个位置。

## 规则

- 需要稳定顺序的采样/遍历：用 **Array** 保存（插入序），Dictionary 只做查找。
- 对 Dictionary 的"前 N 条"结论默认不可信；要么全部遍历，要么记录每次实际
  取到的键（日志里带上锚点标识）。
