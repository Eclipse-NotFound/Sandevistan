/*
 * 斯安维斯坦模组 (Sandevistan Mod) for Fallout Equestria: Remains
 * 逻辑核心 —— 由补丁后的 MainFE 在游戏启动时加载进游戏域并调用 SandevistanMod.init()
 *
 * 时停实现：World.onPause = true（游戏自身冻结 land.step / 实体 / 粒子），
 * 然后本模组每帧手动调用 loc.gg.step() 让玩家照常行动；
 * 同时手动步进链表中的 Part 粒子（特效继续，实体冻结）。
 * 残影：彩虹色调色板 + 加法混合，残影层挂在 world.visual 内（相机自动跟随）。
 * 回放：生效期间记录玩家路径，结束后以 N 倍速回放残影。
 */
package
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.IBitmapDrawable;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.filesystem.File;
   import flash.filesystem.FileMode;
   import flash.filesystem.FileStream;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.ui.Keyboard;
   import flash.utils.getTimer;
   import flash.utils.describeType;
   import flash.utils.Dictionary;

   public class SandevistanMod extends Sprite
   {
      // ---------- 配置（默认值，被 SandevistanMod/config.txt 覆盖） ----------
      private var cfgHotkey:int = Keyboard.BACKSLASH;   // 默认 \
      private var cfgDuration:int = 240;                // 生效帧数（30fps -> 8 秒）
      private var cfgCooldown:int = 0;                  // 冷却帧数（默认 0 = 无冷却，便于调试）
      private var cfgReplaySpeed:Number = 5;            // 回放速度倍率（回放时世界冻结，无渲染压力）
      private var cfgGhostEvery:int = 3;                // 每 N 帧生成一个残影
      private var cfgFxRun:Boolean = true;              // 时停期间粒子特效是否继续

      // ---------- 运行时状态 ----------
      private static var inst:SandevistanMod = null;
      private var world:Object;                         // fe.World.World.w
      private var hooked:Boolean = false;

      private var sandyActive:Boolean = false;
      private var sandyLeft:int = 0;                    // 剩余帧数
      private var cooldownLeft:int = 0;                 // 冷却剩余帧数
      private var savedOnPause:Boolean = false;
      private var ghostLayer:Sprite;                    // 残影容器（世界坐标，挂在 world.visual 内）
      private var ghosts:Array = [];                    // 存活残影
      private var rainbowIdx:int = 0;
      private var history:Array = [];                   // 记录玩家路径 {x,y,s,r,v}
      private var replaying:Boolean = false;
      private var replayIdx:int = 0;
      private var savedGod:Boolean = false;             // 回放期间无敌
      private var savedInvul:Boolean = false;           // 时停期间玩家免疫（攻击体打不中）
      private var savedGgCtrl:Boolean = true;           // 回放前控制状态
      private var startWeapon:Object = null;               // 时停开始时的武器（回放开始切回它）
      private var endWeapon:Object = null;                 // 时停结束时的武器（回放结束切回它）
      private var replayWpn:Object = null;                 // 回放期间钉住的武器（防游戏切换动画乱切）
      private var sandyEndSnap:Object = null;              // 时停结束快照（全武器弹夹+背包弹药，回放结束恢复）
      private var fxTicks:int = 0;
      private var diagTick:int = 0;
      private var replayDiagTick:int = 0;      // 回放段诊断计数
      private var replayAtkTick:int = 0;       // 回放段攻击链路诊断计数
      private var replayBodyTick:int = 0;      // 回放段攻击体状态诊断计数
      private var sandyAtkTick:int = 0;        // 时停段攻击状态诊断计数
      private var sandyEnemyTick:int = 0;      // 时停段敌人移动诊断计数
      private var mouseAtkDown:Boolean = false;   // 鼠标攻击键按住状态
      private var mouseAtkPulse:Boolean = false;  // 鼠标攻击键按下脉冲（同帧 DOWN+UP 不丢）
      private var savedOtbros:Number = -1;        // 回放近战击退原始值（缩放到 1/5 抵消加速）
      private var savedRapids:Object = {};        // 回放中改过的武器 rapid 原始值（结束恢复）
      private var cfgSlowFactor:Number = 5;       // 时停慢速倍率（1/N 速，config slowfactor）
      private var slowTick:int = 0;               // 节流计数器（每 slowfactor 帧 step 1 次）
      private var slowPartClass:Class = null;     // 粒子类（节流 step 跳过，特效单独处理）
      private var replayObjs:Dictionary = new Dictionary();  // 重演对象 → 每帧状态数组 {x,y,f,s}
      private var replayObjArr:Array = [];        // 重演对象引用列表
      private var seenPos:Dictionary = new Dictionary();    // 场景对象移动检测快照
      private var sndClass:Class = null;          // fe.Snd（重演音效播放）
      private var panelOpen:Boolean = false;
      private var optPanelOn:Boolean = false;      // 选项页模组设置面板
      private var optSel:int = 0;                  // 0=生效时间 1=冷却
      private var optTf:TextField = null;
      private var optBg:Sprite = null;
      private var lastGgControl:Boolean = true;
      private var savedInter:Object = null;
      private var keyPressTime:Array = [];      // 按键按下时间戳（防 UP 丢失卡键）
      private var keyMap:Object = {};            // 键码 -> 键布尔名（解析自游戏 keyXML）
      private var keyMapBuilt:Boolean = false;
      private var imeWarnT:int = 0;                 // 输入法警告剩余帧数
      private var keyDownSeen:Array = new Array(256); // 最近按键按下记录（时间戳）
      private var ime229Count:int = 0;                // 短时间内 229 事件计数
      private var ime229Time:int = 0;
      private var imeMissCount:int = 0;                // UP无DOWN 计数（2秒窗口）
      private var imeMissTime:int = 0;

      // 解析游戏默认键位表（keyXML 是 public），建立键码->布尔名映射
      private function buildKeyMap():void
      {
         try
         {
            var kx:* = world.ctr.keyXML;
            if (kx == null) return;
            keyMap = {};
            var keys:XMLList = kx.key;
            for each (var k:XML in keys)
            {
               var id:String = String(k.@id);
               var defs:Array = [String(k.@def), String(k.@alt)];
               for each (var dv:String in defs)
               {
                  var code:int = parseInt(dv, 10);
                  if (dv != "" && !isNaN(code) && code > 0 && code < 256)
                  {
                     keyMap[code] = id;
                  }
               }
            }
            keyMapBuilt = true;
            log("[SandyMod] keyMap built: " + keyMap[65] + "/" + keyMap[68] + "/" + keyMap[32] + "/" + keyMap[220]);
         }
         catch (e:*) { log("[SandyMod] buildKeyMap error: " + e); }
      }
      private var panelSel:int = 0;
      private var panelTf:TextField = null;
      private var prevVisX:Number = 0;
      private var prevVisY:Number = 0;

      private var hud:TextField;                        // 顶部状态文字
      private var hudBg:Sprite;
      private var debugTest:Boolean = false;             // 自动测试模式（config debugtest=1）
      private var cfgShowMark:Boolean = true;            // 启动时显示模组已加载标记
      private var cfgPanelKey:int = Keyboard.F9;         // 参数面板热键
      private var cfgGhostBlend:int = 1;                  // 残影混合: 1=normal柔和 0=add发光
      private var cfgGhostAlpha:int = 25;                 // 残影不透明度（百分比）
      private var cfgReplayGhost:int = 12;                 // 回放残影间隔（每 N 个历史帧生成 1 个）
      private var testStage:int = 0;                     // 0=等待world 1=开始新游戏 2=等待进游戏 3=启动sandy 4=结束sandy
      private var testTicks:int = 0;

      // 彩虹色调色板（边缘行者风格，高饱和）—— alpha 由 config ghostalpha 控制
      private function palette(idx:int):ColorTransform
      {
         var a:Number = Math.max(0.05, Math.min(1, cfgGhostAlpha / 100));
         var cols:Array = [
            [1.6, 0.4, 0.4, 40, 0, 0], [1.7, 0.8, 0.3, 50, 10, 0], [1.7, 1.4, 0.4, 40, 30, 0],
            [0.5, 1.7, 0.5, 0, 50, 10], [0.4, 1.4, 1.6, 0, 40, 50], [0.4, 0.5, 1.8, 0, 10, 60],
            [1.5, 0.4, 1.7, 40, 0, 50], [1.6, 0.3, 1.0, 50, 0, 40]
         ];
         var c:Array = cols[idx % cols.length];
         return new ColorTransform(c[0], c[1], c[2], a, c[3], c[4], c[5], 0);
      }

      public function SandevistanMod()
      {
         super();
         trace("[MOD] ctor stage=" + (stage != null));
      }

      // ==================== 入口（由补丁后的 MainFE 调用） ====================
      public static function init(main:Object):void
      {
         if (inst != null)
         {
            return;
         }
         inst = new SandevistanMod();
         inst.log("[SandyMod] init called");
         inst.loadConfig();
         if (main != null && main.stage != null)
         {
            main.stage.addEventListener(Event.ENTER_FRAME, inst.onFrame);
            main.stage.addEventListener(KeyboardEvent.KEY_DOWN, inst.onKey);
            main.stage.addEventListener(KeyboardEvent.KEY_UP, inst.onKeyUp);
            main.stage.addEventListener(Event.DEACTIVATE, inst.onDeactivateClear);
            // 鼠标左键按住状态（时停中近战拦截后，历史记录真实攻击意图用）
            main.stage.addEventListener(MouseEvent.MOUSE_DOWN, inst.onMouseDown);
            main.stage.addEventListener(MouseEvent.MOUSE_UP, inst.onMouseUp);

         }
         inst.log("[SandyMod] hooks registered");
         if (inst.cfgShowMark)
         {
            inst.showBootMark(main);
         }
      }

      // 启动可见标记（验证模组已加载）
      private function showBootMark(main:Object):void
      {
         try
         {
            var t:TextField = new TextField();
            var tf:TextFormat = new TextFormat();
            tf.font = "Microsoft YaHei";
            tf.size = 14;
            tf.bold = true;
            tf.color = 0x00FF88;
            t.defaultTextFormat = tf;
            t.text = "SandevistanMod v1.50 已加载 (按 \ 触发斯安维斯坦)";
            t.x = 10;
            t.y = 10;
            t.selectable = false;
            t.mouseEnabled = false;
            main.addChild(t);
            trace("[SandyMod] boot mark added");
         }
         catch (e:*) { trace("[SandyMod] boot mark error: " + e); }
      }

      // ==================== 文件日志（模组内 trace 不输出，写文件） ====================
      private var cfgDiagLog:Boolean = false;           // 独立诊断日志开关（config diaglog=1）
      private function log(msg:String):void
      {
         if (!debugTest && !cfgDiagLog) return;   // 正式版不写日志（diaglog=1 时例外）
         var err:String = "";
         try
         {
            var f:File = File.applicationStorageDirectory.resolvePath("sandy_modlog.txt");
            var stream:FileStream = new FileStream();
            stream.open(f, FileMode.APPEND);
            stream.writeUTFBytes(msg + String.fromCharCode(13, 10));
            stream.close();
         }
         catch (e:*) { err = String(e); }
         try
         {
            var f2:File = File.applicationDirectory.resolvePath("SandevistanMod/modlog.txt");
            var s2:FileStream = new FileStream();
            s2.open(f2, FileMode.APPEND);
            s2.writeUTFBytes(msg + String.fromCharCode(13, 10) + (err != "" ? " [appDirErr: " + err + "]" : "") + String.fromCharCode(13, 10));
            s2.close();
         }
         catch (e2:*) { }
      }

      // ==================== 配置 ====================
      private function loadConfig():void
      {
         try
         {
            var cfg:File = File.applicationDirectory.resolvePath("SandevistanMod/config.txt");
            if (cfg.exists)
            {
               var stream:FileStream = new FileStream();
               stream.open(cfg, FileMode.READ);
               var txt:String = stream.readUTFBytes(stream.bytesAvailable);
               stream.close();
               var lines:Array = txt.split(/\r?\n/);
               for each (var line:String in lines)
               {
                  line = line.replace(/^\s+|\s+$/g, "");
                  if (line.length == 0 || line.charAt(0) == "#") continue;
                  var kv:Array = line.split("=");
                  if (kv.length < 2) continue;
                  var k:String = kv[0].replace(/^\s+|\s+$/g, "").toLowerCase();
                  var v:String = kv[1].replace(/^\s+|\s+$/g, "");
                  if (k == "hotkey") cfgHotkey = parseInt(v);
                  else if (k == "duration") cfgDuration = parseInt(v);
                  else if (k == "cooldown") cfgCooldown = parseInt(v);
                  else if (k == "replayspeed") cfgReplaySpeed = parseFloat(v);
                  else if (k == "ghostevery") cfgGhostEvery = parseInt(v);
                  else if (k == "fxrun") cfgFxRun = v.toLowerCase() == "1" || v.toLowerCase() == "true";
                  else if (k == "debugtest") debugTest = v.toLowerCase() == "1" || v.toLowerCase() == "true";
                  else if (k == "showmark") cfgShowMark = v.toLowerCase() == "1" || v.toLowerCase() == "true";
                  else if (k == "panelkey") cfgPanelKey = parseInt(v);
                  else if (k == "diaglog") cfgDiagLog = v.toLowerCase() == "1" || v.toLowerCase() == "true";
                  else if (k == "ghostblend") cfgGhostBlend = parseInt(v);
                  else if (k == "ghostalpha") cfgGhostAlpha = parseInt(v);
                  else if (k == "replayghost") cfgReplayGhost = parseInt(v);
                  else if (k == "slowfactor") cfgSlowFactor = parseFloat(v);
               }
            }
         }
         catch (e:*) { trace("[SandyMod] config error: " + e); }
         if (cfgDuration < 30) cfgDuration = 30;
         if (cfgDuration > 3600) cfgDuration = 3600;
         if (cfgCooldown < 0) cfgCooldown = 0;
         if (cfgReplaySpeed < 1) cfgReplaySpeed = 1;
         if (cfgSlowFactor < 1) cfgSlowFactor = 1;
         if (cfgSlowFactor > 20) cfgSlowFactor = 20;
         trace("[SandyMod] config hotkey=" + cfgHotkey + " dur=" + cfgDuration + " cd=" + cfgCooldown);
      }

      // ==================== 帧循环 ====================
      private function onFrame(e:Event):void
      {
         try
         {
            onFrameInner();
         }
         catch (err:*) { log("[SandyMod] onFrame error: " + err); }
      }

      private function onFrameInner():void
      {
         if (world == null)
         {
            try
            {
               var wc:Class = ApplicationDomain.currentDomain.getDefinition("fe.World") as Class;
               if (wc != null) world = wc["w"];
            }
            catch (err:*) { }
            if (world == null) return;
            log("[SandyMod] World found");
         }

         try
         {
            if (world != null && world.verror != null && world.verror.visible)
            {
               var errtxt:String = "?";
               try { errtxt = String(world.verror.txt.text); } catch (e:*) { }
               log("[ERRDIALOG] " + errtxt);
            }
         }
         catch (e:*) { }

         if (debugTest)
         {
            stepDebugTest();
         }

         try
         {
            if (world != null && world.gg != null)
            {
               var gc:Boolean = world.gg.ggControl;
               if (gc != lastGgControl && debugTest)
               {
                  log("[DIAG] ggControl changed to " + gc + " hp=" + world.gg.hp + " sost=" + world.gg.sost
                      + " X=" + world.gg.X + " Y=" + world.gg.Y + " sandy=" + sandyActive + " replay=" + replaying);
               }
               lastGgControl = gc;
            }
         }
         catch (e:*) { }

         if (!keyMapBuilt && world != null && world.ctr != null && world.ctr.keyXML != null)
         {
            buildKeyMap();
         }

         checkOptPanel();

         if (panelOpen)
         {
            renderPanel();
            return;
         }

         if (sandyActive)
         {
            stepSandy();
         }
         else if (replaying)
         {
            stepReplay();
         }
         else if (cooldownLeft > 0)
         {
            --cooldownLeft;
         }

         updateHud();
         updateGhosts();
         if (cfgDiagLog)
         {
            if (diagTick++ % 60 == 0)
            {
               try
               {
                  var kL:Boolean = world.ctr.keyLeft;
                  var kR:Boolean = world.ctr.keyRight;
                  var kU:Boolean = world.ctr.keyBeUp;
                  var kD:Boolean = world.ctr.keySit;
                  var kJ:Boolean = world.ctr.keyJump;
                  var kA:Boolean = world.ctr.keyAttack;
                  log("[STATE] L=" + kL + " R=" + kR + " U=" + kU + " D=" + kD + " J=" + kJ + " A=" + kA
                      + " ggX=" + (world.gg != null ? world.gg.X : -1) + " ggY=" + (world.gg != null ? world.gg.Y : -1)
                      + " focus=" + world.swfStage.focus);
               }
               catch (err:*) { }
            }
         }
      }

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

      // ==================== 自动测试 ====================
      private function stepDebugTest():void
      {
         try
         {
            if (testStage == 0)
            {
               // 等待 World 就绪后开始新游戏
               if (world != null && world.mm != null && world.mm.loaded)
               {
                  log("[TEST] starting new game");
                  world.mm.mainMenuOff();
                  world.newGame(-1, "TEST", { "dif": 2, "propusk": true });
                  testStage = 1;
               }
            }
            else if (testStage == 1)
            {
               // 等待进入游戏
               if (world.allStat >= 1 && world.gg != null && world.loc != null)
               {
                  log("[TEST] in game, allStat=" + world.allStat);
                  testStage = 2;
                  testTicks = 0;
               }
            }
            else if (testStage == 2)
            {
               // 给游戏一点稳定时间后启动斯安维斯坦
               testTicks++;
               if (testTicks > 90)
               {
                  log("[TEST] starting sandevistan");
                  startSandy();
                  // 测试环境存在开场对话导致 ggControl=false；强制恢复以模拟正常游玩
                  try { world.gg.controlOn(); } catch (e:*) { }
                  testStage = 3;
                  testTicks = 0;
               }
            }
            else if (testStage == 3)
            {
               testTicks++;
               if (testTicks > 180)  // 6秒后结束
               {
                  log("[TEST] ending sandevistan (was active=" + sandyActive + ")");
                  endSandy();
                  testStage = 4;
                  testTicks = 0;
               }
            }
            else if (testStage == 4)
            {
               testTicks++;
               if (testTicks > 300)  // 回放10秒
               {
                  // 卡键自愈验证：模拟 UP 丢失残留后伪造按键事件
                  try
                  {
                     var c2:Object = world.ctr;
                     var dt:XML = describeType(c2);
                     log("[TEST] ctr vars: " + dt.variable.@name.toString().split(",").join(" "));
                     c2.keyRight = false;
                     log("[TEST] pre-heal: keyRight=" + c2.keyRight + " keyMap[68]=" + keyMap[68]);
                     world.swfStage.dispatchEvent(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, false, 0, 68));
                     log("[TEST] post-heal: keyRight=" + c2.keyRight);
                     c2.keyRight = false;
                  }
                  catch (e:*) { log("[TEST] heal test err: " + e); }
                  log("[TEST] done. replaying=" + replaying + " ghosts=" + ghosts.length);
                  testStage = 5;
               }
            }
         }
         catch (e:*) { log("[TEST] error: " + e); }
      }

      // ==================== 选项页模组设置 ====================
      private function checkOptPanel():void
      {
         var on:Boolean = false;
         try
         {
            if (world != null && world.pip != null && world.pip.active && world.pip.currentPage != null)
            {
               var qn:String = flash.utils.getQualifiedClassName(world.pip.currentPage);
               if (qn == "fe.inter::PipPageOpt")
               {
                  on = true;
               }
            }
         }
         catch (e:*) { }
         if (on != optPanelOn)
         {
            optPanelOn = on;
            if (on)
            {
               showOptPanel();
            }
            else
            {
               hideOptPanel();
            }
         }
         if (on)
         {
            renderOptPanel();
         }
      }

      private function showOptPanel():void
      {
         try
         {
            if (world == null || world.main == null) return;
            if (optTf == null)
            {
               optTf = new TextField();
               var tf:TextFormat = new TextFormat();
               tf.font = "Consolas";
               tf.size = 15;
               tf.color = 0x00FF99;
               tf.letterSpacing = 1;
               optTf.defaultTextFormat = tf;
               optTf.selectable = false;
               optTf.mouseEnabled = false;
               optBg = new Sprite();
               world.main.addChild(optBg);
               world.main.addChild(optTf);
            }
            optTf.visible = true;
            optBg.visible = true;
            optSel = 0;
         }
         catch (e:*) { }
      }

      private function hideOptPanel():void
      {
         try
         {
            if (optTf != null) optTf.visible = false;
            if (optBg != null) optBg.visible = false;
         }
         catch (e:*) { }
      }

      private function optAdj(dir:int):void
      {
         if (optSel == 0)
         {
            cfgDuration = Math.max(30, Math.min(3600, cfgDuration + dir * 30));
         }
         else
         {
            cfgCooldown = Math.max(0, Math.min(3600, cfgCooldown + dir * 30));
         }
      }

      private function renderOptPanel():void
      {
         try
         {
            if (optTf == null) return;
            var lines:Array = [];
            lines.push("-- SandevistanMod --");
            lines.push((optSel == 0 ? "> " : "  ") + "生效时间  " + (cfgDuration / 30).toFixed(1) + "s");
            lines.push((optSel == 1 ? "> " : "  ") + "冷却      " + (cfgCooldown / 30).toFixed(1) + "s");
            lines.push("");
            lines.push("上下选择 左右调值 Enter保存");
            optTf.text = lines.join(String.fromCharCode(10));
            var sw:Number = 1280;
            try { sw = world.swfStage.stageWidth; } catch (e:*) { }
            optTf.x = sw - 300;
            optTf.y = 120;
            optTf.width = 260;
            optTf.height = 140;
            optBg.graphics.clear();
            optBg.graphics.lineStyle(1, 0x00FF99, 0.8);
            optBg.graphics.beginFill(0x002211, 0.75);
            optBg.graphics.drawRect(optTf.x - 10, optTf.y - 10, optTf.width + 20, optTf.height + 20);
            optBg.graphics.endFill();
         }
         catch (e:*) { }
      }

      // ===== 清除时停期间玩家发射的冻结子弹（回放重演避免双倍火力）=====
      private function clearFrozenBullets():void
      {
         try
         {
            var loc:Object = world.loc;
            if (loc == null) return;
            var obj:Object = loc.firstObj;
            var guard:int = 0;
            var nFe:int = 0;      // 攻击体对象总数（fe.weapon::*）
            var nRem:int = 0;     // 实际清除数
            var nSkip:int = 0;    // 未清除数（owner 不是玩家，或异常）
            while (obj != null)
            {
               var nxt:Object = obj.nobj;
               try
               {
                  var qn:String = flash.utils.getQualifiedClassName(obj);
                  if (qn.indexOf("fe.weapon::") == 0)
                  {
                     nFe++;
                     if (obj.owner == world.gg)
                     {
                        loc.remObj(obj);
                        nRem++;
                     }
                     else
                     {
                        nSkip++;
                     }
                  }
               }
               catch (e:*) { }
               obj = nxt;
               if (++guard > 20000) break;
            }
            log("[DIAG] clearFrozenBullets: feWeapon=" + nFe + " removed=" + nRem + " skip=" + nSkip);
         }
         catch (e:*) { }
      }

      // ===== 时停中记录重演状态（场景级录像：每帧位置+动画帧+生成音效）=====
      // 单位/攻击体必记录；场景对象移动检测（静态对象不记录，省存储）
      private function recordReplayObjects():void
      {
         try
         {
            var frameN:int = cfgDuration - sandyLeft;   // 时停内帧号（0 起）
            var locR:Object = world.loc;
            if (locR == null) return;
            var oR:Object = locR.firstObj;
            var gR:int = 0;
            while (oR != null)
            {
               var nxR:Object = oR.nobj;
               try
               {
                  if (oR == world.gg) { /* 玩家跳过（历史记录） */ }
                  else if (slowPartClass != null && oR is slowPartClass) { /* 粒子跳过 */ }
                  else
                  {
                     var arrR:Array = replayObjs[oR];
                     if (arrR == null)
                     {
                        // 未记录：类名判断（类型/移动检测）——已记录对象后续直接 push（省性能）
                        var qnR:String = flash.utils.getQualifiedClassName(oR);
                        var isAtk:Boolean = qnR.indexOf("fe.weapon::") == 0;
                        // 单位判断：fe.unit:: / fe.serv::（NPC 在 serv 包）/ 有 setPos 方法（Unit 子类）
                        var isUnit:Boolean = qnR.indexOf("fe.unit::") == 0 || qnR.indexOf("fe.serv::") == 0 || oR["setPos"] != null;
                        if (isAtk || isUnit)
                        {
                           // 单位/攻击体：必记录（补前期帧为当前位置，数组对齐 replayIdx）
                           arrR = [];
                           replayObjs[oR] = arrR;
                           replayObjArr.push(oR);
                           var sndR:String = "";
                           if (frameN > 0)
                           {
                              // 时停中生成的攻击体：记录生成音效（重演时重播）
                              try
                              {
                                 if (oR.weap != null && oR.weap.sndShoot != null) { sndR = oR.weap.sndShoot; }
                              }
                              catch (e:*) { }
                           }
                           for (var f0:int = 0; f0 < frameN; f0++) { arrR.push({ x: oR.X, y: oR.Y, f: -1, s: "", r: 0 }); }
                           arrR.push({ x: oR.X, y: oR.Y, f: animFrameOf(oR), s: sndR, r: oR.rot != null ? oR.rot : 0 });
                        }
                        else
                        {
                           // 场景对象：移动检测（动了才记录）
                           var sp:Object = seenPos[oR];
                           if (sp == null) { seenPos[oR] = { x: oR.X, y: oR.Y }; }
                           else if (sp.x != oR.X || sp.y != oR.Y)
                           {
                              arrR = [];
                              replayObjs[oR] = arrR;
                              replayObjArr.push(oR);
                              for (var f1:int = 0; f1 < frameN; f1++) { arrR.push({ x: sp.x, y: sp.y, f: -1, s: "", r: 0 }); }
                              arrR.push({ x: oR.X, y: oR.Y, f: -1, s: "", r: 0 });
                           }
                        }
                     }
                     else
                     {
                        arrR.push({ x: oR.X, y: oR.Y, f: animFrameOf(oR), s: "", r: oR.rot != null ? oR.rot : 0 });
                     }
                  }
               }
               catch (e:*) { }
               oR = nxR;
               if (++gR > 20000) break;
            }
         }
         catch (e:*) { }
      }

      // ===== 回放中重演：敌人/物品/场景/攻击体按历史状态设置（位置+动画帧+生成音效）=====
      private function replayObjects():void
      {
         try
         {
            if (sndClass == null)
            {
               try { sndClass = ApplicationDomain.currentDomain.getDefinition("fe.Snd") as Class; } catch (e:*) { }
            }
            var idxR:int = replayIdx;
            for each (var oR:Object in replayObjArr)
            {
               try
               {
                  var arrR:Array = replayObjs[oR];
                  if (arrR == null || arrR.length == 0) continue;
                  var stR:Object = arrR[Math.min(idxR, arrR.length - 1)];
                  if (stR == null) continue;
                  // 位置（setPos 更新碰撞边界——玩家子弹命中重演位置敌人正常结算）
                  if (oR["setPos"] != null) { oR.setPos(stR.x, stR.y); }
                  else { oR.X = stR.x; oR.Y = stR.y; }
                  // 视觉同步（setPos 不更新 vis——否则敌人视觉固定在时停结束位置）
                  try
                  {
                     if (oR["setVisPos"] != null) { oR.setVisPos(); }
                     else if (oR.vis != null) { oR.vis.x = stR.x; oR.vis.y = stR.y; }
                  }
                  catch (e:*) { }
                  // 攻击体方向恢复（飞行视觉朝记录时的方向——否则横着/反着飞）
                  if (stR.r != 0 && oR.vis != null)
                  {
                     try { oR.vis.rotation = stR.r * 180 / Math.PI; } catch (e:*) { }
                  }
                  // 动画帧（共用视觉体系，容错）
                  if (stR.f > 0)
                  {
                     try
                     {
                        if (oR.vis != null && oR.vis.osn != null && oR.vis.osn.body != null)
                        {
                           oR.vis.osn.body.gotoAndStop(stR.f);
                        }
                     }
                     catch (e:*) { }
                  }
                  // 生成音效（精确帧：攻击体生成事件在对应历史帧重播）
                  if (idxR < arrR.length)
                  {
                     var stS:Object = arrR[idxR];
                     if (stS != null && stS.s != null && stS.s != "" && sndClass != null)
                     {
                        try { sndClass["ps"](stS.s, stS.x, stS.y); } catch (e:*) { }
                     }
                  }
               }
               catch (e:*) { }
            }
         }
         catch (e:*) { }
      }

      // ===== 回放中玩家攻击体手动 step（世界冻结 onPause=true 时攻击体不自动 step）=====
      private function stepPlayerBullets():void
      {
         try
         {
            var locB:Object = world.loc;
            if (locB == null) return;
            var oB:Object = locB.firstObj;
            var gB:int = 0;
            while (oB != null)
            {
               var nxB:Object = oB.nobj;
               try
               {
                  if (oB["owner"] == world.gg && flash.utils.getQualifiedClassName(oB).indexOf("fe.weapon::") == 0)
                  {
                     oB.step();
                  }
               }
               catch (e:*) { }
               oB = nxB;
               if (++gB > 20000) break;
            }
         }
         catch (e:*) { }
      }

      // ===== 读取对象动画帧（共用视觉体系 vis.osn.body，容错）=====
      private function animFrameOf(o:Object):int
      {
         try
         {
            if (o.vis != null && o.vis.osn != null && o.vis.osn.body != null) { return o.vis.osn.body.currentFrame; }
         }
         catch (e:*) { }
         return -1;
      }

      // ===== 时停慢速世界：节流 step（每 slowfactor 帧对世界对象 step 1 次 = 1/N 速）=====
      // 玩家每帧手动 step（全速）；敌人/物品/攻击体按节流 step——动作与碰撞判定
      // 同步 1/N 速（真慢速，判定=视觉）。粒子（Part）由 stepParticles 单独处理。
      private function slowStepWorld():void
      {
         if (++slowTick % cfgSlowFactor != 0) return;
         try
         {
            if (slowPartClass == null)
            {
               try { slowPartClass = ApplicationDomain.currentDomain.getDefinition("fe.graph.Part") as Class; } catch (e:*) { }
            }
            var locS:Object = world.loc;
            if (locS == null) return;
            var oS:Object = locS.firstObj;
            var gS:int = 0;
            while (oS != null)
            {
               var nxS:Object = oS.nobj;
               try
               {
                  if (oS == world.gg) { /* 玩家跳过（手动 step 全速） */ }
                  else if (slowPartClass != null && oS is slowPartClass) { /* 粒子跳过（stepParticles） */ }
                  else
                  {
                     // 玩家攻击体伤害清零必须在 step **之前**（step 内 run 碰撞会结算）。
                     // 只对攻击体（fe.weapon::）访问 owner——动态属性访问对其他对象
                     // 可能抛异常（会被 catch 吞掉导致对象被跳过 step → 敌人固定不动）
                     var qnS:String = flash.utils.getQualifiedClassName(oS);
                     if (qnS.indexOf("fe.weapon::") == 0)
                     {
                        try
                        {
                           if (oS["owner"] == world.gg)
                           {
                              oS.damage = 0;
                              oS.damageExpl = 0;
                           }
                        }
                        catch (e:*) { }
                     }
                     oS.step();
                  }
               }
               catch (e:*) { }
               oS = nxS;
               if (++gS > 20000) break;
            }
         }
         catch (e:*) { }
      }

      // ===== 时停中近战复用攻击体伤害清零（WClub 的 b 不在 loc 链表，直接清）=====
      private function freezeMeleeDamage():void
      {
         try
         {
            var cwM:* = world.gg.currentWeapon;
            if (cwM == null || cwM.b == null) return;
            var qnM:String = flash.utils.getQualifiedClassName(cwM);
            if (qnM != "fe.weapon::WClub" && qnM != "fe.weapon::WPunch" && qnM != "fe.weapon::WKick") return;
            cwM.b.damage = 0;
            cwM.b.damageExpl = 0;
         }
         catch (e:*) { }
      }

      // ===== 快照时停结束时的武器/弹药状态（回放结束后恢复，保证回放零净消耗）=====
      private function buildSandyEndSnap():void
      {
         sandyEndSnap = null;
         try
         {
            sandyEndSnap = {};
            endWeapon = world.gg.currentWeapon;
            var wns:* = world.invent.weapons;
            for (var wid:String in wns)
            {
               try
               {
                  var wobj:* = wns[wid];
                  if (wobj != null) { sandyEndSnap["h_" + wid] = wobj.hold; }
               }
               catch (e:*) { }
            }
            var ammE:* = world.invent.ammos;
            for (var aE:String in ammE)
            {
               try { sandyEndSnap["it_" + aE] = world.invent.items[aE].kol; } catch (e:*) { }
            }
         }
         catch (e:*) { sandyEndSnap = null; }
      }

      // ===== 模拟游戏 changeWeaponNow：立即切换武器（无切换动画），配套视觉/GUI 更新 =====
      private function switchToWeapon(w:Object):void
      {
         try
         {
            if (world.gg.currentWeapon == w) return;
            if (world.gg.currentWeapon != null)
            {
               try { world.gg.currentWeapon.remVisual(); } catch (e:*) { }
            }
            world.gg.currentWeapon = w;
            world.gg.childObjs[0] = w;
            if (w != null)
            {
               try
               {
                  w.addVisual();
                  w.setNull();
                  w.setPers(world.gg, world.gg.pers);
                  world.gui.setWeapon();
               }
               catch (e:*) { log("[SandyMod] switchToWeapon visual error: " + e); }
            }
            log("[SandyMod] switchToWeapon -> " + (w != null ? w.id : "none"));
         }
         catch (e:*) { log("[SandyMod] switchToWeapon error: " + e); }
      }

      // ===== 恢复时停结束状态：回放结束后弹夹剩余=时停结束时，背包弹药不被回放消耗 =====
      private function restoreSandyEndSnap():void
      {
         if (sandyEndSnap == null) return;
         try
         {
            var wns:* = world.invent.weapons;
            for (var wid:String in sandyEndSnap)
            {
               if (wid.indexOf("h_") == 0)
               {
                  var tW:String = wid.substr(2);
                  try
                  {
                     var wobj:* = wns[tW];
                     if (wobj != null) { wobj.hold = sandyEndSnap[wid]; }
                  }
                  catch (e:*) { }
               }
               else if (wid.indexOf("it_") == 0)
               {
                  var tI:String = wid.substr(3);
                  try
                  {
                     var itR:* = world.invent.items[tI];
                     // 只恢复"少了"的（回放中瞬时换弹扣背包），拾取增加的保留
                     if (itR != null && itR.kol < sandyEndSnap[wid]) { itR.kol = sandyEndSnap[wid]; }
                  }
                  catch (e:*) { }
               }
            }
         }
         catch (e:*) { }
         sandyEndSnap = null;
      }

      // ==================== 参数面板 ====================
      private function togglePanel(open:Boolean):void
      {
         panelOpen = open;
         if (open)
         {
            if (sandyActive) endSandy();
            if (panelTf == null)
            {
               panelTf = new TextField();
               var tf:TextFormat = new TextFormat();
               tf.font = "Consolas";
               tf.size = 14;
               tf.color = 0x00FF99;
               tf.letterSpacing = 1;
               panelTf.defaultTextFormat = tf;
               panelTf.selectable = false;
               panelTf.mouseEnabled = false;
            }
            if (world != null && world.main != null && panelTf.parent == null)
            {
               world.main.addChild(panelTf);
            }
            panelSel = 0;
         }
         else
         {
            if (panelTf != null && panelTf.parent != null) panelTf.parent.removeChild(panelTf);
            saveConfigFile();
         }
      }

      private function panelKey(kc:int):void
      {
         if (kc == Keyboard.ESCAPE || kc == cfgPanelKey) { togglePanel(false); return; }
         if (kc == Keyboard.UP) { panelSel = (panelSel + 6 - 1) % 6; return; }
         if (kc == Keyboard.DOWN) { panelSel = (panelSel + 1) % 6; return; }
         if (kc == Keyboard.LEFT) { panelAdj(-1); return; }
         if (kc == Keyboard.RIGHT) { panelAdj(1); return; }
         if (kc == Keyboard.ENTER) { togglePanel(false); return; }
      }

      private function panelAdj(dir:int):void
      {
         switch (panelSel)
         {
            case 0: cfgDuration = Math.max(30, Math.min(3600, cfgDuration + dir * 30)); break;
            case 1: cfgCooldown = Math.max(0, Math.min(3600, cfgCooldown + dir * 30)); break;
            case 2: cfgReplaySpeed = Math.max(1, Math.min(20, cfgReplaySpeed + dir)); break;
            case 3: cfgGhostEvery = Math.max(1, Math.min(30, cfgGhostEvery + dir)); break;
            case 4: cfgFxRun = !cfgFxRun; break;
            case 5: cfgHotkey = Math.max(1, Math.min(255, cfgHotkey + dir)); break;
         }
      }

      private function renderPanel():void
      {
         if (panelTf == null) return;
         var lines:Array = [];
         lines.push("== SandevistanMod 参数 ==");
         lines.push((panelSel == 0 ? "> " : "  ") + "生效时长   " + (cfgDuration / 30).toFixed(1) + "s");
         lines.push((panelSel == 1 ? "> " : "  ") + "冷却       " + (cfgCooldown / 30).toFixed(1) + "s");
         lines.push((panelSel == 2 ? "> " : "  ") + "回放速度   x" + cfgReplaySpeed);
         lines.push((panelSel == 3 ? "> " : "  ") + "残影间隔   " + cfgGhostEvery + "帧");
         lines.push((panelSel == 4 ? "> " : "  ") + "特效继续   " + (cfgFxRun ? "开" : "关"));
         lines.push((panelSel == 5 ? "> " : "  ") + "热键码     " + cfgHotkey);
         lines.push("");
         lines.push("上下选择 左右调节 Enter保存 Esc关闭");
         panelTf.text = lines.join(String.fromCharCode(10));
         panelTf.x = 30;
         panelTf.y = 30;
         panelTf.width = 420;
         panelTf.height = 220;
         panelTf.visible = true;
      }

      private function saveConfigFile():void
      {
         try
         {
            var f:File = File.applicationDirectory.resolvePath("SandevistanMod/config.txt");
            var stream:FileStream = new FileStream();
            stream.open(f, FileMode.WRITE);
            var NL:String = String.fromCharCode(13, 10);
            var sb:Array = [];
            sb.push("# SandevistanMod config (saved by panel)");
            sb.push("# hotkey: 220=\  33=PageUp 34=PageDown 36=Home  F1-F12=112-123");
            sb.push("hotkey=" + cfgHotkey);
            sb.push("duration=" + cfgDuration);
            sb.push("cooldown=" + cfgCooldown);
            sb.push("replayspeed=" + cfgReplaySpeed);
            sb.push("ghostevery=" + cfgGhostEvery);
            sb.push("fxrun=" + (cfgFxRun ? 1 : 0));
            sb.push("showmark=" + (cfgShowMark ? 1 : 0));
            sb.push("panelkey=" + cfgPanelKey);
            sb.push("debugtest=0");
            stream.writeUTFBytes(sb.join(NL) + NL);
            stream.close();
            log("[SandyMod] config saved");
         }
         catch (e:*) { log("[SandyMod] config save error: " + e); }
      }

      // ==================== 斯安维斯坦 ====================
      private function startSandy():void
      {
         if (sandyActive || replaying) return;
         if (!inGameplay()) return;
         try
         {
            savedOnPause = world.onPause;
            // 时停慢速世界（v1.46）：onPause=true 冻结世界，模组节流 step——
            // 玩家每帧手动 step（全速），敌人/物品/攻击体每 slowfactor 帧 step 1 次
            // （1/N 速）。注：位移回退方案因帧序（模组先于游戏 step，渲染在游戏后）
            // 回退被全速移动覆盖而无效——节流是"真慢速"（动作/判定同步 1/N）
            world.onPause = true;
            // 时停中玩家无敌（godMode 挡伤害；invulner 让攻击体完全打不中——
            // 否则敌人攻击体命中玩家仍有击退/命中反馈的"当场结算"观感）
            try
            {
               savedGod = world.godMode;
               world.godMode = true;
               savedInvul = world.gg.invulner;
               world.gg.invulner = true;
            }
            catch (e:*) { }
            // 记录时停开始时的武器（回放开始切回它重演，回放结束切回时停结束时武器）
            startWeapon = null;
            try { startWeapon = world.gg.currentWeapon; } catch (e:*) { }
            endWeapon = null;
            sandyEndSnap = null;
            // 键状态处理：先保存当前按住的键，关 SATS（其 clearAll 会清布尔），再恢复，
            // 这样"按住空格/方向键进入时停"的玩家在时停中按键依然有效（Flash 不会为重按的键重发事件）
            try
            {
               var cSave:Array = [];
               var kNames:Array = ["keyLeft","keyRight","keyJump","keySit","keyBeUp","keyRun","keyAttack","keyPunch",
                  "keyReload","keyGrenad","keyMagic","keyDef","keyPet","keyAction","keyCrack","keyTele","keySats"];
               for (var ki:int = 0; ki < kNames.length; ki++)
               {
                  cSave[kNames[ki]] = world.ctr[kNames[ki]];
               }
               if (world.sats != null && world.sats.active)
               {
                  world.sats.onoff(-1);
               }
               for (ki = 0; ki < kNames.length; ki++)
               {
                  world.ctr[kNames[ki]] = cSave[kNames[ki]];
               }
            }
            catch (e:*) { }
            // 时停期间禁用玩家交互（防碰触 NPC/触发点 -> 对话 -> controlOff 锁死控制）
            try
            {
               savedInter = world.gg["inter"];
               world.gg["inter"] = null;
            }
            catch (e:*) { }
            sandyActive = true;
            sandyLeft = cfgDuration;
            history = new Array();
            // 清空上一轮重演记录（场景级录像：敌人/物品/攻击体每帧状态）
            replayObjs = new Dictionary();
            replayObjArr = [];
            seenPos = new Dictionary();
            rainbowIdx = 0;
            fxTicks = 0;
            if (ghostLayer == null)
            {
               ghostLayer = new Sprite();
            }
            else if (ghostLayer.parent != null)
            {
               ghostLayer.parent.removeChild(ghostLayer);
            }
            world.visual.addChild(ghostLayer);
            log("[SandyMod] 斯安维斯坦 ON");
         }
         catch (err:*) { trace("[SandyMod] start error: " + err); }
      }

      private function endSandy():void
      {
         if (!sandyActive) return;
         sandyActive = false;
         // 清除时停期间玩家发射的冻结子弹（回放重演攻击，避免双倍火力）
         clearFrozenBullets();
         // 快照时停结束状态（回放结束后恢复：弹夹剩余=时停结束时，背包弹药不被回放消耗）
         buildSandyEndSnap();

         try
         {
            // 回放期间世界冻结（场景级重演：敌人/物品不 step，由 replayObjects 重演；
            // 玩家手动 step 驱动攻击）——回放结束 endReplay 恢复 savedOnPause
            world.onPause = true;
            if (savedInter != null)
            {
               try { world.gg["inter"] = savedInter; } catch (e:*) { }
               savedInter = null;
            }
            // 结束时清理键状态（防残留）
            try
            {
               world.ctr.clearAll();
               var kd2:* = world.ctr["keyDowns"];
               if (kd2 != null)
               {
                  for (var ki2:int = 0; ki2 < kd2.length; ki2++) { kd2[ki2] = false; }
               }
            }
            catch (e:*) { }
            // 恢复玩家控制（防时停期间触发的 controlOff 锁死输入）
            try
            {
               if (world.gg.hp > 0 && world.gg.sost < 3)
               {
                  world.gg.controlOn();
               }
            }
            catch (e:*) { }
         }
         catch (e:*) { }
         replaying = true;
         replayIdx = 0;
         cooldownLeft = cfgCooldown;
         // ==== 真回放模式：玩家从起点沿历史路径快速重演（残影跟随玩家本体）====
         try
         {
            // godMode 已由 startSandy 保存（时停前值）——时停+回放全程无敌，结束恢复
            world.godMode = true;                 // 回放期间无敌（世界正常运行）
            savedGgCtrl = world.gg.ggControl;
            // 取消残留的武器切换动画流程（游戏 changeWeapon 冷却 30+20 帧，
            // 回放中武器切换必须立即生效、无冷却，否则动画流程会在回放中乱切武器）
            try
            {
               world.gg.work = "";
               world.gg.t_work = 0;
            }
            catch (e:*) { }
            // 回放开始切回时停开始时的武器（否则回放停留在时停结束时的最后武器）
            replayWpn = startWeapon;
            savedOtbros = -1;   // 重置击退原始值记录（回放中重新保存）
            switchToWeapon(startWeapon);
            if (history.length > 0)
            {
               world.gg.setPos(history[0].x, history[0].y);   // 传送回起点
               world.gg.setVisPos();
            }

         }
         catch (e:*) { log("[SandyMod] replay init error: " + e); }
         log("[SandyMod] 斯安维斯坦 OFF, replay " + history.length + " frames");
      }

      private function stepSandy():void
      {
         try
         {
            // 时停慢速世界（v1.46）帧序：
            // 1. 帧首：近战复用攻击体伤害清零（时停中命中 0 伤害，回放重演结算）
            // 2. 玩家手动 step（全速）
            // 3. 记录历史（玩家位置）
            // 4. 节流 step：每 slowfactor 帧对敌人/物品/攻击体 step 1 次（1/N 速）
            freezeMeleeDamage();
            var wantA:Boolean = false;
            var wantP:Boolean = false;
            try
            {
               // 鼠标脉冲：同帧 DOWN+UP 的快速连点也能记录（按住由 mouseAtkDown 持续）
               wantA = world.ctr.keyAttack || mouseAtkDown || mouseAtkPulse;
               wantP = world.ctr.keyPunch;
            }
            catch (e:*) { }
            mouseAtkPulse = false;   // 脉冲每帧消费一次
            var loc:Object = world.loc;
            loc.gg.step();   // 玩家全速手动 step

            var gg:Object = loc.gg;
            // 记录攻击键状态与瞄准方向（回放时攻击指向时停期间的发射方向）
            history.push({ x: gg.X, y: gg.Y, s: gg.storona, r: gg.vis != null ? gg.vis.rotation : 0, v: gg.vis != null ? gg.vis.scaleX : 1,
                           a: wantA, p: wantP, g: world.ctr.keyGrenad, m: world.ctr.keyMagic,
                           ax: world.celX, ay: world.celY,
                           w: world.gg.currentWeapon != null ? world.gg.currentWeapon.id : "",
                           wx: world.gg.currentWeapon != null ? world.gg.currentWeapon.X : 0,
                           wy: world.gg.currentWeapon != null ? world.gg.currentWeapon.Y : 0 });
            // 节流 step：敌人/物品/攻击体 1/N 速（含攻击体慢速判定）
            slowStepWorld();
            // 记录重演状态（场景级录像：敌人/物品/攻击体每帧位置+动画帧+生成音效）
            recordReplayObjects();
            // 时停攻击状态诊断（每 30 帧）：观察时停中攻击意图与武器状态
            if (++sandyAtkTick % 30 == 0)
            {
               try
               {
                  var cwS:* = world.gg.currentWeapon;
                  log("[DIAG] sAtk: wantA=" + wantA + " wantP=" + wantP
                      + " A=" + world.ctr.keyAttack + " mouse=" + mouseAtkDown + " pulse=" + mouseAtkPulse
                      + " tA=" + (cwS != null ? cwS.t_attack : -1)
                      + " cw=" + (cwS != null ? flash.utils.getQualifiedClassName(cwS) : "none"));
               }
               catch (e:*) { }
            }
            // 时停敌人移动诊断（每 60 帧）：验证节流 step 是否生效（敌人位置应变化）
            if (++sandyEnemyTick % 60 == 0)
            {
               try
               {
                  var oE2:Object = world.loc.firstObj;
                  var gE2:int = 0;
                  while (oE2 != null)
                  {
                     var nxE2:Object = oE2.nobj;
                     try
                     {
                        if (oE2 != world.gg && oE2["setPos"] != null)
                        {
                           log("[DIAG] sEnemy: X=" + oE2.X + " Y=" + oE2.Y + " cls=" + flash.utils.getQualifiedClassName(oE2));
                           break;
                        }
                     }
                     catch (e:*) { }
                     oE2 = nxE2;
                     if (++gE2 > 20000) break;
                  }
               }
               catch (e:*) { }
            }


            fxTicks++;
            if (fxTicks >= cfgGhostEvery)
            {
               fxTicks = 0;
               spawnGhost(gg, palette(rainbowIdx));
               rainbowIdx++;
            }
            if (diagTick++ % 30 == 0)
            {
               var cam:Object = world.cam;
               log("[DIAG] cam: vx=" + cam.vx + " vy=" + cam.vy + " scaleV=" + cam.scaleV
                   + " visual.x=" + world.visual.x + " visual.y=" + world.visual.y
                   + " visual.scaleX=" + world.visual.scaleX + " visual.scaleY=" + world.visual.scaleY
                   + " gg.vis.parent=" + gg.vis.parent + " ghostLayer.numChildren=" + ghostLayer.numChildren);
            }

            if (cfgFxRun)
            {
               stepParticles(world.loc);
            }

            // [DIAG] jump simulation: every 60 frames press jump for 3 frames
            diagTick++;
            if (debugTest)
            {
               if (diagTick % 60 < 3)
               {
                  world.ctr.keyJump = true;
               }
               else if (diagTick % 60 == 3)
               {
                  log("[DIAG] jump pressed, Y=" + gg.Y + " dy=" + gg.dy + " stay=" + gg.stay);
               }
               else if (diagTick % 60 == 10)
               {
                  log("[DIAG] after jump 7f: Y=" + gg.Y + " dy=" + gg.dy + " stay=" + gg.stay + " jumpp=" + gg.jumpp
                      + " maxjumpp=" + gg.maxjumpp + " dash_t=" + gg.dash_t + " dash_maxt=" + gg.dash_maxt
                      + " isJump=" + gg.isJump + " isLaz=" + gg.isLaz + " jumpNumb=" + gg.jumpNumb);
               }
            }

            --sandyLeft;
            if (sandyLeft <= 0)
            {
               endSandy();
            }
         }
         catch (err:*) { log("[SandyMod] stepSandy error: " + err); endSandy(); }
      }

      // 只步进链表中是粒子的对象（Part 类），并维护 Emitter 计数
      private function stepParticles(loc:Object):void
      {
         var PartClass:Class = null;
         try { PartClass = ApplicationDomain.currentDomain.getDefinition("fe.graph.Part") as Class; } catch (e:*) { return; }
         var EmitterClass:Class = null;
         try { EmitterClass = ApplicationDomain.currentDomain.getDefinition("fe.graph.Emitter") as Class; } catch (e:*) { }
         if (EmitterClass != null)
         {
            EmitterClass["kol2"] = EmitterClass["kol1"];
            EmitterClass["kol1"] = 0;
         }
         var obj:Object = loc.firstObj;
         var guard:int = 0;
         while (obj != null)
         {
            var nxt:Object = obj.nobj;
            if (obj is PartClass)
            {
               obj.step();
            }
            obj = nxt;
            if (++guard > 20000) break;
         }
      }

      // ==================== 回放 ====================
      private function stepReplay():void
      {
         try
         {
            // 锁定输入：回放期间玩家不可操控（清空键状态，control 读到全 false）
            world.ctr.clearAll();
            // 回放中弹匣无限 + 跳过换弹计时（攻击持续流畅，不被换弹打断）
            var cwR:* = world.gg.currentWeapon;
            if (cwR != null)
            {
               if (cwR.holder > 0) { cwR.hold = cwR.holder; }
               cwR.t_reload = 0;
            }
            // 消除回放中游戏武器切换冷却：取消残留切换动画流程，并钉住回放武器
            // （否则 changeWeapon 的 changeWeaponNow 会在回放中触发，把武器切走/卸掉）
            try
            {
               if (world.gg.work == "change") { world.gg.work = ""; world.gg.t_work = 0; }
               if (replayWpn != null && world.gg.currentWeapon != replayWpn) { switchToWeapon(replayWpn); }
            }
            catch (e:*) { }
         }
         catch (e:*) { }
         // 回放段诊断：loc 中攻击体计数（生成/结算是否平衡）与弹夹状态（每 60 帧）
         if (++replayDiagTick % 60 == 1)
         {
            try
            {
               var locR:Object = world.loc;
               var oR:Object = locR.firstObj;
               var nR:int = 0;
               var guardR:int = 0;
               while (oR != null)
               {
                  try
                  {
                     if (flash.utils.getQualifiedClassName(oR).indexOf("fe.weapon::") == 0) { nR++; }
                  }
                  catch (e:*) { }
                  oR = oR.nobj;
                  if (++guardR > 20000) break;
               }
               var cwD:* = world.gg.currentWeapon;
               log("[DIAG] replay: locWeapons=" + nR + " hold=" + (cwD != null ? cwD.hold : -1)
                   + " holder=" + (cwD != null ? cwD.holder : -1) + " t_atk=" + (cwD != null ? cwD.t_attack : -1));
            }
            catch (e:*) { }
         }
         var n:int = Math.ceil(cfgReplaySpeed);
         var ghostIdx:int = replayIdx;
         var atkOn:Boolean = false;
         var punchOn:Boolean = false;
         var grenOn:Boolean = false;
         var magOn:Boolean = false;
         var prevWid:String = replayWpn != null ? replayWpn.id : "";   // 当前回放武器 id（用于重演切换）
         for (var i:int = 0; i < n; i++)
         {
            if (replayIdx >= history.length)
            {
               endReplay();
               return;
            }
            var h:Object = history[replayIdx];
            // 武器切换重演：历史中武器变化时立即切换（无冷却，跟随时停期间的切枪）
            if (h.w != null && h.w != prevWid)
            {
               var tgtW:Object = h.w == "" ? null : world.invent.weapons[h.w];
               switchToWeapon(tgtW);
               replayWpn = tgtW;
               prevWid = h.w;
            }
            // 驱动玩家沿历史路径移动（真回放：玩家本体重演）
            try
            {
               world.gg.X = h.x;
               world.gg.Y = h.y;
               world.gg.storona = h.s;
               world.gg.setVisPos();
               // 喂回记录的瞄准方向（攻击指向时停期间的发射方向）
               if (h.ax != null)
               {
                  world.celX = h.ax;
                  world.celY = h.ay;
                  // 武器位置：枪械强制就位（枪口钉在角色手上，跳过渐进旋转）；
                  // 近战重现时停期间的独立位置（历史 wx/wy + 清插值 del，
                  // 否则 WClub.actions 的追赶插值追不上回放中瞬移的瞄准点，
                  // 武器会滞留在时停结束时的位置）
                  try
                  {
                     var wv:* = world.gg.currentWeapon;
                     if (wv != null)
                     {
                        var qnW:String = flash.utils.getQualifiedClassName(wv);
                        var meleeW:Boolean = qnW == "fe.weapon::WClub" || qnW == "fe.weapon::WPunch" || qnW == "fe.weapon::WKick";
                        if (meleeW)
                        {
                           wv.X = h.wx;
                           wv.Y = h.wy;
                           try { wv.del.x = 0; wv.del.y = 0; } catch (e:*) { }
                        }
                        else
                        {
                           wv.X = world.gg.weaponX;          // 枪口位置就位
                           wv.Y = world.gg.weaponY;
                           wv.rot = Math.atan2(h.ay - world.gg.Y, h.ax - world.gg.X);  // 瞄准角
                           wv.ready = true;                   // 视为已就位（可立即攻击）
                        }
                     }
                  }
                  catch (e:*) { }
               }
            }
            catch (e:*) { }
            // 攻击键 OR 合并（窗口内任一历史帧按下则本帧触发，点按不丢）
            if (h.a == true) atkOn = true;
            if (h.p == true) punchOn = true;
            if (h.g == true) grenOn = true;
            if (h.m == true) magOn = true;
            // 残影抽稀：每 cfgReplayGhost 个历史帧生成 1 个（每帧最多 1 个）
            if (cfgReplayGhost < 1) cfgReplayGhost = 1;
            if (ghostIdx % cfgReplayGhost == 0)
            {
               spawnGhostAt(h.x, h.y, h.s, h.r, h.v, palette(rainbowIdx));
               rainbowIdx++;
            }
            replayIdx++;
         }
         // 回放时攻击加速重演：有攻击的帧加速推进武器冷却（远快于正常攻速）
         // 注意：近战攻击体在冷却递减到 bindMove 窗口（t_attack ∈ [rapid_act/2,
         // rapid_act*5/6]，如 [5,8]）才推进结算——加速过猛（清 0 或 -=5）会让窗口
         // 只剩 1 帧甚至跳过，攻击体无结算机会（挥动画有但无伤害）——近战用 -=3
         // （窗口 2 帧），枪械用 -=5（attack() 内立即射击不受窗口影响）
         if (atkOn || punchOn || grenOn || magOn)
         {
            try
            {
               var cw3:* = world.gg.currentWeapon;
               if (cw3 != null)
               {
                  var qn3:String = flash.utils.getQualifiedClassName(cw3);
                  var melee3:Boolean = qn3 == "fe.weapon::WClub" || qn3 == "fe.weapon::WPunch" || qn3 == "fe.weapon::WKick";
                  if (melee3)
                  {
                     // 允许攻速：rapid 11 → 2（匹配快速连点频率，不吞攻击）
                     if (savedRapids[cw3.id] == null) { savedRapids[cw3.id] = cw3.rapid; }
                     cw3.rapid = 2;
                     // 关键：WClub.shoot 会设 t_auto=3（近战特有的 3 帧攻击冷却），
                     // attack() 在 t_auto>0 时直接 return——不清掉则 rapid=2 被拖成
                     // 实际每 4 帧一刀（吞攻击的元凶）
                     cw3.t_auto = 0;
                     // t_attack 自然走（rapid=2 → 每 2 帧一刀，动画正常）
                     // 攻击体结算兜底：rapid=2 后 bindMove 窗口（tA∈[5,8]）被跳过，
                     // 攻击体的 run 碰撞在模组手动推进下不可靠（大步只测终点、
                     // 贴脸敌人被跳过等实测均 miss）——改为**直接结算**：
                     // 攻击体位置放玩家前方挥击点，对范围内敌人直接调 udarBullet
                     // （完整伤害/击退结算）+ popadalo（命中反馈），完全绕开碰撞
                     if (cw3.b != null && cw3.b.off == false)
                     {
                        var angB:Number = Math.atan2(world.celY - world.gg.Y, world.celX - world.gg.X);
                        cw3.b.X = world.gg.X + Math.cos(angB) * 60;
                        cw3.b.Y = world.gg.Y + Math.sin(angB) * 60 - 10;
                        try
                        {
                           var unitsArr:Object = world.loc.units;
                           for each (var uu:Object in unitsArr)
                           {
                              if (cw3.b.off) break;
                              if (uu == world.gg) continue;
                              if (uu.sost == 4 || uu.disabled || uu.trigDis) continue;
                              if (uu.loc != world.loc) continue;
                              try { if (uu.fraction == world.gg.fraction) continue; } catch (e:*) { }
                              var ddxB:Number = uu.X - cw3.b.X;
                              var ddyB:Number = uu.Y - cw3.b.Y;
                              if (ddxB * ddxB + ddyB * ddyB < 80 * 80)
                              {
                                 var hitResB:int = uu.udarBullet(cw3.b);
                                 if (hitResB >= 0) { cw3.b.popadalo(hitResB); }
                                 cw3.b.off = true;
                                 break;
                              }
                           }
                        }
                        catch (e:*) { }
                     }
                     // 击退缩放：回放攻击频率约 5 倍 → 每次命中击退缩到 1/5，
                     // 总击退位移 ≈ 正常游戏（避免敌人被连续击退甩飞）
                     try
                     {
                        if (cw3.b != null)
                        {
                           if (savedOtbros < 0) { savedOtbros = cw3.b.otbros; }
                           cw3.b.otbros = savedOtbros / 5;
                        }
                     }
                     catch (e:*) { }
                  }
                  else
                  {
                     cw3.t_attack -= 5;
                     if (cw3.t_attack < 0) { cw3.t_attack = 0; }
                  }
                  cw3.t_reload = 0;
               }
            }
            catch (e:*) { }
         }
         try
         {
            world.ctr.keyAttack = atkOn;
            world.ctr.keyPunch = punchOn;
            world.ctr.keyGrenad = grenOn;
            world.ctr.keyMagic = magOn;
         }
         catch (e:*) { }
         // 世界冻结（onPause=true）下的手动驱动：
         // 1. 玩家手动 step（消费喂回的键 → 攻击/动画）
         // 2. 玩家攻击体手动 step（全速飞行+碰撞结算）
         // 3. 敌人/物品/场景/攻击体重演（位置+动画帧+生成音效）
         // 4. 粒子特效照常（枪口火焰等）
         try { world.loc.gg.step(); } catch (e:*) { }
         stepPlayerBullets();
         replayObjects();
         if (cfgFxRun) { try { stepParticles(world.loc); } catch (e:*) { } }
         // 回放攻击体状态诊断（每 3 帧）：攻击体位置/伤害/off 状态（定位近战结算问题）
         if (++replayBodyTick % 3 == 0)
         {
            try
            {
               var cwB:* = world.gg.currentWeapon;
               if (cwB != null && cwB.b != null)
               {
                  log("[DIAG] rBody: bX=" + cwB.b.X + " bY=" + cwB.b.Y + " dmg=" + cwB.b.damage
                      + " off=" + cwB.b.off + " liv=" + cwB.b.liv + " vel=" + cwB.b.vel
                      + " ggX=" + world.gg.X + " ggY=" + world.gg.Y
                      + " cwX=" + cwB.X + " cwY=" + cwB.Y + " tA=" + cwB.t_attack);
               }
            }
            catch (e:*) { }
         }
         // 回放攻击链路诊断（每 10 帧）：确认喂回与游戏攻击条件
         if (++replayAtkTick % 10 == 0)
         {
            try
            {
               var cwA:* = world.gg.currentWeapon;
               log("[DIAG] rAtk: atkOn=" + atkOn + " kA=" + world.ctr.keyAttack
                   + " tA=" + (cwA != null ? cwA.t_attack : -1)
                   + " atkPos=" + (cwA != null ? cwA.attackPos() : false)
                   + " cw=" + (cwA != null ? flash.utils.getQualifiedClassName(cwA) : "none"));
            }
            catch (e:*) { }
         }
         if (replayIdx >= history.length)
         {
            endReplay();
         }
      }

      private function endReplay():void
      {
         replaying = false;
         history = new Array();
         try
         {
            // 回放结束：恢复世界运行（敌人/场景恢复自由行动）
            world.onPause = savedOnPause;
            world.godMode = savedGod;    // 恢复无敌状态
            try { world.gg.invulner = savedInvul; } catch (e:*) { }   // 恢复免疫
            world.ctr.keyAttack = false;
            world.ctr.keyPunch = false;
            world.ctr.keyGrenad = false;
            world.ctr.keyMagic = false;
         }
         catch (e:*) { }
         // 清空场景重演记录
         replayObjs = new Dictionary();
         replayObjArr = [];
         seenPos = new Dictionary();
         // 回放结束：切回时停结束时手上的武器，恢复弹夹/背包（弹夹剩余=时停结束时）
         try
         {
            // 取消残留切换动画（回放结束的切换同样立即生效）
            try { world.gg.work = ""; world.gg.t_work = 0; } catch (e:*) { }
            // 恢复回放中改过的武器攻速（rapid）
            for (var rid:String in savedRapids)
            {
               try
               {
                  var wR:* = world.invent.weapons[rid];
                  if (wR != null) { wR.rapid = savedRapids[rid]; }
               }
               catch (e:*) { }
            }
            savedRapids = {};
            switchToWeapon(endWeapon);
            restoreSandyEndSnap();
            replayWpn = null;
         }
         catch (e:*) { log("[SandyMod] endReplay restore error: " + e); }


         if (debugTest)
         {
            try
            {
               var c:Object = world.ctr;
               log("[DIAG] endReplay: keyLeft=" + c.keyLeft + " keyRight=" + c.keyRight + " keyJump=" + c.keyJump
                   + " keyAttack=" + c.keyAttack + " keyTele=" + c.keyTele + " ggControl=" + world.gg.ggControl
                   + " onPause=" + world.onPause + " allStat=" + world.allStat + " panelOpen=" + panelOpen
                   + " focus=" + world.swfStage.focus);
            }
            catch (e:*) { log("[DIAG] endReplay state err: " + e); }
         }
      }

      // ==================== 残影 ====================
      // 位图不透明像素质心 x（网格采样，用于翻转对照诊断判定镜像是否生效）
      private function ghostCenterX(bd:BitmapData):Number
      {
         var s:Number = 0;
         var wSum:Number = 0;
         try
         {
            for (var yy:int = 40; yy < bd.height - 40; yy += 8)
            {
               for (var xx:int = 20; xx < bd.width - 20; xx += 8)
               {
                  var al:int = bd.getPixel32(xx, yy) >>> 24;
                  if (al > 0)
                  {
                     s += xx * al;
                     wSum += al;
                  }
               }
            }
         }
         catch (e:*) { }
         return wSum > 0 ? s / wSum : -1;
      }

      private function spawnGhost(gg:Object, ct:ColorTransform):void
      {
         try
         {
            var vis:* = gg.vis;
            if (vis == null || !vis.visible) { log("[DIAG] spawnGhost skip: vis null/not visible"); return; }
            var w:Number = vis.width;
            var h:Number = vis.height;
            if (w < 1 || h < 1) { log("[DIAG] spawnGhost skip: w=" + w + " h=" + h); return; }
            var bmp:BitmapData = new BitmapData(w, h, true, 0);
            var m:Matrix = new Matrix();
            var b:Rectangle = vis.getBounds(vis);
            m.tx = -b.left;
            m.ty = -b.top;
            var savedHp:Boolean = false;
            if (gg.hpbar != null && gg.hpbar.visible) { savedHp = true; gg.hpbar.visible = false; }
            // 消除双重缩放：draw 会应用父级链变换（world.visual 相机缩放 0.667），
            // 临时脱离父容器绘制（同帧加回，无渲染间隙），残影尺寸与玩家本体一致
            var savedParent:Object = vis.parent;
            var savedIdx:int = -1;
            if (savedParent != null)
            {
               try { savedIdx = savedParent.getChildIndex(vis); } catch (e:*) { }
               try { savedParent.removeChild(vis); } catch (e:*) { }
            }
            // 朝向镜像（根因修复）：draw 的 matrix 参数替换源显示变换（忽略 vis.scaleX），
            // 动画帧是朝右绘制的——朝左（storona<0）时用水平翻转矩阵画出镜像内容
            var dm:Matrix = m;
            if (gg.storona < 0) { dm = new Matrix(-1, 0, 0, 1, b.right, m.ty); }
            bmp.draw(vis as IBitmapDrawable, dm, ct, "normal", null, true);
            if (savedParent != null)
            {
               try { savedParent.addChildAt(vis, savedIdx); } catch (e:*) { }
            }
            if (savedHp) gg.hpbar.visible = true;
            if (debugTest || cfgDiagLog)
            {
               // 质心诊断：cxA<mid=内容偏左（朝左），cxA>mid=内容偏右（朝右）
               var cxA:Number = ghostCenterX(bmp);
               log("[DIAG] mirror: cxA=" + cxA + " mid=" + (w / 2)
                   + " storona=" + gg.storona + " visScaleX=" + vis.scaleX);
            }
            var bit:Bitmap = new Bitmap(bmp, "auto", true);
            var spr:Sprite = new Sprite();
            spr.x = vis.x + b.left;
            spr.y = vis.y + b.top;
            log("[DIAG] spawnGhost: gg.X=" + gg.X + " gg.Y=" + gg.Y + " vis.x=" + vis.x + " vis.y=" + vis.y
                + " b.left=" + b.left + " b.top=" + b.top + " b.w=" + b.width + " b.h=" + b.height
                + " storona=" + gg.storona + " vis.scaleX=" + vis.scaleX + " spr.x=" + spr.x + " spr.y=" + spr.y
                + " ghostParent=" + (ghostLayer.parent == world.visual));
            spr.addChild(bit);
            bit.blendMode = cfgGhostBlend == 0 ? "add" : "normal";
            ghostLayer.addChild(spr);
            ghosts.push({ s: spr, t: 30, b: bmp });
         }
         catch (e:*) { log("[DIAG] spawnGhost ERROR: " + e + " vis=" + (world != null && world.gg != null ? world.gg.vis : "n/a")); }
      }

      private function spawnGhostAt(x:Number, y:Number, s:Number, rot:Number, sc:Number, ct:ColorTransform):void
      {
         try
         {
            var gg:Object = world.gg;
            if (gg == null || gg.vis == null) return;
            var vis:* = gg.vis;
            var w:Number = vis.width;
            var h:Number = vis.height;
            if (w < 1 || h < 1) return;
            var bmp:BitmapData = new BitmapData(w, h, true, 0);
            var m:Matrix = new Matrix();
            var b:Rectangle = vis.getBounds(vis);
            m.tx = -b.left;
            m.ty = -b.top;
            // 朝向镜像（根因修复）：draw 的 matrix 替换源显示变换（忽略 vis.scaleX），
            // 动画帧是朝右绘制的——历史朝向 s<0 时用水平翻转矩阵画出镜像内容
            var dm:Matrix = m;
            if (s < 0) { dm = new Matrix(-1, 0, 0, 1, b.right, m.ty); }
            // 消除双重缩放（同 spawnGhost：临时脱离父容器绘制）
            var savedParent:Object = vis.parent;
            var savedIdx:int = -1;
            if (savedParent != null)
            {
               try { savedIdx = savedParent.getChildIndex(vis); } catch (e:*) { }
               try { savedParent.removeChild(vis); } catch (e:*) { }
            }
            bmp.draw(vis as IBitmapDrawable, dm, ct, "normal", null, true);
            if (savedParent != null)
            {
               try { savedParent.addChildAt(vis, savedIdx); } catch (e:*) { }
            }
            if (debugTest || cfgDiagLog)
            {
               // 质心诊断：cxA<mid=内容偏左（朝左），cxA>mid=内容偏右（朝右）
               var cxA:Number = ghostCenterX(bmp);
               log("[DIAG] ghostAt-f: s=" + s + " storona=" + gg.storona + " visScaleX=" + vis.scaleX
                   + " cxA=" + cxA + " mid=" + (w / 2));
            }
            var bit:Bitmap = new Bitmap(bmp, "auto", true);
            var spr:Sprite = new Sprite();
            spr.x = x + b.left;
            spr.y = y + b.top;
            log("[DIAG] spawnGhostAt: x=" + x + " y=" + y + " b.left=" + b.left + " b.top=" + b.top
                + " spr.x=" + spr.x + " spr.y=" + spr.y + " vis.w=" + vis.width + " vis.h=" + vis.height
                + " gg.vis.x=" + gg.vis.x + " gg.vis.y=" + gg.vis.y + " gg.X=" + gg.X + " gg.Y=" + gg.Y);
            spr.rotation = rot;
            spr.addChild(bit);
            bit.blendMode = cfgGhostBlend == 0 ? "add" : "normal";
            ghostLayer.addChild(spr);
            ghosts.push({ s: spr, t: 15, b: bmp });
         }
         catch (e:*) { log("[DIAG] spawnGhostAt ERROR: " + e); }
      }

      private function updateGhosts():void
      {
         if (ghosts.length == 0) return;
         var i:int = ghosts.length - 1;
         while (i >= 0)
         {
            var g:Object = ghosts[i];
            g.t--;
            g.s.alpha = g.t / 30;
            if (g.t <= 0)
            {
               if (g.s.parent != null) g.s.parent.removeChild(g.s);
               g.b.dispose();
               ghosts.splice(i, 1);
            }
            i--;
         }
      }

      // 窗口失焦：Flash 会丢失按键 UP 事件导致卡键（游戏自身 bug），模组兜底清理
      private function onDeactivateClear(e:Event):void
      {
         try
         {
            if (world != null && world.ctr != null)
            {
               world.ctr.clearAll();
               var kd:* = world.ctr["keyDowns"];
               if (kd != null)
               {
                  for (var i:int = 0; i < kd.length; i++) { kd[i] = false; }
               }
            }
            keyPressTime = new Array();
         }
         catch (err:*) { }
      }

      // 鼠标按住/按下脉冲状态（快速连点同帧 DOWN+UP 时按住状态会被立即清除，
      // 用脉冲记录"本帧发生过按下"，供历史记录真实攻击意图）
      private function onMouseDown(e:MouseEvent):void
      {
         try { mouseAtkDown = true; mouseAtkPulse = true; } catch (err:*) { }
      }

      private function onMouseUp(e:MouseEvent):void
      {
         try { mouseAtkDown = false; } catch (err:*) { }
      }

      private function onKeyUp(e:KeyboardEvent):void
      {
         // 输入法真卡键判定：UP 无对应 DOWN（2 秒内 >=2 次才算真卡键；
         // 输入法切换瞬间会出现 1 次，属正常不警告）
         if (e.keyCode > 0 && e.keyCode < 256)
         {
            var dt:* = keyDownSeen[e.keyCode];
            if (dt == null)
            {
               var nowM:int = getTimer();
               if (nowM - imeMissTime > 2000) { imeMissCount = 1; imeMissTime = nowM; }
               else { imeMissCount++; }
               if (imeMissCount >= 2)
               {
                  imeWarnT = 90;   // 3 秒警告
                  if (cfgDiagLog) { try { log("[IME] miss x" + imeMissCount + " kc=" + e.keyCode); } catch (err:*) { } }
               }
               else if (cfgDiagLog)
               {
                  try { log("[IME] miss x1 kc=" + e.keyCode + " (switch transient, no warn)"); } catch (err:*) { }
               }
            }
            keyDownSeen[e.keyCode] = null;
         }
         if (cfgDiagLog)
         {
            try { log("[KEY] U " + e.keyCode); } catch (err:*) { }
         }
         try
         {
            if (keyPressTime[e.keyCode] != null)
            {
               keyPressTime[e.keyCode] = null;
            }
         }
         catch (err:*) { }
      }

      // ==================== 输入 ====================
      private function onKey(e:KeyboardEvent):void
      {
         // ===== 中文输入法（IME）检测 =====
         // 真卡键特征：字母键的 KEY_DOWN 被输入法在系统层截获（只发 229 或直接丢失），
         // 随后只有 KEY_UP 到达。判定：
         //   1) 收到 KEY_UP 但之前没有对应 KEY_DOWN → 该键 DOWN 被吃 → 真卡键 → 警告
         //   2) 短时间内连续出现 229 事件（>=2 次/3秒）→ 输入法活跃 → 警告
         // 单个 229 不警告（输入法切换瞬间/英文模式 Shift 等也会产生，属正常）
         if (e.keyCode == 229)
         {
            var nowT:int = getTimer();
            if (nowT - ime229Time > 3000) { ime229Count = 1; ime229Time = nowT; }
            else { ime229Count++; }
            if (ime229Count >= 2)
            {
               imeWarnT = 150;
               if (cfgDiagLog) { try { log("[IME] 229 x" + ime229Count); } catch (err:*) { } }
            }
         }
         else if (e.keyCode > 0 && e.keyCode < 256)
         {
            keyDownSeen[e.keyCode] = getTimer();
         }

         // ===== 按键诊断（diaglog=1 时记录按键事件与游戏状态，用于定位卡键）=====
         if (cfgDiagLog)
         {
            try
            {
               log("[KEY] D " + e.keyCode + "->" + keyMap[e.keyCode]
                   + " pip=" + (world != null && world.pip != null ? world.pip.active : -1)
                   + " stand=" + (world != null && world.stand != null ? world.stand.active : -1)
                   + " consol=" + (world != null ? world.onConsol : -1)
                   + " setkey=" + (world != null && world.ctr != null ? world.ctr.setkeyOn : -1)
                   + " guiPause=" + (world != null && world.gui != null ? world.gui.guiPause : -1)
                   + " ctrActive=" + (world != null && world.ctr != null ? world.ctr.active : -1)
                   + " focus=" + (world != null ? world.swfStage.focus : -1));
            }
            catch (err:*) { }
         }

         // ===== 卡键自愈（游戏本体 bug：clearAll 不清 keyDowns + 失焦丢 UP）=====
         // keyDowns 是 internal 无法访问；改为：KEY_DOWN 时按 keyXML 键位表
         // 强制设置键布尔（public），无论游戏是否因 keyDowns 残留而忽略本次按键，
         // 按键都立即生效。UI 占用输入时（键位重绑/菜单/商店）跳过。
         try
         {
            if (world != null && world.ctr != null)
            {
               var cc:Object = world.ctr;
               if (!cc.setkeyOn && !(world.pip != null && world.pip.active) && !(world.stand != null && world.stand.active))
               {
                  var kb2:* = keyMap[e.keyCode];
                  if (kb2 != null)
                  {
                     cc[kb2] = true;
                  }
               }
            }
         }
         catch (err:*) { }

         if (keyPressTime[e.keyCode] == null)
         {
            keyPressTime[e.keyCode] = getTimer();
         }
         if (panelOpen)
         {
            panelKey(e.keyCode);
            e.stopPropagation();
            return;
         }
         // ===== 选项页模组设置面板（主菜单/游戏内 Options 页）=====
         if (optPanelOn)
         {
            if (e.keyCode == Keyboard.UP) { optSel = 0; return; }
            if (e.keyCode == Keyboard.DOWN) { optSel = 1; return; }
            if (e.keyCode == Keyboard.LEFT) { optAdj(-1); return; }
            if (e.keyCode == Keyboard.RIGHT) { optAdj(1); return; }
            if (e.keyCode == Keyboard.ENTER) { saveConfigFile(); return; }
            // 其它键放行（PipBuck 正常处理，如 TAB 关闭）
         }
         if (e.keyCode == cfgPanelKey)
         {
            if (!sandyActive && !replaying && inGameplay())
            {
               togglePanel(true);
            }
            return;
         }
         if (e.keyCode == cfgHotkey)
         {
            if (sandyActive)
            {
               endSandy();
               e.stopPropagation();
            }
            else if (replaying)
            {
               // 回放中忽略
            }
            else if (cooldownLeft <= 0)
            {
               startSandy();
               e.stopPropagation();
            }
         }
         else if (sandyActive)
         {
            // 时停期间屏蔽 SATS / PipBuck / 交互键（E），避免触发对话锁死控制
            try
            {
               var ctr:Object = world.ctr;
               if (ctr == null) return;
               if (e.keyCode == ctr.keyIds["keySats"].a1 || (ctr.keyIds["keySats"].a2 != null && e.keyCode == ctr.keyIds["keySats"].a2))
               {
                  ctr.keySats = false;
               }
               if (e.keyCode == ctr.keyIds["keyPip"].a1)
               {
                  ctr.keyPip = false;
               }
               if (e.keyCode == ctr.keyIds["keyAction"].a1)
               {
                  ctr.keyAction = false;
               }
            }
            catch (err:*) { }
         }
      }

      // ==================== HUD ====================
      private function updateHud():void
      {
         if (world == null || world.main == null) return;
         if (hud == null)
         {
            hud = new TextField();
            var tf:TextFormat = new TextFormat();
            tf.font = "Consolas";           // PipBuck 终端等宽风
            tf.size = 15;
            tf.bold = false;
            tf.color = 0x00FF99;            // 荧光绿
            tf.letterSpacing = 1;
            hud.defaultTextFormat = tf;
            hud.selectable = false;
            hud.mouseEnabled = false;
            hudBg = new Sprite();
            world.main.addChild(hudBg);
            world.main.addChild(hud);
         }
         var txt:String = "";
         if (imeWarnT > 0)
         {
            imeWarnT--;
            txt = "⚠ 输入法已激活(可能按 Shift 误触)！请按 Ctrl+Space 切回英文";
         }
         else if (sandyActive)
         {
            txt = "⚡ 斯安维斯坦 " + (sandyLeft / 30).toFixed(1) + "s";
         }
         else if (replaying)
         {
            txt = "⟲ 回放中…";
         }
         else if (cooldownLeft > 0)
         {
            txt = "斯安维斯坦 充能中 " + (cooldownLeft / 30).toFixed(1) + "s";
         }
         if (txt != "")
         {
            hud.text = txt;
            var st:Object = world.swfStage != null ? world.swfStage : world.main.stage;
            var sw:Number = 1280;
            try { sw = st.stageWidth; } catch (e:*) { }
            hud.x = (sw - hud.textWidth) / 2 - 6;
            hud.y = 12;
            hud.width = hud.textWidth + 12;
            hud.height = 28;
            hud.visible = true;
            var fg:uint = 0x00FF99;
            if (imeWarnT > 0) fg = 0xFF3333;    // 输入法警告: 红色
            else if (sandyActive) fg = 0x00FFFF;   // 激活: 青色
            else if (replaying) fg = 0xFFFF00; // 回放: 黄色
            hud.textColor = fg;
            hud.text = (imeWarnT > 0) ? "⚠ 输入法已激活(可能按 Shift 误触)！请按 Ctrl+Space 切回英文" : hud.text;
            hudBg.graphics.clear();
            hudBg.graphics.lineStyle(1, fg, 0.9);              // 荧光边框
            hudBg.graphics.beginFill(0x002211, 0.7);           // 深绿黑底
            hudBg.graphics.drawRect(hud.x - 8, hud.y - 4, hud.width + 16, hud.height + 8);
            hudBg.graphics.endFill();
            hudBg.visible = true;
         }
         else
         {
            hud.visible = false;
            hudBg.visible = false;
         }
      }
   }
}
