# Sandevistan —— 开发记忆入口

> 更新：2026-09-23，v1.141 回放敌人身体动画修复。权限见 AGENT_SCOPE.md 与工作区 GOVERNANCE.md。

## 1. 这个模组是什么

斯安维斯坦让玩家全速、世界默认 1/5 速，结束后默认 5 倍速重演录像，配合彩色残影及断点续播音乐。入口 SandevistanMod.init(main)。疾跑切枪/投射物击落已在 v1.127 迁出至 MoreSkills&Weapons，本侧停用。

## 2. 用户偏好与协作约定

- 唯一源码仓 D:\RemainsMod（master），项目 mods\Sandevistan；游戏同名目录是镜像。先源仓提交再定向同步；避免全量脚本覆盖公共资料。
- 先读 design/user-preferences.md。时停正常攻速，保留真实弹药消耗；回放加速攻击、无换弹中断、不二次扣库存。
- 本轮用户明确要求修复掠夺者、尸鬼等马形生物回放动画僵死，已完成实现、隔离验证与游戏目录部署。
- 正式 release/config.txt 保留玩家配置。游戏原始 SWF 和其他模组保持只读；不杀用户实例、不写真实 pfe 存档。用户需正常重启加载新版。
- 接手前未跟踪的源仓 AGENTS.md 保留，未暂存。代码发布同步更新 MEMORY、journal、changelog、说明。

## 3. 当前状态

- 源仓正式 release **v1.141**，50,878 字节，SHA256 `F556C0728DA406A4A6A05399DF93E9A0349C4225107547F1E12FE88A2AEE3E48`。源仓与游戏发布副本哈希一致；实现提交 f6ac18a，发布后隔离启动通过。
- 新增 src/SandyBlitReplay.as，通过公开的精灵图和实际身体 Bitmap 精确匹配帧坐标。recordReplayObjects 保存 bp，回放在原 AI/动画处理完成后重绘该帧；不改战斗、弹药和玩家 MovieClip 路径。
- v1.140 独立 ModSettingsCarrier 注册 16 项，旧 MSW 宿主依赖已移除；F9 继续工作。敌人斯安维斯坦默认关。
- v1.137 配置有 applicationStorageDirectory 覆盖兜底；v1.139 主题曲默认音量 70、90 帧淡出、实际停止位置续播。release/sandy_theme.mp3 被 gitignore，打包须另带。
- 2026-09-23 当前宿主已使用 mods/loader-manifest.txt 的通用加载清单，实查列出七模组；此次修复不改宿主/清单。不要沿用旧的六 loader 矩阵或旧安装器。

## 4. 修复证据与验证边界

- 旧版已复现：原录像掠夺者 17 种/尸鬼 24 种身体画面，回放均只有 1 种，移动 29 次。只改 idx+1→idx+5 可恢复动作变化，仍 0/30 与录像相符；所以不能仅靠位移重算动画。
- 新版像素回归：两类敌人 × 五档速度（1/3/5/8/20）以及正常 AI 模式，共 12 组 **574/574 帧**逐像素相同，12 项尸体姿态保护通过。
- 候选、最终构建、已部署 SWF 各跑一次完整隔离流程：均 **20 PASS / 0 FAIL / 1 SKIP**。覆盖时停/回放、玩家动画、可见/可抓状态、TAB 暂停、F9、主题曲两轮；跳过的是测试实例未安装 ModSettings 的注册。
- 死亡攻击检查本轮 snapSize=0，不据此宣称新增了死亡攻击覆盖；专用夹具验证的是尸体不被活体录像覆盖。所有怪物/联机/七模组战斗组合未在本轮全面验证。
- 测试脚本 build/tests/run-replay-animation.ps1；测试代码只注入 build/out 副本，未进入正式 SWF。每次用独立 app id，结束清理自身进程与描述符。
- 详细证据、失败实验、粗测边界：knowledge/experiments/replay-animation-freeze-2026-09-23.md 与同级 replay-animation-20260923/。

## 5. 已知问题

- 用户仍可反馈回放观感/音乐听感、TAB 暂停体验；敌人斯安维斯坦启用后的行为另需专测。此次已覆盖具体马形敌人僵死故障，不宣称所有动画问题消失。
- 历史低优先：有攻击动画无伤害的残余报告需复现采 rFire；预判死亡偏松；门/地形破坏过程不能完全重演，结果保留。
- Shift/中文输入法吞键：Ctrl+Space 切回英文；提示 UI 已移除，诊断保留。
- architecture/lessons/build 含旧路径和过时说明。Part.setNull 清理/setLight/drawAllObjs/isExpl 的限定见 9 月 9 日源码审计；Blit“无法记录帧”已在 shared-knowledge/entities/facts/monster-blit-animation.md 追加本次更正。
- 旧 dist 安装器未随独立设置和通用 loader 更新，不直接运行；旧回退副本删除只是历史候选，未执行。

## 6. 发布与恢复

- 发布门禁完成：正式构建、版本标记、核心/流程断言、备份、提交后定向同步、哈希校验与发布文件隔离重启均完成。部署日志见 deployed-smoke.txt；没有重启用户实例。
- 回滚备份：D:\RemainsMod\mods\Sandevistan\build\out\SandevistanMod.before-v1.141-20260923.swf（v1.140，49,928 字节，SHA256 `0506615963176D937C596F43B8FF6D865B3BAC5D2DECE8490A47629D65A9A0BA`）。恢复模组 release 后重启即可；此次没有宿主补丁要回滚。
- 游戏 pfe.swf 本轮基线 SHA256 `252E7B34FC8BF0DD8CF566F45876597FE999562BE0F2E6AB596215D1A514C6DB`。
- 当前停点：v1.141 已部署；用户正常重启后加载修复。游戏侧旧版备份在 mods/Sandevistan/release/SandevistanMod.before-v1.141-20260923.swf，SHA256 与上述源仓备份相同。

## 7. 深入了解

- design/user-preferences.md / architecture.md；decisions/lessons.md / changelog.md；state/journal.md。
- 构建：build/build.bat → build/out/SandevistanMod.swf；Java 来自 Animate 2024，Flex/AIR SDK 在 build/tools。新 helper 是强引用类，随主 SWF 编译，无新增 loader。
- 测试：run-replay-animation.ps1 默认专用回归；-Source 旧源码 -ExpectFailure 检查旧版；-Smoke 完整回归；-Smoke -Artifact 指定 SWF 核验发布字节。
- 日志：%APPDATA%\pfe\Local Store\sandy_modlog.txt，按关键词抽取。隔离实例日志随独立 app id 分离。
- 工作区技能：remains-mod-memory、runtime-debug、mod-build、auto-testing、release-gate、swf-patching、knowledge-contribution；公共机制总图见 game-mechanism-atlas-2026-09-09.md。
