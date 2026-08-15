# 构建与部署流程

> 提取自原交接文档 §4，路径已更新为 2026-08-15 整理后的新结构。
> 所有命令在仓库根 `C:\RemainsMod\` 下执行。

## 本目录内容

```
build/
├─ tools/        工具链（已 gitignore，可重新下载）：flexsdk（含 AIR SDK 合并）、
│                airsdk（原始解压）、ffdec、archives/（三个原始 zip）
├─ game-src/     反编译的游戏源码（只读参考；映射表见下）
├─ out/          模组 SWF 编译产物（已 gitignore）
├─ patch_out/    importScript 打补丁产物（已 gitignore）
├─ scripts/      辅助脚本（python：SWF 提取/解析、一次性源码补丁）
├─ tests/        工具链自检文件（tiny.as/tiny.swf）
└─ logs/         编译/诊断日志与下载临时文件（已 gitignore）
```

### game-src/ 映射表（查游戏机制先 grep 这里）

| 目录 | 内容 |
|---|---|
| `game-src/src102` | **1.02 反编译主参考**（完整 fe 包：AllData/Weapon/Bullet/Part/…，gitignored） |
| `game-src/src_pfe` | 1.02 另一份完整反编译（部分 weapon 类缺失，已入库） |
| `game-src/src_pfe2` | 1.02 关键类补全（unit：Unit/UnitPlayer/Mine/VirtualUnit；weapon：Weapon/Bullet/PhisBullet/SmartBullet/WClub/WThrow/WMagic/…） |
| `game-src/src_pfe3` | 1.02 再一版（Unit/UnitPlayer/Weapon） |
| `game-src/src_pfe4` | 1.02 的 MainFE |
| `game-src/src_103, src_103v2, src_104, src_104v2` | 1.03/1.04 各版本 MainFE（原版与 Steam 更新后 v2） |
| `game-src/src_frame` | 视觉截图参考（gitignored） |

## 1. 编译模组 SWF

```
cd C:\RemainsMod\mods\Sandevistan
AIR_HOME="C:\RemainsMod\mods\Sandevistan\build\tools\flexsdk" \
  cmd //c "build\tools\flexsdk\bin\amxmlc.bat -default-size 1280 800 \
  -output build\out\SandevistanMod.swf src\SandevistanMod.as"
```

- 需要：flexsdk（Apache Flex 4.16.1，清华镜像）+ airsdk（Harman 51.3.3.2，需会话流程
  下载）叠加合并。两者被 gitignore，需重新下载（本地已有可跳过）：
  - flexsdk：`https://mirrors.tuna.tsinghua.edu.cn/apache/flex/4.16.1/binaries/apache-flex-sdk-4.16.1-bin.zip`
  - airsdk：`https://airsdk.harman.com/download`（Angular SPA；先 GET
    `/api/config-settings/download` 取 sessionId+cookie，再用 `?id=<sid>` 下载
    `AIRSDK_Flex_Windows.zip`，须带 cookie）
  - ffdec：`https://gh-proxy.com/https://github.com/jindrapetrik/jpexs-decompiler/releases/download/version26.2.1/ffdec_26.2.1.zip`
- 常见坑：**bash heredoc 传 `\n` 会变真实换行**（源码里字符串用
  `String.fromCharCode(13,10)`）；后台任务（run_in_background）里 `cmd //c` 的
  cwd 会丢失（编译失败），**必须前台编译**；`grep -c` 返回 0 会断 `&&` 链。

## 2. 打游戏补丁（MainFE）

```
java -Xmx3g -Xms256m -jar build\tools\ffdec\ffdec.jar \
  -importScript <原版.swf> <输出.swf> C:\RemainsMod\mods\Sandevistan\src\patch
```

- 参数顺序：**输入、输出、脚本目录**（目录内含 `scripts/` 子目录）。
- 三个版本原版在 `release\backup\`（1.02/1.03/1.04，v2 是 Steam 更新后的）。
- 部署：把输出 SWF 复制到游戏目录（`pfe.swf`、`DLC/pfe.swf`、`DLC/pfeUI.swf`），
  同步 `release\patched\`。

## 3. 部署与恢复（v1.109 起：镜像部署，方案 B）

- **模型**：仓库 `C:\RemainsMod` 是唯一事实源；游戏目录放镜像副本：
  - `<游戏目录>\mods\`（除 build/）+ `<游戏目录>\shared-knowledge\`
  - 同步脚本：`C:\RemainsMod\sync-to-game.bat`（robocopy /MIR；排除 build/ 与
    **config.txt**——游戏内 F9 面板直接写游戏目录里的 config，同步不覆盖）。
- **运行路径（已写进补丁与模组）**：
  - 模组加载：`app:/mods/Sandevistan/release/SandevistanMod.swf`
  - 配置读写：`<游戏目录>\mods\Sandevistan\release\config.txt`
- **改代码后的完整流程**：改 src → 编译（§1）→ 拷贝到 `release\` → 跑
  `sync-to-game.bat` →（若改了补丁或游戏 SWF）重打补丁（§2）→ 运行游戏目录
  `mods\Sandevistan\release\安装.bat`（备份原版+安装 patched/）。
- `安装.bat`/`卸载.bat` 已适配新层级（GAMEDIR=`%MODDIR%..\..\..`=游戏根）；
  卸载优先还原 Steam 更新后的 v2 原版。
- **Steam 会校验并还原被修改的 DLC 文件**（启动时）——重跑 安装.bat 即可。
- 回退：游戏目录旧 `SandevistanMod\` 保留一轮（含旧补丁与旧 config）。
- 详细恢复流程见 `state/recovery-guide.md`。

## 4. 配置（`release\config.txt`）

```
hotkey=220       触发热键（\）
duration=210     生效时长（帧，30=1秒 → 7秒，v1.89 起默认）
cooldown=0       冷却（当前 0=无冷却，调试用）
replayspeed=5    回放倍速（每显示帧消耗 5 历史帧）
slowfactor=5     时停世界减速倍率（世界每 slowfactor 显示帧步 1 次）
ghostevery=5     时停残影间隔（帧）
replayghost=1    回放残影生成间隔（显示帧）
replayghostlife=4 回放残影寿命（显示帧）
ghostblend=1     残影混合（1柔和/0发光）
ghostalpha=70    残影不透明度%
colormode=0      配色模式（0彩虹循环/1边缘行者渐变）
edgethresh=15    边缘行者渐变门槛（选项页步进 1，允许奇数）
fxrun=1          时停粒子特效（1继续慢速 0冻结）
swaprun=1        疾跑中切枪开关（1=疾跑时数字键按第一组快捷槽切枪，0=游戏本体行为）
projhits=1       投掷物可击落开关（独立于时停，常规游戏也生效）
projhp=30        投掷物血量（受击至 0 引爆）
projarmor=0      投掷物护甲（伤害先减护甲，预留接口）
showmark=1       加载标记
panelkey=120     F9 参数面板
diaglog=0        诊断日志（AppData\Roaming\pfe\Local Store\sandy_modlog.txt）
debugtest=0      自动测试（新游戏+自动触发 Sandy 全周期）
```
