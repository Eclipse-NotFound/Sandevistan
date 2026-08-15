# 时停/回放核心架构（本模组专属机制）

---
domain: mod-knowledge
type: facts
source: 交接文档 §3.2/§7 + SandevistanMod.as（v1.108）
game-version: 1.02
mod: Sandevistan
confidence: high
verified: true
date: 2026-08-15
---

## 步进速率恒等式（一切速率推导的基准）

- 时停：`onPause=true` 世界冻结，玩家每显示帧手动 `gg.step()`（全速）；
  每 slowfactor 显示帧调用一次真实 `loc.step()`（世界=1/N 速，交互检测/移动/AI 一致慢速）。
- 回放：`onPause=true` 世界冻结，每显示帧消耗 `replayspeed`（=slowfactor）条历史帧
  = **恰好 1 个世界步**。
- 推论：玩家攻击体回放由 `stepPlayerBullets` 步 1 次/帧；`stepUnrecordedAtk` 只应
  处理**敌方未录制**对象——两者重复步进 = 2 倍速错乱（v1.95 双步陷阱）。

## 时停（startSandy → stepSandy → endSandy）

- 帧序：帧首近战伤害清零 → 玩家手动 step（全速）→ 节流帧调真实 `loc.step()`
  （步前预先清键、步后恢复——额外步是"无输入自由物理步"）→ 记录历史+场景录像。
- 伤害策略：时停中玩家攻击体伤害清零（命中 0 伤害），真实伤害在回放重演结算；
  敌人攻击玩家按 v1.82 起为**真实伤害**（玩家 godMode 会 hp 复位横跳，不可用）。
- 预判死亡：creditHit 累计期望伤害（v1.60 期望值公式：damage×vulner×(1+crit…)−护甲
  ×allVulnerMult，含武器耐久 breaking/特攻 pers.damX/期望命中率）≥ 敌人 hp →
  `sost=3` 死亡姿态慢放；不真杀；endSandy 恢复 sost=1。
- 粒子：时停中 MC 型粒子 vis 每显示帧 stop()、节流帧 nextFrame()（mcStepParts，
  防舞台帧率播放+循环重播）；Blit 型随 step 天然慢速。
- 武器切换（时停中真实发生）：游戏 changeWeapon 的 work="change"/t_work 在 1/5 速下
  可能整个时停都完不成——时停结束时 currentWeapon 仍是旧武器（v1.108 日志分析确认）。

## 回放（startReplay → stepReplay → endReplay）

- 武器：回放开始 switchToWeapon(startWeapon)（模拟 changeWeaponNow 全套）；窗口循环
  检测历史 `w` 字段变化立即切换；每帧清 work="change"/t_work 钉住 replayWpn；回放结束
  switchToWeapon(endWeapon) + 恢复弹夹/背包弹药到时停结束快照。
- 开火：fireCnt 按历史逐帧记录的 fc（弹夹下降判定）直接累加，逐发
  t_attack=0/t_auto=0/t_reload=0 + attack() + step()；开火前按 firePts 恢复武器
  位置/瞄准/rot（shoot() 子弹方向取 this.rot，Weapon.as:1495）。
- 敌人：敌对单位每显示帧 step 1 次（enemyAct=2 寻敌不攻击，攻击按 enemyAtks 事件复现），
  步后重钉位置+按记录恢复 storona/武器 rot/vis.visible。
- 结束恢复：endReplay 恢复 godMode/onPause/武器耐久/魔法值/手雷库存；惰性化孪生体
  存活在飞者恢复爆炸能力；弹药防泄漏绳（ammoLeash）120 帧钳制。
