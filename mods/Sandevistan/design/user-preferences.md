# 用户偏好（重要，不要违背）

> 提取自原交接文档 §6。这些是多轮迭代后用户明确选定的行为，改动前先核对本文件。

1. **攻击行为**（用户明确选定，多轮迭代后确定）：
   - 时停期间：武器**正常攻速**实时攻击（子弹冻结在空中）
   - 回放期间：攻击**远快于正常攻速**（加速重演）、**无换弹中断**（弹匣表演性拉满）
   - 时停结束：清除冻结子弹（单批火力）；时停中的弹匣消耗保留真实
2. **不修改游戏本体文件**（除非绝对必要并提前告知）——补丁是已批准的例外
3. 模组所有内容集中在 `release/`（部署后为游戏目录下的 `SandevistanMod\` 文件夹）
4. 用户玩 **1.02 官方版**
5. 配置默认：replayspeed=5、cooldown=0（调试中，用户可能改回）
6. **用户测试节奏**：每版必发日志路径
   `C:\Users\micha\AppData\Roaming\pfe\Local Store\sandy_modlog.txt`（47MB+，用
   `grep -a`/`tail` 取 DIAG 行，勿整读）；关键诊断行：rStart/recEnd/rFire/sAtk/
   recAtk/recBox/boom/sandyBoom/replayHit/rFix/ghostScan/partsKillDeep。

7. **设置入口（2026-09-23）**：用户要求去掉模组独立面板，只保留游戏菜单中的设置区。本轮按统一 ModSettings 接入实现，删除 F9 弹窗与旧 Options 浮层；触发键配置继续沿用。
