# Sandevistan — 斯安维斯坦时停

[English](README.md) · **简体中文**

按下一个键，让世界慢下来，自己照常移动和攻击；结束后快速重演刚才的动作，带出彩色残影。适合喜欢规划连招和电影感战斗的玩家。

**[下载 v1.145 — Sandevistan_v1.145.zip](https://github.com/Eclipse-NotFound/Sandevistan/releases/download/v1.145/Sandevistan_v1.145.zip)** · [发布说明 / 其他版本](https://github.com/Eclipse-NotFound/Sandevistan/releases)

点击上方链接下载成品。也可以打开发布页，展开 **Assets（下载文件）**，选择同名文件；**Source code** 和绿色 **Code → Download ZIP** 是源码，不能直接安装。

## 会带来什么变化

- 默认热键是 **反斜杠 `\`**，默认持续约 7 秒；世界默认降到 1/5 速度，之后加速回放。
- 可以调整持续时间、冷却、回放速度、残影颜色和浓度。
- 可选敌人时停，默认关闭；想增加挑战时再开。
- 可自行添加时停音乐；下载包不附带音乐，没有音乐也能正常玩。

## 安装

适用于 **Windows / Remains 1.02**。

1. 保存并退出游戏。Steam 库中右键 Remains → **管理 → 浏览本地文件**，打开含 `pfe.swf` 和 `application.xml` 的游戏文件夹。
2. 第一次装本系列模组，先完成 [ModLoader 首次安装](https://github.com/Eclipse-NotFound/ModLoader/blob/master/docs/INSTALL.zh-CN.md#first-install)；它包含一次性游戏补丁和模组扫描器。已装好的玩家可跳过。
3. 解压下载的 ZIP，把里面的 **`mods` 文件夹合并到游戏文件夹**，不要套成 `mods/mods`。 首次安装时，将包内 `default-config/Sandevistan/config.txt` 复制到 `mods/Sandevistan/release/config.txt`；升级时保留原配置。
4. 双击游戏目录下的 **`mods/ModLoader/RemainsModScanner.exe`**，等待完成后关闭提示，再按平常方式启动游戏。

放对后应能找到：`mods/Sandevistan/release/SandevistanMod.swf`。进入游戏后按 `\` 体验慢动作；不要依靠旧版常驻“已加载”标识判断。

[图示文件结构、更新与恢复方法](https://github.com/Eclipse-NotFound/ModLoader/blob/master/docs/INSTALL.zh-CN.md)

## 第一次怎么玩

1. 读入角色，在能正常行动时按 **`\`**。
2. 打开 **哔哔小马 → 设置 → 模组 → 斯安维斯坦** 调整手感。当前版本已移除旧 **F9** 独立面板。
3. 想加音乐，把自己准备的 MP3 命名为 `sandy_theme.mp3`，放入 `mods/Sandevistan/release/`，重启后在模组设置中开启音乐。

游戏内已保存的设置优先于配置模板。旧模板中的 F9、加载标识和部分已迁出功能注释是历史说明；疾跑切枪、投射物击落由 [MoreSkillsAndWeapons](https://github.com/Eclipse-NotFound/MoreSkillsAndWeapons) 提供。

## 更新、停用与适用范围

更新前保存退出，备份 `mods/Sandevistan`，再合并新版文件、运行扫描器并重启；保留自己的配置。临时停用时，可把该模组文件夹移到 `mods` 之外备份，再扫描并重启。

本指引对应公开的 v1.145。高帧率宿主已有适配，但这个模组包不会给原版游戏增加高帧率启动器；其他游戏版本、联机和全部模组组合未全面验证。

## 遇到问题

先检查：文件夹是否放对、是否运行过扫描器、是否完全退出并重启。通用问题见[安装与排错指南](https://github.com/Eclipse-NotFound/ModLoader/blob/master/docs/INSTALL.zh-CN.md#troubleshooting)。

仍有问题，请到[问题反馈](https://github.com/Eclipse-NotFound/Sandevistan/issues)说明：游戏版本、本模组版本、其他已装模组、操作步骤、预期结果与实际结果；能附截图或报错原文更好。不要上传个人存档，除非排查时确有需要。

<details>
<summary>开发资料（普通安装无需阅读）</summary>

本页按可下载的发布包编写，仓库源码可能更靠前。实现见 [mods/Sandevistan](mods/Sandevistan/)；历史设计、验证和版本记录保留在项目目录中。

</details>

[查看全部模组及玩法介绍](https://github.com/Eclipse-NotFound/ModLoader/blob/master/README.zh-CN.md#choose-mods) · [首次安装指南](https://github.com/Eclipse-NotFound/ModLoader/blob/master/docs/INSTALL.zh-CN.md)

这是玩家制作的非官方模组项目，需要自行拥有游戏。
