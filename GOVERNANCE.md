> 【副本说明】本文件是游戏目录侧 GOVERNANCE.md 的副本，权威版本在游戏目录根；重大规则变更需两边同步（见 §9 同步与镜像）。

# Remains 模组工作区治理章程（GOVERNANCE.md）

> 本文件是工作区的**完整治理规则**。常驻上下文的 AGENTS.md 只做定位与红线摘要；
> 需要细则时读本文件。规则冲突时以本文件为准；用户的当前明确指令永远最高。
> 本文件由用户维护，agent 发现内容过时应报告，不得自行修改（见 §12 受保护文件）。

---

## 0. 文档地图

整个治理体系只有以下文件，规则只在本文写一遍，各薄壳不重复规则、只记录参数与偏离：

| 文件 | 角色 | 何时读 |
|---|---|---|
| `AGENTS.md`（游戏根） | 常驻上下文：定位 + 红线 + 指针 | 每个会话自动加载 |
| `GOVERNANCE.md`（本文件） | 完整治理规则 | 涉及权限、知识、记忆、同步、重构时 |
| `mods\<Mod>\AGENT_SCOPE.md` | 模组薄壳：项目参数 + 本模组特例 | 开发某模组前必读 |
| `mods\<Mod>\state\MEMORY.md` | 模组记忆入口（快照） | 接手/继续某模组时第一读 |
| `shared-knowledge\README.md` | 知识库领域索引 + 查找入口 | 查找或贡献公共知识时 |
| `game-reference\README.md` | 参考区结构索引 | 查反编译源码时 |

其余长期资产：`.agents\skills\`（技能，见 AGENTS.md §5 技能表）、`shared-knowledge\`（公共知识库）、`game-reference\`（公共参考区）。治理资产本身由游戏根的白名单 git 仓库管理（只跟踪 AGENTS.md、GOVERNANCE.md、.agents\、.zcode\config.json）。

---

## 1. 权限模型

工作区分为四类区域：

| 区域 | 默认权限 |
|---|---|
| 当前模组目录（`mods\<Mod>\`） | **READ-WRITE** |
| `shared-knowledge\` | **READ + 谨慎 WRITE**（§4） |
| `game-reference\` | **REFERENCE-ONLY**（§5） |
| 游戏原始文件（SWF、DLC 等） | **READ-ONLY**，修改需用户明确授权（§6） |
| 其他模组 | **默认不访问；必要时最小范围只读；绝不写**（§7） |
| 未知或未说明目录 | **默认不修改** |

无法判断权限时采用更严格的解释。**不要自行扩大工作范围。**

### 1.1 受保护文件

以下文件即使位于可写区域也默认 READ-ONLY，仅当用户明确要求修改时才可编辑：

- `AGENTS.md`、`GOVERNANCE.md`（游戏根）
- 各 `mods\<Mod>\AGENT_SCOPE.md`
- `shared-knowledge\README.md`、`game-reference\README.md`
- `D:\RemainsMod\sync-to-game.bat`

发现规则不合理时向用户说明，而不是改规则扩大权限。

---

## 2. 当前模组：READ-WRITE

允许：创建修改源码与测试代码、改构建脚本、生成构建产物、整理模组内部目录、更新设计/决策/状态/知识文档、创建发布文件。

典型结构：

```text
<workspace>/
├─ AGENT_SCOPE.md        薄壳（参数 + 特例，规则见本章程）
├─ src/                  源码
├─ build/                构建脚本与中间产物（可再生的不入 git）
├─ release/              游戏运行时加载的部署点（路径是硬契约，见 AGENTS.md §3）
├─ knowledge/            模组专属知识（facts / discoveries / experiments）
├─ design/               架构与功能设计
├─ decisions/            重要技术决策（记"为什么"，含 changelog 若有）
└─ state/
   ├─ MEMORY.md          记忆入口（§8 外置记忆协议）
   └─ journal.md         开发日志（只追加，新条目插最上）
```

不是所有模组都齐全到这个程度；以实际为准，缺的按本章程逐步补齐。

---

## 3. 模组知识与公共知识的边界

判断一条知识该放哪，只问一个问题：

> **如果删除产生这条知识的模组，这条结论是否仍然成立并值得其他模组使用？**

- 是 → `shared-knowledge\<domain>\`（§4）
- 否（模组自己的实现、状态、设计、调试记录）→ `mods\<Mod>\` 内对应目录

边界不明确时，**宁可留在当前模组，不要过早写入公共库。**

---

## 4. shared-knowledge：READ + 谨慎 WRITE

保存**游戏本体**的跨模组可复用知识。开始重新研究某个游戏机制前先搜索已有内容，避免重复逆向。

### 4.1 目录结构

```text
shared-knowledge/
├─ rendering/  weapons-projectiles/  physics-collision/
├─ world-objects/  entities/  ui-systems/
└─ knowledge-validation/        # 元知识：验证方法、诊断规范、知识冲突、跨模组协调注册表
```

每个领域内部：

```text
<domain>/
├─ facts/          已充分验证、可作后续开发依据的结论
├─ discoveries/    有证据但存在版本差异/边界条件/不确定性的发现
└─ experiments/    验证方法、实验过程、有价值的失败尝试
```

知识成熟方向：`experiment → discovery → fact`。方法论类放 `knowledge-validation\methods\`，冲突记录放 `knowledge-validation\conflicts\`，跨模组资源占用（热键/日志名/SharedObject 名）登记在 `knowledge-validation\coordination\registry.md`。

领域划分：rendering（渲染/图层/动画/粒子/相机）、weapons-projectiles（武器/弹药/爆炸/切换）、physics-collision（运动/碰撞/击退/命中）、world-objects（门/Box/场景对象/交互）、entities（玩家/NPC/敌人/AI/生命周期）、ui-systems（输入/HUD/PipBuck/菜单）。可增新领域，但**不以模组名作顶层分类**。

### 4.2 写入规则

1. 先搜索是否已有相同/相关知识；
2. 一个文件只描述一个机制主题；
3. 不把猜测写成 fact；
4. 标明适用游戏版本；
5. 标明可信度与验证状态；
6. 保存足够的证据摘要，使其他 agent **不必进入来源模组**也能理解结论。

不保存机械式源码查询结果（"Weapon 有 t_attack 字段"没必要记）；要记的是机制级结论（"t_attack 在攻击流程中如何变化、清零会怎样"）。

### 4.3 Metadata（YAML front matter）

```yaml
---
domain: weapons-projectiles
type: facts
game-version:
  - "1.02"
confidence: high        # high=证据充分/多方式交叉验证；medium=较强证据有未验证条件；low=初步观察
verified: true
discovered-by: <ModName>
evidence:
  - kind: decompiled-game-code
    game-version: "1.02"
    symbol: "fe.weapon::Weapon.shoot"
  - kind: runtime-experiment
    summary: "简要描述验证方式"
date-updated: <YYYY-MM-DD>
---
```

`verified: false` 或 `confidence: low` 时正文必须区分：**已确认 / 观察到 / 推测 / 尚未验证**。

### 4.4 Evidence 与源码引用

evidence 回答"**为什么相信这条结论**"，不是"去哪里打开文件"。来自反编译源码优先记：游戏版本、类名、方法名、字段名、symbol（如 `fe.weapon::Weapon.shoot`）。文件名与行号只是辅助。

**公共知识必须自包含**：不能要求读取 `mods\<其他模组>\` 的文件才能理解或使用。`discovered-by` 只表示来源，**不代表允许访问该模组**——知识文件中的 source/evidence/路径均不扩大权限。

### 4.5 冲突处理

新结论与已有知识冲突时**不要静默覆盖**，先检查：游戏版本是否不同（分别保留并标 game-version）、实验条件是否不同、是否把模组行为误认为本体行为、哪方证据更充分。无法判断时记入 `knowledge-validation\conflicts\`：两个结论、双方证据、已排除的可能、下一步验证。

---

## 5. game-reference：公共只读研究资料

```text
game-reference/decompiled/
├─ 1.02/   # 实际游玩版本：src102=完整反编译（查机制首选）；另有 src_pfe~src_pfe4 历史补全副本、src_frame 视觉参考
├─ 1.03/   # 仅 MainFE
└─ 1.04/   # 仅 MainFE
```

- **允许**：搜索、阅读、版本比较、类/字段/调用关系分析（grep 首选 `1.02\src102`）。
- **禁止**：修改这些资料来"修复游戏"；把模组代码写入其中；视为模组源码。
- 新的反编译结果输出到当前模组自己的 `build\`，由用户决定是否纳入本目录。

---

## 6. 游戏文件：READ-ONLY

游戏安装文件与原始资源是研究对象，不是开发工作区。允许查看、分析 SWF、读配置、比版本；**禁止**删除原始文件、永久覆盖原始资源、为实验直接改原版文件。

修改游戏文件的唯一正当形态是**给 MainFE 追加模组 loader 段**（用 FFDec 定向单脚本替换，完整流程与安全纪律见 `remains-swf-patching` 技能），且必须有用户明确授权。修改前自动备份、幂等、锚点失配即中止。游戏 SWF 可能被 Sandevistan 同步覆盖（§9），loader 丢失时重跑补丁即可恢复。**除非用户明确要求部署，否则不主动覆盖游戏安装目录。**

---

## 7. 其他模组：隔离原则

`mods\` 下的其他目录属于独立项目。默认不读取。绝对禁止未经授权：修改源码、修 bug、改配置、格式化、重构、移动删除文件、改其 knowledge/design/decisions/state、"顺手"改进。

**核心原则：一个模组开发任务默认只能修改自己的模组。**

仅当当前任务确实要求时（用户要求比较两模组、处理跨模组兼容、调查直接冲突、用户明确授权参考），才可最小范围 READ-ONLY 读取。shared-knowledge 说"这条知识来自某模组"**不是**进入该模组的理由；确需进入时向用户说明：需要访问的位置、读什么、为什么公共知识不足、是否要改，由用户决定。

---

## 8. 外置记忆协议

目标：**新对话零补充说明即可接手某模组**。每个模组的记忆由四层构成，各司其职：

| 层 | 位置 | 性质 | 记什么 |
|---|---|---|---|
| 快照 | `state\MEMORY.md` | 随时重写 | 现在在哪、正在做什么、下一步（§8.1 模板） |
| 日志 | `state\journal.md` | 只追加（新条目插最上） | 开发历程：每轮做了什么、决定指针、遗留 |
| 原因 | `decisions\` | 追加为主 | 为什么这样设计（ADR，含 changelog 若有） |
| 实证 | `knowledge\` / `design\` | 按主题 | 游戏机制结论 / 模组设计 |

### 8.1 MEMORY.md 标准模板（七节）

```text
1. 这个模组是什么（3-5 句：核心体验/主要功能/技术形态/入口类名）
2. 用户偏好与协作约定（怎么测、怎么沟通、什么不能自动做）
3. 当前状态（版本、可玩性、最近验证时间、git 位置）
4. 正在进行与卡点
5. 已知问题
6. 下一步（优先级排序）
7. 深入了解（指针：journal 近期条目、changelog、关键 decisions、design、构建/部署/测试方式）
```

### 8.2 journal.md 条目格式（新条目插在最上面）

```text
## YYYY-MM-DD <主题一句话>
- 做了什么：
- 关键决定/发现：（指针到 decisions\ 或 knowledge\ 的文件）
- 遗留/下一步：
```

### 8.3 更新纪律

- **会话开始**：读当前模组 AGENT_SCOPE.md → `state\MEMORY.md` → 需要时 journal 最上 3 条。
- **会话结束或里程碑**：重写 MEMORY.md 对应小节 + journal 顶部插入一条。发布时此项并入 `remains-release-gate` 门禁。
- journal 只追加不改写；历史修正通过新条目说明。MEMORY.md 随时可以整节重写。
- **内容归属**：journal 记"发生了什么"；"为什么"→ decisions；"机制实证"→ knowledge 或 shared-knowledge；"设计"→ design。不要把大段内容复制进 journal——写指针。
- 涉及游戏本体的新结论，调查结束后按 §3/§4 提炼进 shared-knowledge（配合 `remains-knowledge-contribution` 技能）。

---

## 9. 同步与镜像（Sandevistan 仓库）

本工作区与源仓库 `D:\RemainsMod`（git，master）通过 `D:\RemainsMod\sync-to-game.bat` 单向同步（SRC → GAME）：

| 子树 | 模式 | 语义 |
|---|---|---|
| `mods\Sandevistan` | robocopy `/MIR`（排除 `build\`、`release\config.txt`） | **全镜像**：SRC 没有的文件会被从 GAME 删除 |
| `shared-knowledge` | robocopy `/E` | **加法**：不删除 GAME 侧独有文件，但**同名文件会被 SRC 版覆盖** |
| `game-reference` | robocopy `/E` | 同上 |
| 游戏根目录文件 | 不同步 | AGENTS.md、GOVERNANCE.md、技能等无覆盖风险 |

规则：

1. **Sandevistan 的修改一律在 `D:\RemainsMod` 侧做并 commit，再同步**。唯一例外 `release\config.txt`（游戏内 F9 面板直写，同步脚本不覆盖）。游戏目录侧的 `mods\Sandevistan\` 是镜像，不是工作副本。
2. **同步范围内的同名文件两边必须保持一致**（尤其 `shared-knowledge\README.md`、`game-reference\README.md`、`mods\Sandevistan\AGENT_SCOPE.md`）——修改它们时两边同步改、SRC 侧 commit，否则下次同步会把一边的修改静默覆盖。
3. `GOVERNANCE.md` 在 `D:\RemainsMod` 根有一份副本（头部标注权威版在游戏目录侧）；重大规则变更需两边同步。
4. 游戏 SWF（pfe.swf、`DLC\pfe.swf`、`DLC\pfeUI.swf`）是打补丁的部署产物，可能被同步流程更新/覆盖——loader 段丢失时按 `remains-swf-patching` 重跑补丁恢复，不是故障。

---

## 10. 文件移动与重构

agent 可以整理当前模组内部目录，但移动已有文件前必须检查：构建脚本、import/include、配置、文档链接、部署脚本、相对路径、release/installer 路径。不为整齐而破坏构建/部署/运行/调试。

对 `shared-knowledge\`、`game-reference\`、游戏原始文件、其他模组：**不做大规模移动、删除、重命名，除非用户明确要求。**

---

## 11. 遇到越界问题

发现其他模组 bug、必须改游戏原始文件、shared-knowledge 需大规模调整、问题属于另一项目、修复需跨模组重构、权限不足以验证关键结论时——不要自行扩大范围。向用户说明：发现、原因、影响、需要访问或修改的位置、建议、为什么没有直接改。然后继续完成不依赖越权操作的部分。

---

## 12. 每次开始开发阶段的顺序

```text
1. 读 mods\<Mod>\AGENT_SCOPE.md（薄壳）
2. 读 state\MEMORY.md（记忆入口）
3. 读相关 design\ 与 decisions\
4. 搜索 shared-knowledge\
5. 必要时读 game-reference\
6. 修改当前模组
7. 测试（remains-auto-testing / remains-runtime-debug）
8. 更新 MEMORY.md + journal.md（§8.3）
9. 提炼可复用知识进 shared-knowledge
```

不要重新询问文档中已明确记录的信息。

---

## 13. 最终规则

```text
当前模组            → 可以修改
shared-knowledge    → 可以读取，谨慎贡献
game-reference      → 公共只读研究资料
游戏原始文件        → 默认只读；改 loader 需用户授权
其他模组            → 默认不访问；必要时最小范围只读；绝不修改
知识来源            → 不等于访问授权
记忆                → 会话开始读 MEMORY，结束写 MEMORY + journal
Sandevistan         → 改 D:\RemainsMod 源仓库，再同步
未知范围            → 默认不修改
```

用户当前明确指令可以扩大或缩小这些权限。**agent 自己不能推断权限已经扩大。**
