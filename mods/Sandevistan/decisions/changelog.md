# 版本历史与变更记录

> 提取自原交接文档 §5。**规则**：新版本行插在旧行**之前**（不要整行替换，易覆盖丢行）。
> 每次改动同步更新 `state/current-status.md` 与 `release/说明.txt`。

| 版本 | 内容 |
|---|---|
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
