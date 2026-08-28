# Sandevistan —— 开发日志

> 协议见 GOVERNANCE.md §8：只追加不改写，**新条目插在最上面**。
> 逐版本历史在 decisions/changelog.md（112+ 条，新行插前）；本日志记会话级脉络。

## 2026-08-28 v1.136 敌桑默认关 + 内置自动测试打通 §4 验证

- 做了什么：应用户要求 `esandyenabled` 默认 1→0（暂不测敌桑表现）；`stepDebugTest` 重写为全流程自动验证驱动（app id 双门控，`[TEST-ASSERT]` 断言体系 + SUMMARY 汇总）；搭测试实例（app id `pfe-sandy-test`）跑 5 轮真机迭代；编译落地 build/build.bat + sandy-config.xml；§4 清单机器可验证项全部有结论（详见 MEMORY §4）。
- 关键决定/发现：①**F9/设置页保存功能在 AIR 下必失败**——saveConfigFile 写只读的 applicationDirectory 必抛 SecurityError: fileWriteResource，togglePanel(false) 每次关面板都触发（既有潜伏 bug，待修）；②TextField.text 内部行分隔符是  不是 
（UI 文本断言前要归一化）；③invis/levitPoss 有钻地（inv1+lev0）等合法状态相，残留断言必须用时停瞬间基线对照而非绝对值；④random_mane 飞行怪（天角兽）飞远后会被游戏 disabled——拉怪后要等它回到可交战状态再进时停；⑤flexsdk air-config.xml 的 {airHome} 令牌因 SDK 迁移失效，须自建 config 写绝对 swc 路径（同 TDFC）。
- 遗留/下一步：用户手测动画观感（机器验不了"好不好看"）；敌桑行为面待开 esandy 后实测；F9 保存持久化修复；删旧回退副本（仍待）。

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
