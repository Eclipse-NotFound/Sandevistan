# 测试与诊断工作流（本模组）

---
domain: mod-knowledge
type: experiments
source: 交接文档 §8/§9 + 历次实测流程
game-version: 1.02
mod: Sandevistan
confidence: high
verified: true
date: 2026-08-15
---

## 自动测试

- config 设 `debugtest=1` → 游戏启动后自动 新游戏→触发 Sandy→全周期→
  日志写 `AppData\Roaming\pfe\Local Store\sandy_modlog.txt`。

## 手动测试

- Steam 启动游戏（1.02），`\` 触发，观察时停/回放/残影/弹药。
- 每版必发日志路径 `C:\Users\micha\AppData\Roaming\pfe\Local Store\sandy_modlog.txt`
  （47MB+，用 `grep -a`/`tail` 取 DIAG 行，勿整读）。

## 诊断行速查（diaglog=1）

| 行 | 用途 |
|---|---|
| `v1.108 loaded` | 构建版本标记（确认部署的 SWF 是预期版本） |
| `rStart/recEnd` | 录像构成/完整性 |
| `rFire` | 回放开火计数 vs 执行（吞攻击判定） |
| `sAtk/rAtk/rBody` | 时停/回放攻击链路 |
| `recAtk/recBox/recDoor` | 追踪器登记 |
| `sandyBoom/replayHit/boom` | 时停命中 ↔ 回放命中 ↔ 回放爆炸三方对照 |
| `twinInert/twinKill/pairOk` | 孪生体惰性化/终止/配对 |
| `parts/partsAlive/boomPart/partsKillDeepS/E` | 粒子生命周期（鬼影类问题首选） |
| `ghostScan S/R50/R100` | 显示树扫描（鬼影点名；注意采样偏差见 discoveries） |
| `rFix/reatt` | 重钉/重挂验证 |

## 流程约定

1. 每轮改动只做**最小修复**（一次混入多件事 = v1.50 失败核心）。
2. 定位"用户看到的现象"时先与数据对照（数据不动≠视觉不动），必要时向用户确认
   形态/位置/时机三要素再动手。
3. 修复 → 前台编译 → 部署 SWF 到游戏目录 + release/ → 更新
   state/current-status.md、decisions/changelog.md（新行插旧行前）、release/说明.txt
   → 提交 git（master）。
