# Sandevistan

《Fallout Equestria: REMAINS》的时停战斗模组：按一个键，世界暂停，你从容走位——然后看着操作带着残影被快速回放。敌人也可以装备自己的斯安维斯坦。

[English](README.md) · 简体中文

## 功能（v1.144）

- **时停**：热键可配置（默认 `\`，默认时长 7 秒，独立冷却），结束后快速**回放**你的操作（速度、残影密度与拖尾寿命均可调）。
- 残影效果：混合模式、不透明度、生成间隔可调；时停期间粒子特效可继续或冻结。
- **可击落投掷物**：手雷、导弹与发射的榴弹有血量/护甲，可被子弹击落——支持按武器单独覆盖（`projhp_<武器id>` / `projarmor_<武器id>`），覆盖手雷、野火核弹、榴弹发射器与导弹发射器。
- **敌人斯安维斯坦**（可选，默认关）：装备名单内的兵种（掠夺者/狮鹫佣兵/天角兽/英克雷/铁骑卫/斑马）目击玩家后触发自己的时停，有每房名额、独立时长/冷却/速度与标记。
- **高帧率宿主**（v1.144）：跟随宿主逻辑时钟，90/120 帧下时停与插值平滑（60/90/120 已验收）。
- 彩虹循环或边缘行者式速度渐变配色、启动"模组已加载"标记、顶部状态 UI（"充能中/启动中/回放中"），以及游戏内 **F9 参数面板**。
- 时停主题音乐为可选功能（该曲目有版权，**不**随包分发；文件缺失时自动无声，不影响任何功能）。
- 疾跑切枪（Shift+数字键）与保持瞄准等体验优化。

## 前置

- Fallout Equestria: REMAINS（推荐 1.02；加载器同时支持 1.03/1.04）。
- 一次性 **ModLoader** 游戏补丁——见
  [ModLoader Releases](https://github.com/Eclipse-NotFound/ModLoader/releases) → `Remains-GamePatch`。

## 安装

1. 从 [Releases](../../releases) 下载 `Sandevistan_v1.144.zip`。
2. 把压缩包里的 `mods` 文件夹整个复制进游戏根目录（与 `pfe.swf` 同级）。
3. 重启游戏，游戏内按 `\` 触发。完整中文手册（含历次更新说明）随压缩包附带（`SANDY-MANUAL.txt`）。

## 配置

全部参数在 `mods/Sandevistan/release/config.txt`（重启生效）或游戏内 **F9** 面板：`hotkey`、`duration`（帧，30 帧=1 秒）、`cooldown`、`replayspeed`、`ghostevery`、`fxrun`、`ghostblend`、`ghostalpha`、`replayghost`、`replayghostlife`、`projhits`/`projhp`/`projarmor`（含按武器变体）、`showmark`、`showhud`、`panelkey`、`diaglog`、`slowfactor`、`colormode`（0 彩虹 / 1 边缘行者渐变）、`edgethresh`、`swaprun`，以及敌人时停的 `esandy*` 系列。

## 禁用 / 卸载

在 `mods/loader-manifest.txt` 把本模组的启用位改成 `0`，或删除 `mods/Sandevistan`。

## 仓库说明

源码在本仓库的 `mods/Sandevistan/` 下（本仓库是真源；游戏机上的副本是单向镜像）。构建工具链与分发脚本不纳入版本库；`dist/` 为本地产物。

## 相关模组

[ModLoader](https://github.com/Eclipse-NotFound/ModLoader) ·
[MoreSkillsAndWeapons](https://github.com/Eclipse-NotFound/MoreSkillsAndWeapons) ·
[TDFC](https://github.com/Eclipse-NotFound/TDFC) ·
[RealisticVision](https://github.com/Eclipse-NotFound/RealisticVision) ·
[RandomRooms](https://github.com/Eclipse-NotFound/RandomRooms) ·
[RConnect](https://github.com/Eclipse-NotFound/RConnect)

> 粉丝模组项目，与游戏原作者无关。
