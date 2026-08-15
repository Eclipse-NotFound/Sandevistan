---
domain: ui-systems
type: facts

game-version:
  - "1.02"

confidence: high
verified: true

discovered-by: Sandevistan

evidence:
  - kind: decompiled-game-code
    symbol: "fe.inter::Ctr / MainMenu.mainStep"
  - kind: runtime-experiment
    summary: "Sandevistan v1.4-1.11/1.104（IME 229 卡键、事件层时序：模组 KEY_DOWN 先于 Ctr）"

date-updated: 2026-08-15
---


## Ctr

- `fe.inter.Ctr`：键盘/鼠标监听注册在 stage；`keyDowns` 是**按位记录的 internal
  数组**（模组永远读不到/清不掉）；`clearAll()` 只清布尔键状态**不清 keyDowns**
  （游戏本体 bug 之一）。
- 键位表 `keyXML`（public）：可用它建 键码→布尔成员名 映射（如 keyWeapon1..12、
  keyRun、keyJump、keySit、keyAction、keyGrenad、keyMagic…）。

## 事件层时序（关键，直接决定拦截方案）

- 游戏主循环：`MainMenu.mainStep` 挂 **ENTER_FRAME**——在 MainMenu 构造时注册
  （MainMenu 在模组加载前创建）→ **游戏 World.step 永远先于任何后注册的
  ENTER_FRAME 模组代码**。帧层"先于游戏处理按键"不可能。
- 游戏 `Ctr` 在 World 构造（进游戏）时才注册键盘监听；模组在 init（游戏加载时）
  注册 → **模组 KEY_DOWN 先于游戏 Ctr**。
- 结论：需要"抢在游戏前面处理按键"必须放 KEY_DOWN 层，并
  `stopImmediatePropagation()`（游戏 Ctr 完全收不到该键，keyDowns 不置位）。

## 中文输入法（IME）卡键

- 微软拼音默认"按 Shift 切换中英文"——游戏内按 Shift（跑步）切到中文后，字母键
  KEY_DOWN 被系统层截获（产生 keyCode 229 事件），游戏收不到=按键失效。
- 检测：收到 229 事件、或 KEY_UP 无对应 DOWN；短窗口 ≥2 次 229 才告警
  （单次 229 是正常切换）；提示"Ctrl+Space 切回英文"。
