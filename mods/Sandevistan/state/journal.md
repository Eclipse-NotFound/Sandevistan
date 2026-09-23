# Sandevistan —— 开发日志

## 2026-09-23 v1.143 统一设置入口
- 用户要求只保留菜单设置。本轮移除F9独立弹窗、旧Options绿色浮层、相关状态和输入处理；16项中枢菜单设置及配置保存保留。
- 正式候选与真实ModSettings副本隔离验证21 PASS/0 FAIL/0 SKIP，含打开、存储保存重读、F9事件放行。首次测试因重读debugtest=0停止，修正仅测试分支后通过。
- 候选49,994字节，SHA256 B8805DBACC9A1313FD96BB68889911195AC6EAFCBB526E50C313B86AD1E9C748；已备份v1.142，待提交后部署复验。记录见knowledge/experiments/menu-settings-only-2026-09-23.md。


## 2026-09-23 v1.142 发布复验完成
- 实现提交 e821a76 后定向同步13个文件（不复制build工具链），游戏与源仓release均为51,623字节，SHA256 28449B2646223A8EEE20EB4BB361DDA2D5DC0572C6AAA9CD5FCB5D072A374C44。
- 实际部署文件的同字节隔离重启确认v1.142加载，全流程20 PASS/0 FAIL/1 SKIP；证据death-prediction-20260923/deployed-smoke.txt。未安装ModSettings的注册项跳过，死亡攻击snapSize=0仍不计为实质覆盖。
- 两侧留v1.141回滚，当前宿主B7824465…及玩家配置D91C4C28…在发布前后保持一致；未重启用户进程或触碰真实存档。
- 收尾：53项预判专项、574帧动画回归与正式发布流程通过；概率估计及爆炸/持续伤害/特殊Boss边界已写入研究记录和MEMORY。用户正常重启加载新版。

## 2026-09-23 v1.142 校准时停死亡预判
- 用户澄清：攻击足够致死但不出现预告。完整追踪实际接触与原生伤害函数，确认离场子弹、延迟近战和复用攻击体漏记，以及固定九折、重复耐久惩罚、护甲类型/顺序与破甲模拟错误。
- 增加 SandyDamagePredictor 和按挥击代次记账；独立预计耐久、9点随机伤害积分、覆盖分支期望、原生命中短路。无敌/全闪避/无接触保护；真实 WKick 扣血不再重复记入。
- 有效旧版52项47失败，新版53/53通过；动画574帧一致；正式构建流程20/0/1（未装ModSettings注册跳过）。夹具错误和已排除原因、概率及特殊路径边界见 knowledge/experiments/death-prediction-2026-09-23.md。
- 源仓release更新为51,623字节，SHA256 28449B2646223A8EEE20EB4BB361DDA2D5DC0572C6AAA9CD5FCB5D072A374C44；已备份v1.141，待提交后定向部署复验。公共旧公式追加明确更正，不改宿主/配置/真实存档。
- 当前宿主与上一轮哈希不同，最终测试已使用现有B7824465…宿主副本；没有回写旧宿主或清单。
## 2026-09-23 v1.141 发布复验完成
- 实现提交 f6ac18a 后定向同步；源仓与游戏 release 均为 50,878 字节、SHA256 F556C0728DA406A4A6A05399DF93E9A0349C4225107547F1E12FE88A2AEE3E48。
- 从已部署 SWF 的同字节隔离副本启动：v1.141 loaded，完整两轮流程 20 PASS/0 FAIL/1 SKIP，证据 deployed-smoke.txt。此次未装 ModSettings，注册项跳过；真实 pfe 存档未写、用户进程未重启。
- 同步中 Git 默认转义“说明.txt”导致白名单检查中止；release 已同步，其余文件用 core.quotepath=false 重新核对并完成。备份始终保留，发布复验读取的文件哈希再次确认为最终产物，没有将不完整部署当成完成。
- 游戏和源仓各留 v1.140 回滚，宿主 pfe 哈希仍为本轮基线；玩家配置未覆盖。下一步：用户正常重启游戏加载修复，后续反馈按具体场景复现。

## 2026-09-23 v1.141 修复掠夺者/尸鬼回放动画僵死
- 用户实测报告后，建立真实单位+生产记录/回放方法的隔离像素测试：旧版原录像 17/24 种身体画面，回放都只剩 1 种；移动正常。单改位移采样间隔可动但姿态仍全部不符。
- 新增 SandyBlitReplay：公开精灵图/显示树匹配真实帧，保存坐标，在原动画驱动后重绘；不读取 internal 状态，不每帧克隆素材，保留尸体与战斗处理。
- 12 组 574/574 帧逐像素一致，尸体保护 12 项通过；正式产物与候选各一次完整回归 20/0/1（独立设置宿主未装所以注册跳过）。解释、源码证据和失败实验见 knowledge/experiments/replay-animation-freeze-2026-09-23.md。
- 按发布门禁备份源 v1.140，准备提交源仓、定向同步 v1.141 并从发布文件复核启动；本轮不改宿主/清单/玩家配置，不写真实存档。

## 2026-09-23 接手开发与当前基线核验
- 用户要求接手 Sandevistan；已读 scope、记忆、近期日志、偏好、架构、教训和构建入口，并核对源码的初始化、时停、回放、状态恢复及独立设置注册链路。没有新增功能或部署需求。
- 确认源仓 D:\RemainsMod 的 master；接手前 HEAD 5838e10，仅有既存未跟踪 AGENTS.md，保留不动。源仓与游戏副本的源码、release SWF、主题曲、原 MEMORY/journal 的 SHA256 一致，v1.140 SWF 为 49,928 字节，哈希见 MEMORY。
- 重写 MEMORY 为当前 v1.140 快照，区分历史实机记录与本次静态核验；保留体验待验与已知限制，注明旧 MSW 宿主/旧安装器/旧机制注释不能直接沿用。
- Java、mxmlc 与两个 SWC 路径存在。本次未编译、未启动游戏、未改 SWF 或运行配置；状态文件在源仓提交后仅定向同步对应两文件。
- 停点：接手完成，等待用户指定下一项功能或问题。历史待验项不新增为用户承诺。

## 2026-09-20 v1.140 独立设置入口迁移并安装
- 明确用户授权：安装 ModSettings 并切换客户端入口。直接注册中立载体，16 项配置与保存继续自持；F9 保留，独立面板展开时旧选项浮层收起。
- 完整组合/无 MSW/二次进程保存恢复均通过，正式七模组字节启动检查通过；时停及回放逻辑未改。启动提示与浮层同含类名导致测试误判，已用实际浮层标题修正并截图确认。
- 先在正本提交源码再同步；发布 SHA 与两侧回滚见 MEMORY 顶部。没有更新旧 dist 安装器，没有覆盖正式 config 或其他公共库。

> 协议见 GOVERNANCE.md §8：只追加不改写，**新条目插在最上面**。
> 逐版本历史在 decisions/changelog.md（112+ 条，新行插前）；本日志记会话级脉络。

## 2026-09-07 v1.139 时停主题曲（断点续播）

- 做了什么：应用户需求实现时停 BGM——startSandy 沿播放 release/sandy_theme.mp3，回放结束沿 90 帧线性淡出；断点续播（淡出停止时记 channel.position，再次时停从断点起播，播完整首归零，会话内有效）；还在放时取消淡出恢复音量。musicon/musicvol/musicfade 三键进 config/F9（13 项）/设置页/MSW 模组页（16 项）。mp3 不入 git（gitignore+仓库侧同步）。真机 round 12：SUMMARY pass=22 fail=0 skip=0。
- 关键决定/发现：①状态沿检测（prevSandyActive/prevReplaying）挂 onFrameInner，不入侵 startSandy/endReplay 热函数——测试直调与玩家按键两条路径统一覆盖；②断点取"实际停止位置"（含淡出段）而非淡出起点——避免淡出尾音全音量重播的突兀；③孤儿兜底：无时停无回放但在放 60 帧自动补淡出，防错误路径漏关；④ADL 测试环境特效期掉帧明显（时停+回放实际帧率远低于 30），音乐按墙钟走导致歌位置与游戏帧时间脱钩——断点设计天然兼容。
- 遗留/下一步：用户实机听感验收（音量 70% 是否合适、淡出 3 秒手感）；其余同 MEMORY §6。

## 2026-09-05 v1.138 设置中枢接入打通（父域对象会合点）

- 做了什么：按 MSW 侧 7d9a6ef 的方案切换注册通道——载体 MSWModAPICarrier（挂 main 下，modAPI=hub）优先，getDefinition 降备用；补端到端断言（宿主登记簿 getPages() 反查 sandevistan 页 13 项）；真机 round 11：tries=1 命中，SUMMARY pass=18 fail=0 skip=0。
- 关键决定/发现：①对象引用跨域可用（受限的只是类定义）——会合点方案成立；②跨模组自动测试互相干扰的完整教训链：MSWAutoTest 自激活开档+开 pip → 需要 pip 守卫+恢复期治疗+清场序列（testPipGuard 模式，其他模组写自动测试可复用）；③MSW 的 sol 诊断 flush 时机滞后，跨模组注册验证以宿主登记簿活体反查为准。
- 遗留/下一步：用户实机看双页签效果；二期聚合页由 MSW 侧推进（滚动/choice/action 控件）。

## 2026-09-05 v1.137 F9 持久化修复 + MSW 设置中枢接入（被跨域墙阻断，待宿主侧）

- 做了什么：应用户要求接入 MSW 新做的哔哔小马"模组"设置聚合页——按其契约实现 hubBuildItems（13 项 get/set 回调，范围照抄 F9/设置页口径）+ 常驻注册重试；顺手根治"F9 调参重启即丢"（saveConfigFile 双写应用存储兜底 + loadConfig 覆盖层）；自动测试 10 轮迭代（pip 守卫、恢复期治疗、预压血造击杀窗口），最终 SUMMARY pass=16 fail=0 skip=1。
- 关键决定/发现：①**跨模组类名查找在现有 loader 下不可用**——MainFE 用 LoaderContext(false) 给每模组独立子域，兄弟模组互不可见，MSW 的注册契约（getDefinitionByName）跨模组必然 #1065；MSW 实例不上显示树、loader 引用 internal，我方无合法通道可达；实证已增补 shared-knowledge mod-loader-cross-domain-anomaly.md（置信度升 high），并已列入 MEMORY §4.6 待转告 MSW 开发者；②MSWAutoTest 在 appid≠pfe 实例自激活（开档+开 pip），跨模组自动测试必须互相清场（testPipGuard 模式）；③调试期发现 MSW release 于当日 07:29 重建，含 hub（1.3.1-hub）。
- 遗留/下一步：MSW 侧修复跨模组可达性后 Sandevistan 页自动接入（无需本侧改动）；用户手测 F9 修复与动画观感；RV 满装甲条仍待转告。

## 2026-08-28 v1.136 敌桑默认关 + 内置自动测试打通 §4 验证

- 做了什么：应用户要求 `esandyenabled` 默认 1→0（暂不测敌桑表现）；`stepDebugTest` 重写为全流程自动验证驱动（app id 双门控，`[TEST-ASSERT]` 断言体系 + SUMMARY 汇总）；搭测试实例（app id `pfe-sandy-test`）跑 5 轮真机迭代；编译落地 build/build.bat + sandy-config.xml；§4 清单机器可验证项全部有结论（详见 MEMORY §4）。
- 关键决定/发现：①**F9/设置页保存功能在 AIR 下必失败**——saveConfigFile 写只读的 applicationDirectory 必抛 SecurityError: fileWriteResource，togglePanel(false) 每次关面板都触发（既有潜伏 bug，待修）；②TextField.text 内部行分隔符是 
 不是 
（UI 文本断言前要归一化）；③invis/levitPoss 有钻地（inv1+lev0）等合法状态相，残留断言必须用时停瞬间基线对照而非绝对值；④random_mane 飞行怪（天角兽）飞远后会被游戏 disabled——拉怪后要等它回到可交战状态再进时停；⑤flexsdk air-config.xml 的 {airHome} 令牌因 SDK 迁移失效，须自建 config 写绝对 swc 路径（同 TDFC）。
- 遗留/下一步：用户手测动画观感（机器验不了"好不好看"）；敌桑行为面待开 esandy 后实测；F9 保存持久化修复；删旧回退副本（仍待）。

## 2026-08-27 治理整合 + 外置记忆迁移

- 回灌游戏目录侧 08-26 更新的 current-status 与交接文档（防止同步覆盖丢失）；修复 sync-to-game.bat（D 盘路径 + CRLF，实测通过）；AGENT_SCOPE 精简为薄壳（规则入 GOVERNANCE.md）。
- 外置记忆标准化：current-status.md + 交接文档.md 拆分为本文件 + state\MEMORY.md（原文在 git 历史）；changelog/lessons/recovery-guide/user-preferences 保留不动。
- 遗留：旧 `SandevistanMod\` 游戏目录回退副本待删（见 MEMORY §6）。

## 2026-08-26 交接刷新

- 游戏目录侧更新 current-status 与交接文档至 v1.135 之后状态（当日未提交源仓——08-27 已回灌补上）。

## 2026-08-20~21 v1.133–v1.135 回放忠实度收尾

- v1.133 回放死亡敌人开火根治（sost>=3 非 postDie 跳过 step）；
- v1.134 回放敌人动画僵硬根治（MC 小马类按帧快照 osn.gotoAndStop+body.f；Blit 怪保留 dx 喂入；尸体不快照）；
- v1.135 打开哔哔小马（TAB）时游戏不能暂停修复（stepEnemySandy 加 inGameplay() 门控）。

## 2026-08-18 v1.129–v1.132 敌人隐形攻坚战 + 回放动画帧级化

- v1.129 全敌人类型斯安维斯坦后隐形（v1.128 斑马 shine 修复=采样偏差，保留为兜底）→ 就地检测+自愈（esInvScan / spawnEnemyGhost 重挂 / teleDiag）；
- v1.130 回放玩家动画帧级忠实重演（录 bl/bf，回放 gotoAndStop；旧 v1.120 dx-feed 留作兼容）；
- v1.131 敌人斯安维斯坦生成三控件（master 开关/房间概率/房内比例）；
- v1.132 回放敌人动画防僵死（Blit 怪喂 dx+补 animate）+ 怪物隐身/不可抓根治（录像 iv/lv 逐帧强压）；
- 工程教训追加 decisions/lessons.md §v1.120-1.132（重算vs快照、位置钉住动画冻结、AI 分歧残余态、config 行内注释污染等）；共享知识新增 unit-zebra-shine / unit-zombie-burrow / monster-blit-animation / telekinesis-grab-rules。

## 2026-08-17 v1.127 技能迁出 + 交接

- 疾跑切枪 + 手雷击落迁出到 MoreSkills&Weapons（本模组侧停用；备份 state/migration-backup-v1.126/；回放系统不受影响）；交接文档刷新 v1.127。

## 更早期（v1.0–v1.126，约 2026-08-12~17）

- 完整逐版本史见 decisions/changelog.md：鬼影（v1.108-110）、爆炸动画原生速度（v1.113）、S 徽标（v1.121）、残影（v1.122）、输入法警告移除（v1.125）、敌人触发（v1.126）等主线；阶段复盘见 decisions/lessons.md（含 v1.50 多任务混改失败复盘 2026-08-13）。
