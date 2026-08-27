# game-reference —— 公共只读研究资料

> 反编译源码等公共研究资料。**REFERENCE-ONLY / READ-ONLY**（规则见工作区根目录 `GOVERNANCE.md` §5）。

## 目录

```text
game-reference/
└─ decompiled/          反编译源码（ffdec 输出，只读参考）
   ├─ 1.02/             实际游玩版本
   │  ├─ src102/        完整反编译（全量类——查机制 grep 首选）
   │  ├─ src_pfe~src_pfe4/  历史补全副本（部分类缺失/重叠）
   │  └─ src_frame/     视觉截图参考
   ├─ 1.03/             仅 MainFE（src_103 原版 / src_103v2 Steam 更新后）
   └─ 1.04/             仅 MainFE（src_104 / src_104v2）
```

## 使用

- **允许**：搜索、阅读、版本比较、类/字段/调用关系分析。
- **禁止**：修改这些资料来"修复游戏"；把模组代码写入其中；视为模组源码。
- 新的反编译结果输出到当前模组自己的 `build\`，由用户决定是否纳入本目录。
- 知识文件引用源码证据用 symbol（如 `fe.weapon::Weapon.shoot`）而非路径，详见 GOVERNANCE §4.4。
