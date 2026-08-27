# 当前状态（每次改动后更新本文件）

> 权威来源：本文件 + `decisions/changelog.md`（历史）。入口见 `../交接文档.md`。
> **治理**（2026-08-15 起）：agent 工作范围与权限见 `../AGENT_SCOPE.md`（规则文件，
> 只读）；公共知识规范见 `../../shared-knowledge/README.md`；公共逆向资料在
> `../../game-reference/`（只读）。

## 0. 当前状态（2026-08-21）

- **当前版本 v1.135**（git master `d0ae5a3`，工作树干净），已按**镜像部署**
  运行：仓库 `C:\RemainsMod` 为唯一事实源；游戏目录是**多 agent 共享
  工作区**——`mods\Sandevistan` 全镜像（同步脚本 `C:\RemainsMod\sync-to-game.bat`，
  排除 build 与 config.txt），`shared-knowledge\`/`game-reference\` 增补式
  同步，**不删除其他 agent 的文件**。游戏通过补丁直接从
  `<游戏目录>\mods\Sandevistan\release\SandevistanMod.swf` 加载模组，
  config.txt 也在此目录（F9 面板直接写这里，同步脚本不覆盖）。
  **多开发者注意**：改动游戏本体文件（pfe.swf 等）前必须先做哈希比对，
  他人已改则合并（流程见 `build/README.md` §2）。
  **共存环境**：游戏目录现有 4 个模组（Sandevistan + MoreSkills&Weapons +
  RConnect + RealisticVision），游戏 SWF 已含四方补丁（我们的注入仍在）。
- **v1.127 迁移（不变）**：疾跑切枪 + 手雷击落已迁出到 MoreSkills&Weapons
  （Sandevistan 侧停用；回放系统不受影响；备份 `state/migration-backup-v1.126/`）。
- **已解决（用户确认 ✓）**：鬼影（v1.110）；启动标记版本号完整；
  爆炸动画原生速度（v1.113）；投掷物血量/护甲覆盖（v1.114）；击落敌人
  手雷生效；S 徽标可见（v1.121）；敌人触发修复（v1.126）；输入法警告
  UI 移除 + 顶部状态 UI 开关（v1.125）；残影修复（v1.122）。
- **v1.130-1.135 内容（最近，多数待用户实测确认）**：
  - v1.130 回放玩家动画**帧级忠实重演**（录 bl/bf，回放 gotoAndStop）；
  - v1.131 敌人斯安维斯坦生成三控件（esandyenabled / esandyroomprob /
    esandyper；F9+设置页 7→10 项）；
  - v1.132 回放敌人动画防僵死（Blit 怪按位移喂 dx+补 animate）+ 怪物
    隐身/不可抓根治（录像 iv/lv，逐帧强压 vis.visible/invis/levitPoss）；
  - v1.133 回放死亡敌人开火根治（sost>=3 非 postDie 跳过 step）；
  - v1.134 回放敌人动画僵硬根治（MC 小马类按帧快照 osn.gotoAndStop+body.f；
    Blit 怪保留 dx 喂入；尸体不快照）；
  - v1.135 打开哔哔小马（TAB）时游戏不能暂停修复（stepEnemySandy 加
    inGameplay() 门控——pip/对话/菜单时敌人斯安维斯坦整体冻结）。
- **跨模组问题（已定位，未越权修复）**：全敌人满装甲条 = RealisticVision
  的 hideEnemies 强制 `hpbar.visible=true`——已建议用户转告 RV 开发者。
- **待用户实测确认**（新对话的入口，见 `../交接文档.md` §当前主线）：
  ①v1.130 回放玩家动画帧级还原（起始/结束姿势不一致时）②v1.132-134
  敌人动画（僵尸/蝎子不再僵死、小马类姿态逐帧还原）、怪物不残留隐身/
  可念力抓取、死亡敌人不开火 ③v1.135 pip 暂停恢复 ④v1.131 生成三控件。

## 1. 已知问题与待办

### 待用户实测确认
- **v1.129 敌人隐形 + 念力抓取**：所有敌人类型斯安维斯坦后隐形（v1.128 斑马
  shine 修复=采样偏差，保留为兜底）。v1.129 就地检测+自愈（esInvScan：
  visible=false→置回；脱链→重挂 grafon.visObjs[oE.sloy]；spawnEnemyGhost
  摘挂后 parent==null 兜底重挂）+ 念力诊断 teleDiag（按 E 采样 celObj 的
  levitPoss/onCursor/massa/dist/maxTele）。复现后采 `esInv:`/`tele:`/
  `esandy ... OFF`/`cdVis`/`esGhost-orphan` 行。
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

1. **待用户实测确认**（每轮反馈后逐项勾销，见 §0 待确认清单）：
   ①v1.130 回放玩家动画帧级还原（起始/结束姿势不一致、半截动作）②v1.132-134
   敌人动画（僵尸/蝎子不再僵死；小马类姿态逐帧还原；死亡敌人不开火；
   怪物不残留隐身/可念力抓取，可采 `esInv:`/`tele:` 行）③v1.135 pip
   暂停恢复 ④v1.131 敌人生成三控件（F9/设置页）。
2. 稳定后：更新本文件 + `release/说明.txt`，并删除游戏目录旧
   `SandevistanMod\` 回退副本（保留一轮）；需要时重打包
   `C:\RemainsMod\dist\SandevistanMod_v<版本>.zip`。
