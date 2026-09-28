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
| Shift+F3 | RandomRooms | v13 房间用途、D/V、刷新点与实时枪线调试开关；拦截组合键，不触发原 F3 测试旅行 | src/RandomRoomsMod.as，2026-09-28 已部署 |
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
| `LootEditor.log`、`LootEditor.receipt.json` | RModifier 掉落模块；2026-09-28 已迁移，正式重启由用户延期；测试使用独立 AIR 应用存储 |

新模组约定：`<ModName>.log`，日志行带 `[ModName]` 前缀（衔接 grep -a 工作流）。

## SharedObject / 持久化命名

| 名称 | 占用者 | 位置 |
|---|---|---|
| `MSWConfig.sol` | MoreSkills&Weapons | `#SharedObjects\mods\MoreSkills&Weapons\release\...\` |
| `rr_config` | RandomRooms | getLocal 根路径 `/`，已有版本/种子设置；v13 追加 debugDisplay 与一次性默认版本迁移标记 |
| `Rconnect_config.txt`（storage 副本） | RConnect | 各 app id 的 Local Store |
| `ModSettingsLoader` | ModSettings 独立 loader | getLocal 名称，根路径 `/`；记录加载/初始化状态 |
| `ModLoader` | 通用清单 loader（mods\ModLoader） | getLocal 名称，根路径 `/`；v2 每次启动清空旧状态，写 `session`、`boot_start`、`requested_<入口类>`、`ok_<入口类>`、`boot`、`err_manifest_<行索引>`／`err_loader`／`err_<入口类>`；值带本轮 run id（2026-09-23） |
| `RealisticVision_config.txt` | RealisticVision | Local Store 用户配置；首次读取 release/config.txt 模板，后续优先持久层 |
| `mods/RModifier/config/active.json` | RModifier（原 LootEditor） | 方案由独立编辑器写入，读取模块仅在启动时读取；不占用 SharedObject 或全局热键 |

## UI 覆盖层 / 显示层级

| 位置 | 占用者 | 说明 |
|---|---|---|
| `grafon.visLight` 之后的同层雾层 | RealisticVision | 视野雾（vanilla 模式透传不碰） |
| 哔哔小马 Opt 页（主菜单页）子按钮栏"模组"按钮 + 原版控件设置行 | ModSettings | 2026-09-20 从 MSW 迁移；MSW v1.5.1 只注册自身设置，F6 保留 |
| `World.w.main` 子节点 `MSWModAPICarrier.modAPI`（历史通道） | 旧 MoreSkills&Weapons | v1.5.1 起不再发布；当前客户端使用下列中立通道，不复用旧名称 |
| 顶部状态 UI | Sandevistan | 可开关 |
| `World.w.visual` 子节点 `RandomRooms_DebugWorld`；Stage 子节点 `RandomRooms_DebugHUD` | RandomRooms v13 | 世界坐标标记跟随相机；底部左侧图例；默认关闭、无鼠标拦截，仅生成房显示；2026-09-28 已部署 |
| `World.w.main` 子节点 `TDFC_DebugRoot` | TDFC 0.6 | 右上角观察按钮、可拖动详情面板、屏幕敌人标记；无新增热键，调试默认关闭；2026-09-10 已部署 |
| `World.w.main` 子节点 `ModSettingsCarrier.modAPI` | ModSettings | 2026-09-20 已安装；registerPage/getPages/apiVersion/revision，selectPage/togglePage/isOpen。页面 ID：msw、msw-smart、sandevistan、realisticvision；TDFC 只读 |
| Opt 页自有节点 `ModSettingsButton` / `ModSettingsNavigation` | ModSettings | 正式独立入口；仍对混装的旧 MSW 载体让位，当前七模组组合不产生旧载体；不新增全局热键 |

## 游戏 SWF loader 路径

历史六模组加载矩阵见工作区根 `AGENTS.md` §3；该表尚未由用户更新，不能作为当前加载矩阵。硬编码 release 路径仍不可改名。

2026-09-20 用户授权安装后，实际根 pfe 1.02 新增第七个 loader：`app:/mods/ModSettings/release/ModSettingsMod.swf` → `ModSettingsMod.init(main)`；原六个全部保留，DLC 未改。根 AGENTS 由用户维护，其六模组表为此前版本。

**2026-09-22 起结构变更（路线 B）**：三份游戏 SWF 的 MainFE 中 7/3/2 个专属 loader 调用点已替换为**单一清单驱动通用 loader**（`this.loadModsFromManifest()`，读取 `app:/mods/loader-manifest.txt`，行格式 `目录名|入口类名|1.02开关|1.03开关|1.04开关`）。各模组 release SWF 路径与 `init(main)` 契约不变；**加载矩阵的唯一权威来源现在是 mods\loader-manifest.txt**（AGENTS §3 的表为历史版本）。旧 loader 方法体留作死代码（保持各模组补丁脚本的幂等标记）。Steam 更新冲掉补丁后重跑 `mods\ModLoader\tools\patch_game_swfs.ps1` 即恢复。详见 `knowledge-validation/facts/mod-loader-patch-structure.md` 的 2026-09-22 补充段。

2026-09-23 v2 已部署并在三目标独立实例冒烟通过。补丁恢复脚本现在会校验完整 MainFE 结构并先生成三份产物；未知结构时中止，不能只凭单个标记判断幂等。清单行序仅控制异步加载请求的发起顺序。细节见上述 facts 文件的 v2 补充段。

## LootEditor 正式登记（2026-09-28，文件已安装，重启待核验）

- 清单入口：`LootEditor|LootEditorMod|1|0|0`；通过现有 ModLoader 与扫描器接入，不新增专属 loader，不改 MainFE。
- 中立设置页 ID：`loot-editor`，仅方案状态与本次启用开关；不占用全局热键。
- 桥接字段：`fe.serv.LootGen.lootEditorBridge`、`lootEditorContext`；前者发布 select/emit/capture/death 回调，后者仅在普通奖励调用期间保存 Interact 上下文并在 finally 还原。
- 生产读写位：`mods/LootEditor/config` 与 `profiles`；本次读取回执仍为应用 Local Store 下 `LootEditor.receipt.json`。测试入口 LootProbe 只存在于隔离副本，不能登记到正式清单。
- 用户明确授权后已备份并更新根 pfe.swf、安装 `release/LootEditorMod.swf`，调用现有扫描器登记；原有清单全部保留。根备份 `pfe_before_LootEditor_2026-09-28T00-13-05-389Z-2a4d4198.swf`。用户保留当前游戏、稍后自行重启；正式读取回执待核验，目前没有应用自定义方案。

## RModifier 目录迁移（2026-09-28，替代上方旧目录登记）

- 用户授权总整合并将 `LootEditor` 改名为 `RModifier`；正式目录现为 `mods/RModifier`。清单唯一入口为 `RModifier|LootEditorMod|1|0|0`，入口类与 SWF 名保留 `LootEditorMod`，没有重复保留旧目录或建立目录链接。
- 掉落模块 0.2.0 读取 `mods/RModifier/config/active.json`，回执带 `configRoot=mods/RModifier`。日志/回执名称、中立设置页 `loot-editor` 与掉落桥接字段不变，不新增游戏热键。
- 单文件入口 `mods/RModifier/RModifier.exe`；同窗口掉落/台词/地图三个页面。台词草稿和恢复位于 `profiles/barks`、`config/barks`；地图工作副本和恢复位于 `profiles/maps`、`config/maps`。原生绘图使用独立应用 ID `remains.rmodifier.renderer.s<会话>` 与私有工作目录，不占用正式 `pfe` 存储。
- 本次只迁移工程目录、配置记录、release 模块与现有 ModLoader 登记；根 `pfe.swf` 仍为 c631cbf3…6c64867，最初 b7824465…03305ac 备份保留。其他登记原样保留。撤回迁移记录位于 `mods/.rmodifier-migration/1790576794146-3f61d4d1-3cbd-4ab6-ad98-cc8a4d33f6a8/migration.json`。
- 改名后模块在隔离游戏中128断言通过；正式用户游戏未重启，新版本正式读取仍待用户自行重启后核验。未应用自定义掉落方案，未替换正式台词或地图。
