# 迁移备份：疾跑中切枪（swaprun）+ 手雷击落（projhits）

> 本目录保存 **v1.126 迁移前的完整源码备份**：
> - `SandevistanMod.as.bak.v1.126` —— 迁移前整个模组源码（290610 字节，git v1.126 = bc4a9b9）
> - 本文件 —— 两个被迁移技能的可读源码摘录 + 说明
>
> 2026-08-17 起，这两个技能的**实际运行实现已迁移到**
> `mods/MoreSkills&Weapons/`（见该模组 `state/MIGRATION-Sandevistan-swaprun-projhits.md`）。
> Sandevistan 侧已停用（config 键失效、默认关闭、面板行移除），
> 此处源码仅作备份与对照，**不是游戏实际加载的实现**。

## 1. 迁移了什么

| 技能 | Sandevistan 版本 | 迁移目标 |
|---|---|---|
| 疾跑中切枪（swaprun） | `SandevistanMod.as:5661-5694`（v1.100 引入，v1.104 改事件层） | `mods/MoreSkills&Weapons/src/MSWSwaprun.as` |
| 手雷击落（projhits） | `SandevistanMod.as:1767-2147`（v1.83 引入，v1.114 按武器覆盖） | `mods/MoreSkills&Weapons/src/MSWProjHits.as` |

## 2. 疾跑中切枪（swaprun）源码（v1.126）

位于原 `onKey()`（KEY_DOWN 事件层，先于游戏 Ctr 注册）：

```as
         // v1.104：疾跑中切枪（swaprun）——事件层拦截。游戏 World.step 挂在
         // MainMenu.mainStep 的 ENTER_FRAME 上（先于模组注册，MainMenu 在模组
         // 加载前创建）——v1.100 的 onFrame 拦截永远晚于游戏按键处理（游戏
         // control() 先按第二组快捷槽消费按键，实测无 swapRun 日志）；而模组
         // 的 KEY_DOWN 先于游戏 Ctr 注册（Ctr 在 World 构造时才注册）。此处
         // 直接消费按键+useFav 第一组槽位，并 stopImmediatePropagation 阻止
         // 游戏 Ctr 收到该键（防第二组槽重复处理）。
         try
         {
            if (cfgSwapRun && !replaying && !panelOpen && world != null && world.ctr != null
                && world.ctr.keyRun && e.keyCode > 0 && e.keyCode < 256)
            {
               var kbS:* = keyMap[e.keyCode];
               if (kbS != null && String(kbS).indexOf("keyWeapon") == 0 && inGameplay())
               {
                  var wnS:int = parseInt(String(kbS).substr(9));
                  if (wnS >= 1 && wnS <= 10)
                  {
                     e.stopImmediatePropagation();
                     try { world.invent.useFav(wnS); } catch (e2:*) { }
                     try { if (world.gg.visSel) { world.gui.unshowSelector(0); } } catch (e2:*) { }
                     try { if (world.gg.currentSpell != null) { world.gg.currentSpell.active = false; } } catch (e2:*) { }
                     try { world.ctr.keyDef = false; world.ctr.keyAttack = false; } catch (e2:*) { }
                     if (cfgDiagLog && swapRunDiagCnt < 6)
                     {
                        swapRunDiagCnt++;
                        log("[DIAG] swapRun: key=" + wnS + " run=" + world.ctr.keyRun);
                     }
                     return;
                  }
               }
            }
         }
         catch (e2:*) { }
```

依赖的 `keyMap` 由 `buildKeyMap()`（原 122-147 行）从 `world.ctr.keyXML`（public）
建立"键码 → 布尔名"映射（`keyMap[code] = id`，id 形如 `keyWeapon1`），
换挡槽位号 = `id.substr(9)` 的数字部分（1-10 = 第一组快捷槽）。

`inGameplay()`（原 688-704 行）判定可操作状态：

```as
      private function inGameplay():Boolean
      {
         if (world == null) return false;
         try
         {
            if (world.allStat < 1) return false;
            if (world.gg == null || world.loc == null) return false;
            if (world.onConsol) return false;
            if (world.pip != null && world.pip.active) return false;
            if (world.sats != null && world.sats.active) return false;
            if (world.stand != null && world.stand.active) return false;
            if (world.gui != null && world.gui.guiPause) return false;
            return true;
         }
         catch (e:*) { return false; }
         return false;
      }
```

## 3. 手雷击落（projhits）源码（v1.126）

`stepProjHits()`（原 1767-2147 行）完整逻辑。关键字段：

```as
      private var cfgProjHits:Boolean = true;   // 投掷物可被击落（手雷/导弹/榴弹受击至 0 爆炸）
      private var cfgProjHp:Number = 30;        // 投掷物血量
      private var cfgProjArmor:Number = 0;      // 投掷物护甲（预留接口：伤害先减护甲）
      private var projHp:Dictionary = new Dictionary();  // 投掷物 → 当前血量
      private var projHpOver:Object = null;     // v1.114：按武器 id 的血量覆盖（projhp_<id>）
      private var projArmorOver:Object = null;  // v1.114：按武器 id 的护甲覆盖（projarmor_<id>）
```

config 键：`projhits`（布尔）、`projhp`（默认 30，1-1000）、`projarmor`（默认 0，0-500）、
`projhp_<武器id>` / `projarmor_<武器id>`（按武器覆盖，v1.114）。

核心流程（常规模式，`isSandy=false` 且非回放）：

```as
      // 1. 收集：
      //    projs = 可击落投掷物：PhisBullet / SmartBullet / Bullet 且 explRadius>0 且 !isExpl
      //    objs  = 攻击体：其它 fe.weapon::* 且 vel>=1（近战 vel=0 不参与，v1.90）
      // 2. 清理已消失投掷物的血量记录（projHp 中不在 projs 表里的删除）
      // 3. 双重循环 p×b 判定：
      //    - b==p 跳过（v1.92 自测防护）
      //    - b.owner==p.owner 且投掷物距其 owner<200px → 跳过（v1.91 出生护手）
      //    - 相对速度扫掠碰撞（v1.92）：
      //        sx=b.X-b.dx, sy=b.Y-b.dy; pdx=p.dx, pdy=p.dy
      //        起点差 ddx0=sx-(p.X-pdx), ddy0=sy-(p.Y-pdy)
      //        |起点差|<=28 → 命中；否则 R(t)=O+t·RV, RV=b.dx-pdx, t∈[0,1] 最近点<=28 → 命中
      //    - dmg = b.damage（时停中玩家子弹伤害被清零 → origDam 恢复，Sandy 专属）
      //    - dmg -= 护甲（cfgProjArmor 或 projArmor_<id>）；dmg<=0 跳过
      //    - locP.remObj(b)（命中子弹弹出）
      //    - hpP = projHp[p] ?? (cfgProjHp 或 projhp_<id>)；hpP -= dmg
      //    - hpP<=0：爆炸。
      //        常规：p.explosion() + p.liv=0（防爆炸后继续沿轨迹飞行鬼影）
      //        时停：仅视觉（damageExpl/destroy 清零爆炸后恢复）+ projBoom 记录回放帧（Sandy 专属）
      //    - 否则 projHp[p] = hpP
      //    - 命中后 break（一颗子弹只判一个投掷物）
```

时停/回放专属部分（**不随迁移**，留在 Sandevistan）：
- 时停模式：`isSandy=true` 时爆炸仅视觉 + `projBoom` 记录（回放对应帧真实爆炸）
- 回放模式：`replaying` 时 projBoom 重演（真实爆炸结算）
- `origDam`（时停中玩家子弹伤害快照恢复）
- `seenAtk`（攻击体追踪器，投掷物收集的优先来源）

这些依赖斯安维斯坦的时停/回放系统，MoreSkills&Weapons 无此系统，故只迁移常规模式核心。

## 4. 停用方式（Sandevistan v1.127 起）

- `cfgSwapRun`/`cfgProjHits` 默认改 `false`；
- config.txt 解析分支（projhits/projhp/projarmor/projhp_*/projarmor_*/swaprun）移除，
  已有 config 无法再开启；
- 设置面板（PipPageOpt）两行移除、F9 面板两行移除、saveConfigFile 回写移除；
- `stepProjHits` 的回放重演分支（projBoom）抽成 `replayProjBoom()` 独立于
  `cfgProjHits` 门控——斯安维斯坦回放系统对"时停中自然爆炸"的重演不受影响。