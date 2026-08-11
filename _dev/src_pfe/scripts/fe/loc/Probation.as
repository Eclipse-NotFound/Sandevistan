package fe.loc
{
   import fe.*;
   import fe.serv.Script;
   import fe.unit.Unit;
   
   public class Probation
   {
      
      public var xml:XML;
      
      public var loc:Location;
      
      public var id:String;
      
      public var roomId:String;
      
      public var tip:int = 0;
      
      public var nazv:String;
      
      public var info:String = "";
      
      public var help:String = "";
      
      public var prizeActive:Boolean = false;
      
      public var closed:Boolean = false;
      
      public var active:Boolean = false;
      
      public var isClose:Boolean = false;
      
      public var onWave:Boolean = false;
      
      public var nwave:int = 0;
      
      public var maxwave:int = 0;
      
      public var t_wave:int = 0;
      
      public var nspawn:int = 0;
      
      public var kolEn:int = 0;
      
      public var killEn:int = 0;
      
      public var dopOver:Function;
      
      public var dopOut:Function;
      
      public var alarmScript:Script;
      
      public var inScript:Script;
      
      public var outScript:Script;
      
      public var closeScript:Script;
      
      internal var beg_t:int = 90;
      
      internal var next_t:int = 300;
      
      public function Probation(param1:XML, param2:Location)
      {
         var _loc3_:* = undefined;
         super();
         this.xml = param1;
         this.loc = param2;
         this.id = this.xml.@id;
         this.nazv = Res.txt("m",this.id);
         this.info = "<b>" + this.nazv + "</b><br><br>" + Res.txt("m",this.id,1) + "<br>";
         if(Res.txt("m",this.id,3) != "")
         {
            this.help = "<span class = \'r3\'>" + Res.txt("m",this.id,3) + "</span>";
         }
         if(!this.loc.levitOn)
         {
            this.info += "<br>" + Res.guiText("restr_levit");
         }
         if(!this.loc.portOn)
         {
            this.info += "<br>" + Res.guiText("restr_port");
         }
         if(!this.loc.destroyOn)
         {
            this.info += "<br>" + Res.guiText("restr_des");
         }
         if(this.xml.@prize.length())
         {
            this.prizeActive = true;
         }
         if(this.xml.@tip.length())
         {
            this.tip = this.xml.@tip;
         }
         if(this.xml.@close.length())
         {
            this.isClose = true;
         }
         if(this.tip != 2)
         {
            this.loc.petOn = false;
         }
         if(this.xml.scr.length())
         {
            for each(_loc3_ in this.xml.scr)
            {
               if(_loc3_.@eve == "alarm")
               {
                  this.alarmScript = new Script(_loc3_,this.loc.land);
               }
               if(_loc3_.@eve == "out")
               {
                  this.outScript = new Script(_loc3_,this.loc.land);
               }
               if(_loc3_.@eve == "in")
               {
                  this.inScript = new Script(_loc3_,this.loc.land);
               }
               if(_loc3_.@eve == "close")
               {
                  this.closeScript = new Script(_loc3_,this.loc.land);
               }
            }
         }
         if(this.xml.wave.length())
         {
            this.maxwave = this.xml.wave.length();
         }
      }
      
      public function prepare() : *
      {
         var _loc1_:Box = null;
         for each(_loc1_ in this.loc.objs)
         {
            if(Boolean(_loc1_.inter) && (_loc1_.inter.prize && this.prizeActive))
            {
               _loc1_.inter.setAct("lock",0);
               _loc1_.inter.update();
            }
         }
      }
      
      public function check() : *
      {
         if(this.closed)
         {
            return;
         }
         if(this.checkAllCon())
         {
            this.closeProb();
         }
      }
      
      internal function checkAllCon() : Boolean
      {
         var _loc1_:* = undefined;
         var _loc2_:Box = null;
         var _loc3_:Unit = null;
         for each(_loc1_ in this.xml.con)
         {
            if((_loc1_.@tip == "box" || _loc1_.@tip.length() == 0) && Boolean(_loc1_.@uid.length()))
            {
               for each(_loc2_ in this.loc.objs)
               {
                  if(Boolean(_loc2_.uid == _loc1_.@uid) && Boolean(_loc2_.inter) && (!_loc2_.inter.open && _loc2_.inter.cont != "empty"))
                  {
                     return false;
                  }
               }
            }
            else if(_loc1_.@tip == "unit")
            {
               for each(_loc3_ in this.loc.units)
               {
                  if((Boolean(_loc1_.@uid.length()) && Boolean(_loc3_.uid == _loc1_.@uid) || Boolean(_loc1_.@qid.length()) && Boolean(_loc3_.questId == _loc1_.@qid)) && _loc3_.sost < 3)
                  {
                     return false;
                  }
               }
            }
            else if(_loc1_.@tip == "wave")
            {
               if(this.nwave < this.maxwave || this.killEn < this.kolEn)
               {
                  return false;
               }
            }
         }
         return true;
      }
      
      public function closeProb() : *
      {
         var _loc1_:Box = null;
         this.closed = true;
         this.active = false;
         if(World.w.game.triggers["prob_" + this.id] == null)
         {
            World.w.game.triggers["prob_" + this.id] = 1;
         }
         else
         {
            ++World.w.game.triggers["prob_" + this.id];
         }
         World.w.gui.infoText("closeProb",this.nazv);
         Snd.ps("quest_ok");
         this.doorsOnOff(1);
         if(!this.prizeActive)
         {
            for each(_loc1_ in this.loc.objs)
            {
               if(Boolean(_loc1_.inter) && _loc1_.inter.prize)
               {
                  _loc1_.inter.command("unlock");
               }
            }
         }
         if(this.closeScript)
         {
            this.closeScript.start();
         }
      }
      
      public function over() : *
      {
         World.w.gui.messText("",this.nazv,World.w.gg.Y < 300);
         if(!this.closed)
         {
            this.defaultProb();
         }
         if(this.inScript)
         {
            this.inScript.start();
         }
         if(this.isClose)
         {
            this.activateProb();
         }
         this.loc.broom = false;
      }
      
      public function out() : *
      {
         if(this.closed)
         {
            this.loc.openAllPrize();
            this.loc.broom = true;
         }
         else
         {
            if(this.outScript)
            {
               this.outScript.start();
            }
            if(this.onWave)
            {
               this.resetWave();
            }
         }
      }
      
      public function showHelp() : *
      {
         var _loc1_:* = this.help != "";
         World.w.gui.informText(this.info + (_loc1_ ? "<br><br>" + Res.guiText("need_help") : ""),_loc1_);
      }
      
      public function activateProb() : *
      {
         if(this.closed || this.active || !this.loc.active)
         {
            return;
         }
         this.active = true;
         this.doorsOnOff(-1);
      }
      
      public function defaultProb() : *
      {
         this.active = false;
         this.doorsOnOff(0);
      }
      
      internal function doorsOnOff(param1:int) : *
      {
         var _loc2_:Box = null;
         for each(_loc2_ in this.loc.objs)
         {
            if(_loc2_.id == "doorout")
            {
               if(!_loc2_.vis.visible && param1 == 1 || _loc2_.vis.visible && param1 == -1)
               {
                  _loc2_.inter.shine();
               }
               if(param1 == -1 || param1 == 0 && _loc2_.uid != "begin")
               {
                  _loc2_.vis.visible = _loc2_.shad.visible = false;
                  _loc2_.inter.active = false;
               }
               if(param1 == 1 || param1 == 0 && _loc2_.uid == "begin")
               {
                  _loc2_.vis.visible = _loc2_.shad.visible = true;
                  _loc2_.inter.active = true;
               }
            }
         }
      }
      
      public function beginWave() : *
      {
         if(this.onWave)
         {
            return;
         }
         this.doorsOnOff(-1);
         this.onWave = true;
         this.kolEn = this.killEn = 0;
         this.nwave = 0;
         this.t_wave = this.beg_t;
      }
      
      internal function createWave() : *
      {
         var _loc2_:* = undefined;
         this.nspawn = 0;
         var _loc1_:XML = this.xml.wave[this.nwave];
         if(_loc1_ == null)
         {
            return;
         }
         for each(_loc2_ in _loc1_.obj)
         {
            this.loc.waveSpawn(_loc2_,this.nspawn);
            ++this.kolEn;
            ++this.nspawn;
         }
         if(_loc1_.@t.length())
         {
            this.t_wave = int(_loc1_.@t) * World.fps;
         }
         ++this.nwave;
      }
      
      public function checkWave(param1:Boolean = false) : *
      {
         if(param1)
         {
            ++this.killEn;
         }
         if(this.killEn >= this.kolEn)
         {
            this.checkAllCon();
            if(this.nwave < this.maxwave)
            {
               this.t_wave = this.next_t;
            }
            else
            {
               this.t_wave = 0;
            }
         }
      }
      
      internal function resetWave() : *
      {
         var _loc1_:Unit = null;
         this.onWave = false;
         for each(_loc1_ in this.loc.units)
         {
            if(_loc1_.wave)
            {
               _loc1_.sost = 4;
               _loc1_.disabled = true;
            }
         }
      }
      
      public function step() : *
      {
         if(this.onWave)
         {
            if(this.t_wave > 0)
            {
               --this.t_wave;
            }
            if(this.t_wave == 1 && this.nwave < this.maxwave)
            {
               this.createWave();
            }
            if(this.t_wave % 30 == 1)
            {
               World.w.gui.messText("",Math.floor(this.t_wave / 30).toString());
            }
         }
      }
   }
}

