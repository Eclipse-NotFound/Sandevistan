# 恢复与重新部署指南（用户视角）

> 原 `恢复说明.txt`（v1.6 时代）已并入本文件并更新至当前版本 v1.109。

## 目录模型（2026-08-15 起：镜像部署）

- **仓库** `C:\RemainsMod\`（唯一事实源）：`mods\Sandevistan\`（源码/分发/构建/文档）
  + `shared-knowledge\`
- **游戏目录镜像**：`<游戏目录>\mods\`（除 build/）与 `<游戏目录>\shared-knowledge\`；
  同步命令：`C:\RemainsMod\sync-to-game.bat`
- 游戏直接从 `mods\Sandevistan\release\SandevistanMod.swf` 加载模组；
  config.txt 在同目录（F9 面板直接写，同步脚本不覆盖）

## 重新下载游戏本体后的操作

1. 仓库在游戏目录之外，Steam 重下不影响它
2. Steam 中卸载/删除游戏 → 重新下载安装（**注意：卸载会删除游戏目录里的镜像，
   包括 F9 面板写过的 config.txt**——重要配置请先备份）
3. 重下后：运行 `C:\RemainsMod\sync-to-game.bat` 重建镜像
4. 运行游戏目录 `mods\Sandevistan\release\安装.bat`（备份新版原文件+打补丁）
5. Steam 启动游戏，确认左上角显示 "SandevistanMod v1.109 已加载"

## 卸载 / 还原原版

- 运行游戏目录 `mods\Sandevistan\release\卸载.bat`（从 backup\ 还原原版 SWF，
  1.03/1.04 优先还原 Steam 更新后的 v2 原版）

## 游戏版本更新、模组失效

游戏更新可能改变引擎代码，导致旧补丁不匹配。重新生成补丁所需（详见 `build/README.md`）：
- `mods/Sandevistan/src/patch/scripts/MainFE.as` —— 补丁源码
- `mods/Sandevistan/build/tools/flexsdk\` —— 编译器（amxmlc，已合并 AIR SDK）
- `mods/Sandevistan/build/tools/ffdec\` —— SWF 补丁工具
- `mods/Sandevistan/src/SandevistanMod.as` —— 模组源码
