# 子弹/爆炸体流程（Bullet 核心）

---
domain: weapons-projectiles
type: facts
source: Bullet.as / PhisBullet.as（1.02 反编译 build/game-src/src102）
game-version: 1.02
mod: -
confidence: high
verified: true
date: 2026-08-15
---

## 类族

- `Bullet`（枪弹/榴弹等直射弹）、`PhisBullet`（手雷等投掷物理弹）、
  `SmartBullet`（导弹 navod）、`Trasser`（弹壳）。爆炸能力= `explRadius>0`
  （天角兽闪电等 expl=0 天然无爆炸）。
- `tipDamage` 决定爆炸类型（D_EXPL/D_FIRE/D_BALE/D_VENOM/D_PINK/D_ACID/D_EMP…）。

## 爆炸（explosion / explRun）

- `explosion()` 首行 **`if(this.isExpl) return`**（Bullet.as:666-668）——所有引爆路径
  （导火索/碰撞/近炸 sensor/外部击落）最终都进这里。**禁用爆炸体 = 置 isExpl=true**
  （一步全禁伤害+视觉+连爆排定），恢复 = isExpl=false。
- `explRun()`：`explDestroy()`（半径内瓦片破坏 hitTile→光照重算）+ `explBlast()`/
  `explGas()`（按 explTip；D_EXPL 发射 `expl`(blit 240²)+`flare`(visualFlare)+
  `iskr`×16 粒子）+ `explVis()`（按 weap.visexpl，aglau 等无 visexpl 则跳过）。
- 集束连爆：`explKol>1` 时排定 `expl_t=(explKol-1)*explPeriod` 后续连爆——
  `expl_t` 是 **internal**，外部无法清零；禁连爆只能把对象移除出链（remObj）。
- `babah`：撞击标志——接触处理 `if(!babah)` 守卫；babah 后 vis 隐藏 1 帧+liv=4，
  无伤害无爆炸（爆炸被 isExpl 守卫时同理）。

## 生命周期

- `liv` 每世界步递减；导火索型（手雷）liv 归零=引爆；引爆/撞毁后 liv<=0 →
  `vse → remObj` 出链（"引爆即杀"外部一致性模式：直接 `p.liv=0`）。
- 子弹视觉（vbul）随 step 同步位置；`flare` 字段非空时飞行中周期性
  `Emitter.emit(flare)`（拖尾）。

## 与伤害相关的字段

- `damage/damageExpl/destroy/explRadius/otbros(击退)/tipDamage/pier/armorMult/
  critCh/critDamMult/tipDecal`；`weap` 引用发射武器（damageExpl 恢复源）。
- `damage()` 期望值公式（v1.60 使用）：
  `dmg × vulner[tipDamage] × (1+critCh×(critDamMult−1)) − max(0,(skin+armor_qual×armor
  +shitArmor)×armorMult−pier) × allVulnerMult`。
