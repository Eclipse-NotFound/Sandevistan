---
domain: rendering
type: experiments
game-version: ["1.02"]
confidence: high
verified: true
discovered-by: Sandevistan
evidence:
  - kind: decompiled-game-code
    symbol: "fe.serv.Gov60.frame / fe.MainMenu.mainStep / fe.inter.Camera.calc, applyInterp"
  - kind: runtime-experiment
    summary: "原高帧宿主隔离副本，旧版失败基线、30/60/90/120/auto、切换与开火验证"
date-updated: 2026-09-23
---

# v1.144 高帧率适配

用户请求：适配游戏高帧率模式。唯一源码在 D:/RemainsMod，本轮不改其他模组。

## 游戏实际机制

当前根 pfe60.swf 为 1.02 高帧衍生版，原 SHA256 `FC19AF4A43438273A19D7CFBAC7A1CF584647CE94254F8D503A359C43E81091B`。app60.xml 指向它；调查开始时 pfe60.cfg 为 fps=60，发布时外部已改为90，本轮保留该变化。普通 application.xml 仍指向 pfe.swf。

MainMenu.mainStep 每显示帧调用一次 Gov60.frame()；返回 0 才执行菜单/世界逻辑，返回 1 仅调用 Camera.applyInterp(alpha)。Gov60 用 getTimer、累积余量与节拍锁定维持 30 Hz 逻辑，最多每显示帧一步，不是简单每 N 帧一步。配置支持 30/60/90/120/auto。disabled/N=1 时每帧一步。freeze/resume 同时管理原生 MovieClip 的播放。

旧版模组每个 ENTER_FRAME 都运行：在真实失败基线中，60 次录像推进对应只有 40 次宿主逻辑步；录制、回放、冷却、慢世界计数及相机目标六项失败。倍率越高或调度越不规则，不能只把 duration 乘 FPS/30 补救。

## 最终实现

- 可选 `fe.serv.SandyHighFpsClock` 桥接宿主包内的 k，只读当前调度结果。先探测宿主定义是否存在；普通宿主仍每帧走原路径。模组绝不额外调用 Gov60.frame，也不改舞台帧率或调度器。
- 主循环的计时、记录、攻速推进、回放、敌方时停、残影、淡出与弹药保护统一跟随宿主逻辑帧。额外显示帧交给原生插值和 MovieClip 管理。
- `SandyHighFpsView` 在模组手动步进后更新相机的玩家/悬浮武器端点，并立即应用当前 alpha。只动显示，不对物理位置或录像插值；转身、回放切段、换房和大位移重置端点，避免跨段拉线。相机 calc 不重复执行。
- Gov60Stubs.swc 由 build.bat 从 build/stubs-high-fps 生成到 build/out，仅 external 链接。正式类清单只有 SandevistanMod、SandyBlitReplay、SandyDamagePredictor、SandyHighFpsView、fe.serv.SandyHighFpsClock，没有 Gov60/游戏存根。
- 16 项统一菜单和已有配置保留，未加回 F9 设置窗。按 30 次逻辑步换算原有配置，无需修改玩家数值。

## 验证

具体回执在 high-fps-20260923/。专项在实际 AIR 高帧宿主中运行，注入前后观察器调用真实模组主循环，断言每个宿主逻辑/显示帧的变化；不是另写一套计时模型。

| 场景 | 结果 | 实际覆盖 |
|---|---|---|
| v1.143 高帧基线 | 11 项中 6 失败 | raw=132、logic=80、skipped=52 |
| 普通 pfe 30 帧 | 8/8 | 没有 Gov60 仍能启动并完整结束 |
| 高帧 60 | 11/11 | 132 逻辑步 / 250 显示帧 |
| 高帧 120 | 11/11 | 132 / 380 |
| 自动帧率 | 11/11 | 132 / 286 |
| 运行中 30/120/关闭/恢复 | 12/12 | 四次切换，132 / 234 |
| 120 帧真实移动与开火 | 15/15 | 60 移动步、5 发手枪、995 发余弹，额外显示帧物理不动，武器/玩家插值通过 |
| 90 帧真实移动与开火 | 15/15 | 同上，原生世界暂停/无敌恢复、回放后弹药保留 |
| 正式 SWF + ModSettings，高帧120 | 21/0/0 | 玩家动画、完整时停回放、Pip 暂停、菜单打开/保存重读/F9放行、音乐断点/淡出 |

正式构建按发布参数编译；专项注入包与正式文件严格区分。初次正式验证是 SHA `AB6693E1...`，最后重建版本的正式字节复验另记。计时受本机负载/日志与场景影响，60 逻辑步录像约 2.15–2.58 秒，不能当作“稳定达到120fps”的性能声明。采样给出真实额外显示帧数量，避免低帧场景假阳性。

## 夹具失败及边界

- 第一个调度读取试验用 QName("fe.serv","k") 报 #1069；同包编译桥接 + external 存根有效。未把“动态公有字段访问”当成可访问 internal。
- 首轮测试误关 cfgDiagLog，导致运行后没有 SUMMARY；属于观察器问题。补回日志后获取有效失败基线。先前测试曾临时关闭加载期 Gov60，但最终各有效场景保留原生启动调度。
- 半自动手枪持续按住只开一枪；改成 12 个逻辑步一次扳机脉冲，真实记录五次。出生区剧情会改 ggControl，旧代码 savedGgCtrl 也不是恢复承诺；该场景不声称验证剧情控制恢复，单独核对世界暂停/无敌恢复并保留控制状态日志。
- 第一次全清单验证读取仍运行中的 stdout 遇文件共享锁，21 个行为项已通过；后改为加载器正式的 ModLoader.sol 回执验证请求/成功项。
- 玩家动画来自完整流程，马形敌人精灵图 helper 本轮未改；上一版574帧证据不是本轮重新测得。死亡预测53项也是上一版证据，本轮没改模型。
- 未全面验证DLC 1.03/1.04、所有武器/爆炸、敌方时停、联机与七模组混战；本轮只保证已测1.02高帧入口的本模组及菜单组合。

## 高帧入口候选与发布边界

原 pfe60 MainFE 无模组加载器。`build/tests/prepare-high-fps-host.ps1` 在 build/out 生成候选，仅为 MainFE 接入现有清单加载器，并限 Sandevistan + ModSettings 两项；不自动开启其他尚未适配的玩法模组。

候选 `pfe60-with-loader.swf` 为 15,099,039 字节，SHA `D88D19A11B7100491A8EDD6153499AB92D59545C1576693368762C9C0AB7E97B`。5039 个 SWF 标签数与顺序相同，仅 index332 的 DoABC 数据块变化（5,629,791→5,639,773字节）；导出回读 Gov60、MainMenu、Camera 与原文件逐字节一致。用户已明确批准接入并部署；普通入口与默认启动描述符不随本任务切换。首次部署复验发现旧观察器误判，按门禁回滚后完成下述定位。

回滚：发布前保留 v1.143 SWF；若批准高帧加载器，额外保留原 pfe60.swf，并在替换前重新核对原 SHA。玩家 config、pfe60.cfg 和真实存档不改。
首次待部署构建：51,085字节，SHA256 0642842AD78FF55599AD88371F5CBD34E9DED1F5F1CB6A2F0615BC1B38DBED29。20260923192018325在最终限定加载器、正式七项清单副本下21 PASS/0 FAIL/0 SKIP；ModLoader.sol确认仅请求并成功初始化两项。用户随后明确同意接入并部署pfe60加载器。

## 部署复验触发的旧观察器误报

20260923192858343 使用已部署的 60 FPS 宿主及正式 0642842A… 字节，20 PASS / 1 FAIL：`dead-enemy-atk-frozen` 报 new/moved=3、snapSize=3。按门禁先恢复 v1.143 与原 pfe60，再调查；失败原始日志见 deployed-60-failed.txt。

日志 rStart 显示 3 个 PhisBullet 都有 rec=1。生产 replayObjects 按录像更新旧弹体坐标；stepUnrecordedAtk 同样允许已发射弹体继续飞行。v1.133 的真实规则是禁止尸体重跑 AI 后新开火（postDie 例外），并不是射手死亡后所有旧投射物静止。旧观察器把“类名+位置”当身份，既把移动当新生，也会误报刚死亡单位和原生 postDie 例外。

新增 `run-high-fps.ps1 -AttackObserver`：隔离新档中创建真实 UnitRaider、PhisBullet，调用正式 recordReplayObjects/replayObjects 录放两帧，并直接验证内置采样器。旧版稳定 7 项中 4 项失败（20260923193651366）；修正后 7/7（20260923193832409）。覆盖录制弹体移动、未录制旧弹体移动、新死亡前已发射弹体、postDie 例外；故意生成“已死亡射手的新弹体”两项负向检查均能报警。此专项验证观察器判别，不声称覆盖所有尸体 AI 行为。

内置检查改为每个逻辑步按对象引用登记攻击体、记录已观察到的死亡射手，对其新增攻击报警；无死亡样本明确 SKIP。测试从未尝试冻结已有弹体，也未改变正式战斗机制。最后一次源码变更仅涉及隔离自动测试路径，高帧调度、插值、伤害与动画路径均未变。

修正后正式候选：51,243 字节，SHA256 `2C26EADCFE760EC3BD998DDBEDF0FAD333151E203B0688AF268BDF0612BA0263`。后续正式字节/部署复验见发布回执。
## 最终发布回执

修正后的正式字节：普通30帧（20260923194052453）与高帧60（20260923193909399）各21 PASS / 0 FAIL / 0 SKIP。源码/证据/产物提交 eaa5956 后重新定向部署；实际安装文件的90帧隔离重启（20260923194628482）再次21 PASS / 0 FAIL / 0 SKIP，死亡后新增攻击采样 new=0、deadOwners=1；ModLoader.sol确认七项清单只请求并成功加载Sandevistan、ModSettings两项。测试复制件与源release、游戏release同为最终2C26EADC…字节。

当前部署为v1.144，pfe60为D88D19A1…；原始宿主备份pfe60_before_sandevistan_v1144_20260923.swf、旧模组备份release/SandevistanMod.before-v1.144-20260923.swf均保留并校验。普通pfe、两份启动描述符、清单和玩家配置未改，真实存档未写、用户进程未动。配置文件在19:32:27由本轮部署以外的操作改为fps=90，发现后保留并按90帧复验。测试结果和完整哈希见high-fps-20260923/deployment-receipt.txt。

首次失败和回滚记录保留；不得把此前snapSize=0的旧检查当成已验证尸体弹体冻结，也不应为迎合错误检查而禁止生前弹体飞行。重新部署中的空备份路径调用失败在替换前发生，已核验恢复；最终使用明确的额外备份路径完成原子替换，原始备份未覆盖。