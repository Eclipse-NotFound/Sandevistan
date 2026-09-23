      // Isolated regression for the smoke observer; production record/replay + real projectiles.
      private var observerStage:int = 0;
      private var observerFail:int = 0;
      private var observerChecks:int = 0;
      private function observerCheck(name:String, ok:Boolean):void {
         observerChecks++; if(!ok) observerFail++;
         log("[FPS-TEST] " + name + " " + (ok ? "PASS" : "FAIL"));
      }
      private function fpsAfterFrame():void {}
      private function fpsBeforeFrame():void {
         if(observerStage==2 || world==null) return;
         try {
            if(observerStage==0 && world.mm.loaded && world.landData!=null) {
               world.mm.mainMenuOff(); world.newGame(-1,"OBSERVER",{dif:2,propusk:true}); observerStage=1;
            } else if(observerStage==1 && world.allStat==1 && world.gg!=null && world.loc!=null) {
               world.onPause=true;
               var U:Class=ApplicationDomain.currentDomain.getDefinition("fe.unit.UnitRaider") as Class;
               var B:Class=ApplicationDomain.currentDomain.getDefinition("fe.weapon.PhisBullet") as Class;
               var u:Object=new U("1",10);
               u.putLoc(world.loc,world.gg.X+120,world.gg.Y); world.loc.addObj(u); world.loc.units.push(u);
               u.disabled=true; u.sost=1;
               var b:Object=new B(u,u.X,u.Y-40);
               replayObjs=new Dictionary(); replayObjArr=[]; seenPos=new Dictionary(); seenAtk=new Dictionary();
               cfgDuration=2; sandyLeft=2; recordReplayObjects();
               b.X+=25; sandyLeft=1; recordReplayObjects();
               observerCheck("actual-two-frame-projectile-record", replayObjs[b]!=null && replayObjs[b].length==2 && replayObjs[b][1].x-replayObjs[b][0].x==25);
               replayObjArr=[b]; u.sost=3; u.postDie=false;
               replayIdx=0; replayObjects();
               testDeadAtkNew=0; testDeadSnapN=0; testDeadAtkSnap=new Dictionary(); testDeadAtkSample("start");
               replayIdx=1; replayObjects(); testDeadAtkSample("run");
               observerCheck("recorded-flight-after-owner-death", testDeadAtkNew==0 && b.X==replayObjs[b][1].x);
               var loose:Object=new B(u,u.X+100,u.Y-40);
               testDeadAtkNew=0; testDeadSnapN=0; testDeadAtkSnap=new Dictionary(); testDeadAtkSample("start");
               loose.X+=12; testDeadAtkSample("run");
               observerCheck("existing-unrecorded-flight", testDeadAtkNew==0);
               var extra:Object=new B(u,u.X+250,u.Y-40);
               testDeadAtkSample("run");
               observerCheck("injected-dead-owner-shot-detected", testDeadAtkNew>0);
               u.sost=1;
               testDeadAtkNew=0; testDeadSnapN=0; testDeadAtkSnap=new Dictionary(); testDeadAtkSample("start");
               var live:Object=new B(u,u.X+350,u.Y-40); testDeadAtkSample("run");
               u.sost=3; testDeadAtkSample("run");
               observerCheck("shot-before-new-death-allowed", testDeadAtkNew==0);
               extra=new B(u,u.X+450,u.Y-40); testDeadAtkSample("run");
               observerCheck("shot-after-observed-death-detected", testDeadAtkNew>0);
               u.postDie=true;
               testDeadAtkNew=0; testDeadSnapN=0; testDeadAtkSnap=new Dictionary(); testDeadAtkSample("start");
               extra=new B(u,u.X+550,u.Y-40); testDeadAtkSample("run");
               observerCheck("native-post-die-exception",testDeadAtkNew==0);
               log("[FPS-TEST] SUMMARY "+(observerFail==0?"PASS":"FAIL")+" checks="+observerChecks+" fail="+observerFail);
               observerStage=2; NativeApplication.nativeApplication.exit(observerFail==0?0:1);
            }
         } catch(e:*) { log("[FPS-TEST] ERROR "+e+" "+e.getStackTrace()); observerStage=2; NativeApplication.nativeApplication.exit(2); }
      }