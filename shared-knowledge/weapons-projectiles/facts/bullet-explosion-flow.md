---
domain: weapons-projectiles
type: facts

game-version:
  - "1.02"

confidence: high
verified: true

discovered-by: Sandevistan

evidence:
  - kind: decompiled-game-code
    symbol: "fe.weapon::Bullet.explosion / explRun / explBlast / explVis"
  - kind: runtime-experiment
    summary: "Sandevistan v1.91-1.101 boom 重演机制实测（isExpl 守卫一步全禁；expl_t internal 无法赋值）"

  - kind: runtime-experiment
    summary: "2026-09-23 原生 UnitRaider/UnitTurret 伤害对照与 2400 次随机覆盖采样，更正旧期望公式。"

date-updated: 2026-09-23
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

## 2026-09-23 更正：旧期望公式不是本体结算公式

上面的“v1.60 使用”表达式是旧模组近似，保留作历史来源，不能继续当作 Unit.damage 的事实公式。1.02 的源码审计及真实 UnitRaider/UnitTurret 调用证实：

- 攻击体 damage 已含发射时 resultDamage 的武器损坏惩罚；重复扣耐久会再次低估。
- 类型易伤和玩家类别特攻在护甲前；非玩家护甲耐久也在减伤前扣，本次打破护甲立即令 armor_qual=0。
- 物理组用 armor，能量组用 marmor；armor_qual 是“本次有无护甲覆盖”的概率。应分别算有甲/无甲的非负伤害再平均，不能先平均护甲值。
- 普通暴击和偷袭在减甲后；之后才处理分解和全局易伤。POISON/BLEED/INSIDE 不乘 allVulnerMult。
- 同一输入100：物理甲70/能量甲10的激光实际90；护甲耐久50被本击打破实际100；物理甲20且必定双暴击实际160；覆盖率0.5/护甲200的100伤害，2400次本体结算平均约50，而不是0。
- parr 在 udarBullet 的随机命中之前记录，只是接触；接触当步可以出链。WClub 重用 Bullet 但每次挥击替换 parr。WKick 则在 actions 内立即重设伤害并 bindMove；已经发生的 HP 损失不能再按“未结算”追加。

证据：fe.unit::Unit.udarBullet/damage、fe.weapon::Bullet.udar/step、Weapon.shoot/resultDamage、WClub.shoot、WKick.actions；2026-09-23 独立 AIR 实验使用真实类，固定伤害逐例与原生结果相等，并以随机采样核验覆盖率边界。完整顺序及子类差异见 [战斗源码审计](../discoveries/combat-pipeline-source-audit-2026-09-09.md)。这里验证的是基类链路与列出的炮塔特例，不将其泛化到所有 Boss/玩家护甲/爆炸气体路径。