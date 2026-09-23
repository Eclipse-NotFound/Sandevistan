      // Test-only injection: real game classes + production record/replay methods.
      private var animProbeStage:int = 0;
      private var animProbeTicks:int = 0;
      private function animProbeBitmap(u:Object):BitmapData
      {
         return Bitmap(u.vis.getChildAt(0).getChildAt(0)).bitmapData;
      }
      private function animProbeHash(u:Object):uint
      {
         var b:BitmapData = animProbeBitmap(u);
         var v:Vector.<uint> = b.getVector(b.rect);
         var h:uint = 2166136261;
         for (var i:int = 0; i < v.length; i++) { h = ((h << 5) - h) ^ v[i]; }
         return h;
      }
      private function animProbeCase(className:String, speed:int = 5, transitions:Boolean = false, activeAI:Boolean = false):Boolean
      {
         var cls:Class = ApplicationDomain.currentDomain.getDefinition(className) as Class;
         var u:Object = new cls("1", 10);
         u.putLoc(world.loc, world.gg.X + 120, world.gg.Y);
         world.loc.addObj(u);
         world.loc.units.push(u);
         u.disabled = true; // eliminate new AI decisions; retain real animate/record/replay code
         u.sost = 1;
         u.stay = true;
         replayObjs = new Dictionary(); replayObjArr = []; seenPos = new Dictionary();
         cfgDuration = 150; cfgReplaySpeed = speed;
         var hashes:Array = [];
         var images:Array = [];
         var started:int = getTimer();
         var sourceDistinct:Object = {};
         var startX:Number = u.X;
         for (var i:int = 0; i < cfgDuration; i++)
         {
            if (i % 5 == 0)
            {
               u.setPos(startX + 4 * int(i / 5), u.Y);
               u.stay = true; u.dx = 4; u.dy = 0;
               if (transitions)
               {
                  if (i >= 50 && i < 75) u.dx = 0;
                  if (i >= 75 && i < 100) { u.stay = false; u.dy = -4 + (i - 75) / 3; }
                  if (i >= 100) { u.dx = -10; u.storona = -1; }
               }
               u.animate();
            }
            sandyLeft = cfgDuration - i;
            recordReplayObjects();
            hashes.push(animProbeHash(u));
            images.push(animProbeBitmap(u).clone());
            sourceDistinct[String(hashes[i])] = true;
         }
         var recordMs:int = getTimer() - started;
         var captureClock:int = getTimer();
         var observer:SandyBlitReplay = new SandyBlitReplay();
         observer.capture(u); // exclude first atlas index construction from warm capture cost
         captureClock = getTimer();
         for (var costIndex:int = 0; costIndex < 300; costIndex++) observer.capture(u);
         log("[ANIM-COST] " + className + " warmCapture300Ms=" + (getTimer() - captureClock));
         observer.reset();
         replayObjArr = [u];
         u.disabled = !activeAI;
         world.godMode = true;
         var replayDistinct:Object = {};
         var matches:int = 0;
         var count:int = 0;
         var moving:int = 0;
         var lastX:Number = NaN;
         for (i = 0; i < cfgDuration; i += speed)
         {
            replayIdx = i;
            replayObjects();
            var actual:uint = animProbeHash(u);
            replayDistinct[String(actual)] = true;
            var diff:* = animProbeBitmap(u).compare(images[i]);
            if (diff is Number && diff == 0) matches++;
            else if (diff is BitmapData) BitmapData(diff).dispose();
            if (!isNaN(lastX) && u.X != lastX) moving++;
            lastX = u.X;
            count++;
         }
         var sn:int = 0; var rn:int = 0;
         for (var k:String in sourceDistinct) sn++;
         for (k in replayDistinct) rn++;
         var pass:Boolean = sn > 3 && moving >= Math.min(10, int(150 / Math.max(speed, 5)) - 1) && rn > 3 && matches == count;
         log("[ANIM-TEST] " + className + " speed=" + speed + " transitions=" + transitions + " activeAI=" + activeAI + " recordMs=" + recordMs + " sourceFrames=" + sn + " replayFrames=" + rn
            + " moving=" + moving + " exact=" + matches + "/" + count + " " + (pass ? "PASS" : "FAIL"));
         u.disabled = true; u.sost = 3; u.stay = true; u.animate();
         var deadImage:BitmapData = animProbeBitmap(u).clone();
         replayIdx = 0; replayObjects();
         var deadDiff:* = animProbeBitmap(u).compare(deadImage);
         var liveDiff:* = animProbeBitmap(u).compare(images[0]);
         var corpseOK:Boolean = (liveDiff is BitmapData) && (u.animState == "die" || u.animState == "death" || u.animState == "fall");
         if (liveDiff is BitmapData) BitmapData(liveDiff).dispose();
         if (deadDiff is BitmapData) BitmapData(deadDiff).dispose();
         deadImage.dispose();
         log("[ANIM-TEST] corpse-guard " + className + " " + (corpseOK ? "PASS" : "FAIL"));
         pass = pass && corpseOK;
         for each (var img:BitmapData in images) img.dispose();
         u.setNull();
         return pass;
      }
      private function stepAnimProbe():void
      {
         try
         {
            if (++animProbeTicks > 1800) throw new Error("boot timeout");
            if (animProbeStage == 0 && world.mm != null && world.mm.loaded && world.landData != null)
            {
               log("[ANIM-TEST] boot ready");
               world.mm.mainMenuOff();
               world.newGame(-1, "ANIMTEST", { dif: 2, propusk: true });
               animProbeStage = 1;
            }
            else if (animProbeStage == 1 && world.allStat == 1 && world.gg != null && world.loc != null)
            {
               world.onPause = true;
               var ok:Boolean = true;
               for each (var className:String in ["fe.unit.UnitRaider", "fe.unit.UnitZombie"])
               {
                  for each (var speed:int in [1, 3, 5, 8, 20])
                     if (!animProbeCase(className, speed, true)) ok = false;
                  if (!animProbeCase(className, 5, true, true)) ok = false;
               }
               log("[ANIM-TEST] SUMMARY " + (ok ? "PASS" : "FAIL"));
               NativeApplication.nativeApplication.exit(ok ? 0 : 1);
               animProbeStage = 2;
            }
         }
         catch(e:*) { log("[ANIM-TEST] ERROR " + e + " " + e.getStackTrace()); NativeApplication.nativeApplication.exit(2); }
      }
