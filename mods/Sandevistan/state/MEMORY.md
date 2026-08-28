# Sandevistan —— 开发记忆入口

> 新会话从这里开始。协议见工作区 GOVERNANCE.md §8；本模组参数与镜像特例见 ../AGENT_SCOPE.md。

## 1. 这个模组是什么

为《FOE: REMAINS》加入"斯安维斯坦"技能：按热键触发**时间停止**（世界 1/5 慢速、玩家全速），彩色残影特效，结束后**快速回放**玩家操作。入口类 `SandevistanMod`。v1.127 起疾跑切枪与手雷击落已迁出至 MoreSkills&Weapons（本模组侧停用，源码备份 `state/migration-backup-v1.126/`）。

## 2. 用户偏好与协作约定

- **design/user-preferences.md 记录的偏好不要违背**。
- 输入法 Shift 误触为已知环境问题（Ctrl+Space 恢复）。
- **改游戏本体文件（pfe.swf 等）前必须先做哈希比对**——他人已改则先合并（流程见 build/README.md §2）；游戏目录是多 agent 共享工作区（现共存 4+ 个模组）。
- 发布纪律：改代码 → 更新三份文档（本文件/changelog/说明.txt）→ 提交 git master。

## 3. 当前状态

- **v1.136**（git master，镜像部署运行中）：本仓库（`D:\RemainsMod`）为唯一事实源，游戏目录 `mods\Sandevistan\` 由 `sync-to-game.bat` 全镜像（排除 build\ 与 release\config.txt——后者由游戏内 F9 面板直写）。
- v1.136 变更：**敌人斯安维斯坦默认关**（`esandyenabled` 默认 0，用户要求）；`stepDebugTest` 重写为全流程自动验证驱动（app id 双门控：config debugtest=1 且 applicationID≠"pfe" 才激活）。
- 游戏通过补丁从 `<游戏目录>\mods\Sandevistan\release\SandevistanMod.swf` 加载；补丁 SWF 的安装/还原 = 游戏目录 `mods\Sandevistan\release\安装.bat / 卸载.bat`；Steam 校验还原 DLC 后重跑安装.bat。

## 4. 正在进行与卡点（2026-08-28 自动验证轮后状态）

机器可验证部分已由内置自动测试覆盖（5 轮真机，测试 app id `pfe-sandy-test`，详见 §7）：

1. ✅ v1.130 回放**玩家**动画帧级还原——站立玩家回放帧采样多变（frames=[24,15,1,9,10,1,4,5]）PASS；**视觉观感仍待用户手测**；
2. ✅ v1.132-1.134 回放**敌人**——基线对照无隐身/抓取残留 PASS（佣兵 alive=1 dead=1 实测）；死亡敌人不开火子项仅部分覆盖（击杀敌人时无飞行弹可观测，无回归迹象）；僵尸/蝎子专项待用户实测；
3. ✅ v1.135 哔哔小马暂停——门控输入侧 PASS×3（pip 开→allStat=2+inGameplay()=false→关恢复）；**敌桑行为面**（敌桑激活中开 TAB）需开 esandy 后实测；
4. ✅ v1.131 三控件——F9 面板+设置页 10 项渲染断言 PASS（原文比对）；v1.136 默认"关"四处（启动/config/F9/设置页）PASS；
5. ✅ v1.127 迁移回归——projhits/swaprun 停用断言 PASS；回放全周期 ×5 无错误。

**跨模组问题（已定位未越权修复）**：全敌人满装甲条 = RealisticVision 的 hideEnemies 强制 `hpbar.visible=true`——应转告 RV 开发者。

## 5. 已知问题

- **F9/设置页调参无法持久化（既有潜伏 bug，待修）**：`saveConfigFile` 写 `File.applicationDirectory`（AIR 只读）必抛 `SecurityError: fileWriteResource`；`togglePanel(false)` 每次关面板都触发。用户 F9 调的参数只活在当前会话。修复方向：写 applicationStorageDirectory + 启动时回迁，或引导手编 config.txt。
- 遗留低优先：「有攻击动画无伤害」残余（rFire 诊断就位，再现采日志）；预判死亡略松（可调余量 0.9）；门/场景破坏**过程**无法重演（瓦片/光照引擎限制，结果保留——已知限制）。
- 环境：游戏目录旧 `SandevistanMod\` 回退副本待删（确认稳定后）；用户日志 `%APPDATA%\pfe\Local Store\sandy_modlog.txt`（diaglog=1，grep -a 勿整读）。

## 6. 下一步

1. 用户手测：回放动画观感（帧级还原、残影）、TAB 暂停体验——机器只能验逻辑，观感要人；
2. 想测敌人斯安维斯坦时：F9 或 config 开 `esandyenabled=1` 后实测 §4.3 行为面；
3. F9 保存持久化修复（§5 首条）；
4. 稳定后：删除游戏目录旧 SandevistanMod\ 回退副本、按需重打包 `dist\SandevistanMod_v<版本>.zip`。

## 7. 深入了解

- **开发历程**：state/journal.md（近期会话级历程）；**decisions/changelog.md（v1.0→v1.135 全部 112+ 条版本史——新版本行插旧行之前）**；decisions/lessons.md（工程教训：internal 不可访问、密封类 #1069 陷阱、步进速率恒等式、isExpl 禁爆、帧/键时序——**改代码前必读**）
- **架构**：design/architecture.md（技术架构与游戏内部机制，改动前必读）
- **构建/补丁/部署全流程**：build/README.md（§2 哈希比对合并、§3 改动完整流程：src → build.bat → release\ → sync-to-game.bat → 重打补丁 → 三份文档 → git）
- **自动测试**：config.txt 设 `debugtest=1` + 用独立 app id 描述符启动（app id 禁下划线；范本见 remains-auto-testing 技能）→ 测试日志在 `%APPDATA%\<appid>\Local Store\sandy_modlog.txt`，grep `[TEST-ASSERT]` 与 `SUMMARY`；用户实例（pfe）被 app id 门控保护。整轮约 4 分钟（开机 45s + 场景 ~2.5min）
- **用户偏好**：design/user-preferences.md
- **恢复**：state/recovery-guide.md（用户视角重装/卸载/恢复）
- **知识**：knowledge/（facts/discoveries/experiments）；共享贡献在仓库根 shared-knowledge/
- **技能**：remains-runtime-debug、remains-swf-patching、remains-mod-build、remains-auto-testing
