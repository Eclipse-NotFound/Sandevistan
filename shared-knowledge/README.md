# shared-knowledge —— 跨模组共享知识库

> 本文件教未来的 AI agent 如何**读取、贡献和维护**这里的知识。
> 它不是模组 README、不是任务记录、不是开发日志。

## 1. 这里是什么

`shared-knowledge/` 保存关于 **《Fallout Equestria: REMAINS》游戏本体**的可复用知识——
任何为这个游戏开发模组/工具的 agent 都能直接引用的事实与验证方法。

它**不保存**：

- 某个模组自己的实现逻辑、版本历史、任务状态（那些在 `mods/<ModName>/` 内）；
- 未经标注的猜测（一切都要带 source 与 confidence）；
- 可以从反编译源码 10 秒内 grep 到的琐碎信息（这里存**机制级的结论**，
  反编译源码本身在 `mods/Sandevistan/build/game-src/`）。

## 2. 什么时候应该读这里

- **动手改游戏行为之前**：涉及渲染/武器/碰撞/世界对象/单位/UI 任一领域时，
  先读对应领域的 `facts/`——多数"发现的坑"已经有人踩过并验证。
- **排查疑难 bug 时**：先读 `discoveries/`（历史行为发现）与 `experiments/`
  （现成的验证方法），再设计自己的诊断。
- **不确定某个行为是不是游戏本体的 bug** 时：fact 文件里标了 `verified` 与
  源码位置，可直接引用。

## 3. 目录结构与分类定义

```
shared-knowledge/
├─ rendering/            画面/图层/粒子/视觉同步
├─ weapons-projectiles/  武器、子弹、爆炸、切换流程
├─ physics-collision/    运动、碰撞、击退、伤害语义
├─ world-objects/        对象容器、Box/门/瓦片
├─ entities/             单位、AI 状态、玩家单位
├─ ui-systems/           输入、PipBuck、HUD
└─ knowledge-validation/ 元知识：如何验证、运行时交互规则、诊断方法
```

每个领域内部：

```
<domain>/
├─ facts/         已确认、稳定、可直接引用的信息（引擎机制、字段语义、流程）
├─ discoveries/   通过逆向/实验/测试发现的行为——可能版本相关
└─ experiments/   测试过程、验证方法、失败尝试（可复用的"怎么做"）
```

**判定标准：**

- `facts`：多轮验证过、能从源码行号/多次实测支撑、未来可直接引用做决策。
- `discoveries`：一次或几次观察得出的行为结论；**必须**写 source/confidence/
  game-version，可能随游戏版本变化。
- `experiments`：方法而非结论——即使实验本身失败也有价值（后来者不必重试）。

新领域可以新增（保持顶层领域是**游戏机制主题**而非模组名）。

## 4. 新发现应该放在哪里

```
是某个模组自己的实现细节/状态？      → mods/<ModName>/knowledge/（不进这里）
是游戏本体的行为/机制？              → 按上面 7 个领域归入对应 <domain>/
是"如何验证/如何诊断"的方法？        → <domain>/experiments/ 或 knowledge-validation/
是对既有知识的修正/冲突？            → 见第 7 条冲突处理
```

## 5. 如何避免污染公共知识

- 写之前先搜：同一结论是否已存在（用不同关键词搜概念，别只搜文件名）。
- **不写模组专属逻辑**：写"引擎的爆炸流程"，不写"Sandevistan 的 boom 重演机制"。
  发现两者边界模糊时，宁可放在 `mods/<ModName>/knowledge/`。
- **不写未经验证的推测**：只有假设没有验证 → 标 `confidence: low` + `verified: false`，
  或先放在 experiments 里作为"待验证假设"。
- 引用的源码行号必须来自固定的反编译参考（`mods/Sandevistan/build/game-src/src102`），
  并注明文件名——行号随反编译版本漂移，文件名+符号名更稳。
- 一个文件一个主题；新主题开新文件，别把无关结论塞进既有文件。

## 6. 来源与可信度（metadata 规范）

每个知识文件开头必须带 YAML front-matter（后续工具可直接解析）：

```yaml
---
domain: rendering                  # 所属领域
type: facts | discoveries | experiments
source: Part.as:66 / 实测日志 / 用户确认    # 具体到文件:行 或 日志文件
game-version: 1.02                 # 结论适用的游戏版本（多版本写 "1.02-1.04"）
mod: - | <ModName>                 # 结论来源模组；"-" = 与特定模组无关
confidence: high | medium | low    # 对该结论的把握
verified: true | false             # 是否经过二次验证/实测确认
date: 2026-08-15                   # 最后更新日期（ISO）
---
```

- `verified: false` 或 `confidence: low` 的文件**必须**在正文里写明"哪些部分
  已验证、哪些是推测"，让引用者自行判断。
- 引用他人结论时写"见 xxx.md"，不要复制粘贴造成双源漂移。

## 7. 冲突知识的处理

1. 发现冲突（同主题两个文件结论不一致）→ **不要静默覆盖**。
2. 在**较旧或可信度较低**的文件头部加：

   ```
   > ⚠️ 与 <冲突文件> 冲突，见该文件。本结论保留作历史参考（原因：…）。
   ```

3. 把较新结论写入其主题文件，`source` 注明旧结论来源，`confidence` 按新证据定。
4. 若冲突源于**游戏版本差异**（如 1.02 vs 1.04 行为不同）：两个结论都保留，
   各自 `game-version` 标注清楚，正文互相引用。
5. 无法裁决时：保留两方，在双方文件都标冲突提示，把裁决留给下一个 agent
   （并附上裁决所需的关键证据线索）。

## 8. 完成一次实验/修复后如何贡献知识

1. **写进模组自己的 `knowledge/`**：本次实验的过程与模组专属结论。
2. **提炼出"游戏本体行为"的部分**，判断属于哪个领域与类型。
3. 按第 6 条格式写入 shared-knowledge 对应位置（facts/discoveries/experiments）。
4. 更新 README 之外的**受影响文件**：如果新发现修正了既有 fact，按第 7 条处理。
5. 在 `mods/<ModName>/state/current-status.md` 里不需要登记（那是模组状态，
   不污染公共库）。
6. 提交 git 时把知识文件与代码改动分开描述（commit message 注明
   "shared-knowledge: <主题>"）。

## 9. 维护原则

- **宁缺毋滥**：一条 verified:true 的 fact 胜过十条 low-confidence 猜测。
- **知识会过时**：game-version 变了、行为变了 → 更新文件并 bump date，
  冲突按第 7 条走。
- **本 README 是契约**：分类规则、metadata、冲突流程有变更时，先更新本文件。
