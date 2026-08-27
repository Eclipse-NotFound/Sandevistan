# shared-knowledge —— 跨模组共享知识库

> 保存关于**《Fallout Equestria: REMAINS》游戏本体**的可复用知识。
> 完整规则（写入规范、frontmatter、evidence、冲突处理、权限边界）见工作区根目录 `GOVERNANCE.md` §3–§4。
> 本 README 只做领域索引与查找入口。

## 快速判断：一条知识放哪？

> **删除产生这条知识的模组后，这条结论是否仍然成立并值得其他模组使用？**

是 → 本库对应领域；否 → `mods\<ModName>\`；不确定 → 宁可留在模组内，不过早入公共库。

## 领域索引

| 领域 | 覆盖 |
|---|---|
| `rendering/` | 渲染、图层、动画、粒子、相机、视觉同步 |
| `weapons-projectiles/` | 武器、弹药、projectile、爆炸、攻击与切换流程 |
| `physics-collision/` | 运动、碰撞、击退、物理与命中判定 |
| `world-objects/` | 门、Box、场景对象、地图对象与交互 |
| `entities/` | 玩家、NPC、敌人、AI、状态与生命周期 |
| `ui-systems/` | 输入、HUD、PipBuck、菜单和 UI 事件 |
| `knowledge-validation/` | 元知识：验证方法（methods/）、诊断规范、知识冲突（conflicts/）、跨模组资源注册表（coordination/） |

每个领域内部：`facts/`（已验证结论）→ `discoveries/`（有证据待稳定）→ `experiments/`（过程与失败尝试）。
知识成熟方向：experiment → discovery → fact。可增新领域，但**不以模组名作顶层分类**。

## 使用要点（细则见 GOVERNANCE.md §4）

- 写入前先搜索已有知识；一个文件一个主题；不把猜测写成 fact；标 game-version 与 confidence/verified。
- 公共知识必须自包含——不得要求读取 `mods\<其他模组>\` 的文件才能理解或使用。
- `discovered-by` / `source` / `evidence` 只说明来源，**不授予任何访问权限**。
- 与已有知识冲突时不要静默覆盖，走 GOVERNANCE §4.5 冲突流程。
- 占用跨模组共享资源（热键、日志文件名、SharedObject 名等）先登记 `knowledge-validation\coordination\registry.md`。
