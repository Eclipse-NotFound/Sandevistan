# 构建与部署流程

> 提取自原交接文档 §4，路径已更新为 2026-08-15 整理后的新结构。
> 所有命令在仓库根 `C:\RemainsMod\` 下执行。

## 本目录内容

```
build/
├─ tools/        工具链（已 gitignore，可重新下载）：flexsdk（含 AIR SDK 合并）、
│                airsdk（原始解压）、ffdec、archives/（三个原始 zip）
├─ out/          模组 SWF 编译产物（已 gitignore）
├─ patch_out/    importScript 打补丁产物（已 gitignore）
├─ scripts/      辅助脚本（python：SWF 提取/解析、一次性源码补丁）
├─ tests/        工具链自检文件（tiny.as/tiny.swf）
└─ logs/         编译/诊断日志与下载临时文件（已 gitignore）
```

### 反编译源码（查游戏机制先 grep 这里）

已迁至公共只读研究区 **`game-reference/decompiled/{1.02,1.03,1.04}`**——
映射表与使用规则见 `game-reference/README.md`（默认 REFERENCE-ONLY，见
`../AGENT_SCOPE.md` §4）。

## 1. 编译模组 SWF

```
cd D:\RemainsMod\mods\Sandevistan
cmd //c "build\build.bat"        # 产物 build\out\SandevistanMod.swf
```

- 2026-08-28 实测：flexsdk 自带 air-config.xml 的 `{airHome}` 令牌因 SDK 目录迁移
  失效，直接调 amxmlc 报"无法打开 {airHome}/frameworks/libs/air"。现走
  `build\build.bat` + `build\sandy-config.xml`（显式写 playerglobal/airglobal
  绝对路径，同 TDFC 的 tdfc-config.xml 范本）；Java 用 Adobe Animate 2024 自带
  JRE（`D:\Program Files\Adobe Animate 2024\jre`，本机无独立 JDK）。
- 产物拷贝 `build\out\SandevistanMod.swf` → `release\` 后跑 `sync-to-game.bat`。

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

**⚠️ 多开发者协作检查（2026-08-15 起，改动游戏本体文件前必做）**：
游戏目录由多个 agent/开发者共享——覆盖 `pfe.swf`/`DLC\*` 前必须确认当前文件
没有被其他人改过：

1. 算当前游戏文件的 MD5，与 `release\patched\`（我们上次部署）和
   `release\backup\`（原版）比对：
   - 等于我们上次部署 → 我们最后改的，可直接覆盖；
   - 等于原版 → 被 Steam 还原了，可直接覆盖；
   - **其它任何值 → 有其他人改过，禁止直接覆盖**，走合并：
2. 合并流程：把**对方当前的游戏文件**当作新的输入（而不是 backup 原版），
   对其运行 importScript（对方改的是 MainFE 之外的部分会保留）；若对方也
   改过 MainFE（出现冲突），把我们的 `loadSandevistanMod` 注入逻辑合并进
   对方的 MainFE 源码后再导入，并记录合并说明。
3. 部署前把对方版本的 MD5 记入提交信息，便于回溯。

```
java -Xmx3g -Xms256m -jar build\tools\ffdec\ffdec.jar \
  -importScript <输入.swf> <输出.swf> C:\RemainsMod\mods\Sandevistan\src\patch
```

- 参数顺序：**输入、输出、脚本目录**（目录内含 `scripts/` 子目录）。
- 三个版本原版在 `release\backup\`（1.02/1.03/1.04，v2 是 Steam 更新后的）。
- 部署：把输出 SWF 复制到游戏目录（`pfe.swf`、`DLC/pfe.swf`、`DLC/pfeUI.swf`），
  同步 `release\patched\`。

## 3. 部署与恢复（v1.109 起：镜像部署，方案 B）

- **模型**：仓库 `C:\RemainsMod` 是唯一事实源；游戏目录是**多 agent 共享工作区**
  （其他 agent 的模组并存于 `mods\` 下）。同步脚本 `C:\RemainsMod\sync-to-game.bat`：
  - `mods\Sandevistan` → **全镜像**（/MIR；排除 build/ 与 **config.txt**——游戏内
    F9 面板直接写游戏目录里的 config，同步不覆盖）；
  - `shared-knowledge\`、`game-reference\` → **增补式同步**（/E，不删除其他
    agent 贡献的文件）。
  - 脚本**绝不触碰** `mods\` 下的其他模组目录。
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
# v1.114 按武器 id 单独设置（可选，不写=用全局值）：
#   projhp_<武器id> / projarmor_<武器id>
#   例：projhp_grenade=60  projhp_bel=120  projhp_aglau=45  projarmor_aglau=10
#   常用 id：grenade=手雷 bel=野火核弹 aglau=榴弹发射器 mlau=导弹发射器
# v1.115 敌人斯安维斯坦：
enemysandy=UnitRaider,UnitMerc,UnitAlicorn,UnitEncl,UnitRanger
                  # 装备名单（类名；默认=掠夺者/狮鹫(佣兵)/天角兽/英克雷/铁骑卫）
esandydur=150     # 持续帧（30帧=1秒 → 5秒）
esandycd=300      # 冷却帧（10秒）
esandyspd=5       # 加速倍率
esandyghost=1     # 敌人残影（边缘行者配色）
esandymark=1      # 调试"S"徽标（绿=待机 黄=激活 灰=冷却）
showmark=1       加载标记
panelkey=120     F9 参数面板
diaglog=0        诊断日志（AppData\Roaming\pfe\Local Store\sandy_modlog.txt）
debugtest=0      自动测试（新游戏+自动触发 Sandy 全周期）
```
