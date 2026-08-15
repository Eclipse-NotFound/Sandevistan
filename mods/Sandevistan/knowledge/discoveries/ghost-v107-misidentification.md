# v1.107 鬼影误报的教训（本模组发现）

---
domain: mod-knowledge
type: discoveries
source: sandy_modlog.txt ghostScan 日志 + v1.108 修复过程
game-version: 1.02
mod: Sandevistan
confidence: high
verified: true
date: 2026-08-15
---

## 现象与误报

v1.107 的 ghostScanS（回放开始时刻）在爆炸记录附近只发现两个"可见武器视觉"
visdefwave/visaglau，于是把鬼影归因于"武器 vis 被钉死"。v1.108 深挖后证明是误报：

1. **它们本来就是玩家时停结束位置手边的武器视觉**（时停结束玩家站 (932,640)，
   visaglau (932,591) 恰是武器位；visdefwave 是魔法槽法术视觉悬浮手边）——位置正确
   不是 bug。
2. **R50/R100 扫描证明它们已跟随玩家移动**：若钉死在 (932,591)，f=119 boom 的扫描
   （半径 300px 覆盖该点）在 R50/R100 必会再次命中——但没有。
3. **真正的钉死对象**是爆炸坐标 (1028.8,299.3) 上的 visualFlare+2 个裸 MovieClip
   （R50/R100 全程可见）——爆炸粒子死亡后遗留的孤儿 vis（见 shared-knowledge/
   rendering/discoveries/part-vis-orphan-ghost.md）。

## 误报机制（两层）

- **ghostScan 只扫 projBoom 字典的"前 2 条"**：Dictionary 对象键迭代序不稳定（≠插入序），
  S 帧恰好取到 {f=119, f=129}（不含 f=109）——扫描根本没覆盖爆炸点 → "S 帧没有、
  R50 出现"的错觉，被解读为"鬼影在回放前几帧才生成"。
- **扫描命中上限 found<4（按 boom×图层）**：同层 4 个命中后其余被丢弃——R100 的
  sloy=2 被 4 个 visbulgren40 占满，同层的其它候选被静默掩盖。

## 教训（适用于一切采样类诊断）

1. 采样"前 N 条"前先确认容器的迭代顺序语义（Dictionary 对象键 ≠ 插入序）。
2. 扫描类诊断要设足够大的命中上限，或按类名聚合计数而不是逐条截断。
3. "某帧没有/某帧有"要先排除**扫描覆盖范围本身的变化**，再下"对象变化"的结论。
4. 定位类结论要与用户描述三方核对（本案例：用户说"亮光/闪光/钉死不动"——与
   visualFlare 吻合，与武器形状不符；三个问题直接改变了排查方向）。
