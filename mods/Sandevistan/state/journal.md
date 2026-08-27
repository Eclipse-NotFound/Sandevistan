# Sandevistan —— 开发日志

> 协议见 GOVERNANCE.md §8：只追加不改写，**新条目插在最上面**。
> 逐版本历史在 decisions/changelog.md（112+ 条，新行插前）；本日志记会话级脉络。

## 2026-08-27 治理整合 + 外置记忆迁移

- 回灌游戏目录侧 08-26 更新的 current-status 与交接文档（防止同步覆盖丢失）；修复 sync-to-game.bat（D 盘路径 + CRLF，实测通过）；AGENT_SCOPE 精简为薄壳（规则入 GOVERNANCE.md）。
- 外置记忆标准化：current-status.md + 交接文档.md 拆分为本文件 + state\MEMORY.md（原文在 git 历史）；changelog/lessons/recovery-guide/user-preferences 保留不动。
- 遗留：旧 `SandevistanMod\` 游戏目录回退副本待删（见 MEMORY §6）。

## 2026-08-26 交接刷新

- 游戏目录侧更新 current-status 与交接文档至 v1.135 之后状态（当日未提交源仓——08-27 已回灌补上）。

## 2026-08-20~21 v1.133–v1.135 回放忠实度收尾

- v1.133 回放死亡敌人开火根治（sost>=3 非 postDie 跳过 step）；
- v1.134 回放敌人动画僵硬根治（MC 小马类按帧快照 osn.gotoAndStop+body.f；Blit 怪保留 dx 喂入；尸体不快照）；
- v1.135 打开哔哔小马（TAB）时游戏不能暂停修复（stepEnemySandy 加 inGameplay() 门控）。

## 2026-08-18 v1.129–v1.132 敌人隐形攻坚战 + 回放动画帧级化

- v1.129 全敌人类型斯安维斯坦后隐形（v1.128 斑马 shine 修复=采样偏差，保留为兜底）→ 就地检测+自愈（esInvScan / spawnEnemyGhost 重挂 / teleDiag）；
- v1.130 回放玩家动画帧级忠实重演（录 bl/bf，回放 gotoAndStop；旧 v1.120 dx-feed 留作兼容）；
- v1.131 敌人斯安维斯坦生成三控件（master 开关/房间概率/房内比例）；
- v1.132 回放敌人动画防僵死（Blit 怪喂 dx+补 animate）+ 怪物隐身/不可抓根治（录像 iv/lv 逐帧强压）；
- 工程教训追加 decisions/lessons.md §v1.120-1.132（重算vs快照、位置钉住动画冻结、AI 分歧残余态、config 行内注释污染等）；共享知识新增 unit-zebra-shine / unit-zombie-burrow / monster-blit-animation / telekinesis-grab-rules。

## 2026-08-17 v1.127 技能迁出 + 交接

- 疾跑切枪 + 手雷击落迁出到 MoreSkills&Weapons（本模组侧停用；备份 state/migration-backup-v1.126/；回放系统不受影响）；交接文档刷新 v1.127。

## 更早期（v1.0–v1.126，约 2026-08-12~17）

- 完整逐版本史见 decisions/changelog.md：鬼影（v1.108-110）、爆炸动画原生速度（v1.113）、S 徽标（v1.121）、残影（v1.122）、输入法警告移除（v1.125）、敌人触发（v1.126）等主线；阶段复盘见 decisions/lessons.md（含 v1.50 多任务混改失败复盘 2026-08-13）。
