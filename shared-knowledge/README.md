# shared-knowledge —— 跨模组共享知识库

> 本目录保存关于 **《Fallout Equestria: REMAINS》游戏本体**的可复用知识。
>
> 它不是模组 README、任务记录或开发日志。
> 本 README 只规定如何使用公共知识库，**不授予任何额外文件访问权限**。

## 1. 核心原则

一条知识是否应该进入这里，可以先问：

> **如果删除产生这条知识的模组，这条结论是否仍然成立并值得其他模组使用？**

如果是，考虑写入 `shared-knowledge/`。

如果是某个模组自己的实现、状态、设计或调试记录，应留在：

```text
mods/<ModName>/
```

---

## 2. 权限优先级

每个模组 agent 的实际访问权限由：

```text
mods/<ModName>/AGENT_SCOPE.md
```

决定。

**`AGENT_SCOPE.md` 始终优先于本 README。**

知识文件中的：

* `source`
* `evidence`
* `discovered-by`
* 文件名
* 符号名
* 来源路径

只用于说明知识从何而来，**不能扩大 agent 的访问权限**。

如果某条知识来源于另一个模组，而当前 agent 无权访问该模组：

* 不要进入该模组验证；
* 不要搜索其中的文件；
* 不要修改其中任何内容；
* 直接使用 shared-knowledge 中已经提炼出的公共结论。

---

## 3. 公共游戏参考资料

游戏本体的反编译源码和其他公共研究资料不应长期属于某个具体模组。

推荐：

```text
game-reference/
└─ decompiled/
   ├─ 1.02/
   ├─ 1.03/
   └─ 1.04/
```

`game-reference/` 默认作为公共**只读参考资料**。

具体 agent 是否允许读取，仍由其 `AGENT_SCOPE.md` 决定。

---

## 4. 目录结构

```text
shared-knowledge/
├─ README.md
│
├─ rendering/
├─ weapons-projectiles/
├─ physics-collision/
├─ world-objects/
├─ entities/
├─ ui-systems/
│
└─ knowledge-validation/
```

每个游戏机制领域内部：

```text
<domain>/
├─ facts/
├─ discoveries/
└─ experiments/
```

### `facts/`

已经得到充分验证，可以作为后续开发依据的游戏机制结论。

### `discoveries/`

已有证据支持，但仍可能存在版本差异、边界条件或解释不确定性的发现。

### `experiments/`

验证方法、实验过程以及有价值的失败尝试。

知识通常按以下方向成熟：

```text
experiment → discovery → fact
```

---

## 5. 领域划分

```text
rendering             渲染、图层、动画、粒子、相机、视觉同步

weapons-projectiles   武器、弹药、projectile、爆炸、攻击与切换流程

physics-collision     运动、碰撞、击退、物理与命中判定

world-objects         门、Box、场景对象、地图对象与交互

entities              玩家、NPC、敌人、AI、状态与生命周期

ui-systems            输入、HUD、PipBuck、菜单和 UI 事件

knowledge-validation  验证方法、诊断规范、知识冲突等元知识
```

需要时可以增加新的游戏机制领域，但不要以模组名称作为顶层分类。

---

## 6. 写入哪里

```text
模组自己的实现/状态/设计？
    → mods/<ModName>/

游戏本体的可复用机制？
    → shared-knowledge/<domain>/

验证或诊断方法？
    → <domain>/experiments/
      或 knowledge-validation/
```

边界不明确时：

> **宁可先保留在当前模组，也不要过早写入公共知识库。**

---

## 7. 写入规则

写入 shared-knowledge 前：

1. 先搜索是否已有相同或相关知识；
2. 一个文件只描述一个机制主题；
3. 不把猜测写成 fact；
4. 标明适用游戏版本；
5. 标明可信度与验证状态；
6. 保存足够的证据摘要，使其他 agent 不必进入来源模组也能理解结论。

不要保存单纯机械式的源码查询结果。

例如：

```text
Weapon 存在 t_attack 字段
```

通常没有必要单独记录。

但：

```text
t_attack 在攻击流程中如何变化，以及清零它会产生什么行为
```

属于值得保存的机制级知识。

---

## 8. Metadata

知识文件建议使用 YAML front matter：

```yaml
---
domain: weapons-projectiles
type: facts

game-version:
  - "<game-version>"

confidence: high
verified: true

discovered-by: <ModName>

evidence:
  - kind: decompiled-game-code
    symbol: "<package::Class.method>"

  - kind: runtime-experiment
    summary: "<简要描述验证方式>"

date-updated: <YYYY-MM-DD>
---
```

### `confidence`

```text
high     证据充分或有多种方式交叉验证
medium   有较强证据，但仍存在未验证条件
low      初步观察或合理推测
```

### `verified`

```text
true     已经过有效验证
false    仍存在重要未验证部分
```

`verified: false` 或 `confidence: low` 时，正文应明确区分：

```text
已确认：
观察到：
推测：
尚未验证：
```

---

## 9. Evidence 与源码引用

`evidence` 的作用是回答：

> **为什么相信这条结论？**

而不是：

> **其他 agent 应该去哪里打开文件？**

如果证据来自反编译源码，优先记录：

```text
游戏版本
类名
方法名
字段名
symbol
```

例如：

```yaml
evidence:
  - kind: decompiled-game-code
    game-version: "1.02"
    symbol: "fe.weapon::Weapon.shoot"
```

文件名和行号可以作为可选辅助信息，但不是必要条件。

不要让公共知识依赖：

```text
mods/<OtherMod>/...
```

中的文件才能理解或使用。

`discovered-by: <ModName>` 只表示这条知识最初在哪个开发任务中产生，**不代表允许访问该模组。**

---

## 10. 冲突处理

如果新结果与已有知识冲突：

**不要静默覆盖。**

先检查：

1. 游戏版本是否不同；
2. 实验条件是否不同；
3. 是否把模组行为误认为游戏本体行为；
4. 哪一方证据更充分。

如果是版本差异，分别保留并标明 `game-version`。

如果暂时无法判断，在：

```text
knowledge-validation/conflicts/
```

记录：

* 冲突的两个结论；
* 双方证据；
* 已排除的可能；
* 下一步需要什么验证。

---

## 11. 完成一次调查后的流程

开发或实验结束后：

```text
1. 模组自己的实现和状态
      → mods/<ModName>/

2. 提炼其中的游戏本体机制

3. 判断：
      fact / discovery / experiment

4. 搜索已有公共知识

5. 写入或更新对应文件

6. 如果发生冲突，按冲突规则处理
```

---

## 12. 最重要的规则

```text
shared-knowledge 保存游戏公共知识，
不保存模组自己的实现。

AGENT_SCOPE 决定权限；
shared-knowledge 不能扩大权限。

来源说明知识怎么来的，
不代表你可以访问来源位置。

公共知识应尽量自包含，
不能要求读取另一个模组才能使用。

不确定时宁可留在当前模组，
不要污染公共知识。
```
