# 版本历史与变更记录

> 提取自原交接文档 §5。**规则**：新版本行插在旧行**之前**（不要整行替换，易覆盖丢行）。
> 每次改动同步更新 `state/current-status.md` 与 `release/说明.txt`。

| 版本 | 内容 |
|---|---|
| v1.142 | **时停死亡预判校准**：修复离场子弹、延迟接触和连续挥击漏记；独立伤害模型对齐物理/能量护甲、先行破甲、护盾、暴击/特攻和命中短路，去除二次耐久折扣与固定九折；分支期望处理随机护甲，独立累计预计耐久。无敌/全闪避/无接触与踢击重复伤害保护；53 项真实类专项通过，旧版对应 52 项中 47 项失败，动画 574 帧回归及正式构建流程通过。 |
| v1.141 | **修复掠夺者/尸鬼等贴图单位回放动画僵死**：记录实际身体在精灵图中的帧坐标，回放在 AI/动画驱动后恢复，避免重复位置帧被判定为站立。新增真实游戏像素回归：两类敌人、五档速度与 AI 模式，574/574 帧一致；保留尸体保护及原攻击/弹药逻辑。 |
| v1.140 | 独立 ModSettingsCarrier 设置注册，移除对 MSW 设置宿主的依赖；16 项、保存、F9 保留，旧选项浮层在独立面板打开时让位。七模组与无 MSW 组合、重启持久化、正式字节启动验证通过。 |
| v1.139 | **时停主题曲（断点续播）**（用户需求+四项拍板）：`startSandy` 后播放 release/sandy_theme.mp3（10MB MP3 不入 git，gitignore+仓库侧存放供 /MIR 同步；部署名固定规避原文件名空格/分号的 URL 边角；init 预加载，缺失/加载失败全程静默降级），回放结束线性淡出。**断点续播**：淡出结束时记录 channel.position 为断点，再次时停从断点起播（自然播完整首归零；会话内有效，重启归零）；还在放（含淡出中）取消淡出恢复音量继续。实现：flash.media.Sound/SoundChannel + 独立 SoundTransform（不受游戏音量影响），状态沿检测（时停开始沿 play、回放结束沿 fade）挂在 onFrameInner 不入侵热函数；孤儿兜底（无时停无回放但在放 60 帧 → 补淡出，防 endReplay 未达的错误路径）。配置 musicon=1/musicvol=70/musicfade=90 三键进 config/F9 面板（10→13 项，导航 %13）/设置页（13 项）/MSW 模组页（16 项）；F9 音乐开关关=立即停（断点保留）。真机 round 12：SUMMARY pass=22 fail=0 skip=0，断点续播实测 start@0 → 淡出@21501 → 停止断点@26493 → 二周目 start@26493(resume) |
| v1.138 | **MSW 设置中枢接入打通（父域对象会合点）**：按 MSW 侧 7d9a6ef 落地的方案切换注册通道——MSW 把 hub 发布到 main 下动态载体 MSWModAPICarrier 的 modAPI 属性（对象引用跨域可用，受域限制的只是类定义）；stepHubRegister 改为载体优先（getChildByName("MSWModAPICarrier") → modAPI.registerPage），原 getDefinition 查找降为备用通道（覆盖将来 loader 合并域的情形）。真机验证：tries=1 首次尝试即命中；端到端断言 hub-page-listed 从宿主登记簿 getPages() 反查到 sandevistan 页（13 项）——SUMMARY pass=18 fail=0 skip=0。重启游戏后哔哔小马"模组"页可见"斯安维斯坦"页签 |
| v1.137 | **F9 保存持久化修复 + MSW 设置中枢接入（就绪待宿主）**：①**修复"F9/设置页调参重启即丢"潜伏 bug**——saveConfigFile 写 File.applicationDirectory 在 AIR 只读沙箱下必抛 SecurityError: fileWriteResource（togglePanel(false) 每次关面板都触发），现双写：应用目录（保留尝试）+ 应用存储 SandevistanMod_config.txt（必定成功）；loadConfig 抽出 parseConfigLines 双层读入（应用目录模板 → 应用存储覆盖，菜单调过的值优先）；②**MSW 设置中枢（哔哔小马"模组"页）接入**：按其注册契约实现 hubBuildItems（13 项 get/set 回调，范围步进照抄 F9/设置页既有口径；check 即时 saveCfgQuiet、slider 收页 flush）、ENTER_FRAME 重试注册（≤36000 帧、每 10 帧节流）——**当前注册被 loader 子域拓扑阻断**（模组各自独立子域，跨模组类名查找必然 #1065，详见 shared-knowledge mod-loader-cross-domain-anomaly.md 2026-09-05 增补），MSW 侧修复可达性后自动接上，无需本侧再改；③自动测试强化：pip 守卫（MSWAutoTest 在测试实例自激活会开 pip，各阶段循环前清场）、恢复期治疗 30 帧/次、时停中 30 帧/次治疗、全体敌人预压 30% 血造击杀窗口；hub-registered 断言 SKIP 语义（外部依赖不误报）；本轮 10 轮真机迭代，SUMMARY pass=16 fail=0 skip=1 |
| v1.136 | **敌人斯安维斯坦默认关 + 内置自动测试**：①`esandyenabled` 默认值 1→0（用户要求：暂不测敌桑表现；config/F9/设置页仍可手动开；仓库 config.txt 模板同步更新）②`stepDebugTest` 重写为全流程自动验证驱动：**app id 双重门控**（config debugtest=1 且 NativeApplication.applicationID≠"pfe" 才激活——用户实例即使 config 残留也不会被自动驱动；测试实例存档/日志随 app id 天然隔离），状态机=开机等 landData→newGame(-1)→gotoLand(random_mane)→拉怪（合成 ctr 键位输入）→满血+基线快照（esVisState 逐单位）+最弱敌人打到 1hp 造击杀→startSandy→自然结束进回放→**断言体系 [TEST-ASSERT] name=PASS/FAIL**：esandy 默认关/迁移键停用/时停自然结束≠未启动/回放玩家动画帧驱动（animFrameOf 采样去重≥2）/死亡敌人攻击体冻结（位置快照比对）/隐身与念力抓取残留（**基线对照**——invis/levitPoss 有钻地等合法状态相，绝对值断言必误报，只对时停瞬间→回放后的状态"变化"报警）/pip 开→allStat=2+inGameplay=false→关恢复/设置页 10 项+F9 面板敌桑默认"关"（**TextField.text 内部行分隔符是 
 不是 
**——断言前必须归一化）→[TEST] SUMMARY 汇总；③编译路线落地 `build/build.bat`+`sandy-config.xml`（flexsdk 自带 air-config.xml 的 {airHome} 令牌因 SDK 迁移失效，显式写 playerglobal/airglobal 绝对路径，同 TDFC 范本；Java 用 Animate 2024 自带 JRE）|
| v1.135 | **打开哔哔小马（TAB）时游戏不能暂停修复**（用户实测）：本体 pip 开启 → `World.allStat=2`（World.as:1384）暂停世界（World.as:1256 `allStat==1 && !onPause` 才步进），但模组的 `stepEnemySandy` 每显示帧照跑——激活中的斯安维斯坦敌人继续 5× 补步+状态机+徽标移动=世界看似没暂停。修复：常规分支调用加 `inGameplay()` 门控（allStat>=1 / 非 pip/sats/stand/guiPause / 非 onConsol）——pip/对话/菜单打开时敌人斯安维斯坦整体冻结（计时也冻结，关闭后从原处继续），世界真正暂停 |
| v1.134 | **回放敌人动画僵硬根治（MC 小马类按帧快照）**（用户实测"回放期间敌人动画又出现僵硬"）：v1.132 的 dx 喂入只覆盖移动档（run/trot/walk），**站桩攻击/瞄准/翻滚等非移动姿态被强行按 dx 量化为 stay=僵硬**。修复：录像每帧追加敌人 `an`（animState）+`bl`（osn 标签，osnLabelOf）；回放敌对块按敌人类型分流——①**MC 小马类**（录到 osn 标签/身体帧）→ 与玩家回放(v1.130)同款**按帧快照** `osn.gotoAndStop(bl)+body.gotoAndStop(f)`，攻击/瞄准/翻滚任意中间姿态逐帧还原，不受 AI 分歧影响；②**Blit 怪**（无 osn.body，f<0）→ 保留 dx 喂入+补 animate()（贴图怪内部 anims/BlitAnim 不可读，只能按移动档重现）；③**尸体**（sost>=3 非 postDie）→ 不快照不喂入，保持游戏最后一步的死亡定格（v1.133 起尸体不 step；若录像死亡帧早于回放死亡，快照会把尸体打回存活姿态=穿帮，故排除）。位置/可见/可抓恢复照常 |
| v1.133 | **回放中死亡敌人开火根治**（用户实测"回放期间一些死亡的敌人也会开火"）：反编译确认 `Unit.step` 对尸体不门控——仅 `disabled||trigDis` 早退，sost==3/4 尸体照跑 `control()/actions()`（攻击路径又不受 sost 约束）→ 回放敌对重演块（重跑 AI）把尸体也 step 了="尸体开火"。修复：回放敌对块 step 前判 `sost>=3 且 !postDie` 则跳过 step（postDie 是本体"死后仍行动"设定，Unit.as:414 public，保留）；重钉/可见性/可抓性恢复（v1.132 块）照常执行，尸体保持定格死亡帧、不再开火 |
| v1.132 | **①回放敌人动画"偶发僵死"根治（尸鬼/辐射蝎等 Blit 怪）**：敌人回放动画靠回放中重跑 AI 驱动（v1.71 enemyAct=2 完整 step）——位置逐帧重钉使 AI 常判"已到目标范围"→控制层 dx≈0 → animate() 只走 stay（Blit 怪没有 MC 身体帧可记录，框架已注释-1）+ `anims[state].st` 非循环态 → 原地定住=僵死。修复：回放步后**按记录位移折算 dx/dy 补喂并补调一次 animate()**——视觉按真实移动档位（run/trot/walk）重现 ②**怪物"偶发隐身"根治（肉食灵/辐射蝎等）**：反编译确认僵尸 burrow（aiState=5 → `vis.visible=false`+`invis=true`+`levitPoss=false`+`fixed=true`）；回放 AI 分歧会把怪物推入 burrow（回放期间玩家被钉住/敌人远离判定）→ 回放结束怪物残留隐身/不可念力抓取。修复：录像每帧新增 `iv`（invis）/`lv`（levitPoss），回放逐帧按记录强压 `vis.visible / invis / levitPoss`（在步后复压，防 step 内 animate 覆盖） |
| v1.131 | **敌人斯安维斯坦生成三控件**（用户要求"设置中加入控件"）：①总开关 `esandyenabled`（1/0，默认 1）——0=任何房间不生成斯安维斯坦敌人；②房间概率 `esandyroomprob`（0-100，默认 100）——换房间（loc 变化）时掷一次，未掷中则该房间整房不生成（esRoomAllow 标志，diaglog 下 roomChange 行带 allow/prob）；③房内装备占比 `esandyper`（0-100，默认 50，v1.119 已有，现面板可调）。**两处设置 UI 各加 3 项**：F9 参数面板 7→10（敌人斯安维斯坦开/关、敌人房间概率%±10、房内装备占比%±5）+ 游戏设置页（optPanel）7→10 同款。config 解析/保存新增 esandyenabled/esandyroomprob（启动日志追加 esen/esprob）；stepEnemySandy/stepEnemySandyB 顶部守卫（总开关/房间允许） |
| v1.130 | **回放玩家动画帧级忠实重演**（用户："回放期间玩家动画普遍有问题，尤其起始/结束姿势不一致时"）。根治：不再靠 dx 量化+状态机重算 animate()（v1.73/v1.120 方案本质是"重放动作分类再重算动画"，姿态连续性依赖状态机从干净起点走起——时停跨越半个动作（跳到一半/滚到一半/起立中途）时回放从该动作开头或错误分支开始=错乱）。改为**直接快照重演**：history 每帧追加 `bl`（vis.osn.currentFrameLabel）+`bf`（vis.osn.body.currentFrame）；回放中 `gg.step()`（清键只会放 stay 纸偶）之后直接 `osn.gotoAndStop(bl)+body.gotoAndStop(bf)+animState=an`——逐帧复现玩家当时姿势（跑/跳/翻滚/趴下/起身/挥击任意组合与中间帧），起始帧=时停起始帧、结束帧=时停结束帧。旧录像无 bf 时回落 v1.120 状态机喂入（保留原路径作兜底）。叠光/攻击动画由独立 weapon 视觉重演不受影响 |
| v1.129 | **用户澄清：所有敌人类型斯安维斯坦后都隐形（非只斑马）+ 无法念力抓敌人**。v1.128 斑马 shine 修复是采样偏差（日志恰逢斑马战），保留但改为兜底。通用排查+自愈：①**esInvScan**（每帧对每个注册敌人，就地检测并修复）：vis.visible=false→置 true 记录；alpha<0.25→记录；parent 链未达 stage（脱链）→按游戏 addVisual 方式重挂回 `grafon.visObjs[oE.sloy]` 并记录 ②**spawnEnemyGhost 兜底**：摘挂后若 `visE.parent==null`（重挂失败），立即放回敌人所在图层——从根上防孤儿 ③**esVisState 扩展**：追加 levitPoss/chain/massa ④**念力抓取诊断 teleDiag**：按 E/交互键时采样 `loc.celObj`（仅敌人）levitPoss/onCursor/massa/celDist/maxTeleMassa——一次复现确认抓取卡在哪环（很可能是隐形敌人 onCursor 不成立） |
| v1.128 | **敌人斯安维斯坦结束后隐身（斑马 shine 版，v1.129 修订为通用排查）**：根因（斑马）=`UnitZebra` 每次 step() 扣 1 点 shine（UnitZebra.as:74，shine 是 internal）——场景 A 补 4 次额外 step → shine 按 5 倍速暴跌，`vis.alpha→0` 且 `invis=true`。修复：isShoot 是 **public**（Unit.as:346，仅 UnitZebra 消费）——置 true 后下一次 animate() 走 `isShoot→shine=currentWeapon.shine` 回充（weapon.shine 默认 500）→ 立即回亮，无副作用。新增 esShineGuard（仅斑马家族+invis/alpha<0.5），接入场景 A/B。附带诊断（esTick OFF/冷却前三帧 esVisState；spawnEnemyGhost 摘挂校验 esGhost-orphan） |
| v1.127 | **两技能迁出到 mods/MoreSkills&Weapons（Sandevistan 侧停用）**：`疾跑中切枪`（swaprun）与`手雷击落`（projhits）实际运行实现迁移到 MoreSkills&Weapons（新文件 MSWSwaprun.as / MSWProjHits.as，SharedObject 配置，面板第 7-10 行）。Sandevistan 侧：①cfgProjHits/cfgSwapRun 默认改 false；②config 解析分支（projhits/projhp/projarmor/projhp_<id>/projarmor_<id>/swaprun）、设置面板（PipPageOpt）两行、saveConfigFile 回写全部移除（已有 config 无法再开启）；③**适配**：stepProjHits 的回放重演分支抽成 replayProjBoom() 脱离 cfgProjHits 门控——斯安维斯坦回放系统对"时停中自然爆炸"的重演不受影响；④启动日志/版本标记更新；⑤源码完整备份于 `state/migration-backup-v1.126/`。**共存约定**：MSW 侧 MSWU.inGameplay() 含 onPause 判定，斯安维斯坦时停/回放期间两技能不介入（行为差异：时停期间疾跑切枪不再生效，换取回放系统共存） |
| v1.126 | **敌人斯安维斯坦触发修复（用户实测两 bug）**：①**玩家持续在敌人视野内时，敌人冷却结束不会再次开启**——根因：触发条件要求 `celUnit==gg` **上升沿**（`!recE.sawCel`），sawCel 记录后恒 true，冷却结束（st 2→0）后条件永不满足。修复：去掉上升沿要求，改为"celUnit==gg 且待机（不在冷却）"即触发——战斗中持续存在=每次冷却结束自动重新开启（dur/cd 循环）；已处于战斗中的敌人（注册时已锁定玩家）也能首次触发 ②**玩家开着时停进入敌人视野，敌人进入战斗但不开启**——根因：触发检测只在常规分支 stepEnemySandy 里跑（sandyActive 时被跳过），玩家时停走 stepEnemySandyB 只处理已激活（st==1）敌人，没有触发检测；敌人 AI 在节流帧（loc.step 1/N 速）更新 celUnit 进入战斗但无人响应。修复：stepEnemySandyB 补上同条件触发检测 + 全部状态推进（esTick 覆盖 st==0/1/2，冷却在玩家时停中同样按显示帧倒计时，结束即可重触发）+ 徽标全状态更新；新增诊断 `esandy: ... ON(during player sandy)` |
| v1.125 | ①**移除输入法警告 UI**（用户要求）：imeWarnT 显示块、红色分支、触发赋值全部删除（229/UP无DOWN 检测保留为 diaglog=1 的纯诊断日志）②**顶部状态 UI 加开关**：`showhud` config 键（默认 1=显示）——"⚡ 斯安维斯坦"/"⟲ 回放中…"/"充能中"全部受控，关闭即隐藏；F9 面板新增第 7 项"顶部状态UI"左右切换（6→7 项，panelKey/panelAdj/renderPanel 同步） |
| v1.124 | **①"没有敌人存在过的房间也有 S"=跨房间泄漏**：World 单例 grafon.visual——旧房间的徽标 TextField 挂在共享层上，换房间后旧坐标直接漏进新房间显示（v1.123 排除尸体只解决同一房间的残留）。修复：stepEnemySandy 检测 loc 变化（loc=每房间一个，Land.newLoc 实证）→ 清空 esEnemies/esMarks/esRoomCnt 并重开房间级诊断 ②**掠夺者无 S 的两处嫌疑一并消除**：(a) esRoomCnt 按 room.id 计数且从不跨房间清理——房间 id 跨章节复用/残留计数会吃掉新房间名额→换房间即清零；(b) 注册/预扫描的 `currentWeapon != null` 条件——武器加载失败/无武器的掠夺者被静默排除（白名单本身就是敌对人类，该条件纯属多余）→ 移除，仅凭类名白名单+sost 存活检查 ③诊断升级：esmark 创建事件按敌人逐个记录（esCreateDiag，覆盖整局而非只前 10 帧——旧 esMarkDiag 上限使首房间之后全盲区）+ roomChange 日志 |
| v1.123 | ①**S 徽标出现在"没有敌人处"的根因=尸体**：Land.newLoc 实证每个 Room 建一个 Location（loc=当前房间，扫描本来就不跨房间）；esmark 日志实证标记都在真实 UnitMerc 上——用户疑"随机算法选中非敌人实体"，实为**尸体（sost>=3）仍被当作候选/注册/保留徽标**：名额被尸体占掉=活敌无标记、S 飘在尸体上方（"明显没有敌人的地方"）。修复：预扫描/注册/清理三处排除 sost>=3，死亡即摘标释放名额 ②**回放翻滚诊断**（用户实测仍不重现）：时停记录侧每帧统计 isSit/animState=="roll" 帧数（endSandy 打 rollRec: tot/sit/roll——sit=0=记录侧问题，roll>0=驱动侧问题）+ 回放驱动侧 rRoll 日志（喂入 siR/anR/pCat/stay/storona/walkSpeed 与 animate() 后实际 animState，≤25 条）——下一轮实测日志直接定位 |
| v1.122 | **敌人残影"几乎没有"真根因**：ghostLayer 只在玩家开时停（startSandy）时创建——只触发敌人斯安维斯坦（玩家没开过时停）时 ghostLayer==null → spawnEnemyGhost 的 addChild 空指针被吞=残影全部静默失败（"偶尔可见"=会话早先开过时停残留了层）。修复：①spawnEnemyGhost 懒初始化/重挂 ghostLayer（挂 world.visual、插敌人 vis 所在层下方——残影被本体遮挡，与玩家残影同款插层法；每次生成前校验 parent==visual 防换场景/重建后失效）②敌人残影专用寿命 esandyghostlife（默认 12 显示帧线性淡出；原复用 cfgReplayGhostLife=4 帧太短）③静止不生成阈值（位移<2px 跳过，防同位置叠残影）④速度映射改用本显示帧真实位移（场景 A 补步已含 N×，原 ×spd 恒满速全绿、渐变从不体现）⑤config 新增 esandyghostlife |
| v1.121 | **S 徽标三轮修复的真正根因（配置解析）**：日志实证（esandy ON/OFF 有、esmark 诊断 0 条）→ updateESMark 首行 `if (!cfgESMark) return` 恒提前返回=cfgESMark 恒 false。根因：loadConfig **不剥离行尾注释**，config.txt 布尔键带行内注释（`esandymark=1  # 调试...`）→ 值解析成 `1  # ...` → 布尔精确匹配 `=="1"` 失败（parseInt 键靠数字前缀侥幸存活——esandydur 等正常；同病 esandyghost=1 行内注释=敌人残影其实也一直未开启）。修复：①loadConfig 对**所有键**剥离 `#` 起行尾注释（v1.121 起配置行尾注释兼容）②两份 config.txt 的 esandy 段注释改独立行③启动日志追加 esmark/esghost/esper 开关状态（排查此类问题第一手数据） |
| v1.120 | **回放重现翻滚/趴下/起身动画**：回放玩家动画驱动（v1.73）只按历史位移量化 dx 喂 animate()——只能走 走/跑/小跑 分支；翻滚（roll）是 `isSit` 移动分支的动画（UnitPlayer.animate：isSit 且 maxSpeed>walkSpeed×1.6 且 dx×storona>0 且 runForever → "roll"，否则 "polz"），回放中 isSit 从未被喂 → 时停中翻滚趴下并快速起身在回放里不出现（用户实测）。修复：时停 history 每帧记录 si（isSit）+an（animState）；回放驱动按录像喂同样的状态机输入（isSit=true + dx/maxSpeed/runForever 分档：roll 大dx+超阈maxSpeed+runForever；polz 小dx低maxSpeed；静止 dx=0 → down 姿态）——游戏自身 animate() 走出 roll→polz→down→up 的真实过渡（起身 up 由 isSit true→false 的待机分支自动触发）；an=="roll" 兜底贴墙翻滚（位移小但动画在滚） |
| v1.119 | ①**S 徽标改挂 grafon.visual 顶层专用容器**：v1.118 每帧重挂仍不可见（用户实测）——drawAllObjs 每帧把 visObjs 图层 Sprite 整个换新，且其它模组（RealisticVision）在我们之后还会再重建图层（重挂又被摘掉）。visual 是全部图层的父容器、drawAllObjs 只替换子层对象不清 visual 本身——挂这里任何重建都碰不到，永远渲染在最上层（世界坐标不变）。新增 esmark 诊断（前 10 条：挂载链/onStage/x/y/visible，diaglog=1 时）②**每房间装备名额：1 → esandyper%（默认 50=一半）**：stepEnemySandy 预扫描房间候选数算配额（quota=round(候选×per%)，候选>0 时至少 1）；esRoomTaken 单槽改 esRoomCnt 计数（登记+1、死亡-1）；config 新增 esandyper（0=关闭 100=全部），F9 保存回写 |
| v1.118 | **S 徽标显示修复（真根因）**：游戏 `Grafon.drawAllObjs`（Grafon.as:703）每帧把 visObjs 各层**换成全新 Sprite** 再 addVisual 重挂（hpbar 靠此存活）——徽标挂在旧 Sprite 上时 parent≠null，v1.116 的 parent==null 重挂判断永不触发 → 徽标永久脱离显示树（用户实测：狮鹫房敌人明显加速但头顶无 S）。修复：updateESMark 每帧校验 `t.parent != 当前 visObjs[3]`（含旧层/被摘除两种情况）→ 摘掉重挂，与 Unit.hpbar 同款每帧重挂模式 |
| v1.117 | ①**敌人斯安维斯坦注册修复**：esClasses 存裸类名 vs getQualifiedClassName 返回 `fe.unit::UnitRaider` 全名——索引比较永远不匹配（v1.115/116 无敌人注册=S 徽标不出现的根因）；loadConfig 统一构造全名存储 ②白名单加 **UnitZebra（斑马）**（逻辑与其它一致）③**常规玩法击落诊断**：projScan（每 60 帧：projs/objs 表计数+前 3 个投掷物类名/坐标）与 projHit（命中时：类名/子弹类名/伤害/坐标）——定位"敌人手雷/导弹无法击落"（游戏 Bullet/PhisBullet/SmartBullet 类经反编译比对 0 差异，非游戏侧变更） |
| v1.116 | **S 徽标图层重建兼容**：其它模组（RealisticVision 每帧 setLight→drawAllObjs）重建 visObjs 层会把徽标摘出显示树——updateESMark 改为 parent==null 时重挂（v1.115 徽标创建后永不重挂，多模组环境下会消失） |
| v1.115 | **敌人斯安维斯坦（Enemy Sandevistan）**：①配置 `enemysandy`（类名白名单，默认 UnitRaider/UnitMerc(狮鹫)/UnitAlicorn/UnitEncl/UnitRanger）+ esandydur=150/esandycd=300/esandyspd=5/esandyghost/esandymark ②触发=敌人 AI 锁定玩家（`celUnit==world.gg` 上升沿——aiState 是 internal 读不到，celUnit 是 public 战斗信号）后立即开启 ③**每房间最多 1 个**（esRoomTaken 按 loc.room.id，死亡释放名额）④场景 A（玩家未开）：常规分支在游戏步进后给活跃敌人补 spd-1 次 step() → AI/移动/攻击 N×，敌人子弹 1×（世界步进）；残影 spawnEnemyGhost（边缘行者配色，画敌人 vis 的独立管线——spawnGhostAt 画的是玩家 vis）⑤场景 B（玩家同时开）：stepSandy 内活跃敌人与玩家同权每帧 step（stepEnemySandyB；节流帧 loc.step 的重复步=与玩家"自由物理步"同款 1.2× 现象，接受）⑥调试"S"徽标（visObjs[3] TextField，绿待机/黄激活/灰冷却；不设 hero、不碰 goldstar）⑦诊断 esandy ON/OFF |
| v1.114 | **投掷物血量/护甲按武器 id 覆盖**：可击落爆炸物=血量机制（默认 30，伤害先减护甲，血量≤0 才引爆）——新增 config `projhp_<武器id>`/`projarmor_<武器id>`（读配置动态收集进 projHpOver/projArmorOver，判定时按 p.weap.id 取覆盖值，无覆盖沿用全局；键小写匹配武器 id）；saveConfigFile 回写覆盖项（防 F9 面板保存丢用户自定义）；config.txt 附注释示例 |
| v1.113 | **爆炸动画按原生速度播完**：移除 v1.104 的回放粒子寿命钳制（liv>20 压到 20）——钳制把长寿命爆炸粒子压缩播放：野火核弹 balefire 60 帧压成 20 帧=3 倍速（用户实测"播放速度有些快，野火核弹尤为明显"；baleblast 30→20=1.5 倍）。v1.111/1.112 已让未播完爆炸在回放后自然续播，钳制失去意义——回放中按原生 liv 以 1 世界步/显示帧播放，剩余部分回放后由世界恢复步进自然播完（原生速度/原生时长） |
| v1.112 | **回放结束爆炸动画自然播完（修正版）**：v1.111 的 sweepOrphanPartVis 扫除不分死活——类名命中即摘，把回放末段**活粒子**的 vis 也摘了（日志实证：partsAlive n=17 且 boom 在 replIdx=210、partsResumeE vis=6——活粒子丢 vis 后无声死亡=动画在回放结束瞬间消失）。修复：扫除前先遍历 firstObj 链收集活粒子的 vis 集合（liveVis），仅摘除不在集合中的孤儿 vis |
| v1.111 | **回放结束爆炸动画自然播完**：endReplay 不再瞬间清空粒子（killPartsDeep→resumePartsAtEnd）——用户实测"未播完的爆炸动画回放结束后直接被清除"。现在回放结束后世界恢复步进，粒子按剩余 liv（回放中已钳 ≤20）自然播放至死亡；MC 型粒子恢复 play()（回放中 mcStepParts 曾 stop+手动推帧，不恢复会冻在末帧）；孤儿 vis 扫除（sweepOrphanPartVis，从 killPartsDeep 抽出）保留。v1.106 的"火光长留"不会重现：当时 balefire liv 60 未钳制，现钳 ≤20 → 尾焰 ≤0.7 秒。诊断 partsResumeE: resumed=N vis=M |
| v1.110 | **鬼影真根因修复**：①`slowPartClass` 从未赋值（声明=null 后无初始化）——recordReplayObjects 的"粒子跳过"分支（oR is slowPartClass）恒 false → 时停中移动/首见的粒子被误录像进 replayObjs（v1.109 日志实证：reatt 行 cls=fe.graph::Part ×4，其一钉在爆炸点 1268.33,243.58）→ 回放中 v1.87 的 vis 重挂把**已死粒子**（endSandy killPartsDeep 已摘除 vis）的 vis 重新 addChild 回显示层、按录像末帧钉在死亡位置=鬼影（R50-R150 全程可见；boom 的 explDestroy→drawAllObjs 重建图层才抹掉=用户"爆炸后消失"）。修复：init 里初始化 slowPartClass + reatt 条件排除 Part 对象（双保险）②启动标记版本号显示不全（TextField 默认宽度截断）——加 autoSize；F9 面板标题带版本号 |
| v1.109 | **模组迁入 mods/ 目录（镜像部署，方案 B）**：①补丁 MainFE 加载路径 `app:/SandevistanMod/SandevistanMod.swf` → `app:/mods/Sandevistan/release/SandevistanMod.swf`（重打 pfe.swf/DLC/pfe.swf/DLC/pfeUI.swf，1.03/1.04 用 v2 原版，三版输出仅 +10 字节）；②模组 config/modlog 路径改为 `mods/Sandevistan/release/...`（loadConfig/saveConfigFile/modlog 三处）；③安装/卸载.bat GAMEDIR 改 `%MODDIR%..\..\..`，卸载优先还原 v2 原版（旧脚本会还原旧版，修复）；④仓库留守 C:\RemainsMod，游戏目录放镜像（sync-to-game.bat，/MIR 排除 build 与 config.txt——config 由游戏内 F9 面板直接写，不覆盖）；旧 SandevistanMod\ 暂留作回退 |
| v1.108 | **鬼影根治（killPartsDeep）**：真根因=游戏 `Part.setNull`（Part.as:66）死亡路径从不摘除粒子 vis（`Pt.remVisual` 存在但没人调）——时停中爆炸粒子自然死亡/被 partsKill 杀死后 vis 冻结在爆炸位置=钉死鬼影；正常游戏靠 `Grafon.setLight→drawAllObjs`（Grafon.as:681/703）重建图层抹掉孤儿 vis，时停+回放世界冻结期间无重建、回放 boom 爆炸破坏瓦片触发重建才消失（与用户"回放开始到爆炸结束"时段完全吻合）。v1.107 ghostScan 的 visdefwave/visaglau 是误报（R50/R100 证明已跟随玩家），真身=爆炸坐标钉死的 visualFlare+2MC（partsAlive≈0 非粒子本体）。修复：①链上 Part 先 `remVisual()` 再 `setNull()`（endSandy/endReplay 两处 partsKill 改 killPartsDeep）；②显示树扫除自然死亡粒子的孤儿 vis（AllData `<part vis='...'>` 类名清单，倒序遍历）；③mcStepParts 播完即杀补 remVisual。诊断 partsKillDeepS/E: killed=N vis=M；版本标记 v1.108 |
| v1.107 | ①**ghostScan 显示树扫描（定位鬼影候选）**：回放开始+每 50 帧扫 projBoom 位置 300px 内 visObjs 各图层所有视觉（类名/坐标/可见性）。命中：回放开始时刻爆炸位置附近有**两个可见武器视觉**——`visdefwave`（defwave 法术武器 tip=5，AllData.as:3629）与 `visaglau`（榴弹发射器武器）钉在原地（sloy=2 vis=1 alpha=1）。已排除粒子/录像体/孪生体/重挂/连爆/MC循环。**鬼影未修完**——待确认归属+修复（v1.108 澄清为误报） |
| v1.106 | ①**鬼影尾焰修复**：v1.105 实证回放末段爆炸粒子寿命未耗尽（idx=200 仍存活 22 个、回放 210 结束）——endReplay **清空全部残留粒子**（partsKillEnd 诊断，实测 n=125） |
| v1.105 | ①诊断构建：partsAlive（每 10 帧粒子存活计数——证实粒子正常死亡非冻结）、partErr（单粒子 step 异常捕获——0 条）、boomPart（爆炸后粒子清单 vis 类/blit/liv）、reatt（重挂诊断——0 条）、回放阶段 parts 诊断重置 |
| v1.104 | ①**鬼影真根因修复（balefire）**：野火核弹（tipDamage=D_BALE）爆炸发射 balefire（火光 **Blit**，minliv=60 无淡出）+baleblast（MC 30）——回放仅 42 帧，火光贯穿回放并延续到回放后（v1.103 只杀 MC）；stepParticles（仅回放调用）把粒子 **liv 钳制 20 帧**自然完结 ②**疾跑切枪真根因修复（事件层拦截）**：游戏 World.step 挂 MainMenu.mainStep 的 ENTER_FRAME（先于模组注册——MainMenu 在模组加载前创建）→v1.100 onFrame 拦截永远晚于游戏按键处理；模组 KEY_DOWN 先于游戏 Ctr 注册——拦截改到 onKey：useFav(N)+stopImmediatePropagation；删除 onFrame 死代码 ③v1.102/103 附带：回放 MC 粒子 stop 防循环+播完即杀、boom 日志去上限（≤30 加 explKol/replIdx）、twinKill 状态诊断 |
| v1.101 | ①**鬼影/双冲击波真根因修复**：expl_t 是 internal（Bullet.as:131）——v1.99 的 kB.expl_t=0 在子域静默失败（try 吞掉）；集束武器连爆排定后回放结束后于爆炸位置喷出。修复：boom 重演后**直接 remObj 录像体** ②**切枪弹药增加真根因修复**：快照遍历 ammos（base 键）按 base 读 items（id 键）——换弹型变种弹药 id≠base 从未被覆盖；改遍历 world.invent.items（全部物品 id 键）③**疾跑切枪默认开**（cfgSwapRun=true + config swaprun=1）；新增 init 版本标记日志+partsKill+swapRun 诊断 |
| v1.100 | ①**爆炸位置鬼影/第二个冲击波环根治**：残留爆炸粒子——endSandy 改**清空全部粒子**；回放爆炸由 boom 新生成 ②**切枪后弹药增加修复（ammoLeash 防泄漏绳）**：游戏侧弹药返还发生在 endReplay 快照恢复之后——恢复后 120 帧钳制 ③**新功能：疾跑中切枪（swaprun）**：游戏本体疾跑时数字键映射第二组快捷槽（通常为空=无法切枪）——onFrame 拦截（后来 v1.104 证明帧层太晚，改事件层） |
| v1.99 | ①爆炸位置鬼影清除：endSandy 按 projBoom 位置清除半径 360px 内残留 Part ②野火核弹两次爆炸动画根治：boom 后 `expl_t=0` 只爆一次；未配对孪生体随③消除 ③导弹飞过爆炸点续飞根治：配对 ±1 容差+recPaired 去重；boom 触发时就近 200px 终止未配对惰性化孪生体（twinKill）④弹道偏移修复：历史记录 wrot、回放开火按记录 rot 复现 ⑤boom 位置按 projBoom x/y 精确重演 |
| v1.98 | ①时停爆炸动画"多次加载"根治（mcStepParts）：MC 型 Part 视觉播放头按舞台帧率推进+时停拉长 liv 5 倍→循环重播；时停中每显示帧 vis.stop()、节流帧 nextFrame() 推 1 帧→1/N 慢速播一次不循环 ②回放双倍伤害根治（twinInert 惰性化）：回放重执行的爆炸体 isExpl=true+damageExpl=0（原始值存 twinSavExpl）——explosion() 早退+projs 排除；endReplay 对存活在飞体恢复 ③野火核弹两个爆炸动画随②消除 |
| v1.97 | ①弹药"有概率增加"修复：改**精确双向恢复**+invent.mass[2] 负重同步 ②两次爆炸动画修复：录像原体已死亡的重执行体不再步进（位置由 reExecPin 重钉，导火索冻结）③回放开头爆炸鬼影修复：endSandy 将残留粒子快速步进 60 次至自然完结 |
| v1.96 | ①**爆炸统一由 boom 重演**（移除 v1.93 的 isReExecB 跳过）——日志证实 boom 位置与时停命中完全一致 ②**重执行体录像死亡帧终止**：reExecPin 检测录像孪生体 vv=false→重执行体 isExpl=true+liv=0+隐藏 vis+解除钉 |
| v1.95 | ①**重演子弹双步修复**（回放引爆位置晚于时停根因）：stepUnrecordedAtk 没有排除玩家方——回放重执行子弹被 stepPlayerBullets 和 stepUnrecordedAtk 各步一次=2 世界步/帧。修复：`owner==gg → continue` ②命中位置诊断：sandyBoom+replayHit+boom 三者对照 |
| v1.94 | ①**重执行爆弹体钉到录像轨迹（reExecPin）**：配对后每显示帧把重执行体 X/Y/vis 钉到录像轨迹 ②**异常引爆动画修复**：追踪器补帧 vv=!(isExpl==true)（引爆帧起隐藏）+ boom 触发处主动 vis.visible=false ③boom 诊断 |
| v1.93 | ①核弹/榴弹回放两份修复：boom 触发处跳过重执行体的录像爆炸（isReExecB）②时停前在飞投掷物不重演修复（hideGhost 增加 spawnedInS 条件）③普通 Bullet 爆炸死亡记录（追踪器死亡 boom 检测扩到 Bullet && explRadius>0） |
| v1.92 | ①爆炸后鬼影根治：引爆即杀 `p.liv=0`（Bullet/PhisBullet/SmartBullet 的 step 均 liv<=0→vse→remObj）②可击落类型扩充：榴弹发射器与野火核弹发射器 tip=3→普通 Bullet——projs 过滤扩到 `Bullet && explRadius>0` ③**命中判定重写（相对速度扫掠）**：R(t)=O+t·RV，t∈[0,1]，\|R\|≤28 命中 ④自测防护：爆炸弹同时在 projs/objs 两表——b==p 跳过 |
| v1.91 | ①手雷回放鬼影修复：回放不重执行抛掷（keyGrenad 不回喂）——录像体=唯一实体；hideGhost 增补 ②射击自己的手雷不引爆修复：出生距离守卫（同源且距 owner<200px 不判定）③**projBoom 爆炸重演**：时停中引爆→回放对应帧真实爆炸 |
| v1.90 | ①**回放不重演之谜根因**：setPos/setVisPos 仅 Unit 拥有——对密封类括号访问不存在成员抛 ReferenceError，replayObjects 每对象整段 try 被吞；改探测一次 hasSP/hasSVP 布尔后全用布尔；链扫描 isUnit 同修 ②移除 v1.88 预推进（双重计入）③攻击体补帧 vv=false（回放开头不可见）④近战体不参与击落（vel<1 跳过） |
| v1.89 | ①投掷物击落独立化：常规游戏分支（!sandy && !replaying）每帧 stepProjHits ②默认时停 120→210 帧（7 秒）+config.txt ③rFix 诊断 |
| v1.88 | ①时停前在飞玩家攻击体登记录像（startSandy 扫描全部 fe.weapon）②回放射击偏移修正（预推进——v1.90 移除）③recEnd 诊断 |
| v1.87 | **关键修复：攻击体重演可见性**——时停中死亡/移除的对象的 vis 被 remVisual 摘除→回放重钉不可见；replayObjects 中按 grafon.visObjs[sloy] 重挂（reattached 记录，endReplay 摘除） |
| v1.86 | ①回放子弹精确到开火帧（firePts）②startSandy 登记已在飞的敌人攻击体 ③投掷箱追踪器接管 ④被投掷敌人惯性 ⑤门重演 ⑥recBox 诊断 |
| v1.85 | ①攻击体录像追踪器（seenAtk）——绕开链扫描之谜 ②天角兽额外攻击根治（psyWeapon internal→逐槽 try/catch）③被投掷敌人惯性 ④投掷物击落 ⑤诊断：recAtk/recDoor |
| v1.84 | ①投掷物击落线段碰撞（closest-point 参数化）②天角兽额外攻击修复 ③枪械攻击偶发无动画/音效修复 ④被投掷敌人并入敌对完整 step ⑤投掷箱回放不 step ⑥门重演 ⑦recObj 诊断 |
| v1.83 | **新功能：投掷物可击落**——手雷/导弹/榴弹有血量，受击至 0 直接爆炸：stepProjHits（碰撞判定 28px、同源不互击、命中子弹 remObj）；时停中爆炸仅视觉（damageExpl/destroy 暂清零→explosion()→恢复），回放中真实爆炸。config projhits/projhp/projarmor |
| v1.82 | ①伤害策略统一：移除时停中 godMode（hp 复位横跳根源）——时停中受真实伤害，回放仍无敌 ②回放额外攻击修复 ③时停前已在飞的攻击体保留 ④被投掷单位动画 ⑤门重演 ⑥sAtk 诊断加 nPb |
| v1.81 | ①攻击改记录事件复现（enemyAtks 记录 t_attack 上升沿+瞄准点，回放逐事件复现）②回放玩家不再受攻击（enemyAct 3→2）③场景互动重演（vf 帧重演）④手雷库存恢复 |
| v1.80 | ①回放炮台/枪械无法攻击修复（移除 t_attack=1 守卫）②炮塔预判死亡隐身残留修复（endReplay 恢复 vis.visible=true） |
| v1.79 | ①朝向/转动如实重演（录像新增 sto+wrot 字段）②瞄准改按记录方向（替代 v1.77 钉玩家） |
| v1.78 | **回放步进速率修正**（v1.76 引入的算术错误——敌人每显示帧步进 5 次被错误加速）：正确速率=回放每显示帧消耗 5 历史帧=恰好 1 世界步；敌对单位 step 5次/帧→1次/帧、stepUnrecordedAtk 5→1 |
| v1.77 | ①残影层级修复（残影容器插玩家视觉层下方）②回放敌人攻击方向修复（每步前强制 celX/celY/celUnit=gg 当前位置） |
| v1.76 | ①**回放敌人攻击真实重演**：enemyAct 2→3（AI 完全运行：寻敌+追击+出手）——天角兽闪电、炮塔射击真实重放 ②回放撞击反馈（hit_flesh 音效+bum）③vis.visible 录制+重演（vv 字段）④stepUnrecordedAtk 对未录制攻击体 step×N |
| v1.75 | ①炮塔预判死亡调严（turret3 临时 shithp/shitArmor 25 护甲 + 正面减伤 25）②炮塔预判死亡慢速爆炸（expl()+vis.visible=false）③实体型攻击回放冻结修复（stepUnrecordedAtk） |
| v1.74 | ①**念力抛敌人撞击重做**：时停中不再钉 t_throw，只清零 damWall；节流步前后快照速度检测首次撞击→记录 thrownImpacts 并手动置 t_throw=0；回放推进到撞击帧时 unit.damage(dam,2) ②敌人走路动画有时僵死修复（enemyAct 1→2）③新默认值：duration 120、ghostalpha 70、ghostevery 5、edgethresh 15、replayghost 1、replayghostlife 4 |
| v1.73 | ①**回放玩家动画驱动**：按历史轨迹量化 dx（±6 走/±14 跑）喂 animate() ②回放残影可配置（replayghost/replayghostlife）③默认值调整 |
| v1.72 | ①念力抛敌人伤害仍当场结算修复（钉 t_throw=50 无效→清零 damWall+回放只重钉不 step）②**偶发吞攻击根治**：回放开火计数改时停逐帧记录 fc（弹夹下降判定）直接累加；逐发 hp=maxhp+清 jammed ③（同轮） |
| v1.71 | ①**走路动画新方案**：敌对单位回放中完整 step+位置重钉（enemyAct=1）②渐变门槛控件 edgethresh ③回放残影拖尾式（每 2 显示帧 1 个+寿命 12 帧；颜色用历史 ci）④念力抛出敌人伤害延后（钉 t_throw=50）⑤武器耐久/魔法值防双倍消耗 |
| v1.70 | ①**回退视觉捕获方案**（敌人变小/视野外显示）——恢复动画驱动 ②念力撞墙伤害延后（钉投掷箱 t_throw=5 防过期）③回放残影节奏修复（% 4 而非 % replayghost） |
| v1.69 | ①箱子念力投掷回演（loc.objs 记录）②炮塔类死亡判定可视化（disabled+隐藏血条）③走路动画视觉捕获回放（v1.70 回退） |
| v1.68 | ①走路动画僵死根治尝试（enemyAct=1 调 control）②残影渐变修正 ③残影叠加防护（位移<8px 不生成+总数上限 50） |
| v1.67 | 选项页模组面板扩展 4 项；saveConfigFile 补全全部配置键 |
| v1.66 | ①残影显示优化：时停残影寿命无限；回放残影间隔/寿命可调 ②边缘行者配色模式（colormode+edgePalette） |
| v1.65 | ①念力投掷物复位（历史 tx/ty 钉住）②敌人手雷复位（throwWeapon/magicWeapon 位置 twx/twy）③小马类动画重启扩展 ④rAnim 采样子 Bitmap 像素 |
| v1.64 | ①跳跃"有攻击无判定"修复（每发开火前重新瞄准）②小马类单位静止动画定期重启 ③rAnim 诊断对 MovieClip 视觉采样嵌套帧 |
| v1.63 | 跳跃相关吞攻击修复：单步 tA 记录、弹匣下降沿兜底、蓄力强制、换武器重置基线、rFire 诊断 |
| v1.62 | **回放吞攻击根治**：旧 -=5 冷却加速的量化误差——历史新增 tA，回放按 t_attack 上升沿计数窗口内真实开火次数，逐发手动驱动 t_attack=0/t_auto=0/t_reload=0 + attack() + step() |
| v1.61 | 预判模型再扩展：武器耐久、特攻（pers.damPony 等）、期望命中率（accuracy=precision/dist 对抗、近战 dodge）、损耗余量 ×0.9 |
| v1.60 | 预判死亡伤害估算升级：按游戏 damage() 期望值公式（护甲-穿甲克制纳入判定），新增 rAnim 诊断 |
| v1.59 | 回放僵死根治+下穿修复：攻击状态残留（world.enemyAct=0 调 control）、walk/run 抖动量化+迟滞、keySit 保留 |
| v1.58 | 按住 E 交互进度条跳动修复（keyAction 保留不清） |
| v1.57 | 三修复：回放敌人"僵死"（stay 阈值 36→900）、预判死亡调严（parr 优先+×0.7）、念力悬浮（keyJump/keyBeUp 保留） |
| v1.56 | **世界真慢速运行 + 时停可交互**：节流帧改为调用真实 loc.step()（public）——交互检测（celObj/celDist）在 loc.step 内；玩家全速每帧手动 gg.step + 节流帧 loc.step 内额外步（预先清键/步后恢复）；伤害清零+origDam 捕获+预判死亡压位移到 loc.step 前 |
| v1.55 | **时停预判死亡**：时停中统计玩家攻击本应造成的伤害（creditHit 位置盒检测）累计 ≥ 敌人 hp → sost=3 死亡姿态；不真杀；endSandy 恢复 sost=1，回放中真实结算死亡 |
| v1.54 | **敌人回放动画+武器位置修复**（基于 v1.49 回退版）：怪物动画用 BlitAnim（internal 读不到）——改按历史相邻帧位移设 dx/dy/stay 并驱动公开的 animate()；时停记录敌人 currentWeapon 位置 wx/wy，回放按历史恢复 |
| v1.53 | 修复 v1.50 的敌人视觉倒转（vis.rotation 仅限攻击体）——但用户要求整体回退 |
| **v1.49r** | **回退版**：v1.50-v1.53 增量改动引入敌人视觉异常（rot 语义混淆），回退到 v1.49 稳定基线。已知限制：时停中敌人攻击有击退/反馈观感；敌人攻击体回放方向可能横飞 |
| v1.50 | 敌人攻击时停"当场结算"修复（invulner=true）；回放攻击体方向恢复；重演记录性能优化（见 lessons.md——此版是失败核心） |
| v1.49 | 时停中敌人固定不动修复（owner 判断只对 fe.weapon:: 做并隔离异常） |
| v1.48 | 时停攻击当场结算修复（伤害清零移到节流 step 之前）；敌人固定时停结束位置修复（setVisPos+记录范围扩大） |
| v1.47 | **回放场景级完整重演**：时停期间记录所有对象每帧状态（replayObjs）；回放期间 onPause=true 世界冻结——玩家手动 gg.step + stepPlayerBullets + replayObjects |
| v1.46 | 时停慢速改**节流 step**（v1.45 位移回退因帧序无效）：onPause=true 冻结世界，玩家每帧手动 step，敌人/物品/攻击体每 slowfactor 帧 step 1 次 |
| v1.45 | **时停慢速世界（问题5 定稿）**：位移回退方案——帧序问题见 v1.46 |
| v1.44 | 回放近战结算改**直接结算**（攻击体位置放玩家前方挥击点，80px 范围直接 udarBullet+popadalo） |
| v1.43 | 回放近战无伤害修复（rBody 定位 off 恒 false）：沿瞄准方向推进+分段 6 步×20px |
| v1.42 | 吞攻击元凶修复：WClub.shoot 设 t_auto=3（近战特有冷却）——回放中近战每帧清 t_auto=0 |
| v1.41 | 回放近战不吞攻击：rapid 11→2（savedRapids 保存）；bindMove 窗口被跳过→每攻击帧手动 b.run() 兜底；历史记录武器位置 wx/wy |
| v1.40 | 时停伤害冻结修复（WClub 复用攻击体不挂 loc 链表→直接清 currentWeapon.b）；回放击退缩放（otbros×1/3） |
| v1.39 | 近战方案定稿：时停中正常出手；伤害冻结改帧首清零攻击体 damage；鼠标按下脉冲（mouseAtkPulse） |
| v1.38 | 回放近战伤害修复（bindMove 窗口推进结算；近战 -=3 而非 -=5） |
| v1.37 | 近战时停冻结定稿：时停中近战拦截攻击键（不出手），真实意图记入历史，回放重演出手结算 |
| v1.36 | 残影朝向根因修复（BitmapData.draw matrix 替换源显示变换——按朝向翻转矩阵）；时停中近战伤害清零；回放攻击加速改 t_attack -= 5 |
| v1.35 | 残影双重缩放修复（draw 临时脱离父容器）；残影镜像决定性诊断（翻转对照） |
| v1.34 | 回放武器切换重演：历史每帧记录武器 id（w 字段），回放推进时检测武器变化立即切换 |
| v1.33 | 回放武器切换恢复（回放开始切回时停开始武器，结束切回）；回放结束弹夹/背包恢复到时停结束时状态；回放中武器切换无冷却；诊断日志增强 |
| v1.32 | 武器立即就位：回放强制 wv.X/Y=weaponX/Y、wv.rot=瞄准角、wv.ready=true |
| v1.31 | 攻击方向记录：时停记录 world.celX/celY，回放喂回 |
| v1.30 | **稳定基线**：v1.25 行为 + replayspeed=5 + cooldown=0 |
| v1.26-1.29 | 弹匣恢复尝试（replayHoldStart）——用户实测无效，**回退** |
| v1.25 | 回放中弹匣无限（hold=holder、t_reload=0，无换弹中断） |
| v1.22-1.24 | 双倍火力修复：清冻结子弹；弹药冻结（ammos 无效→items.kol；最终改"时停返还"） |
| v1.21 | **攻击行为定稿**：时停中正常攻速实时攻击；回放中加速攻击（强制 t_attack=0） |
| v1.16-1.20 | 攻击延迟到回放（拦截键盘+鼠标——最终**回退**） |
| v1.15 | 选项页叠加设置面板（生效时间/冷却） |
| v1.13-1.14 | 真回放模式（玩家传送起点重演+输入锁定+godMode）；回放残影抽稀 |
| v1.9-1.11 | 输入法（IME）检测与警告（229 事件）；误报修正（2秒内≥2次才警告） |
| v1.4-1.7 | 卡键排查：失焦清键、keyDowns 清空（internal 不可访问→无效）、keyXML 强制设置键布尔 |
| v1.0-1.2 | 初版：时停+残影+回放；修复残影定位（vis.x+b.left）；HUD 终端风；F9 面板 |
