# 跨模组共享资源注册表

> 新模组占用热键 / 日志文件名 / SharedObject 名 / UI 覆盖层**之前必须先查本表并登记**（规则见 GOVERNANCE.md §4.1）。冲突处理：先到先得，后到者协商（通过用户转告，模组间不直接接触）。
> 建立于 2026-08-27，初始内容从各模组文档记录播种（出处列）；带 ⚠ 的条目是文档记载的已知共用/潜在冲突，待核实。

## 热键（F 键与特殊键）

| 键 | 占用者 | 用途 | 出处 |
|---|---|---|---|
| `\` | Sandevistan | 触发时停 | 其 testing-workflow |
| F1 | RandomRooms | rr_test | 其 current-status（git 历史） |
| F2 | RandomRooms | 回 rbl 基地 | 同上 |
| F3 | RandomRooms | 显示房间池 | 同上 |
| F4 | RandomRooms | 深度循环 | 同上 |
| F5 | RandomRooms | 展示馆（合成房实测） | 同上 |
| F6 | MoreSkills&Weapons | 设置浮层面板（主入口=哔哔小马设置页） | 其 HANDOFF（git 历史） |
| F7 | RandomRooms | jumpToSynth | 同上 |
| F8 | —（避开） | 该键盘无键事件，勿用 | MSW 记录 |
| F9 | Sandevistan | Sandevistan 设置面板；TDFC 0.6.0 已于 2026-09-10 移除 F9 测试生成，改独立场景与观察按钮 | 各自文档；TDFC 0.6 发布记录 |
| F10 | RConnect、RealisticVision ⚠ | RConnect NetHud 联机面板；RV 调试面板——**两面板同键，已知冲突候选，待协调** | 各自 HANDOFF；MSW 曾因此让出 F10 |
| F11 | RealisticVision | 模组总开关 | 其 HANDOFF（git 历史） |
| F12 | RealisticVision | 渲染模式轮换 | 同上 |
| TAB（pip 打开态） | Sandevistan v1.135 相关 | pip 打开时敌人冻结门控（非独占键，行为协调） | 其 current-status（git 历史） |

## 日志文件名（`%APPDATA%\pfe\Local Store\`）

| 文件 | 占用者 |
|---|---|
| `sandy_modlog.txt` | Sandevistan |
| `RConnect.log` | RConnect（测试实例在各自 app id 下） |
| `tdfc.log` | TDFC |
| `tdfc.previous.log`、`tdfc-report-<时间>.txt` | TDFC 0.6：轮转日志与按需诊断 |
| `RandomRooms_diag.log` | RandomRooms |
| `ModSettings.log` | ModSettings（2026-09-20 v0.2.0 已安装） |

新模组约定：`<ModName>.log`，日志行带 `[ModName]` 前缀（衔接 grep -a 工作流）。

## SharedObject / 持久化命名

| 名称 | 占用者 | 位置 |
|---|---|---|
| `MSWConfig.sol` | MoreSkills&Weapons | `#SharedObjects\mods\MoreSkills&Weapons\release\...\` |
| `Rconnect_config.txt`（storage 副本） | RConnect | 各 app id 的 Local Store |
| `ModSettingsLoader` | ModSettings 独立 loader | getLocal 名称，根路径 `/`；记录加载/初始化状态 |
| `RealisticVision_config.txt` | RealisticVision | Local Store 用户配置；首次读取 release/config.txt 模板，后续优先持久层 |

## UI 覆盖层 / 显示层级

| 位置 | 占用者 | 说明 |
|---|---|---|
| `grafon.visLight` 之后的同层雾层 | RealisticVision | 视野雾（vanilla 模式透传不碰） |
| 哔哔小马 Opt 页（主菜单页）子按钮栏"模组"按钮 + 原版控件设置行 | ModSettings | 2026-09-20 从 MSW 迁移；MSW v1.5.1 只注册自身设置，F6 保留 |
| `World.w.main` 子节点 `MSWModAPICarrier.modAPI`（历史通道） | 旧 MoreSkills&Weapons | v1.5.1 起不再发布；当前客户端使用下列中立通道，不复用旧名称 |
| 顶部状态 UI | Sandevistan | 可开关 |
| `World.w.main` 子节点 `TDFC_DebugRoot` | TDFC 0.6 | 右上角观察按钮、可拖动详情面板、屏幕敌人标记；无新增热键，调试默认关闭；2026-09-10 已部署 |
| `World.w.main` 子节点 `ModSettingsCarrier.modAPI` | ModSettings | 2026-09-20 已安装；registerPage/getPages/apiVersion/revision，selectPage/togglePage/isOpen。页面 ID：msw、msw-smart、sandevistan、realisticvision；TDFC 只读 |
| Opt 页自有节点 `ModSettingsButton` / `ModSettingsNavigation` | ModSettings | 正式独立入口；仍对混装的旧 MSW 载体让位，当前七模组组合不产生旧载体；不新增全局热键 |

## 游戏 SWF loader 路径

六模组加载矩阵见工作区根 `AGENTS.md` §3（运行时契约，不可改名）。**不属于本表的协商范围**——那是由补丁流程管理的硬契约。

2026-09-20 用户授权安装后，实际根 pfe 1.02 新增第七个 loader：`app:/mods/ModSettings/release/ModSettingsMod.swf` → `ModSettingsMod.init(main)`；原六个全部保留，DLC 未改。根 AGENTS 由用户维护，其六模组表为此前版本。
