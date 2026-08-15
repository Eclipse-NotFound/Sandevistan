# 当前状态（每次改动后更新本文件）

> 权威来源：本文件 + `decisions/changelog.md`（历史）。入口见 `../交接文档.md`。
> **治理**（2026-08-15 起）：agent 工作范围与权限见 `../AGENT_SCOPE.md`（规则文件，
> 只读）；公共知识规范见 `../../shared-knowledge/README.md`；公共逆向资料在
> `../../game-reference/`（只读）。

## 0. 当前状态（2026-08-15）

- **当前版本 v1.114**（git master），已按**镜像部署**运行：仓库 `C:\RemainsMod` 为
  唯一事实源；游戏目录是**多 agent 共享工作区**——`mods\Sandevistan` 全镜像
  （同步脚本 `C:\RemainsMod\sync-to-game.bat`，排除 build 与 config.txt），
  `shared-knowledge\`/`game-reference\` 增补式同步，**不删除其他 agent 的文件**。
  游戏通过补丁直接从
  `<游戏目录>\mods\Sandevistan\release\SandevistanMod.swf` 加载模组，
  config.txt 也在此目录（F9 面板直接写这里，同步脚本不覆盖）。
- **已解决（用户确认 ✓）**：鬼影（v1.110，用户实测确认）；启动标记版本号显示完整；
  回放结束爆炸动画自然播完（v1.111/1.112）；爆炸动画原生速度（v1.113 移除寿命钳制）。
- **v1.114 内容**：投掷物血量/护甲可按武器 id 覆盖（projhp_<id>/projarmor_<id>）。
- **待用户实测确认**：v1.113 野火核弹速度；v1.114 按武器覆盖（如 projhp_bel=120
  后野火核弹要多枪才爆）。
- **日志**：`C:\Users\micha\AppData\Roaming\pfe\Local Store\sandy_modlog.txt`
  （启动有 `v1.114 loaded swaprun=1` 标记；诊断行 grep -a 取：
  ghostScan/partsKillDeep/partsResumeE/reatt/boom/twinKill/swapRun）。

## 1. 已知问题与待办

### 待用户实测确认
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

1. 等用户实测 v1.109（镜像部署）+ v1.108（鬼影是否消失）。
2. 若确认：更新本文件 + `decisions/changelog.md` + `release/说明.txt`，提交 git；
   并删除游戏目录旧 `SandevistanMod\` 回退副本。
3. 若未解决：按对应诊断（partsKillDeep vis 计数 / ghostScan）继续定位，改后重复 2。
