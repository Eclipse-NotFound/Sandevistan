# v1.145：移除加载标识与自备音乐指南（2026-09-27）

用户要求移除常驻“Sandevistan mod已加载”，并在游戏设置加入音乐文件配置指南，分享时不附带音乐。

- 删除showBootMark及showmark读写；既有配置中的showmark被忽略，不需要玩家手改。顶部时停/回放/充能状态保留。
- 沿用统一菜单16项，将指南放在页面右侧说明以及“时停主题曲”的悬停提示中。说明自备MP3、sandy_theme.mp3命名、mods/Sandevistan/release/目录、重启、开启及调高音量、缺文件不影响时停、不要重复后缀和不能仅改后缀转格式。
- release/音乐配置.txt提供相同路径的可随包说明。未增加、删除或替换玩家的本地音频；未制作含音乐的分享包。
- 音乐加载路径仍为游戏目录下mods/Sandevistan/release/sandy_theme.mp3，播放算法不变。

## 当前环境变化与必要接入

9月24日独立ModSettings已并入ModLoader。当前真实清单启用ModLoader、禁用ModSettings；既有pfe60仍是9月23日的两项限制，导致高帧入口无法加载现行设置组件。延续用户此前明确批准的“pfe60接入本模组及菜单设置”，仅在既有MainFE允许列表加入ModLoaderMod；旧ModSettings仍以清单开关为准，其他玩法模组不放行。不修改其他模组、本体普通入口、清单或默认启动。

候选高帧宿主SHA256 `2E69FB2E4A4D276FFE543CBD17BF1251455CDEB332D05EE46DA26DBB719E7370`；补丁前为D88D19A1…。从当前文件导出并定向导入MainFE，Gov60/Camera/MainMenu回读哈希不变。

## 验证

- 正式模组51,316字节，SHA256 `8ECFDDC8CAA729B1346873D325CE9EC61DCEF8A516D5A5380E363A15195F11C4`。
- 无音乐隔离安装（20260927210657222）：正式模组原字节、当前ModLoader正式组件，加独立菜单观察器，9/9。加载标识不存在、设置页打开、主题曲项存在、页面与悬停说明可见且无裁切、无游戏错误对话框。正文14行250.2/300px，悬停15行268.05/300px，实际截图已检查。
- 高帧90正式候选（20260927210413176）：21 PASS / 0 FAIL / 0 SKIP。真实八项清单只请求并成功加载ModLoaderMod与SandevistanMod；原音乐播放/断点续播/淡出/停止与16项设置保存重读通过。
- 菜单观察器最初在跨阶段复用for-each变量时空引用，正文渲染/截图已成功但悬停未测完。改为显式数组索引遍历后完整通过；没有把该失败当成正式界面故障，也未改变正式模组以迁就测试。
- 经验检索返回partial，某条无关写作原件不可读；本轮依据当前ModLoader接口与源码、Sandevistan既有记忆核实，不以无命中推断没有经验。

所有自动化使用独立app id，不改真实存档或用户实例。
## 发布完成

实现与正式产物提交f491b17后定向同步。实际安装文件的90帧隔离复验20260927211237841：21 PASS / 0 FAIL / 0 SKIP，当前真实清单仅加载ModLoaderMod和SandevistanMod。部署SWF与候选及测试副本的字节一致。

宿主完整性：5039个标签数量/顺序保持，只变更一个DoABC块；非MainFE的高帧机制源码回读相同。普通pfe.swf、两份启动描述符、pfe60.cfg（90帧）、清单、ModLoader正式包、玩家config.txt和本地sandy_theme.mp3的部署前后哈希全部一致。

回滚v1.144：游戏release/SandevistanMod.before-v1.145-20260927.swf（SHA256 2C26EADCFE760EC3BD998DDBEDF0FAD333151E203B0688AF268BDF0612BA0263）；源build/out另留同名备份。高帧宿主备份为游戏根pfe60_before_sandevistan_v1145_20260927.swf（SHA256 D88D19A11B7100491A8EDD6153499AB92D59545C1576693368762C9C0AB7E97B）。两项恢复后重启。未修改或恢复旧ModSettings启用项。