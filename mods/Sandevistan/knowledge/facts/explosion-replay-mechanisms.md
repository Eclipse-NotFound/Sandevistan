# 爆炸/投掷物重演机制速查（本模组专属）

---
domain: mod-knowledge
type: facts
source: 交接文档 §7（v1.83-1.101 机制速查）
game-version: 1.02
mod: Sandevistan
confidence: high
verified: true
date: 2026-08-15
---

## 可击落投掷物（stepProjHits）

- 可击落类型：`PhisBullet`（手雷/榴弹/野火核弹）、`SmartBullet`（导弹）、
  普通 `Bullet && explRadius>0`（tip=3 榴弹/核弹发射器的子弹；天角兽闪电 expl=0 排除）。
- 命中判定：**相对速度扫掠** `R(t)=O+t·RV`（t∈[0,1] 钳制端点），|R(t*)|≤28px 命中
  ——高速相向必须用此式（旧"子弹段 vs 投掷物末端"整段交叉错过）。
- 守卫：同源出生距离守卫（投掷物距 owner<200px 不判定）；`b==p` 自测防护；vel<1
  近战体排除；命中子弹 remObj；引爆后 `p.liv=0`（三类 step 均 liv<=0→vse→remObj）。
- 调用点：slowStepWorld（节流步后）+ stepReplay（replayObjects 后）+ 常规游戏每帧。

## projBoom（时停引爆 → 回放真实爆炸）

- 时停中引爆（stepProjHits 击落记录 + 追踪器死亡检测 isExpl 补录自然到期/撞墙）
  → 字典 `{f, x, y}`（f=时停帧号）。
- 回放在 replayIdx≥f 时：恢复 damageExpl → `kB.X/Y=b m.x/y`、vis 同步 → `isExpl=false`
  → `explosion()` → **remObj(kB)**（防 expl_t 连爆——internal 无法赋值）→ liv=0 →
  隐藏 vis。**爆炸一律走 boom**（日志证明 boom 位置与时停命中完全一致），
  不要依赖"重演子弹击中重执行体"（量化误差不可靠）。

## 孪生体（回放重执行产生的爆炸体）

- **twinInert（v1.98）**：stepPlayerBullets 首次步进前惰性化：`isExpl=true` +
  `damageExpl=0`（原始值存 twinSavExpl）——explosion() 早退 + projs 表排除；
  孪生体只做轨迹视觉。endReplay 对存活在飞（in_chain && liv>0 && !babah）恢复。
- **reExecPin（v1.94）**：与录像原体按**开火帧**配对（owner==gg && 补帧 vv=false &&
  首个 vv=true 索引==fp.f，±1 容差+recPaired 去重）→ 每显示帧把重执行体 X/Y/vis
  钉到录像轨迹；录像原体 vv=false（死亡标记）→ 终止（isExpl=true+liv=0+隐藏+解除钉）。
- **twinKill（v1.99）**：boom 触发时就近 200px 终止未配对惰性化孪生体
  （先收集后终止——迭代中删字典键不安全）。

## 弹药/资源精确恢复

- endReplay 对 `invent.items` **id 键**双向精确恢复 + `invent.mass[2]` 负重同步
  （回放中玩家无操控不可能拾取，双向安全）；旧"只向上补"已废弃。
- ammoLeash：恢复后 120 帧钳制 kol/非当前武器 hold（游戏侧换弹返还发生在恢复之后）。
- 弹夹 hold 快照 + endSnapWpnHp/endSnapMana/gSnapKol（手雷库存）。

## 粒子处理（v1.97-1.108）

- endSandy：清空**全部**粒子（360px 半径杀不净快粒子）→ **v1.108 起 killPartsDeep
  （remVisual+setNull+显示树扫除孤儿 vis）**。
- 回放：stepParticles 只步回放粒子（liv 钳 ≤20）；mcStepParts stop+推进、播完即杀
  （v1.108 补 remVisual）。
- endReplay：killPartsDeep（原 partsKillEnd）。

## hideGhost / vv 补帧

- hideGhost：被 clearFrozenBullets 清除的玩家攻击体（owner==gg && !in_chain &&
  spawnedInS（arrR[0].vv==false）&& 非投掷武器）录像原体隐藏——回放由重执行渲染。
- 投掷武器（weap==throwWeapon）的手雷**不重执行**（keyGrenad 不回喂）——录像体是
  唯一实体，回放结束后自然续飞爆炸。
- 追踪器补帧：攻击体首帧 vv=false（回放开头不可见）；死亡帧起 vv=!(isExpl)（隐藏）。
