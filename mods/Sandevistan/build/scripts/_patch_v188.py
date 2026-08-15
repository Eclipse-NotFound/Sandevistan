# -*- coding: utf-8 -*-
import io

p = 'C:/RemainsMod/_dev/modsrc/SandevistanMod.as'
with io.open(p, encoding='utf-8') as f:
    s = f.read()

def rep(old, new):
    global s
    assert old in s, "NOT FOUND: " + old[:60]
    s = s.replace(old, new, 1)

# ---- 1. startSandy: register ALL pre-existing fe.weapon (incl. player's) ----
rep("""            // 时停开始时已在飞的攻击体：玩家方的快照（不清除——回放中继续
            // 飞行并正常结算）；敌人方的直接登记录像（时停前已发射的攻击
            // 不漏录——天角兽启动时停前已打出的闪电/蓄力完成后的攻击重演）
            preExistB = new Dictionary();
            try
            {
               var oP2:Object = world.loc != null ? world.loc.firstObj : null;
               var gP2:int = 0;
               while (oP2 != null)
               {
                  try
                  {
                     if (oP2["owner"] != world.gg && flash.utils.getQualifiedClassName(oP2).indexOf("fe.weapon::") == 0)
                     {
                        registerAtk(oP2);
                     }
                  }
                  catch (e:*) { }
                  oP2 = oP2.nobj;
                  if (++gP2 > 20000) break;
               }
            }
            catch (e:*) { }""",
    """            // 时停开始时已在飞的攻击体：**全部登记录像**（玩家方的也录——
            // 时停前抛出的手雷/导弹在回放中重演其慢速飞行轨迹；v1.87 之前
            // 只录敌人的，玩家的漏录导致"时停前在飞手雷未重演"）。玩家方
            // 同时留 preExistB 快照（endSandy 不清除，回放后继续飞行）。
            preExistB = new Dictionary();
            try
            {
               var oP2:Object = world.loc != null ? world.loc.firstObj : null;
               var gP2:int = 0;
               while (oP2 != null)
               {
                  try
                  {
                     if (flash.utils.getQualifiedClassName(oP2).indexOf("fe.weapon::") == 0)
                     {
                        try { if (oP2["owner"] == world.gg) { preExistB[oP2] = true; } } catch (e:*) { }
                        registerAtk(oP2);
                     }
                  }
                  catch (e:*) { }
                  oP2 = oP2.nobj;
                  if (++gP2 > 20000) break;
               }
            }
            catch (e:*) { }""")

# ---- 2. stepPlayerBullets: skip tracked objects ----
rep("""                  if (oB["owner"] == world.gg && flash.utils.getQualifiedClassName(oB).indexOf("fe.weapon::") == 0)
                  {
                     oB.step();
                  }""",
    """                  if (oB["owner"] == world.gg && replayObjs[oB] == null
                      && flash.utils.getQualifiedClassName(oB).indexOf("fe.weapon::") == 0)
                  {
                     oB.step();
                  }""")

# ---- 3. bullet spawn positional correction ----
rep("""                        cwNow.rot = Math.atan2(world.celY - cwNow.Y, world.celX - cwNow.X);
                        cwNow.ready = true;
                     }
                     catch (e:*) { }
                  }""",
    """                        cwNow.rot = Math.atan2(world.celY - cwNow.Y, world.celX - cwNow.X);
                        cwNow.ready = true;
                        // v1.88：开火帧到窗口末的位移修正——子弹在开火帧生成，
                        // 世界显示在窗口末（Δ≤4 历史帧）→ 子弹沿飞行方向预推进
                        // Δ×vel/slowfactor（时停显示帧速度），与窗口末的投掷物
                        // 位置对齐——回放中射击手雷偏移的根源修正
                        try
                        {
                           if (fp != null && fp.f != null && replayIdx > fp.f)
                           {
                              var preB:* = cwNow.b;
                              if (preB != null && preB.vel != null && preB.rot != null)
                              {
                                 var dCorr:Number = (replayIdx - fp.f) * preB.vel / Math.max(1, cfgSlowFactor);
                                 preB.X += Math.cos(preB.rot) * dCorr;
                                 preB.Y += Math.sin(preB.rot) * dCorr;
                                 try { if (preB.vis != null) { preB.vis.x = preB.X; preB.vis.y = preB.Y; } } catch (e:*) { }
                              }
                           }
                        }
                        catch (e:*) { }
                     }
                     catch (e:*) { }
                  }""")

# firePts entry: add frame f
rep("""            if (h.fc != null && h.fc > 0)
            {
               fireCnt += h.fc;
               firePts.push({ x: h.wx, y: h.wy, ax: h.ax != null ? h.ax : 0, ay: h.ay != null ? h.ay : 0 });
            }""",
    """            if (h.fc != null && h.fc > 0)
            {
               fireCnt += h.fc;
               firePts.push({ f: replayIdx, x: h.wx, y: h.wy, ax: h.ax != null ? h.ax : 0, ay: h.ay != null ? h.ay : 0 });
            }""")

# ---- 4. endSandy recEnd diag ----
rep("""         // 清除时停期间玩家发射的冻结子弹（回放重演攻击，避免双倍火力；
         // 时停前已在飞的不清除——回放继续飞行）
         clearFrozenBullets();""",
    """         // 清除时停期间玩家发射的冻结子弹（回放重演攻击，避免双倍火力；
         // 时停前已在飞的不清除——回放继续飞行）
         clearFrozenBullets();
         // 追踪器数组长度诊断（v1.88）：len=1 说明追加失败（对象"未重演"定位）
         try
         {
            for (var kE:Object in seenAtk)
            {
               var arrE:Array = replayObjs[kE];
               log("[DIAG] recEnd: cls=" + flash.utils.getQualifiedClassName(kE)
                   + " len=" + (arrE != null ? arrE.length : -1)
                   + " inChain=" + (kE.in_chain != null ? kE.in_chain : -1));
            }
         }
         catch (e:*) { }""")

rep("v1.87 已加载", "v1.88 已加载")

with io.open(p, 'w', encoding='utf-8') as f:
    f.write(s)
print("done")
