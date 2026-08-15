# 技术架构（改动前必读）

> 提取自原交接文档 §1-§3。文件位置为 2026-08-15 整理后的新路径。

## 1. 项目概览

**目标游戏**：《Fallout Equestria: REMAINS》（Steam AppID 3908900，作者 Empalu）
**模组功能**：为游戏加入"斯安维斯坦"（《赛博朋克:边缘行者》风格）技能——
按热键触发时间停止，玩家照常行动，彩色残影特效，结束后快速回放玩家操作。

**游戏技术栈**：Adobe AIR 31（`adl64.exe -runtime runtimes\air\win64 <descriptor.xml>`）+ ActionScript 3。
主程序 `pfe.swf`（FWS 未压缩，SWF v41，15MB），另有 `DLC/pfe.swf`（1.03）与
`DLC/pfeUI.swf`（1.04）变体。启动器（`Remains.exe` 内嵌 pfeUI）让用户选择版本后
用 adl64 加载对应描述符（`application.xml`→1.02，`app.xml`→1.03，`app104.xml`→1.04）。

**用户当前玩的版本**：1.02 官方版（根目录 `pfe.swf`）。

## 2. 文件位置

| 路径（相对仓库根 `C:\RemainsMod\`） | 内容 |
|---|---|
| `mods/Sandevistan/src/SandevistanMod.as` | **模组全部逻辑源码**（唯一源码文件） |
| `mods/Sandevistan/src/patch/scripts/MainFE.as` | **游戏补丁源码**（MainFE 文档类补丁，importScript 布局：目录下含 scripts/） |
| `mods/Sandevistan/src/patch/MainFE.original.as` | 原版 MainFE（未打补丁，对照参考） |
| `mods/Sandevistan/src/archive/` | 旧源码/旧构建备份（SandevistanMod.as.bak、SandevistanMod_bak.swf） |
| `game-reference/decompiled/` | 反编译的游戏源码（**公共只读**；映射表见 `game-reference/README.md`） |
| `mods/Sandevistan/build/tools/` | 构建工具链 flexsdk/airsdk/ffdec（**已 gitignore**，需要重新下载） |
| `mods/Sandevistan/release/` | **模组分发物**（部署时复制为游戏目录下的 `SandevistanMod\`） |
| `C:\Program Files (x86)\Steam\steamapps\common\Remains\` | **游戏安装目录**（模组已部署在此） |

游戏目录内的部署物：`SandevistanMod\` 文件夹 + 三个被补丁的 SWF
（`pfe.swf`、`DLC/pfe.swf`、`DLC/pfeUI.swf`，原版备份在 `SandevistanMod\backup\`）。

## 3. 技术架构

### 3.1 注入机制（补丁 + 子域加载）
1. 游戏 SWF 的文档类 `MainFE` 被打补丁（`src/patch/scripts/MainFE.as`）：
   在 `onEnterFrameLoader`（主内容加载完成后）调用 `loadSandevistanMod()`，
   用 **Loader + 子 ApplicationDomain** 加载 `SandevistanMod/SandevistanMod.swf`，
   完成后调用 `SandevistanMod.init(main)`。
2. 模组在**子域**运行：不能访问游戏类的 internal/private 成员（`#1069`），
   不能 hook 游戏类原型；只能访问 **public 成员**（动态 bracket 访问）和
   `flash.utils.getQualifiedClassName` / `describeType`。
3. 补丁方法（对三个版本 SWF 执行同一补丁，MainFE 三版一致）：
   ```
   java -Xmx3g -jar ffdec/ffdec.jar -importScript <原版.swf> <输出.swf> <patch_scripts目录>
   ```
   `importScript` 参数顺序：**输入、输出、脚本目录**（目录内含 `scripts/` 子目录）。
   具体命令见 `build/README.md`。

### 3.2 模组运行时架构（SandevistanMod.as）
- **入口**：`SandevistanMod.init(main)`（静态）→ 注册 ENTER_FRAME / KEY_DOWN / KEY_UP /
  DEACTIVATE / MOUSE_DOWN / MOUSE_UP 监听（**先于游戏 Ctr 注册**，这是事件层拦截的前提）。
- **世界访问**：`world = fe.World.w`（同域类经 `getDefinition("fe.World")` 获取），
  之后全部用 bracket 动态访问 public 成员（`world.onPause`、`world.loc`、`world.gg`、
  `world.ctr`、`world.invent` 等）。
- **时停实现**：`world.onPause = true`（游戏自身机制：`World.step()` 在 onPause 时
  跳过 `land.step()` → 整个世界冻结）；模组每帧手动 `world.loc.gg.step()` 驱动玩家。
  时停结束恢复 `onPause`。
- **回放实现（v1.13+，v1.33 增补）**：时停期间逐帧记录历史
  `{x, y, s(朝向), r(旋转), v(缩放), a/p/g/m(攻击键), ax/ay(瞄准点)}`；
  结束时把玩家 `setPos` 到起点，每帧按 `replayspeed`（默认5）推进历史：
  驱动玩家位置（`X/Y + setVisPos()`）、喂回攻击键（窗口 OR 合并）、
  喂回瞄准（`world.celX/celY`）、强制武器就位（`wv.X/Y = weaponX/weaponY`、
  `wv.rot = atan2(ay-Y, ax-X)`、`wv.ready = true`、`wv.t_attack = 0`）、
  弹匣表演性拉满（`wv.hold = wv.holder`、`wv.t_reload = 0`）。
  回放期间 `godMode = true`（无敌），结束恢复；输入锁定（每帧 `ctr.clearAll()`）。
  **v1.33**：回放开始切回时停开始时的武器（模拟游戏 `changeWeaponNow`），
  回放结束切回时停结束时武器；回放中武器切换无冷却；回放结束恢复弹夹与背包弹药
  到**时停结束时**的状态——弹夹不再被拉满、回放零背包消耗；时停中的弹匣消耗保留真实。
- **残影**：彩虹色调色板（8 色，alpha 由 config 控制），`BitmapData.draw(gg.vis)` 快照
  放入 `world.visual` 内（世界坐标，相机自动跟随）。位置 = `vis.x + getBounds.left`。
- **HUD**：`world.main` 顶层 TextField（Consolas 荧光绿 PipBuck 风格）。
- **选项页设置面板**：检测 `pip.active && currentPage` 类名为 `fe.inter::PipPageOpt`
  时在右侧叠加设置面板（生效时间/冷却，方向键调节，Enter 保存 config.txt）。
- **参数面板**：F9 打开模组内面板（同样调参）。

### 3.3 关键游戏内部机制（反编译所得）
- **SAT/时间**：`World.step()` 中 `allStat==1 && !onPause` 才 `land.step()`。
  玩家由 `Location.step()` 开头 `gg.step()` 驱动；其余实体在 `firstObj` 链表遍历 `obj.step()`。
- **输入**：`fe.inter.Ctr`（`ctr`）——键盘/鼠标监听在 stage；`keyDowns`（按位记录）
  **是 internal**（模组无法访问）；`clearAll()` 只清布尔不清 keyDowns（游戏本体 bug
  之一，但已确认卡键主因是输入法而非此）；键位表 `keyXML`（**public**，模组用它建
  键码→布尔映射 `keyMap`）。
- **卡键真相（已闭环）**：微软拼音默认"按 Shift 切换中英文"——游戏中按 Shift（跑步键）
  把输入法切到中文 → 字母键 KEY_DOWN 被系统层截获（产生 keyCode 229 事件）→ 游戏收不到
  → 按键失效。模组检测 229/UP无DOWN 并 HUD 警告"按 Ctrl+Space 切回英文"。
- **武器**：`Weapon.t_attack/t_reload`（public，攻击/装填计时）、`hold/holder`（弹匣）、
  `rot/drot`（旋转/旋转速度——`drot>0` 渐进旋转，`ready` 就位标志）、`weaponX/weaponY`
  （玩家手上武器位置）、弹药消耗：射击扣 `hold`，弹匣空从 `invent.items[弹药类型].kol`
  补充（**`invent.ammos` 是派生汇总，不可用作快照恢复**）。
- **攻击方向**：`Weapon` 用 `owner.celX/celY`（= `World.w.celX/celY`，鼠标世界坐标，
  由 Camera.calc 每帧从屏幕坐标转换）计算 `atan2` 方向。
- **玩家控制**：`control()` 开头 `if(!ggControl) return;`——`ggControl=false` 时
  移动/攻击/念力全失效（对话/死亡等触发 `controlOff()`）。
