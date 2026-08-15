# 恢复与重新部署指南（用户视角）

> 原 `恢复说明.txt`（v1.6 时代）已并入本文件并更新至当前版本 v1.108。

## 目录结构变化（2026-08-15 整理后）

- `mods/Sandevistan/release/` —— 模组本体（安装/卸载脚本、补丁文件、备份、配置）
- `mods/Sandevistan/build/` —— 开发工具链（模组源码在 `src/`；编译器/打补丁工具在
  `build/tools/`）—— 用于游戏版本更新后重新生成补丁

## 部署模组到游戏

1. 把 `mods/Sandevistan/release/` 整个文件夹复制到游戏根目录，
   **重命名为 `SandevistanMod`**：
   `C:\Program Files (x86)\Steam\steamapps\common\Remains\SandevistanMod`
   （重命名不能省——补丁按 `SandevistanMod/SandevistanMod.swf` 这个路径加载模组）
2. 双击运行 `SandevistanMod\安装.bat`（自动备份新版原文件到 `backup\` 并打补丁）
3. 从 Steam 启动游戏，确认左上角显示 "SandevistanMod v1.108 已加载"

## 卸载 / 还原原版

- 双击运行 `SandevistanMod\卸载.bat`（从 `backup\` 还原三个原版 SWF）

## 重新下载游戏本体后的操作

1. 本仓库（RemainsMod）在游戏目录之外，Steam 重下不影响它
2. Steam 中卸载/删除游戏 → 重新下载安装
3. 按上面"部署模组到游戏"的 1-3 步操作
4. Steam 启动时可能校验并还原被修改的 DLC 文件——重跑 安装.bat 即可

## 游戏版本更新、模组失效

游戏更新可能改变引擎代码，导致旧补丁不匹配。
重新生成补丁所需（详见 `build/README.md`）：
- `mods/Sandevistan/src/patch/scripts/MainFE.as` —— 补丁源码
- `mods/Sandevistan/build/tools/flexsdk\` —— 编译器（amxmlc，已合并 AIR SDK）
- `mods/Sandevistan/build/tools/ffdec\` —— SWF 补丁工具
- `mods/Sandevistan/src/SandevistanMod.as` —— 模组源码
