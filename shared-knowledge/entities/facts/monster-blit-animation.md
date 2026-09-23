---
domain: entities
type: facts

game-version:
  - "1.02"

confidence: high
verified: true

discovered-by: Sandevistan

evidence:
  - kind: decompiled-game-code
    symbol: "fe.unit::UnitZombie.animate; fe.unit::UnitMonstrik.animate; fe.unit::Unit.blit"
  - kind: runtime-experiment
    summary: "Sandevistan v1.71-1.132 敌人回放实测：贴图怪在回放中偶发僵死；按位移喂 dx+补 animate() 后恢复"

date-updated: 2026-09-23
---

## 2026-09-23 限定与补充（1.02）

下文关于 internal 计数不可访问仍成立；“唯一公开驱动入口是 animate”“无法逐帧录像”不再成立。`Unit.blitData` 是公开原始精灵图，`Unit.initBlit` 把实际身体 Bitmap 放入 `vis` 的子容器；`Unit.blit(row, frame)` 也是 public。因此可以把当前身体像素与原图分块精确匹配，只记录行/列，再通过 blit 重绘，完全不读 internal 的 anims/visData/visBmp。

UnitRaider 和 UnitZombie 都是这个结构；马形不代表 `osn.body` 的 MovieClip 动画。按位移猜动作还有采样陷阱：世界每 5 帧才走一步而录像每帧记录时，idx 与 idx+1 经常同位置，推导 dx=0 会把移动体画成 stay。扩大取样间隔只能恢复动作变化，无法保证录像姿态/相位一致。

本机 1.02/AIR 实证：两个真实类、生产记录/回放路径，原实现均 30 个回放采样仅有 1 种身体画面；记录真实精灵图坐标后，在 1/3/5/8/20 倍、走停腾空与转向、正常 AI 步进合计 12 组中 574/574 采样帧逐像素一致。尸体不覆盖生前姿态的 12 项保护通过。条件只覆盖这些单位与用例，未验证全部动画素材/所有怪物；未知或非原图的视觉应保持原处理。匹配须校验完整像素，稀疏采样只能筛选候选；不要每个历史帧保存一份 BitmapData，更不可 dispose 游戏共享图。

源码证据：`fe.unit::Unit.initBlit/blit`、`UnitRaider.animate`、`UnitZombie.animate`。以下旧实验记录保留，作为当时驱动方案的适用条件而非排他的实现上限。

## 怪物贴图动画架构（Blit 动画）

僵尸（UnitZombie）、辐射蝎等怪物（UnitMonstrik）不使用 MovieClip 身体动画，
而是**贴图（blit）动画**：

- 每个怪物持有一张 `anims` 表：`anims[animState]` → `BlitAnim`
  （internal，模组读不到）。状态名示例：`stay / walk / trot / run / jump /
  attack / die / death / pre / super / dig / plav`。
- `animate()` 每帧：根据 `stay`、`dx`、`aiState`、`sost` **重新推导
  animState**（如：stay 且 dx≈0 → "stay"；dx>6 → "trot"；aiState==3 → "run"），
  状态变化时 `anims[s].restart()`；然后 `anims[s].step()` 推进内部帧 f、
  `blit(anims[s].id, f)` 把纹理块画到 vis。
- **帧号不可读**：`vis.osn.body.currentFrame` 对这类怪物恒为 -1（没有 MC
  身体）——不要像小马类那样做逐帧录像，唯一公开驱动入口是 `animate()`。

## 关键陷阱：位置钉住 → AI 停步 → 动画僵死

- `animState` 每帧由 `stay`/`dx` 重新推导。任何把怪物**位置钉死**的重放/
  慢放机制都会让控制层算出 `dx≈0`（AI 认为已到达目标），于是 animate()
  恒走 "stay" 且 `anims["stay"].st==true`（非循环态）——**贴图不再推进，
  怪物原地定住**（表现为"回放中尸鬼/蝎子动画僵死"）。
- 修复模式：按记录位移折算 `dx`/`dy`（public）喂给怪物后再调一次
  `animate()`，动画即按真实移动档位（run/trot/walk）重现；步后仍需重钉
  位置（step 内 run() 会真移动）。
- 同帧内 AI 的 `control()` 会重算 dx，所以喂入是瞬时值（每帧都要喂）。

## 衍生事实

- `UnitZombie extends UnitPon`（小马形僵尸），但 animate 重写为 blit；
  僵尸的 `vis` 是承载 `visData` BitmapData 的容器，`vis.visible` 由 aiState==5
  分支控制（见 unit-zombie-burrow.md）。
- UnitMonstrik 按 `cid` 区分品种（scorp/肉食灵等共用一套 `anims` 状态机），
  aiState 0/1/2/3 对应潜伏/移动/攻击等，无 burrow/vis.visible 隐藏。
