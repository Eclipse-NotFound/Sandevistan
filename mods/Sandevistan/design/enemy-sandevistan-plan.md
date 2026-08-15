# 敌人斯安维斯坦（Enemy Sandevistan）—— 探索结论与规划

---
type: design-plan
status: 规划中（未实施，2026-08-15）
source: 用户需求 + 游戏源码探索（game-reference/decompiled/1.02）+ 模组既有机制
---

> 用户需求：
> 1. **场景 A**：敌人开启斯安维斯坦、玩家未开启 → 敌人处于加速状态（类似回放模式），玩家正常。
> 2. **场景 B**：敌人与玩家同时开启 → 双方处于"正常关系"（全速对抗），**其余世界慢放**。
> 3. 不把 Sandy 敌人当作精英怪处理（不碰 hero/goldstar）；允许添加调试用标记。

## 1. 探索结论（游戏机制事实，均已定位到源码）

| # | 机制 | 结论 | 证据 |
|---|---|---|---|
| 1 | 精英怪标记 | `Unit.hero>0` → 血条 `hpbar.goldstar` 显示；hero 由 AllData `<param hero='raider' hbonus='1'/>` 按单位类型配置 | Unit.as:2888、AllData.as:74+ |
| 2 | AI 门控 | `World.enemyAct` 默认 **3**（全 AI）；子类 control 内 `enemyAct<=0` 早退（部分类）、findCel 需 >1、攻击需 >=3（模组既有结论） | World.as:170、UnitBloat.as:208 |
| 3 | 单位步进安全性 | `Unit.step()`：早退检查 → emergence → inter/forces/control → `run()`——高速移动时**游戏自带 div 子步进**（\|dx\|>maxdelta 时 run(div) 分步）→ actions/setVisPos/animate。**重复调用 step() 安全**，不会穿墙 | Unit.as step 全览 |
| 4 | 移动字段 | `maxSpeed`（Unit.as:216）、`dx/dy/storona/stay`；移动逻辑在子类 control() | Unit.as |
| 5 | 帧序 | 游戏 World.step（MainMenu 的 ENTER_FRAME）**先于**模组 onFrame → 模组在游戏步进之后"补步"是天然时机 | 既有结论（v1.104 教训） |
| 6 | 录像/回放兼容 | `recordReplayObjects` 已逐帧记录**所有**单位——场景 B 中敌人快速移动天然被录像；回放 `replayObjects` 的 isHostile 分支（enemyAct=2、1 步/帧、位置重钉）可 1:1 复现敌人的 Sandy 行为——**回放代码无需改动** | 模组既有机制 |
| 7 | 伤害策略 | 玩家时停中：玩家攻击=冻结 0 伤害+回放结算；敌人攻击玩家=**真实伤害**（v1.82 策略）。场景 B 沿用；场景 A 敌人 N× 攻击频率=真实伤害 | 既有结论 |
| 8 | 残影复用 | `spawnGhostAt(x,y,s,r,v,ct)` 是通用接口（回放残影已在用）——敌人残影可直接复用；颜色映射用速度 dx/dy | 模组既有机制 |

## 2. 架构方案

### 2.1 敌人注册与触发（新模块：enemySandy）

- **检测**：`onFrameInner` 常规分支（`!sandyActive && !replaying`）每帧遍历 `loc.firstObj`
  链（复用 replayObjects 的 isHostile 判据：有 currentWeapon 且类名非 NPC），
  类名命中白名单（config `enemysandy`）且未注册 → 注册进 `sandyEnemies: Dictionary`
  （值 = {left, cd, spd, ghost…}）。
- **触发**：冷却制自动开启（冷却/持续帧可配置）；是否联动"玩家开启时同开"为待决策点。
- **标记**：注册即挂调试标记（visObjs[3] 小徽标，或 vis.filters 辉光——**绝不用 goldstar**，
  不设 hero>0），死亡/出链清理注册表与标记。

### 2.2 场景 A（仅敌人 Sandy：世界正常、敌人 N×）

- 不动 `onPause`，世界照常步进。
- 模组 onFrame（游戏步进后）对每个活跃 Sandy 敌人补 `(N-1)` 次 `step()` →
  AI（寻敌/攻击冷却）/移动/攻击全部 N×。
- 敌人子弹：由世界 1× 步进（N× 射速、1× 弹速——待决策：是否像玩家时停那样给 Sandy
  敌人的子弹也做全速步进）。
- 残影：`spawnGhostAt(enemy.X, enemy.Y, …)` 复用；颜色按速度映射。
- 平衡：N、持续、冷却可配置；玩家承受 N× 攻击频率（真实伤害）——需实测调数值。

### 2.3 场景 B（敌我同时：双方全速、世界 1/N 慢放）

- 玩家触发 `startSandy` 照旧（世界冻结 + 玩家全速 + 节流世界）。
- `stepSandy` 每帧对**每个活跃 Sandy 敌人**也手动 `step()` 一次（与玩家同权）→
  敌我全速"正常关系"，其余世界 1/N。
- 节流帧的 `loc.step()` 会再步到 Sandy 敌人一次（1/N 慢步）——与玩家"自由物理步"
  同款现象（净 ~1.2×），接受并记录在案。
- 伤害：敌人攻玩家=真实伤害；玩家攻敌人=冻结 0 伤害、回放重演结算（与 v1.82/回放
  体系一致，无需改动）。
- 录像天然覆盖敌人快速轨迹；回放无需特判。

### 2.4 配置（草案，键名可再议）

```
enemysandy=UnitRaider,UnitMerc,UnitEncl,UnitAlicorn   # 白名单类名；all=全部敌意单位
esandydur=150      # 敌人 Sandy 持续帧（30帧=1秒）
esandycd=600       # 触发冷却（帧）
esandyspd=5        # 加速倍率（每显示帧补 spd-1 次 step）
esandyghost=1      # 敌人残影开关
esandymark=1       # 调试标记开关
```

### 2.5 与现有系统的交互清单

- **投掷物可击落（projHits）**：独立于时停，敌人 Sandy 中照常生效（无需改动）。
- **预判死亡/伤害估算**：仅作用于玩家时停（不涉及场景 A）。
- **回放**：敌人 Sandy 轨迹被录像天然重演（不碰回放代码）。
- **godMode**：仅玩家回放用（不涉及）。
- **清理**：敌人死亡/出链时从 `sandyEnemies` 移除并摘标记（跟随 firstObj 链扫描清理）。

## 3. 风险与开放问题（需用户决策）

1. **场景 A 的压迫强度**：敌人 N× 攻速对玩家是真实伤害——N/持续/冷却需要实测调平衡；
   是否给"敌人 Sandy 激活时"加提示（音效/HUD）也待定。
2. **子类 AI 门控差异**：部分单位（天角兽等）control 无 enemyAct 门——N× 补步下
   攻击节奏是否如预期需按类实测（探索时已确认大部分类有 `enemyAct<=0` 早退）。
3. **场景 A 敌人子弹速度**：1×（当前草案）还是与敌人同速 N×（更"时停感"）——
   实现复杂度不同（后者要新增"敌人方攻击体全速步进"，类似 stepPlayerBullets 的敌方版）。
4. **同屏 Sandy 敌人数量上限**：每帧 ×N 步进有性能成本——建议同屏 ≤3 + 白名单限类。
5. **触发方式**：纯冷却自动 / 玩家开启时联动触发 / 受击狂暴触发（可选其一或组合）。
6. **调试标记形式**：位置徽标（"S"）/ 辉光滤镜 / 血条染色——不影响精英怪判定。
7. **残影样式**：复用玩家彩虹/边缘行者配色，还是固定配色（如红色系）以示区分。

## 4. 实施步骤（草案，未开始——待用户确认后执行）

1. 配置键 + `sandyEnemies` 注册表 + 白名单链扫描 + 调试标记（v1.115 基础）
2. 场景 A：补步循环 + 残影 + 诊断行 `esandy: cls/X/Y/left`（v1.116）
3. 场景 B：`stepSandy` 挂钩（v1.117）
4. 实测平衡 + 文档（changelog/state/说明.txt）
