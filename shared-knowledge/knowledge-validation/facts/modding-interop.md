# 模组与游戏运行时交互规则（子域开发约束）

---
domain: knowledge-validation
type: facts
source: Sandevistan mod 长期实践（#1069、internal 静默失败、密封类陷阱）
game-version: 1.02（AIR 31 通用行为）
mod: -
confidence: high
verified: true
date: 2026-08-15
---

## 注入模型

- 模组被游戏文档类（补丁后 MainFE）用 Loader + **子 ApplicationDomain** 加载，
  再调用 `Mod.init(main)`。
- 子域约束：
  - 游戏类的 **internal/private 成员不可访问**（编译期 #1069）；对 internal 的
    **赋值静默失败**（运行时抛异常，常被 try 吞掉）——想改行为只能绕（如禁连爆
    用 remObj 而非改 expl_t）。
  - 不能 hook 游戏类原型；只能调 public 成员（动态 bracket 访问）+ 反射
    （getQualifiedClassName/describeType）。

## 密封类 bracket 访问陷阱（最重要的一条）

- 对**密封类**（Box/Bullet/PhisBullet/SmartBullet/Weapon…）用 `obj["不存在成员"]`
  访问会抛 **ReferenceError #1069**（不是返回 undefined），且**外层 try 整段被吞**
  ——表现为功能静默失效、诊断永不打印（v1.90"回放不重演之谜"即此）。
- 规则：访问任何非 Unit 类成员前先 try/catch 探测布尔（hasX = obj["x"]!=null）再
  分支，或按 getQualifiedClassName 分流；Unit 上的 setPos/setVisPos 等同样先探测。

## 帧/事件时序（拦截按键的唯一正确位置）

- 游戏 ENTER_FRAME 注册先于模组（MainMenu 构造早）→ 模组帧代码永远晚于游戏 step；
- 游戏键盘监听（Ctr）注册晚于模组 → **模组 KEY_DOWN 永远先于游戏**。
- 需要"抢在游戏前处理输入"= KEY_DOWN 层 + stopImmediatePropagation。

## 数据容器语义（快照/遍历前必核对键空间）

- `Invent.items`：**id 键**；`Invent.ammos`：**base 键**（派生汇总，不可做快照恢复）。
- `loc.firstObj`（链，含 Part）vs `loc.objs`（数组，Box）vs `loc.units`——三容器
  互不包含。
- Dictionary 以**对象**为键时迭代顺序不是插入序（"前 N 条"采样不可靠）。

## 引擎侧的"静默兜底"（排查时要想到它们）

- `Grafon.setLight→drawAllObjs` 重建显示层——会抹掉孤儿视觉（正常游戏无鬼影的
  原因），也意味着"视觉在正常游戏没问题"不等于"代码路径正确"。
- `Part.setNull` 不摘 vis——冻结/慢速世界里暴露（见 rendering/）。
- `godMode` 掉血即复位、`clearAll` 不清 keyDowns、expl_t 连爆排定……引擎自带
  大量"在常规节奏下无感、被 mod 改变节奏后现形"的行为。
