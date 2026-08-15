---
domain: knowledge-validation
type: experiments

game-version:
  - "1.02"

confidence: medium
verified: true

discovered-by: Sandevistan

evidence:
  - kind: runtime-experiment
    summary: "Sandevistan diaglog 体系长期实践（版本标记/三方对照/限制计数/grep -a 取证）"

date-updated: 2026-08-15
---


## 基础装备

1. **版本标记行**：mod init 时打 `[Mod] vX.Y loaded <关键开关>`——先确认线上
   跑的是预期构建，再谈别的。
2. **每功能一个诊断计数 + 上限**（如 twinInert ≤8 条）：防日志刷爆（本游戏日志
   文件可到 47MB+）。
3. **三方对照式诊断**：把同一事件在三个环节各打一条（时停中命中 sandyBoom /
   回放命中 replayHit / 回放真实爆炸 boom）——偏移和缺失一眼可见。

## 排查套路

1. `grep -a "<DIAG前缀>" 日志 | tail -N`（日志可能含二进制内容，务必 -a）。
2. 症状 → 定位**时段**（用户描述）→ 找到该时段前后的诊断行 → 确定"该时段内
   发生的唯一事件"（如 boom）→ 假设它制造/掩盖了现象。
3. 假设 → 最小改动或最小诊断构建验证 → 用户实测 → 三方核对（形态/位置/行为）。
4. 结论必须落到**代码位置级**（文件:行），否则不算闭环。

## 教训沉淀位置

- 已闭环的排查 → shared-knowledge 对应领域 discoveries/experiments（标注
  game-version 与可信度）；本模组专属的 → mods/Sandevistan/knowledge/。
