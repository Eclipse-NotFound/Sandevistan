# 当前状态（每次改动后更新本文件）

> 权威来源：本文件 + `decisions/changelog.md`（历史）。入口见 `../交接文档.md`。
> **治理**（2026-08-15 起）：agent 工作范围与权限见 `../AGENT_SCOPE.md`（规则文件，
> 只读）；公共知识规范见 `../../shared-knowledge/README.md`；公共逆向资料在
> `../../game-reference/`（只读）。

## 0. 当前状态（2026-08-16）

- **当前版本 v1.124**（git master），已按**镜像部署**运行：仓库 `C:\RemainsMod` 为
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
- **已解决（用户确认 ✓）**：鬼影（v1.110）；启动标记版本号显示完整；
  回放结束爆炸动画自然播完（v1.111/1.112）；爆炸动画原生速度（v1.113）；
  投掷物血量/护甲按武器覆盖（v1.114）；击落敌人手雷生效；**S 徽标可见
  （v1.121 配置解析真根因）**。
- **v1.115-1.124 内容**：敌人斯安维斯坦（v1.117 修类名匹配；斑马；v1.119
  徽标改挂 grafon.visual 顶层容器 + esandyper=50%；v1.121 S 徽标真根因=配置
  解析）；v1.120 回放重现翻滚/趴下/起身；v1.122 敌人残影修复；v1.123 S
  徽标排除尸体 + 回放翻滚诊断（rollRec/rRoll）；**v1.124 换房间清空敌方
  状态（跨房间徽标泄漏）+ 移除 currentWeapon 过滤（掠夺者无 S）+ 按敌人
  逐个的创建诊断**。
- **跨模组问题（已定位，未越权修复）**：全敌人满装甲条 = RealisticVision 的
  hideEnemies 对视野内敌人强制 `hpbar.visible=true` + 游戏血条子元件默认可见。
  已建议用户转告 RV 开发者；我们不动其代码。
- **待用户实测确认**：①掠夺者房间出现 S（v1.124）②S 不再出现在无敌人
  房间（v1.124 换房间清空）③敌人残影明显可见（v1.122）④**回放翻滚**——
  若仍不重现，把日志里 `rollRec:`/`rRoll:` 行发我（diaglog=1）。

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

1. 待用户实测 v1.120（回放中翻滚/趴下/起身动画；顺带确认 v1.119 的 S 徽标
   可见性与每房间一半敌人装备）。
2. 若 S 徽标仍不可见：diaglog=1 采集 esmark 行（挂载链/onStage/坐标）发我。
3. 稳定后：更新本文件 + `release/说明.txt`，并删除游戏目录旧
   `SandevistanMod\` 回退副本（保留一轮）。
