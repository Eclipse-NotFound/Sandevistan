      private var fpsCombat:Boolean = false;
      private var fpsMoves:int = 0;
      private var fpsShotCount:int = 0;
      private var fpsRecordedHold:int = 0;
      private var fpsSwitchModes:Boolean = false;
      private var fpsSwitchCount:int = 0;
      private var fpsPhase:int = 0;
      private var fpsHeartbeat:int = 0;
      private var fpsGood:Object = {};
      private var fpsCounts:Object = {};
      private var fpsRaw:int = 0;
      private var fpsLogical:int = 0;
      private var fpsSkipped:int = 0;
      private var fpsStart:int = 0;
      private var fpsBefore:Object;
      private var fpsGov:Class;
      private var fpsDone:Boolean = false;
      private function fpsCheck(name:String, pass:Boolean):void {
         if (fpsGood[name] == null) fpsGood[name] = true;
         if (!pass) fpsGood[name] = false;
         fpsCounts[name] = int(fpsCounts[name]) + 1;
      }
      private function fpsBeforeFrame():void {
         fpsBefore = null;
         if (fpsDone || world == null) return;
         if(++fpsHeartbeat % 120 == 0) log("[FPS-TEST] heartbeat phase="+fpsPhase+" loaded="+world.mm.loaded+" landData="+(world.landData!=null)+" allStat="+world.allStat+" gg="+(world.gg!=null)+" ng="+world.ng_wait+" ctrl="+(world.gg!=null?world.gg.ggControl:false)+" pause="+world.onPause);
         if (fpsGov == null) {
            try { fpsGov = ApplicationDomain.currentDomain.getDefinition("fe.serv.Gov60") as Class; } catch(e:*) {}
         }
         if (world.verror != null && world.verror.visible) {
            log("[FPS-TEST] ERROR " + world.verror.txt.text); fpsDone = true; return;
         }
         if (fpsPhase == 0 && world.mm != null && world.mm.loaded && world.landData != null) {

            world.mm.mainMenuOff(); world.newGame(-1, "FPS-TEST", {dif:2, propusk:true}); fpsPhase=1;
         } else if (fpsPhase == 1 && world.allStat == 1 && world.gg != null && world.loc != null && world.gg.ggControl) {

            cfgDuration=60; cfgReplaySpeed=5; cfgCooldown=60; cfgDiagLog=true;
            cfgMusicOn=false; world.godMode=true;
            if(fpsCombat) {
               world.loc.base=false;
               world.invent.addWeapon("p9mm",16777215,1000);
               world.gg.changeWeapon("p9mm",true);
               world.gg.currentWeapon.hold=1000;
            }
            startSandy(); fpsPhase=2; fpsStart=getTimer();
         }
         if (fpsPhase < 2) return;
         var logic:Boolean = fpsGov == null || SandyHighFpsClock.isLogicFrame();
         fpsRaw++; if(logic) fpsLogical++; else fpsSkipped++;
         if(fpsSwitchModes && logic && fpsGov != null) {
            if(fpsLogical==15) {fpsGov["N"]=1; world.main.stage.frameRate=30; fpsSwitchCount++;}
            if(fpsLogical==30) {fpsGov["N"]=4; world.main.stage.frameRate=120; fpsSwitchCount++;}
            if(fpsLogical==45) {fpsGov["enabled"]=false; world.main.stage.frameRate=30; fpsSwitchCount++;}
            if(fpsLogical==75) {fpsGov["enabled"]=true; world.main.stage.frameRate=120; fpsSwitchCount++;}
         }
         if(fpsCombat && sandyActive) {
            world.gg.controlOn(); world.gg.work=""; world.gg.t_work=0;
            world.ctr.keyAttack=((cfgDuration-sandyLeft)%12==2);
            world.celX=world.gg.X+250; world.celY=world.gg.Y-25;
         }
         world.ctr.keyRight = sandyActive;
         fpsBefore={logic:logic, sandy:sandyActive, replay:replaying, left:sandyLeft,
            len:history.length, idx:replayIdx, cd:cooldownLeft, x:world.gg.X, y:world.gg.Y,
            slow:slowTick, leash:leashLeft};
      }
      private function fpsAfterFrame():void {
         if (fpsDone || fpsBefore == null) return;
         var b:Object=fpsBefore;
         if(b.sandy && world.gg.X != b.x) fpsMoves++;
         if (b.sandy && sandyActive) {
            fpsCheck("record-clock", sandyLeft == b.left - (b.logic ? 1 : 0));
            fpsCheck("record-count", history.length == b.len + (b.logic ? 1 : 0));
            fpsCheck("slow-world-clock", slowTick == b.slow + (b.logic ? 1 : 0));
         }
         if (b.replay && replaying) fpsCheck("replay-clock", replayIdx == b.idx + (b.logic ? cfgReplaySpeed : 0));
         if (!b.sandy && !b.replay && b.cd>0) fpsCheck("cooldown-clock", cooldownLeft == b.cd - (b.logic ? 1 : 0));
         if ((b.sandy || b.replay) && !b.logic) {
            fpsCheck("intermediate-no-physics", world.gg.X == b.x && world.gg.Y == b.y);
            if(fpsGov != null) {
               var c:Object=world.cam; var a:Number=Number(fpsGov["alpha"]);
               if(fpsCombat && c.wpVis!=null) {
                  fpsCheck("weapon-interpolation", Math.abs(c.wpVis.x-(c.i_wpx+(c.i_wtx-c.i_wpx)*a))<0.05);
               }
               fpsCheck("intermediate-interpolation", Math.abs(world.gg.vis.x - (c.i_gpx+(c.i_gtx-c.i_gpx)*a))<0.05);
            }
         }
         if ((sandyActive || replaying) && b.logic && fpsGov != null) {
            fpsCheck("player-camera-target", Math.abs(world.cam.i_gtx-world.gg.X)<0.01 && Math.abs(world.cam.i_gty-world.gg.Y)<0.01);
         }
         if (fpsPhase==2 && !sandyActive) {
            if(fpsCombat) {
               for each(var f:Object in history) fpsShotCount+=int(f.fc);
               fpsRecordedHold=world.gg.currentWeapon.hold;
               fpsCheck("nonempty-movement", fpsMoves>=10);
               fpsCheck("nonempty-shooting", fpsShotCount>=2 && replayObjArr.length>0);
               log("[FPS-COST] combat shots="+fpsShotCount+" movementSteps="+fpsMoves+" hold="+fpsRecordedHold);
            }
            fpsCheck("record-exactly-60", history.length==60);
            log("[FPS-COST] recorded60 wallMs="+(getTimer()-fpsStart)+" render="+fpsRaw+" logic="+fpsLogical+" skipped="+fpsSkipped);
            fpsPhase=3;
         }
         if(fpsPhase==3 && !replaying) {
            log("[FPS-COST] restore pause="+world.onPause+" saved="+savedOnPause+" god="+world.godMode+" savedGod="+savedGod+" control="+world.gg.ggControl+" capturedControl="+savedGgCtrl);
            fpsCheck("restored-world", world.onPause==savedOnPause && !sandyActive && world.godMode==savedGod);
            fpsPhase=4;
         }
         if(fpsPhase==4 && cooldownLeft==0) {
            fpsCheck("real-extra-frames", fpsGov==null || int(fpsGov["N"])<2 || fpsSkipped>=5);
            if(fpsCombat) fpsCheck("ammo-preserved", world.gg.currentWeapon.hold==fpsRecordedHold);
            if(fpsSwitchModes) fpsCheck("live-mode-switches", fpsSwitchCount==4);

            var fail:int=0; var count:int=0;
            for(var name:String in fpsGood) {count++; if(!fpsGood[name]) fail++; log("[FPS-TEST] "+name+" "+(fpsGood[name]?"PASS":"FAIL")+" samples="+fpsCounts[name]);}
            log("[FPS-TEST] SUMMARY "+(fail==0?"PASS":"FAIL")+" checks="+count+" fail="+fail+" raw="+fpsRaw+" logic="+fpsLogical+" skipped="+fpsSkipped+" wallMs="+(getTimer()-fpsStart));
            fpsDone=true;
         }
      }
