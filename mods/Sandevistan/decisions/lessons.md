# 教训与技术选择复盘

> 提取自原交接文档 §5.5 与 §7 的教训条目。这些是本模组踩过的坑，多数同样适用于
> 该游戏的其它模组（跨模组部分已同步到 `shared-knowledge/`，引用处会注明）。

## v1.50 失败复盘（2026-08-13）

1. **视觉/逻辑属性语义混淆**（直接 bug）：`vis.rotation = rot*180/PI` 对所有对象执行——
   但 `Unit.rot` 是**朝向角**（`storona>0 ? 0 : Math.PI`），攻击体的 `rot` 是**飞行方向角**。
   朝左敌人被设 180° → 视觉倒转。**教训：跨类访问字段前必须验证语义（同名≠同义）；**
   视觉属性恢复必须按对象类型隔离。
2. **一次改动混入多件事**：v1.50 同时做了 invulner、方向恢复、性能优化——出问题无法隔离。
   **教训：修复=最小改动；新功能/优化单独立项。**
3. **诊断采样偏差**：sEnemy/postSandy 采样"第一个单位"——经常采到炮塔或站桩 NPC。
   **教训：诊断必须采样多个单位并记录类名；用户观察需先对照数据定位"真不动"还是"视觉异常"。**
4. 回放重演架构本身（v1.47 世界冻结+手动驱动）是稳定的——失败全部来自增量改动的副作用。

## 模组开发通用陷阱（跨模组版见 shared-knowledge/knowledge-validation/facts/）

- **internal 成员（keyDowns/keys/keyIds/expl_t/BlitAnim）永远无法从模组访问**；
  对 internal 赋值在子域**静默失败**且常被 try 吞掉（v1.101 教训）——想禁集束连爆
  用**移除对象**（loc.remObj）而不是改 internal 字段。
- **密封类 bracket 访问陷阱**：setPos/setVisPos 仅 Unit 拥有——对 Box/Bullet/PhisBullet
  等密封类访问不存在成员抛 ReferenceError #1069，且**整段 try 被吞**。一律先 try/catch
  探测布尔（hasSP/hasSVP）再分支（v1.90 教训）。
- **步进速率恒等式**：时停世界每 slowfactor 显示帧步 1 次；回放每显示帧消耗 slowfactor
  历史帧=恰好 1 世界步。玩家攻击体回放由 stepPlayerBullets 步 1 次/帧，stepUnrecordedAtk
  只应处理敌方未录制对象（双步=2×速错乱，v1.95 教训）。
- **禁用爆炸走 isExpl 守卫**：游戏所有引爆路径（导火索/碰撞/近炸 sensor/可击落）最终都进
  `explosion()`，首行 `if(isExpl) return`（Bullet.as:668）——禁用某爆炸体的爆炸用
  `isExpl=true`（一步全禁：伤害+视觉+explRun），同时自动被 stepProjHits 的 projs 表排除；
  只清零 damageExpl 不够（仍会播动画+explRun）。
- **帧层 vs 事件层**：游戏 World.step 挂在 MainMenu.mainStep 的 ENTER_FRAME（先于模组
  注册——MainMenu 在模组加载前创建）→ 模组 onFrame 永远晚于游戏按键处理。拦截按键
  必须放 KEY_DOWN 层（模组 KEY_DOWN 先于游戏 Ctr 注册）+ stopImmediatePropagation。
- **快照键空间语义**：Invent.items 按 **id** 键、Invent.ammos 按 **base** 键（派生汇总）——
  跨容器快照必须核对键空间，且 ammos 不可用作快照恢复（v1.101 教训）。
- **粒子死亡不摘 vis（v1.108 教训）**：游戏 `Part.setNull` 从不调 `remVisual`（Part.as:66）——
  孤儿 vis 平时由 `Grafon.setLight→drawAllObjs` 重建图层抹掉；在冻结/慢速世界里会
  钉死成"鬼影"。模组自清粒子必须补 remVisual + 显示树扫除（killPartsDeep 模式）。
- **Dictionary 对象键迭代序不稳定**：projBoom 等以对象为键的字典，"前 2 条"采样在不同
  时刻可能取到不同条目——扫描/采样类诊断的"S 帧没有、R 帧出现"可能是采样偏差而非
  事实变化（v1.107 ghostScan 误报的直接原因）。
- **历史记录武器切换（v1.33 模式）**：回放中模拟 changeWeaponNow 要同时做
  remVisual/currentWeapon 赋值/childObjs[0]/addVisual/setNull/setPers/gui.setWeapon；
  并每帧清 work="change"/t_work 钉住 replayWpn，防游戏 changeWeapon 动画流程在回放中
  触发 changeWeaponNow 乱切。

## v1.120-1.132 阶段教训（回放忠实度 + 敌人生成）

- **"重算型回放"必然失真，能用快照就别重算**：回放动画若靠"分类动作+状态机重算"
  （dx 量化喂 animate），姿态连续性依赖状态机从干净起点走起——时停跨越半个动作
  （跳到一半/滚到一半）时回放从动作开头或错误分支开始=错乱（用户实测）。改成
  **快照重演**（逐帧记录标签+帧号，回放 gotoAndStop）后彻底解决（v1.130 玩家、
  v1.132 敌人按位移补喂 dx+animate——贴图怪无帧可录时的次优解）。
- **位置钉住 → AI 判"已到目标" → dx≈0 → 动画僵死**：回放把敌人钉在记录位置后，
  重跑的 AI 常认为已抵达（尤其目标在攻击范围内）→ 控制层 dx=0 → animate() 只走
  stay。贴图动画怪（僵尸/蝎子，anims[state].st 非循环态）直接定住。修法：步后按
  记录位移折算 dx/dy 再补调一次 animate()。
- **AI 重跑有分歧，会污染"事后世界"**：回放重跑怪物 AI 可能把它推入本体隐蔽状态
  （僵尸钻地 aiState=5 → vis.visible=false+invis=true+levitPoss=false），**回放结束
  后残留**——表现为"偶发隐身的怪物"+"无法念力抓取"。修法：录像每帧记公开标志
  （vis.visible/invis/levitPoss），回放步后按录像强压。任何"重跑型"机制都要防
  状态分歧残留（快照恢复的时机是每帧，不是只在结束时）。
- **config 行尾注释会毒化布尔键（v1.121 教训）**：解析器不剥 `#` 注释时，
  `esandymark=1  # 说明` 的布尔精确匹配（`v=="1"`）失败=功能被静默关闭（三轮
  "修复无效"的真根因）；parseInt 键靠数字前缀侥幸存活——同一 bug 对不同类型键
  表现完全不同，**诊断时要对比同源键的行为差异**。修法：解析器统一剥注释；
  配置文件注释独立成行。
- **采样偏差会再犯（v1.128 教训）**：斑马 shine 修复依据的是"日志恰好只有一场
  斑马战"——用户随后澄清所有类型都隐形。已有 diag-sampling-rules（shared-knowledge）
  照样再犯一次：**单一样本定案前必须确认样本对全部类型成立**。
- **公开字段是逃生门**：internal 读不到时，找同机制链上的 public 杠杆——
  斑马 shine 用 `isShoot`（全游戏仅 UnitZebra 消费）触发其自带回充；
  僵尸钻地用 vis.visible/invis/levitPoss 强压。先把游戏自身的重置路径找全。
