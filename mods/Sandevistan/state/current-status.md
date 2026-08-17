# 当前状态（每次改动后更新本文件）

> 权威来源：本文件 + `decisions/changelog.md`（历史）。入口见 `../交接文档.md`。
> **治理**（2026-08-15 起）：agent 工作范围与权限见 `../AGENT_SCOPE.md`（规则文件，
> 只读）；公共知识规范见 `../../shared-knowledge/README.md`；公共逆向资料在
> `../../game-reference/`（只读）。

## 0. 当前状态（2026-08-17）

- **当前版本 v1.128**（git master），已按**镜像部署**运行：仓库 `C:\RemainsMod` 为
  唯一事实源；游戏目录是**多 agent 共享工作区**——`mods\Sandevistan` 全镜像
  （同步脚本 `C:\RemainsMod\sync-to-game.bat`，排除 build 与 config.txt），
  `shared-knowledge\`/`game-reference\` 增补式同步，**不删除其他 agent 的文件**。
  游戏通过补丁直接从
  `<游戏目录>\mods\Sandevistan\release\SandevistanMod.swf` 加载模组，
  config.txt 也在此目录（F9 面板直接写这里，同步脚本不覆盖）。
  **多开发者注意**：改动游戏本体文件（pfe.swf 等）前必须先做哈希比对，
  他人已改则合并（流程见 `build/README.md` §2）。
  **共存环境**：游戏目录现有 4 个模组（Sandevistan + MoreSkills&Weapons +
  RConnect + RealisticVision），游戏 SWF 已含四方补丁（我们的注入仍在）。
  **同步注意**：`sync-to-game.bat` 是 LF-only 换行，cmd/PowerShell 直接跑会
  逐行错乱（'le'/'o' 不是命令），需在 Git Bash 下包装或用临时 CRLF 副本；
  本次改用 PowerShell 直接执行等效 robocopy（/MIR 排除 build+config.txt）。
- **v1.127 迁移（2026-08-17）**：**疾跑切枪 + 手雷击落 已迁出到
  MoreSkills&Weapons**（新组件 MSWSwaprun.as / MSWProjHits.as，SharedObject
  配置、面板第 7-10 行；交接文档见该模组
  `state/MIGRATION-Sandevistan-swaprun-projhits.md`）。Sandevistan 侧停用：
  cfgProjHits/cfgSwapRun 默认 false、config 键/设置面板行/saveConfigFile 回写
  移除；**适配**：stepProjHits 回放重演分支抽成 replayProjBoom() 脱离门控，
  斯安维斯坦回放对"时停中自然爆炸"的重演不受影响；完整源码备份在
  `state/migration-backup-v1.126/`。共存约定：MSW 侧 MSWU.inGameplay() 含
  onPause 判定——时停/回放期间两技能不介入（行为差异：时停期间疾跑切枪
  不再生效，换取回放系统共存）。
- **已解决（用户确认 ✓）**：鬼影（v1.110）；启动标记版本号显示完整；
  回放结束爆炸动画自然播完（v1.111/1.112）；爆炸动画原生速度（v1.113）；
  投掷物血量/护甲按武器覆盖（v1.114）；击落敌人手雷生效；**S 徽标可见
  （v1.121 配置解析真根因）**；**敌人触发修复（v1.126）**。
- **跨模组问题（已定位，未越权修复）**：全敌人满装甲条 = RealisticVision 的
  hideEnemies 对视野内敌人强制 `hpbar.visible=true` + 游戏血条子元件默认可见。
  已建议用户转告 RV 开发者；我们不动其代码。
- **待用户实测确认**：①掠夺者房间出现 S（v1.124）②S 不再出现在无敌人
  房间（v1.124 换房间清空）③敌人残影明显可见（v1.122）④**回放翻滚**——
  若仍不重现，把日志里 `rollRec:`/`rRoll:` 行发我（diaglog=1）
  ⑤**v1.126 敌人触发**：a. 玩家保持在敌人视野内→敌人冷却结束后再次开启
  b. 玩家开着时停进入敌人视野→敌人照常开启（日志可查 `ON(during player
  sandy)`）⑥**v1.128 斑马隐身修复**：敌人斯安维斯坦结束后斑马不再隐形。

## 1. 已知问题与待办

### 待用户实测确认
- **v1.128 斑马隐身**：斑马（UnitZebra）在敌人斯安维斯坦后不再隐形（根因
  =shine 每步-1 被 5× 补步放大；esShineGuard 用 public isShoot 触发
  `shine=weapon.shine` 回充）。若仍隐身：diaglog=1 采
  `esandy: ... OFF`/`cdVis`/`shineGuard`/`esGhost-orphan` 行（esVisState
  会显示 vis/onSt/parent/alpha/sost——区分"显示链断了"还是"alpha 归零"）。
- **v1.127 迁出回归**：①Sandevistan 侧疾跑切枪/手雷击落确认不再生效
  （无双重执行）；②斯安维斯坦时停/回放一切照常（含回放爆炸重演——
  验证 replayProjBoom 抽离门控后无回归）；③MoreSkills&Weapons 侧两技能
  正常（见其 HANDOFF/MIGRATION 文档）。
- **v1.126 敌人触发两场景**（见 §0 ⑤）：触发节奏是否符合预期（dur/cd 循环）。
- **v1.109 镜像部署**：加载标记、时停/回放、F9 保存 config（见上）。
- **v1.108 鬼影修复**：触发时停→回放，看回放开始到爆炸前还有没有钉死的亮光。
  若有：采集 `ghostScan`/`partsKillDeep` 行；若无：收尾。

### 遗留（低优先级，未再确认）
- "有攻击动画但无伤害"残余（偶发）：rFire cnt/exec 诊断已就位，如再现采集日志定案。
- 预判死亡略松（历史反馈）：v1.60-1.61 模型 + v1.62 吞攻击根治后未再确认，
  如需可调余量 0.9。
- 门/场景破坏过程重演：瓦片层重建/光照图受引擎限制，回放无法驱动（结果保留、
  过程不重演），当前按 vf/dop 尽力重演——已知限制。

### 长期/环境
- Steam 还原 DLC 文件（1.02 不受影响；重跑游戏目录 mods\Sandevistan\release\安装.bat）
- 输入法 Shift 误触（用户已知，Ctrl+Space 恢复）
- diaglog=1 的日志在 AppData\Roaming\pfe\Local Store\sandy_modlog.txt
- 旧 `SandevistanMod\` 文件夹（游戏目录）为回退副本，确认稳定后删除

## 2. 下一步

1. **待用户实测确认**（每轮反馈后逐项勾销，见 §0）：
   ①掠夺者房间出现 S（v1.124）②S 不再出现在无敌人房间（v1.124）
   ③敌人残影明显可见（v1.122）④回放翻滚/趴下/起身（v1.120；仍不重现则
   让用户开 diaglog=1，发回 `rollRec:`/`rRoll:` 日志行）
   ⑤v1.126 敌人触发：a. 玩家保持在视野内→冷却结束再开启 b. 玩家时停中
   进入视野→敌人照常开启（`ON(during player sandy)` 日志可证）
   ⑥v1.127 迁出回归（见 §1）：Sandevistan 侧两技能不再生效、斯安维斯坦
   时停/回放（含爆炸重演）无回归。
   ⑦v1.128 斑马隐身修复：敌人斯安维斯坦结束后斑马不再隐形（shine 回充）；
   若仍有隐身，diaglog=1 采 `esandy: ... OFF`/`cdVis`/`shineGuard`/`esGhost-orphan` 行。
2. 稳定后：更新本文件 + `release/说明.txt`，并删除游戏目录旧
   `SandevistanMod\` 回退副本（保留一轮）。
