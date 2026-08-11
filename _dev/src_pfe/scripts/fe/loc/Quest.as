package fe.loc
{
   import fe.*;
   import fe.serv.Item;
   
   public class Quest
   {
      
      public var id:String;
      
      public var xml:XML;
      
      public var nazv:String;
      
      public var info:String;
      
      public var empl:String;
      
      public var main:Boolean = false;
      
      public var sub:Boolean = false;
      
      public var nsub:int = 0;
      
      public var subs:Array;
      
      public var subsId:Array;
      
      public var par:Quest;
      
      public var auto:Boolean = true;
      
      public var isCheck:Boolean = false;
      
      public var nn:Boolean = false;
      
      public var collect:String;
      
      public var colTip:int = 0;
      
      public var isDel:Boolean = false;
      
      public var give:String;
      
      public var est:int = 0;
      
      public var kol:int = 1;
      
      public var canBeUse:Boolean = false;
      
      public var gived:int = 0;
      
      public var pay:int = 0;
      
      public var prevRes:String = "";
      
      public var hidden:Boolean = false;
      
      public var invis:Boolean = false;
      
      public var result:Boolean = false;
      
      public var report:String;
      
      public var begDial:String;
      
      public var endDial:String;
      
      public var endScript:String;
      
      public var state:int = 0;
      
      public var sp:int = 0;
      
      public var xp:int = 0;
      
      public var rep:int = 0;
      
      public var trigger:String;
      
      public var triggerSet:String;
      
      public var sort:int = 0;
      
      public function Quest(param1:XML, param2:Object = null, param3:Quest = null, param4:int = 0)
      {
         var node:*;
         var pid:String = null;
         var sxml:XML = null;
         var sl:Object = null;
         var q:Quest = null;
         var nxml:XML = param1;
         var loadObj:Object = param2;
         var npar:Quest = param3;
         var nnsub:int = param4;
         super();
         this.xml = nxml;
         this.id = this.xml.@id;
         if(npar == null)
         {
            pid = this.id;
         }
         else
         {
            this.par = npar;
            this.sub = true;
            pid = this.par.id + this.id;
         }
         this.state = 1;
         this.nsub = nnsub;
         if(loadObj)
         {
            this.state = loadObj.state;
            this.est = loadObj.est;
            if(loadObj.gived)
            {
               this.gived = loadObj.gived;
            }
         }
         if(this.xml.@empl.length())
         {
            this.empl = this.xml.@empl;
         }
         if(this.xml.@begdial.length())
         {
            this.begDial = this.xml.@begdial;
         }
         if(this.xml.@enddial.length())
         {
            this.endDial = this.xml.@enddial;
         }
         if(this.xml.@endscr.length())
         {
            this.endScript = this.xml.@endscr;
         }
         if(this.xml.@nn.length())
         {
            this.nn = true;
         }
         if(this.xml.@collect.length())
         {
            this.collect = this.xml.@collect;
            this.isCheck = true;
            if(this.par)
            {
               this.par.isCheck = true;
            }
            if(this.xml.@del.length())
            {
               this.isDel = true;
            }
            if(this.xml.@coltip.length())
            {
               this.colTip = this.xml.@coltip;
            }
         }
         if(this.xml.@give.length())
         {
            this.give = this.xml.@give;
         }
         if(this.xml.@pay.length())
         {
            this.pay = this.xml.@pay;
         }
         if(this.xml.@kol.length())
         {
            this.kol = this.xml.@kol;
         }
         if(this.xml.@report.length())
         {
            this.report = this.xml.@report;
         }
         if(this.xml.@us.length())
         {
            this.canBeUse = true;
         }
         if(this.xml.@hidden.length())
         {
            this.hidden = true;
         }
         if(this.xml.@invis.length())
         {
            this.invis = true;
         }
         if(this.xml.@result.length())
         {
            this.result = true;
            if(this.par)
            {
               this.par.result = true;
            }
         }
         if(this.xml.@sp.length())
         {
            this.sp = this.xml.@sp;
         }
         if(this.xml.@xp.length())
         {
            this.xp = this.xml.@xp;
         }
         if(this.xml.@rep.length())
         {
            this.rep = this.xml.@rep;
         }
         if(this.xml.@trigger.length())
         {
            this.trigger = this.xml.@trigger;
            if(this.xml.@triggerset.length())
            {
               this.triggerSet = this.xml.@triggerset;
            }
            else
            {
               this.triggerSet = "1";
            }
            if(this.state == 2 && World.w.game.triggers[this.trigger] == null)
            {
               World.w.game.triggers[this.trigger] = this.triggerSet;
            }
         }
         if(Boolean(loadObj) && loadObj.invis != undefined)
         {
            this.invis = loadObj.invis;
         }
         node = Res.d.txt.(@id == pid);
         if(node.length() == 0)
         {
            node = Res.e.txt.(@id == pid);
         }
         if(node.length())
         {
            node = node[0];
            this.nazv = node.n[0];
            if(this.nazv == null)
            {
               this.nazv = "[" + this.id + "]";
            }
         }
         else
         {
            this.nazv = "[" + this.id + "]";
         }
         if(!this.sub)
         {
            if(Boolean(node) && Boolean(node.info.length()))
            {
               this.info = node.info[0];
            }
            else
            {
               this.info = "---";
            }
            this.main = this.xml.@main.length() > 0;
            this.subs = new Array();
            this.subsId = new Array();
            nnsub = 1;
            for each(sxml in this.xml.q)
            {
               if(loadObj)
               {
                  sl = loadObj.subs[sxml.@id];
               }
               q = new Quest(sxml,sl,this,nnsub);
               this.subsId[q.id] = q;
               this.subs.push(q);
               nnsub++;
            }
         }
      }
      
      public function save() : Object
      {
         var _loc2_:Quest = null;
         var _loc1_:Object = {
            "id":this.id,
            "state":this.state,
            "est":this.est,
            "gived":this.gived,
            "invis":this.invis
         };
         if(!this.sub)
         {
            _loc1_.subs = new Array();
            for each(_loc2_ in this.subs)
            {
               _loc1_.subs[_loc2_.id] = _loc2_.save();
            }
         }
         return _loc1_;
      }
      
      public function inc(param1:String, param2:int = 1) : *
      {
         var _loc3_:Quest = null;
         if(param1 == this.collect)
         {
            this.est += param2;
         }
         if(!this.sub)
         {
            for each(_loc3_ in this.subs)
            {
               _loc3_.inc(param1,param2);
            }
         }
      }
      
      public function deposit() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Item = null;
         if(this.xml.deposit.length())
         {
            for each(_loc1_ in this.xml.deposit)
            {
               if(_loc1_.@id.length())
               {
                  if(_loc1_.@kol.length())
                  {
                     _loc2_ = new Item("",_loc1_.@id,_loc1_.@kol);
                  }
                  else
                  {
                     _loc2_ = new Item("",_loc1_.@id);
                  }
                  World.w.invent.take(_loc2_,2);
               }
               if(_loc1_.@trigger.length())
               {
                  if(_loc1_.@set.length())
                  {
                     World.w.game.triggers[_loc1_.@trigger] = _loc1_.@set.toString();
                  }
                  else
                  {
                     World.w.game.triggers[_loc1_.@trigger] = 1;
                  }
               }
            }
         }
      }
      
      public function check(param1:String = null) : String
      {
         var _loc2_:String = null;
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc5_:Quest = null;
         if(this.sub)
         {
            if(Boolean(this.collect) && Boolean(this.colTip == 0) && this.gived < this.kol)
            {
               if(World.w.invent.items[this.collect])
               {
                  this.est = World.w.invent.items[this.collect].kol + this.gived;
               }
               if(this.est > this.kol)
               {
                  this.est = this.kol;
               }
               if(this.give == null)
               {
                  if(this.est >= this.kol)
                  {
                     this.state = 2;
                     if(this.par.result)
                     {
                        this.par.isResult();
                     }
                  }
                  else if(this.canBeUse)
                  {
                     if(this.state < 2)
                     {
                        this.state = 1;
                     }
                     else
                     {
                        this.est = this.kol;
                     }
                  }
                  else
                  {
                     this.state = 1;
                  }
               }
               if(param1 != null && this.collect == param1)
               {
                  _loc2_ = this.nazv + " " + this.est + "/" + this.kol;
               }
               if(World.w.invent.items[this.collect])
               {
                  this.est = World.w.invent.items[this.collect].kol;
               }
            }
            if(Boolean(this.collect) && this.colTip == 1)
            {
               if(World.w.invent.weapons[this.collect] != null && World.w.invent.weapons[this.collect].respect != 3)
               {
                  this.state = 2;
                  if(this.par.result)
                  {
                     this.par.isResult();
                  }
               }
               if(param1 != null && this.collect == param1)
               {
                  _loc2_ = this.nazv;
               }
            }
         }
         else
         {
            if(this.state == 2)
            {
               return null;
            }
            _loc3_ = true;
            for each(_loc5_ in this.subs)
            {
               _loc4_ = _loc5_.check(param1);
               if(_loc4_ != null)
               {
                  _loc2_ = _loc4_;
               }
               if(_loc5_.state < 2 && !_loc5_.nn)
               {
                  _loc3_ = false;
               }
            }
            if(_loc3_)
            {
               this.close();
            }
         }
         if(_loc2_ == this.prevRes || _loc2_ == null)
         {
            return null;
         }
         this.prevRes = _loc2_;
         return _loc2_;
      }
      
      public function chGive(param1:String, param2:Boolean = false) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:Quest = null;
         if(this.sub)
         {
            if(this.give == null)
            {
               return false;
            }
            if(this.collect)
            {
               if(World.w.invent.items[this.collect])
               {
                  this.est = World.w.invent.items[this.collect].kol;
               }
               if(this.est > 0 && this.kol - this.gived > 0)
               {
                  if(this.est > this.kol - this.gived)
                  {
                     this.est = this.kol - this.gived;
                  }
                  if(param2)
                  {
                     World.w.invent.minusItem(this.collect,this.est);
                     this.gived += this.est;
                     if(this.pay > 0)
                     {
                        World.w.invent.money.kol += this.est * this.pay;
                        World.w.gui.infoText("reward",Res.txt("i","money"),this.est * this.pay);
                     }
                     World.w.gui.infoText("withdraw",World.w.invent.items[this.collect].nazv,this.est);
                     this.est = 0;
                     if(this.gived >= this.kol)
                     {
                        this.close();
                     }
                  }
                  return true;
               }
            }
            return false;
         }
         _loc3_ = false;
         for each(_loc4_ in this.subs)
         {
            if(_loc4_.chGive(param1,param2))
            {
               _loc3_ = true;
            }
         }
         this.check(null);
         return _loc3_;
      }
      
      public function chReport(param1:String, param2:Boolean = false) : Boolean
      {
         var _loc3_:Boolean = false;
         var _loc4_:Quest = null;
         var _loc5_:Quest = null;
         if(!this.sub)
         {
            _loc3_ = true;
            for each(_loc5_ in this.subs)
            {
               if(Boolean(_loc5_.report) && _loc5_.report == param1)
               {
                  _loc4_ = _loc5_;
               }
               else if(_loc5_.state < 2 && !_loc5_.nn)
               {
                  _loc3_ = false;
               }
            }
            if(_loc3_ && Boolean(_loc4_))
            {
               if(!param2)
               {
                  return true;
               }
               _loc4_.close();
               this.check(null);
               return true;
            }
         }
         return false;
      }
      
      public function isClosed() : *
      {
         var _loc2_:Quest = null;
         var _loc1_:Boolean = true;
         for each(_loc2_ in this.subs)
         {
            if(_loc2_.state < 2)
            {
               _loc1_ = false;
            }
         }
         if(_loc1_)
         {
            this.close();
         }
      }
      
      public function isResult() : *
      {
         var _loc2_:Boolean = false;
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this.subs.length)
         {
            if(this.subs[_loc1_].result)
            {
               _loc2_ = true;
               _loc3_ = _loc1_ - 1;
               while(_loc3_ >= 0)
               {
                  if(this.subs[_loc3_].state < 2)
                  {
                     _loc2_ = false;
                  }
                  _loc3_--;
               }
               if(_loc2_)
               {
                  this.subs[_loc1_].invis = false;
               }
            }
            _loc1_++;
         }
      }
      
      public function closeSub(param1:String) : *
      {
         if(this.state == 2 || param1 == null || param1 == "" || this.subsId[param1] == null)
         {
            return;
         }
         this.subsId[param1].close();
         if(this.result)
         {
            this.isResult();
         }
         if(this.state == 1)
         {
            this.isClosed();
         }
      }
      
      public function showSub(param1:String) : *
      {
         if(param1 == null || param1 == "" || this.subsId[param1] == null)
         {
            return;
         }
         this.subsId[param1].invis = false;
      }
      
      public function close() : *
      {
         var _loc1_:Quest = null;
         var _loc2_:* = undefined;
         var _loc3_:Item = null;
         if(this.state == 2)
         {
            return;
         }
         this.state = 2;
         if(!this.sub)
         {
            for each(_loc1_ in this.subs)
            {
               if(_loc1_.isDel)
               {
                  if(_loc1_.colTip == 0)
                  {
                     World.w.invent.minusItem(_loc1_.collect,_loc1_.kol);
                     try
                     {
                        World.w.gui.infoText("withdraw",World.w.invent.items[_loc1_.collect].nazv,_loc1_.kol);
                     }
                     catch(err:*)
                     {
                     }
                  }
                  else if(_loc1_.colTip == 1)
                  {
                     try
                     {
                        World.w.gui.infoText("withdraw",World.w.invent.weapons[_loc1_.collect].nazv,1);
                     }
                     catch(err:*)
                     {
                     }
                     World.w.invent.remWeapon(_loc1_.collect);
                  }
               }
            }
         }
         if(this.sp)
         {
            World.w.pers.addSkillPoint(this.sp);
         }
         if(this.xp)
         {
            World.w.pers.expa(this.xp);
         }
         if(this.rep)
         {
            World.w.pers.rep += this.rep;
         }
         if(this.trigger)
         {
            World.w.game.triggers[this.trigger] = this.triggerSet;
         }
         if(this.xml.reward.length())
         {
            for each(_loc2_ in this.xml.reward)
            {
               if(_loc2_.@id.length())
               {
                  if(_loc2_.@kol.length())
                  {
                     _loc3_ = new Item("",_loc2_.@id,_loc2_.@kol);
                  }
                  else
                  {
                     _loc3_ = new Item("",_loc2_.@id);
                  }
                  World.w.invent.take(_loc3_,2);
               }
               if(_loc2_.@trigger.length())
               {
                  if(_loc2_.@set.length())
                  {
                     World.w.game.triggers[_loc2_.@trigger] = _loc2_.@set.toString();
                  }
                  else
                  {
                     World.w.game.triggers[_loc2_.@trigger] = 1;
                  }
               }
            }
         }
         if(!this.sub)
         {
            World.w.gui.infoText("doneTask",this.nazv);
            Snd.ps("quest_ok");
         }
         else
         {
            World.w.gui.infoText("doneStage",this.nazv);
         }
         if(Boolean(this.endDial) && World.w.dialOn)
         {
            World.w.pip.onoff(-1);
            World.w.gui.dialog(this.endDial);
         }
         if(this.endScript != null)
         {
            World.w.game.runScript(this.endScript);
         }
      }
   }
}

