# game-reference —— 公共只读研究资料

> 本目录保存不属于任何具体模组的游戏研究资料（反编译源码、结构导出等）。
> 默认 **REFERENCE-ONLY / READ-ONLY**（见 `mods/Sandevistan/AGENT_SCOPE.md` §4）。

## 目录

```
game-reference/
└─ decompiled/          反编译源码（ffdec 输出，只读参考）
   ├─ 1.02/             游戏版本 1.02（用户当前游玩的版本）
   │  ├─ src102/        完整反编译（含 fe.weapon::Weapon/Bullet/Part、AllData.as 等
   │  │                 全量类——**查机制首选**；未入库 git，可重新反编译生成）
   │  ├─ src_pfe/       另一份完整反编译（部分 weapon 类缺失，已入库）
   │  ├─ src_pfe2/      关键类补全（unit: Unit/UnitPlayer/Mine/VirtualUnit；
   │  │                 weapon: Weapon/Bullet/PhisBullet/SmartBullet/WClub/WThrow/WMagic/…）
   │  ├─ src_pfe3/      再一版（Unit/UnitPlayer/Weapon）
   │  ├─ src_pfe4/      MainFE
   │  └─ src_frame/     视觉截图参考（未入库）
   ├─ 1.03/             游戏版本 1.03（DLC/pfe.swf）
   │  ├─ src_103/       MainFE（原版）
   │  └─ src_103v2/     MainFE（Steam 更新后）
   └─ 1.04/             游戏版本 1.04（DLC/pfeUI.swf）
      ├─ src_104/       MainFE（原版）
      └─ src_104v2/     MainFE（Steam 更新后）
```

## 使用规则

- **允许**：搜索、阅读、比较版本、分析类/字段/调用关系（grep 首选 `1.02/src102`）。
- **禁止**：修改这些资料来"修复游戏"；把模组代码写入其中；将其视为模组源码。
- 需要新的反编译结果时，输出到当前模组自己的 `build/` 或临时目录，由用户决定
  是否纳入本目录。
- 知识文件引用源码证据时用 symbol（如 `fe.weapon::Weapon.shoot`）而非路径，
  详见 `shared-knowledge/README.md` §9。
