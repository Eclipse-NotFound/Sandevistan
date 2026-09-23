# Sandevistan —— 开发记忆入口

> 更新：2026-09-23，v1.144高帧率适配已验证，用户已批准pfe60接入，待提交部署复验。权限见 AGENT_SCOPE.md 与工作区 GOVERNANCE.md。

## 1. 这个模组是什么

斯安维斯坦让玩家全速、世界默认 1/5 速，结束后默认 5 倍速重演录像，配合彩色残影及断点续播音乐。入口 SandevistanMod.init(main)。疾跑切枪/投射物击落已在 v1.127 迁出至 MoreSkills&Weapons。

## 2. 用户偏好与协作约定

- 最新请求：去掉独立设置面板，只留菜单设置；本轮按同时移除F9和旧绿色浮层处理。

- 唯一源码仓 D:\RemainsMod（master），项目 mods\Sandevistan；游戏同名目录是镜像。先源仓提交再定向同步，避免全量脚本覆盖公共资料。
- design/user-preferences.md：时停正常攻速，保留真实弹药消耗；回放加速攻击、无换弹中断、不二次扣库存。
- v1.142用户明确“打出足够致死的攻击，敌人仍不出现预判死亡”，要求详细研究并优化；不是玩家死亡问题。上一轮马形敌人动画修复已完成。
- 正式 release/config.txt 保留玩家配置。游戏原始 SWF/其他模组只读；不杀用户实例、不写真实 pfe 存档。重启游戏才加载新版。
- 接手前未跟踪的源仓 AGENTS.md 保留，未暂存；代码发布同步 MEMORY、journal、changelog、说明。

## 3. 当前状态

- v1.144候选51,085字节，SHA256 `0642842AD78FF55599AD88371F5CBD34E9DED1F5F1CB6A2F0615BC1B38DBED29`。Gov60包内只读桥接，主循环按宿主逻辑帧运行；SandyHighFpsView同步手动步进后的玩家/武器插值端点，普通宿主保持原路径。
- 30/60/90/120/auto与运行中切换通过；90/120真实开火各15项通过（5枪、60移动步、995余弹）；最终正式字节+限定loader+七项清单21项通过，实际只加载本模组与ModSettings。详见knowledge/experiments/high-fps-adaptation-2026-09-23.md。
- 原pfe60无loader，候选D88D19A1…，原SHA FC19AF4A…。用户已明确批准接入部署；普通pfe、pfe60.cfg和默认启动描述符不改。

- 上轮源仓与游戏 release **v1.143**，49,994 字节，SHA256 `B8805DBACC9A1313FD96BB68889911195AC6EAFCBB526E50C313B86AD1E9C748`；两侧哈希一致，实现提交c05a2d4，发布复验通过。删除F9独立弹窗及旧Options绿色浮层，只保留ModSettings统一菜单设置；16项、保存和hotkey配置保留，panelkey停止读写。
- v1.142新增 SandyDamagePredictor：按真实命中短路、物理/能量甲、先破甲后减伤、护盾、暴击/偷袭/分解及全局易伤顺序估计。9 点积分处理随机伤害，独立累计预计耐久，不改真实实体状态；取消二次武器耐久惩罚及固定0.9折扣。
- slowStepWorld 保存步前攻击体引用，步后仍读取已离场子弹碰撞；近战缓存原伤害，以 parr 引用区分挥击且持续读取晚接触；去掉位置盒猜测。WKick 内联扣血不再补记延后伤害。
- v1.141 SandyBlitReplay 记录真实精灵图帧坐标，回放后恢复，保持尸体保护。v1.140 独立 ModSettingsCarrier 16 项（v1.143起无F9弹窗）；敌人斯安维斯坦默认关。v1.139 主题曲默认音量70、90帧淡出、断点续播。
- 当前宿主已是通用 mods/loader-manifest.txt 七模组清单；不沿用旧六 loader 矩阵或旧安装器。主题曲 release/sandy_theme.mp3 被 gitignore，分发需另带。

## 4. 证据与当前停点

- v1.142验证：有效旧版基线52项中47项失败；新版53/53通过，原生 damage/udarBullet 对照、真实近战延迟接触和 WKick 防双记。出链测试必须断言 in_chain=false 和实际目标一致。
- v1.142验证：动画回归12组574/574帧逐像素相同，12项尸体保护通过；最后的 WKick 防双记调整不涉及动画路径。
- v1.142验证：正式构建与实际部署字节各自 -Smoke -Artifact 完整流程20 PASS/0 FAIL/1 SKIP；跳过未安装 ModSettings 的注册。死亡攻击检查 snapSize=0，不能视作实质覆盖。
- 详细研究、失败夹具纠正、源码顺序与日志：knowledge/experiments/death-prediction-2026-09-23.md、death-prediction-20260923/。上一轮动画证据保留 replay-animation-freeze-2026-09-23.md。
- 上轮停点：v1.143已部署；正式构建及实际部署字节与ModSettings副本分别隔离验收21/0/0通过；菜单打开、保存重读、F9放行均已通过。详见knowledge/experiments/menu-settings-only-2026-09-23.md。上述53项和574帧属于上一版验证，本轮未改其代码。

## 5. 已知问题与边界

- 预判是伤害期望，回放重新抽随机；预计耐久用均值状态，伤害浮动用9点近似，不能保证每次预告都对应真实击杀。无碰撞的在途子弹不凭瞄准提前记账。
- 爆炸范围/气体、持续毒火、念力撞墙等未补齐预判入口；穿透后续衰减及特殊 Boss 覆盖也未全面建模。炮塔临时护盾已专项验证。过去“预判偏松”的泛化记录以本次具体证据和这些边界代替。
- 1.03/1.04、联机及全模组混战未在本轮全面验证；敌人斯安维斯坦开启后的表现仍需单独场景验证。
- 有攻击动画无伤害的历史残余需采 rFire；门/地形破坏过程不能完全重演。Shift/中文输入法吞键可用 Ctrl+Space 切英文。
- architecture/lessons 有过时机制与旧路径；公共 bullet-explosion-flow 已明确更正旧伤害期望公式，详细本体链见 combat-pipeline-source-audit-2026-09-09.md。旧 dist 安装器未随通用 loader 更新，不直接运行。

## 6. 发布与恢复

- v1.143回滚到v1.142：源仓build/out/SandevistanMod.before-v1.143-20260923.swf，51,623字节，SHA256 28449B2646223A8EEE20EB4BB361DDA2D5DC0572C6AAA9CD5FCB5D072A374C44。

- 源仓 v1.141 回滚：build/out/SandevistanMod.before-v1.142-20260923.swf，50,878字节，SHA256 `F556C0728DA406A4A6A05399DF93E9A0349C4225107547F1E12FE88A2AEE3E48`。游戏 release 已另留同名备份且哈希一致；换回后重启即可，本轮没有宿主补丁需要回滚。
- 当前 pfe.swf 指纹 `B78244657ED407D03808C90E97325509DB35F802122835F58933FFF8003305AC`，与上一轮不同（文件时间10:54:55，来源未调查）；最终专项/动画/流程均在该宿主副本运行。本轮未写宿主和清单。
- 玩家 config SHA256 `D91C4C2889ABA19B1BCFB356885921B0605A50188B270A9E7619D2116E7EBDC3`，同步不得覆盖。更早 v1.140 回滚 before-v1.141 保留。

## 7. 深入了解

- design/user-preferences.md / architecture.md；decisions/lessons.md / changelog.md；state/journal.md。
- 构建：build/build.bat → build/out/SandevistanMod.swf；Java=Animate 2024 JRE，Flex/AIR SDK=build/tools。helper均随主SWF编译。v1.144构建先生成external Gov60存根到build/out，不得嵌入游戏类；高帧入口须有loader。
- 专项：build/tests/run-death-prediction.ps1，-Source 旧源码 -ExpectFailure 对照；run-replay-animation.ps1 做动画。-Smoke -Artifact 指定 SWF 验证正式字节。
- 日志：%APPDATA%\pfe\Local Store\sandy_modlog.txt；隔离实例用 pfe-sandy-death-时间戳 / pfe-sandy-anim-时间戳。测试只杀自己 PID。
- 本轮沿用 remains-mod-memory、runtime-debug、mod-build、auto-testing、release-gate、knowledge-contribution 与 diagnosing-bugs。公共机制总图见 game-mechanism-atlas-2026-09-09.md。