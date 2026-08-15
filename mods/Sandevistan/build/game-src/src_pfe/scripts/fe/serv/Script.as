package fe.serv
{
   import fe.*;
   import fe.loc.Land;
   import fe.unit.Unit;
   
   public class Script
   {
      
      internal var land:Land;
      
      public var owner:Obj;
      
      public var eve:String;
      
      public var acts:Array;
      
      internal var actObj:Object;
      
      public var onTimer:Boolean = false;
      
      public var running:Boolean = false;
      
      internal var wait:Boolean = false;
      
      internal var ncom:int;
      
      internal var tcom:int = 0;
      
      internal var dial_n:int = -1;
      
      public function Script(param1:XML, param2:Land = null, param3:Obj = null, param4:Boolean = false)
      {
         var _loc5_:XML = null;
         super();
         this.land = param2;
         this.owner = param3;
         this.acts = new Array();
         if(param1.@eve.length())
         {
            this.eve = param1.@eve;
         }
         if(param1.@act.length())
         {
            this.analiz(param1);
         }
         if(param1.s.length())
         {
            for each(_loc5_ in param1.s)
            {
               this.analiz(_loc5_);
            }
         }
         if(param4)
         {
            this.onTimer = true;
         }
         if(Boolean(this.land) && this.onTimer)
         {
            this.land.scripts.push(this);
         }
      }
      
      internal function analiz(param1:XML) : *
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = "-1";
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         if(param1.@act.length())
         {
            _loc2_ = param1.@act;
            if(_loc2_ == "dial" || _loc2_ == "dialog" || _loc2_ == "inform" || _loc2_ == "landlevel")
            {
               this.onTimer = true;
            }
         }
         if(param1.@targ.length())
         {
            _loc3_ = param1.@targ;
         }
         if(param1.@val.length())
         {
            _loc4_ = param1.@val;
         }
         if(param1.@t.length())
         {
            _loc5_ = Math.round(param1.@t * World.fps);
            if(_loc5_ > 0)
            {
               this.onTimer = true;
            }
         }
         if(param1.@n.length())
         {
            _loc6_ = param1.@n;
         }
         if(param1.@opt1.length())
         {
            _loc7_ = int(param1.@opt1);
         }
         if(param1.@opt2.length())
         {
            _loc8_ = int(param1.@opt2);
         }
         if(_loc2_)
         {
            this.acts.push({
               "act":_loc2_,
               "targ":_loc3_,
               "val":_loc4_,
               "t":_loc5_,
               "n":_loc6_,
               "opt1":_loc7_,
               "opt2":_loc8_
            });
         }
      }
      
      public function start() : *
      {
         var _loc1_:Object = null;
         if(this.acts.length <= 0)
         {
            return;
         }
         if(!this.onTimer)
         {
            for each(_loc1_ in this.acts)
            {
               this.com(_loc1_);
            }
         }
         else
         {
            this.ncom = 0;
            this.com(this.acts[this.ncom]);
            this.tcom = this.acts[this.ncom].t;
            this.running = true;
         }
      }
      
      public function step() : *
      {
         if(this.tcom > 0)
         {
            --this.tcom;
         }
         if(this.tcom <= 0)
         {
            if(this.wait)
            {
               if(World.w.ctr.keyPressed2)
               {
                  this.dial_n = 10000;
               }
               else if(!World.w.ctr.keyPressed)
               {
                  return;
               }
               if(this.dial_n < 0)
               {
                  World.w.gui.dialText();
                  this.wait = false;
               }
               else
               {
                  ++this.dial_n;
                  if(World.w.gui.dialText(this.actObj.val,this.dial_n,this.actObj.opt1 > 0,true))
                  {
                     World.w.ctr.active = false;
                     World.w.ctr.keyPressed = false;
                     World.w.gg.levit = 0;
                     return;
                  }
                  World.w.gui.dialText();
                  World.w.gg.controlOn();
                  this.wait = false;
               }
               World.w.ctr.keyPressed = World.w.ctr.keyPressed2 = false;
            }
            ++this.ncom;
            if(this.ncom >= this.acts.length)
            {
               this.running = false;
               World.w.gui.dialText();
            }
            else
            {
               this.com(this.acts[this.ncom]);
               this.tcom = this.acts[this.ncom].t;
            }
         }
      }
      
      internal function com(param1:Object) : *
      {
         var _loc2_:Obj = null;
         var _loc3_:* = undefined;
         var _loc4_:Item = null;
         var _loc5_:Array = null;
         var _loc6_:Unit = null;
         if(param1 == null)
         {
            return;
         }
         this.actObj = param1;
         if(World.w.gui.vis.dial.visible)
         {
            World.w.gui.dialText();
         }
         World.w.ctr.keyPressed = World.w.ctr.keyPressed2 = false;
         this.wait = false;
         this.dial_n = -1;
         if(param1.targ)
         {
            if(param1.targ == "this")
            {
               _loc2_ = this.owner;
            }
            else if(this.land)
            {
               _loc2_ = this.land.uidObjs[param1.targ];
            }
            else
            {
               _loc2_ = World.w.land.uidObjs[param1.targ];
            }
            if(_loc2_)
            {
               _loc2_.command(param1.act,param1.val);
            }
         }
         else
         {
            if(param1.act == "control off")
            {
               World.w.gg.controlOff();
            }
            if(param1.act == "control on")
            {
               World.w.gg.controlOn();
            }
            if(param1.act == "mess")
            {
               World.w.gui.messText(param1.val,"",param1.opt1 > 0,param1.opt2 > 0);
            }
            if(param1.act == "dial")
            {
               if(param1.t <= 0)
               {
                  this.wait = true;
               }
               World.w.ctr.active = false;
               World.w.gui.dialText(param1.val,param1.n,param1.opt1 > 0,this.wait);
            }
            if(param1.act == "dialog")
            {
               if(World.w.dialOn)
               {
                  World.w.gg.controlOff();
                  this.wait = true;
                  this.dial_n = 0;
                  World.w.ctr.active = false;
                  World.w.gui.dialText(this.actObj.val,this.dial_n,this.actObj.opt1 > 0,true);
                  World.w.ctr.keyJump = false;
                  World.w.gg.levit = 0;
               }
            }
            if(param1.act == "inform")
            {
               World.w.gg.controlOff();
               this.wait = true;
               this.dial_n = 0;
               World.w.ctr.active = false;
               World.w.gui.dialText(<r mod={this.actObj.opt2} push={this.actObj.opt1 > 0 ? "1" : "0"}>{this.actObj.val}</r>,0,false,true);
            }
            if(param1.act == "landlevel")
            {
               if(World.w.dialOn && Boolean(World.w.game.lands[this.actObj.val]))
               {
                  World.w.gg.controlOff();
                  this.wait = true;
                  World.w.ctr.active = false;
                  _loc3_ = Res.txt("m",this.actObj.val) + "\n" + Res.pipText("recLevel") + ": [" + World.w.game.lands[this.actObj.val].dif + "]\n" + Res.pipText("isperslvl") + ": [" + World.w.pers.level + "]";
                  if(World.w.game.lands[this.actObj.val].dif > World.w.pers.level)
                  {
                     _loc3_ += "\n\n" + Res.pipText("wrLevel");
                  }
                  World.w.gui.dialText(<r mod='1'>{_loc3_}</r>,0,false,true);
               }
            }
            if(param1.act == "allact")
            {
               World.w.loc.allAct(null,param1.val,param1.n);
            }
            if(param1.act == "take")
            {
               if(param1.n < 0)
               {
                  if(World.w.invent.items[param1.val])
                  {
                     World.w.gui.infoText("withdraw",World.w.invent.items[param1.val].nazv,-param1.n);
                     World.w.invent.minusItem(param1.val,-param1.n);
                     World.w.pers.setParameters();
                  }
               }
               else
               {
                  _loc4_ = new Item(null,param1.val,param1.n);
                  World.w.invent.take(_loc4_);
               }
            }
            if(param1.act == "armor")
            {
               World.w.gg.changeArmor(param1.val,true);
            }
            if(param1.act == "xp")
            {
               World.w.pers.expa(param1.val,World.w.gg.X,World.w.gg.Y);
            }
            if(param1.act == "perk")
            {
               World.w.pers.addPerk(param1.val);
            }
            if(param1.act == "eff")
            {
               World.w.gg.addEffect(param1.val,param1.opt1,param1.opt2);
            }
            if(param1.act == "remeff")
            {
               World.w.gg.remEffect(param1.val);
            }
            if(param1.act == "music")
            {
               if(param1.n > 0)
               {
                  Snd.playMusic(param1.val,param1.n);
               }
               else
               {
                  Snd.playMusic(param1.val);
               }
            }
            if(param1.act == "music_rep")
            {
               if(World.w.pers.rep >= World.w.pers.repGood)
               {
                  Snd.playMusic(param1.val);
               }
            }
            if(param1.act == "anim")
            {
               World.w.gg.anim(param1.val,this.actObj.opt1 > 0);
            }
            if(param1.act == "turn")
            {
               if(param1.val > 0)
               {
                  World.w.gg.storona = 1;
               }
               else
               {
                  World.w.gg.storona = -1;
               }
               World.w.gg.dx += World.w.gg.storona * 3;
            }
            if(param1.act == "black")
            {
               World.w.cam.dblack = 0;
               if(param1.val > 0)
               {
                  World.w.vblack.visible = true;
               }
               World.w.vblack.alpha = param1.val;
            }
            if(param1.act == "dblack")
            {
               World.w.cam.dblack = param1.val;
            }
            if(param1.act == "gui off")
            {
               World.w.gui.hpBarOnOff(false);
            }
            if(param1.act == "gui on")
            {
               World.w.gui.hpBarOnOff(true);
            }
            if(param1.act == "refill")
            {
               World.w.land.refill();
            }
            if(param1.act == "upland")
            {
               World.w.game.upLandLevel();
            }
            if(param1.act == "locon")
            {
               World.w.loc.allon();
            }
            if(param1.act == "locoff")
            {
               World.w.loc.alloff();
            }
            if(param1.act == "quest")
            {
               World.w.game.addQuest(param1.val);
            }
            if(param1.act == "showstage")
            {
               World.w.game.showQuest(param1.val,param1.n);
            }
            if(param1.act == "show")
            {
               World.w.cam.showOn = false;
            }
            if(param1.act == "stage")
            {
               World.w.game.closeQuest(param1.val,param1.n);
            }
            if(param1.act == "trigger")
            {
               if(param1.n != null)
               {
                  World.w.game.setTrigger(param1.val,param1.n);
               }
               else
               {
                  World.w.game.setTrigger(param1.val);
               }
            }
            if(param1.act == "goto")
            {
               _loc5_ = param1.val.split(" ");
               if(_loc5_.length == 2)
               {
                  this.land.gotoXY(_loc5_[0],_loc5_[1]);
               }
            }
            if(param1.act == "gotoland")
            {
               if(param1.n == 2)
               {
                  World.w.game.gotoLand(param1.val,null,true);
               }
               else if(param1.n == 1)
               {
                  World.w.game.gotoLand(param1.val,param1.opt1 + ":" + param1.opt2);
               }
               else
               {
                  World.w.game.gotoLand(param1.val);
               }
            }
            if(param1.act == "openland")
            {
               if(World.w.game.lands[param1.val])
               {
                  World.w.game.lands[param1.val].access = true;
               }
               else
               {
                  trace("error land ",param1.val);
               }
            }
            if(param1.act == "passed")
            {
               World.w.land.act.passed = true;
            }
            if(param1.act == "actprob")
            {
               if(World.w.loc.prob)
               {
                  World.w.loc.prob.activateProb();
               }
            }
            if(param1.act == "alarm")
            {
               World.w.loc.signal();
            }
            if(param1.act == "trus")
            {
               if(Boolean(this.owner) && Boolean(this.owner.loc))
               {
                  this.owner.loc.trus = Number(param1.val);
               }
               else
               {
                  World.w.loc.trus = Number(param1.val);
               }
            }
            if(param1.act == "checkall")
            {
               for each(_loc6_ in World.w.loc.units)
               {
                  _loc6_.command("check");
               }
            }
            if(param1.act == "robots")
            {
               World.w.loc.robocellActivate();
            }
            if(param1.act == "weapch")
            {
               World.w.gg.changeWeapon(param1.val);
            }
            if(param1.act == "alicorn")
            {
               if(param1.val <= 0)
               {
                  World.w.gg.alicornOff();
               }
               else
               {
                  World.w.gg.alicornOn();
               }
            }
            if(param1.act == "wave")
            {
               if(World.w.loc.prob)
               {
                  World.w.loc.prob.beginWave();
               }
            }
            if(param1.act == "pip")
            {
               World.w.pip.onoff(param1.val,param1.n);
            }
            if(param1.act == "speceffect")
            {
               World.w.grafon.specEffect(param1.n);
            }
            if(param1.act == "scene")
            {
               if(param1.val)
               {
                  World.w.showScene(param1.val,param1.n);
               }
               else
               {
                  World.w.unshowScene();
               }
            }
            if(param1.act == "endgame")
            {
               World.w.endgame();
            }
            if(param1.act == "gameover")
            {
               World.w.endgame(1);
            }
            if(param1.act == "wait")
            {
               this.wait = true;
               this.dial_n = 0;
               World.w.ctr.active = false;
            }
         }
      }
   }
}

