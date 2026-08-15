# 世界对象容器与链

---
domain: world-objects
type: facts
source: Location.as/Obj.as（1.02 反编译）+ Sandevistan mod v1.69/1.90
game-version: 1.02
mod: -
confidence: high
verified: true
date: 2026-08-15
---

## 三个容器，别混

- `loc.firstObj`：**对象链**（`nobj` 指针）——单位、武器/抛射物、粒子（Part）都在这条
  链上；`Location.step()` 遍历它调用 `obj.step()`。
- `loc.objs`：**数组**——Box（箱子/门）等场景对象在这里，**不在 firstObj 链**上
  （v1.69：遍历 firstObj 永远找不到 Box）。
- `loc.units`：单位集合（budilo 警报、范围伤害等遍历它）。

## 出链与存在性

- `loc.remObj(obj)`（public）：从 firstObj 链移除（vse 流程）；对象有 `in_chain`
  标志反映是否在链上。
- 死亡/移除后的对象视觉：`Obj.vse→remVisual` 摘除 vis（**注意：Part 例外**，见
  rendering/facts/part-lifecycle.md）。

## 密封类 bracket 访问陷阱（关键）

- `setPos/setVisPos` **仅 Unit 拥有**；对密封类（Box/Bullet/PhisBullet/SmartBullet）
  用 `obj["setPos"]` 访问不存在成员会抛 **ReferenceError #1069**（不是返回 undefined），
  且通常把外层 try 整段吞掉——表现为"整段逻辑静默失效+诊断永不打印"。
- 规则：访问任何非 Unit 类的成员前，先 try/catch 探测布尔（hasSP/hasSVP）再分支；
  或先 `getQualifiedClassName` 分流。public 成员 bracket 访问本身没问题。

## Box/门

- 门 = `Box.door>0`；开关走 `setVisState("open"/"close")`（门形象=Box 自身 vis 的
  open/close 帧）；门框瓦片用 `tiles[].opac/t_visi/visi` 淡出（两套视觉路径并存）。
- 投掷的箱子：`t_throw>0` 期间只打晕（neujaz），过期后 udarBox 结算撞毁。
