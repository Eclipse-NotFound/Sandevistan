# PipBuck / HUD / 界面组件

---
domain: ui-systems
type: facts
source: PipBuck.as/PipPageOpt.as/GUI.as（1.02 反编译）+ Sandevistan mod v1.15/1.67
game-version: 1.02
mod: -
confidence: high
verified: true
date: 2026-08-15
---

## PipBuck（Pip-Boy 面板）

- `pip.active` 打开状态；`currentPage` 为各 `fe.inter::PipPage*` 实例
  （PipPageOpt=选项页、PipPageInv=物品…）。
- 在选项页上叠加自定义设置面板的可靠检测：`pip.active && currentPage 类名==
  "fe.inter::PipPageOpt"`；面板里方向键调参、Enter 写配置文件即可与原 UI 共存。

## 其它

- `gui.setWeapon()`：武器切换后的 HUD 刷新入口（外部模拟 changeWeaponNow 时必调）。
- 血条：`Unit.hpbar`，挂在 sloy=3；炮塔预判死亡可用 `hpbar` 隐藏。
- 顶层 HUD：`world.main` 顶层容器可挂 TextField（模组 HUD 用）。
- 选择器（快捷槽选择 UI）：`visSel`/`unshowSelector(0)`。
