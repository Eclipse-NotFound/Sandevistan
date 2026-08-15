# -*- coding: utf-8 -*-
import io

p = 'C:/RemainsMod/_dev/modsrc/SandevistanMod.as'
with io.open(p, encoding='utf-8') as f:
    s = f.read()

def rep(old, new):
    global s
    assert old in s, "NOT FOUND: " + old[:60]
    s = s.replace(old, new, 1)

# ---- 1. firePts: declare + collect + use ----
rep("         var fireCnt:int = 0;   // 窗口内真实开火次数（时停记录逐帧累加）",
    "         var fireCnt:int = 0;   // 窗口内真实开火次数（时停记录逐帧累加）\n"
    "         var firePts:Array = [];   // 开火帧的武器位置/瞄准点（v1.86：子弹按开火帧精确复现）")

rep("""            // 真实开火计数（v1.72）：直接累加时停期间逐帧记录的开火数——
            // 记录时以相邻帧弹夹下降（子弹真实生成）判定，回放不再做窗口
            // 边缘检测（旧上升沿/下降沿在窗口首帧必丢边——吞攻击根源之一）
            if (h.fc != null && h.fc > 0) { fireCnt += h.fc; }""",
    """            // 真实开火计数（v1.72）：直接累加时停期间逐帧记录的开火数——
            // 记录时以相邻帧弹夹下降（子弹真实生成）判定，回放不再做窗口
            // 边缘检测（旧上升沿/下降沿在窗口首帧必丢边——吞攻击根源之一）。
            // v1.86：开火帧的武器位置与瞄准点逐帧记录（子弹按开火帧精确
            // 复现——窗口末位置/瞄准会让子弹与重演的投掷物等实体产生
            // 整窗口偏差："回放中子弹离手雷偏差大"的根源）
            if (h.fc != null && h.fc > 0)
            {
               fireCnt += h.fc;
               firePts.push({ x: h.wx, y: h.wy, ax: h.ax != null ? h.ax : 0, ay: h.ay != null ? h.ay : 0 });
            }""")

rep("""                  // 开火前武器重新瞄准/就位（枪械）：gg.step 后武器的位置/旋转
                  // 可能被 setWeaponPos/actions 重算——跳跃场景下子弹会从偏离
                  // 记录位置发射导致"有攻击无判定"。近战由直接结算处理不需要。
                  if (!meleeNow)
                  {
                     try
                     {
                        cwNow.X = world.gg.weaponX;
                        cwNow.Y = world.gg.weaponY;
                        cwNow.rot = Math.atan2(lastAimY - world.gg.Y, lastAimX - world.gg.X);
                        cwNow.ready = true;
                     }
                     catch (e:*) { }
                  }""",
    """                  // 开火前武器重新瞄准/就位（枪械）：v1.86 按**开火帧**记录的
                  // 武器位置与瞄准点精确复现（firePts）——跳跃/窗口偏移不再
                  // 使子弹偏离；无记录时退回窗口末瞄准。近战不需要。
                  if (!meleeNow)
                  {
                     try
                     {
                        var fp:Object = firePts.length > 0 ? firePts.shift() : null;
                        if (fp != null)
                        {
                           cwNow.X = fp.x;
                           cwNow.Y = fp.y;
                           world.celX = fp.ax;
                           world.celY = fp.ay;
                        }
                        else
                        {
                           cwNow.X = world.gg.weaponX;
                           cwNow.Y = world.gg.weaponY;
                           world.celX = lastAimX;
                           world.celY = lastAimY;
                        }
                        cwNow.rot = Math.atan2(world.celY - cwNow.Y, world.celX - cwNow.X);
                        cwNow.ready = true;
                     }
                     catch (e:*) { }
                  }""")

# ---- 2. startSandy: register pre-existing enemy attack bodies ----
rep("""            // 时停开始时已在飞的玩家攻击体（手雷/导弹等）快照——不清除，
            // 回放中继续飞行并正常结算（时停中伤害被清零，结束恢复）
            preExistB = new Dictionary();""",
    """            // 时停开始时已在飞的攻击体：玩家方的快照（不清除——回放中继续
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
            catch (e:*) { }""")

# ---- 3. box tracker takeover ----
rep("""                        if (oT != null && oT.isThrow == true)
                        {
                           oT.t_throw = 5;
                           // 投掷箱按引用录像（v1.85：绕开链扫描之谜——
                           // 箱子的飞行轨迹回放重演）
                           try { registerAtk(oT); } catch (e:*) { }
                        }""",
    """                        if (oT != null && oT.isThrow == true)
                        {
                           oT.t_throw = 5;
                           // 投掷箱由追踪器接管录像（v1.86）：move 检测的录像
                           // 受链扫描之谜影响不可靠——直接建/补追踪器数组，
                           // 逐帧按引用记录，飞行轨迹回放重演
                           try
                           {
                              if (seenAtk[oT] == null)
                              {
                                 seenAtk[oT] = true;
                                 var arrTB:Array = replayObjs[oT];
                                 if (arrTB == null)
                                 {
                                    arrTB = [];
                                    replayObjs[oT] = arrTB;
                                    replayObjArr.push(oT);
                                 }
                                 var fN2:int = cfgDuration - sandyLeft;
                                 while (arrTB.length < fN2 + 1)
                                 {
                                    arrTB.push({ x: oT.X, y: oT.Y, f: -1, s: "", wx: 0, wy: 0, twx: 0, twy: 0, vv: true, sto: 1, wrot: -99 });
                                 }
                                 log("[DIAG] recBox: X=" + oT.X + " Y=" + oT.Y + " frameN=" + fN2);
                              }
                           }
                           catch (e:*) { }
                        }""")

# ---- 4. remove hostile-branch dx/dy save/restore (superseded) ----
rep("""                                 catch (e:*) { }
                                 // v1.85：保存单位速度（被投掷敌人的惯性——AI 步会
                                 // 覆写 dx/dy，步后恢复 → 回放结束后继续沿投掷方向
                                 // 飞行；非投掷单位时停末速度≈0，无副作用）
                                 var sdxT:Number = oR.dx != null ? oR.dx : 0;
                                 var sdyT:Number = oR.dy != null ? oR.dy : 0;
                                 oR.step();""",
    """                                 catch (e:*) { }
                                 oR.step();""")

rep("""                              catch (e:*) { }
                              // 恢复单位速度（v1.85：被投掷敌人的惯性保留到
                              // 回放结束后——继续沿投掷方向飞行）
                              try { oR.dx = sdxT; oR.dy = sdyT; } catch (e:*) { }
                              // v1.85：攻击体复现已移除——攻击体由追踪器（seenAtk）""",
    """                              catch (e:*) { }
                              // v1.85：攻击体复现已移除——攻击体由追踪器（seenAtk）""")

# ---- 5. endReplay: restore thrownPreV velocities before clearing ----
rep("""               thrownDamWall = new Dictionary();
               thrownImpacts = new Dictionary();
               thrownPreV = new Dictionary();
               thrownUnits = new Dictionary();""",
    """               // v1.86：被投掷敌人的惯性恢复——用节流步前速度快照的
               // 末次值（时停末仍在飞行的单位），回放结束后继续沿投掷方向飞行
               try
               {
                  for (var kPV:Object in thrownPreV)
                  {
                     try
                     {
                        kPV.dx = thrownPreV[kPV].dx;
                        kPV.dy = thrownPreV[kPV].dy;
                     }
                     catch (e:*) { }
                  }
               }
               catch (e:*) { }
               thrownDamWall = new Dictionary();
               thrownImpacts = new Dictionary();
               thrownPreV = new Dictionary();
               thrownUnits = new Dictionary();""")

# ---- 6. door setVisState on dop change ----
rep("""                  // 门瓦片不透明度重演（v1.82/1.84）：门开合=门框瓦片 opac 淡出——
                  // 按记录恢复 opac + t_visi + visi（渲染路径三处全设，确保可见）""",
    """                  // 门视觉重演（v1.86）：按记录 dop 变化调 setVisState——
                  // 门的可见形象是 Box 自己的 vis（open/close 帧），不是瓦片
                  // 淡出；dop 变化=开合事件（doorPrevDop 防重复调用重播音效）
                  try
                  {
                     if (oR["setPos"] == null && stR.dop != null && stR.dop >= 0
                         && oR["setVisState"] != null && oR.door != null && oR.door > 0)
                     {
                        var prevDop:Number = doorPrevDop[oR] != null ? doorPrevDop[oR] : -1;
                        if (prevDop != stR.dop)
                        {
                           doorPrevDop[oR] = stR.dop;
                           oR.setVisState(stR.dop < 0.5 ? "open" : "close");
                        }
                     }
                  }
                  catch (e:*) { }
                  // 门瓦片不透明度重演（v1.82/1.84）：门开合=门框瓦片 opac 淡出——
                  // 按记录恢复 opac + t_visi + visi（渲染路径三处全设，确保可见）""")

rep("      private var recDoorCnt:int = 0;        // 门对象诊断计数（每轮时停重置）",
    "      private var recDoorCnt:int = 0;        // 门对象诊断计数（每轮时停重置）\n"
    "      private var doorPrevDop:Dictionary = new Dictionary();  // 门重演：上一帧 dop（防重复 setVisState 音效）")

rep("            seenAtk = new Dictionary();         // 攻击体追踪器重置",
    "            seenAtk = new Dictionary();         // 攻击体追踪器重置\n"
    "            doorPrevDop = new Dictionary();")

rep("v1.85 已加载", "v1.86 已加载")

with io.open(p, 'w', encoding='utf-8') as f:
    f.write(s)
print("all done")
