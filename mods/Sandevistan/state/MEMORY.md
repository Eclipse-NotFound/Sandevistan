# Sandevistan —— 开发记忆入口

> 更新：2026-09-27，v1.145已部署：移除加载标识，设置页新增自备音乐指南；无音乐菜单9项及部署高帧流程21项通过。权限见AGENT_SCOPE.md与工作区GOVERNANCE.md。

## 1. 这个模组是什么

斯安维斯坦让玩家全速、世界默认1/5速，结束后默认5倍速重演录像，配合彩色残影及断点续播音乐。入口SandevistanMod.init(main)。疾跑切枪/投射物击落已在v1.127迁出至MoreSkills&Weapons。

## 2. 用户偏好与协作约定

- 最新请求：去掉常驻加载标识，设置页加入自备音乐配置指南，分享包不附带音乐。v1.145已部署；菜单9项与实际部署高帧流程21项通过。
- 唯一源码仓D:/RemainsMod（master），项目mods/Sandevistan；游戏同名目录是镜像。先提交后定向同步，不跑全量镜像脚本覆盖公共资料。
- design/user-preferences.md：时停正常攻速，保留真实弹药消耗；回放加速攻击、无换弹中断、不二次扣库存。
- 用户“死亡判定过严”指足够致死的攻击却不出现预判死亡，v1.142已优化。马形敌人回放动画v1.141已修复；v1.143已删除F9独立设置和旧绿色浮层，仅保留主菜单16项。
- 正式release/config.txt保留玩家配置。不杀用户实例、不写真实pfe存档。修改其他游戏SWF仍需明确授权；本次授权仅pfe60接入。
- 源仓接手前未跟踪的根AGENTS.md保留，不暂存。重启游戏才加载新文件。

## 3. 当前状态

- 已部署v1.145（实现f491b17），源release/游戏release/实际测试副本均51,316字节，SHA256 `8ECFDDC8CAA729B1346873D325CE9EC61DCEF8A516D5A5380E363A15195F11C4`。删去showBootMark和showmark读写；保留顶部时停状态。指南在统一设置页desc与主题曲hint中，仍为16项，另有release/音乐配置.txt。
- 模组通过fe.serv同包只读桥接读取Gov60逻辑步；所有计时/录像/回放跟随真实逻辑步。SandyHighFpsView同步手动步进后的玩家/悬浮武器显示端点；普通宿主不依赖Gov60。
- 当前设置服务已由ModSettings并入ModLoader，旧独立入口被清单禁用。pfe60沿原授权补入ModLoaderMod，仍只放行本模组与设置提供者；当前实际加载Sandevistan+ModLoader两项。SHA256 `2E69FB2E4A4D276FFE543CBD17BF1251455CDEB332D05EE46DA26DBB719E7370`，5039标签同序，仅一处DoABC变更；Gov60/Camera/MainMenu回读一致。
- 当前pfe60.cfg为fps=90、hud=0（19:32:27外部更改，本轮保留）；普通application.xml仍指向pfe.swf，app60.xml仍指向pfe60.swf。未切换默认启动入口。
- v1.142使用SandyDamagePredictor对齐原生护甲/护盾、破甲顺序、暴击/偷袭/分解，9点积分处理随机伤害；修复离场子弹、延迟近战和连续挥击漏记，WKick内联伤害不重复记。
- v1.141 SandyBlitReplay记录真实精灵图帧，保留尸体姿态。敌方时停默认关。主题曲release/sandy_theme.mp3被gitignore；分享包不得附带本地音乐，由使用者按设置指南自行放置MP3后重启。缺少文件时音乐静默，时停正常。

## 4. 验证与停点

- v1.145无音乐安装菜单9/9，实际正文14行250.2/300px、悬停15行268.05/300px，截图已检查；正式产物与实际部署90帧各21/0/0（最终20260927211237841），仅请求并成功加载ModLoaderMod+SandevistanMod。改动不涉及音乐播放算法。详见knowledge/experiments/music-guide-2026-09-27.md及music-guide-20260927/。
- 当前任务完成，重启即可加载新版。以下为v1.144历史验证：

- v1.144高帧专项：旧版60帧11项中6失败；新版普通30、高帧60/90/120/auto、四次运行中切换通过；90/120真实开火各15项通过（60移动步、5枪、995余弹）。不据此声称机器稳定达到120fps。
- v1.144正式文件普通30与高帧60各21 PASS/0 FAIL/0 SKIP；实际安装文件高帧90复验20260923194628482同样21/0/0，菜单16项、打开/保存重读、音乐/暂停及录像回放均通过。加载器回执只请求并成功初始化两项。
- 首次部署60帧20/1/0后按门禁回滚，查明旧测试把旧弹体按录像移动误判为尸体开火。修正仅涉及隔离测试：按对象引用查死亡后新增攻击，无死亡样本明确SKIP。固定7项旧版4失败、新版全过，故意新增异常弹体仍会报警；本次部署样本deadOwners=1、new=0。
- 详细机制、测试、首次失败与回滚、最终哈希和部署回执：knowledge/experiments/high-fps-adaptation-2026-09-23.md、high-fps-20260923/。没有待完成的本次部署工作。
- 先前证据：v1.142预判53/53、动画574/574帧和12项尸体保护；本轮未重新跑这些专项，也未改其实现。

## 5. 已知问题与边界

- 预判是伤害期望，回放重新抽随机；均值耐久/9点近似不保证每次预告都对应真实击杀。无碰撞的在途子弹不凭瞄准记账。
- 爆炸范围/气体、持续毒火、念力撞墙等预判入口仍未补齐；穿透后续衰减及特殊Boss未全面建模。
- 本轮未全面验证DLC1.03/1.04、敌方时停、联机、七模组混战及全部武器。高帧入口只启用已验证的本模组与菜单组件。
- 出生区剧情可改变ggControl；专项只验证world.onPause/godMode恢复，不宣称修复旧控制恢复问题。门/地形破坏过程仍不能完全重演。
- architecture/lessons含过时机制和路径，旧dist安装器未随通用loader更新，不直接运行。

## 6. 发布与恢复

- v1.145回滚：游戏release及源build/out的SandevistanMod.before-v1.145-20260927.swf（v1.144，2C26EADC…）；游戏根pfe60_before_sandevistan_v1145_20260927.swf（D88D19A1…）。两项恢复后重启；原始备份均保留。玩家音乐/配置、普通宿主/描述符、清单及ModLoader正式包均未改。

- v1.144回滚需恢复两项并重启：游戏根pfe60_before_sandevistan_v1144_20260923.swf，SHA `FC19AF4A43438273A19D7CFBAC7A1CF584647CE94254F8D503A359C43E81091B`；游戏release及源build/out的SandevistanMod.before-v1.144-20260923.swf是v1.143，49,994字节，SHA `B8805DBACC9A1313FD96BB68889911195AC6EAFCBB526E50C313B86AD1E9C748`。原始备份未覆盖。
- 普通pfe.swf仍为 `B78244657ED407D03808C90E97325509DB35F802122835F58933FFF8003305AC`；玩家config仍为 `D91C4C2889ABA19B1BCFB356885921B0605A50188B270A9E7619D2116E7EBDC3`。清单、描述符保持原值。
- 更早v1.141/v1.142/v1.143回滚备份继续保留，完整历史见journal及各版研究记录。

## 7. 深入了解

- design/user-preferences.md、architecture.md；decisions/lessons.md、changelog.md；state/journal.md。
- 构建build/build.bat输出build/out/SandevistanMod.swf；Java=Animate2024 JRE，Flex/AIR SDK=build/tools。先生成external Gov60存根，不得把游戏类实现编进模组。
- build/tests/run-high-fps.ps1：-HostSwf高帧宿主、-Fps、-SwitchModes、-Combat；-AttackObserver专测检查器。-Smoke -Artifact验证无注入正式字节，-WithSettings -InstalledManifest验证正式七项清单下的两项限定加载。
- run-death-prediction.ps1、run-replay-animation.ps1为旧专项。prepare-high-fps-host.ps1仅从无loader原版生成候选，不对已部署文件重复叠加。
- 日志：%APPDATA%/pfe/Local Store/sandy_modlog.txt；隔离实例用pfe-sandy-fps-时间戳，只杀自己PID、清理自己的临时描述符。
- run-high-fps.ps1新增-CurrentSettings（真实ModLoader）、-MenuGuide -Artifact -NoMusic（普通宿主，无音乐，用独立SandyMenuProbe检查正式字节界面）。高帧设置provider修正候选由prepare-high-fps-settings-host.ps1生成。
- 本轮沿用memory、runtime-debug、mod-build、auto-testing、swf-patching、release-gate、knowledge-contribution与diagnosing-bugs技能。公共高帧机制见shared-knowledge/rendering/discoveries/high-fps-gov60-clock-2026-09-23.md。