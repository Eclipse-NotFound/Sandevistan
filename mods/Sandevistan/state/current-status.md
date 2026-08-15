# 当前状态（每次改动后更新本文件）

> 权威来源：本文件 + `decisions/changelog.md`（历史）。入口见 `../交接文档.md`。

## 0. 当前状态（2026-08-15）

- **当前版本 v1.108**（git master，工作区干净），已部署到游戏目录与
  `mods/Sandevistan/release/SandevistanMod.swf`。
- **已解决（用户确认 ✓）**：回放爆炸物双倍伤害、野火核弹双冲击波、切枪后弹药增加、
  疾跑切枪（swaprun，KEY_DOWN 事件层拦截）、回放结束后的火光尾焰（endReplay
  partsKillEnd 清空残留粒子）。
- **鬼影（v1.108 已修复，待用户实测确认）**：真根因=游戏 `Part.setNull`（Part.as:66）
  死亡路径**从不摘除粒子 vis**（`Pt.remVisual` 存在但没人调）——时停中爆炸粒子自然
  死亡或被 partsKill 杀死后，vis 冻结在爆炸位置（visualFlare 亮光+爆炸 MC）=回放中
  钉死的鬼影。正常游戏里这些孤儿 vis 靠 `Grafon.setLight→drawAllObjs`（Grafon.as:681/703，
  爆炸破坏瓦片触发光照重算）重建显示层时抹掉——时停+回放世界冻结期间无重建，鬼影
  全程可见；回放 boom 爆炸破坏瓦片触发重建才消失=用户观察"鬼影从回放开始、到回放中
  爆炸结束后消失"的完整解释。v1.107 的 ghostScan 误报候选（visdefwave/visaglau）：
  R50/R100 扫描证明两者已跟随玩家移动（不在钉死位置），真正钉死的是爆炸坐标
  (1028.8,299.3) 上的 visualFlare+2 个 MovieClip（回放第 10/20 帧均在，partsAlive≈0
  证明非粒子本体）。**修复**：`killPartsDeep`——①链上每个 Part 先 `remVisual()` 再
  `setNull()`；②显示树扫除（按 AllData `<part vis='...'>` 类名清单）自然死亡粒子的
  孤儿 vis；endSandy 与 endReplay 各调一次；mcStepParts 播完即杀同步补 remVisual。
  诊断 `partsKillDeepS/E: killed=N vis=M`。
- **日志**：`C:\Users\micha\AppData\Roaming\pfe\Local Store\sandy_modlog.txt`
  （启动有 `v1.108 loaded swaprun=1` 标记；诊断行 grep -a 取：
  ghostScan/partsKillDeep/boom/twinKill/swapRun）。

## 1. 已知问题与待办

### 待用户实测确认
- **v1.108 鬼影修复**：触发时停→回放，看回放开始到爆炸前还有没有钉死的亮光。
  若有：采集 `ghostScan`/`partsKillDeep` 行；若无：收尾。

### 遗留（低优先级，未再确认）
- "有攻击动画但无伤害"残余（偶发）：rFire cnt/exec 诊断已就位，如再现采集日志定案。
- 预判死亡略松（历史反馈）：v1.60-1.61 模型 + v1.62 吞攻击根治后未再确认，
  如需可调余量 0.9。
- 门/场景破坏过程重演：瓦片层重建/光照图受引擎限制，回放无法驱动（结果保留、
  过程不重演），当前按 vf/dop 尽力重演——已知限制。

### 长期/环境
- Steam 还原 DLC 文件（1.02 不受影响；重跑 release/安装.bat）
- 输入法 Shift 误触（用户已知，Ctrl+Space 恢复）
- diaglog=1 的日志在 AppData\Roaming\pfe\Local Store\sandy_modlog.txt

## 2. 下一步

1. 等用户实测 v1.108（鬼影是否消失）。
2. 若确认：更新本文件 + `decisions/changelog.md` + `release/说明.txt`，提交 git。
3. 若未解决：按 v1.108 诊断（partsKillDeep vis 计数）继续定位，改后重复 2。
