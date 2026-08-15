package fe.serv
{
   import fe.*;
   import fe.unit.UnitNPC;
   
   public class NPC
   {
      
      public var xml:XML;
      
      public var id:String = "";
      
      public var vid:String;
      
      public var owner:Obj;
      
      public var vendor:Vendor;
      
      public var inter:Interact;
      
      public var hidden:Boolean = false;
      
      public var rep:int = 0;
      
      public var zzzGen:Boolean = false;
      
      public var npcInter:String = "";
      
      public var userAction1:String;
      
      public var userAction2:String;
      
      public var ndial:String;
      
      public function NPC(param1:XML, param2:Object = null, param3:String = null, param4:int = 100)
      {
         super();
         this.xml = param1;
         if(this.xml)
         {
            this.id = this.xml.@id;
            if(this.xml.@vendor.length())
            {
               this.vid = this.xml.@vendor;
            }
            if(this.xml.@inter.length())
            {
               this.npcInter = this.xml.@inter;
            }
            if(this.xml.@ua1.length())
            {
               this.userAction1 = this.xml.@ua1;
            }
            if(this.xml.@ua2.length())
            {
               this.userAction2 = this.xml.@ua2;
            }
            if(this.xml.@ndial.length())
            {
               this.ndial = this.xml.@ndial;
            }
         }
         if(param2)
         {
            if(param2.rep != null)
            {
               this.rep = param2.rep;
            }
         }
         if(param3 != null)
         {
            this.vid = param3;
         }
         if(this.vid != null && this.vid != "")
         {
            if(World.w.game.vendors[this.vid])
            {
               this.vendor = World.w.game.vendors[this.vid];
            }
            else
            {
               this.vendor = new Vendor(param4,null,null,this.vid);
               if(this.vid == "doctor")
               {
                  this.npcInter = "doc";
               }
               else
               {
                  this.npcInter = "vr";
               }
            }
         }
      }
      
      public function save() : Object
      {
         var _loc1_:* = new Object();
         _loc1_.rep = this.rep;
         return _loc1_;
      }
      
      public function setInter() : *
      {
         if(this.id == "adoc" && this.rep <= 1)
         {
            this.inter.t_action = 45;
         }
      }
      
      public function init() : *
      {
         if(this.id == "calam")
         {
            if(this.rep == 0 || this.trig("rbl_visited") > 0)
            {
               this.hidden = true;
            }
            if(this.rep == 1)
            {
               (this.owner as UnitNPC).aiTip = "agro";
            }
         }
         if(this.id == "steel2")
         {
            this.refresh();
         }
      }
      
      internal function trig(param1:String) : *
      {
         return World.w.game.triggers[param1];
      }
      
      public function refresh() : *
      {
         if(this.id == "calam")
         {
            if(this.rep == 0 && Boolean(this.owner))
            {
               this.owner.command("ai","");
            }
         }
         if(this.id == "calam2")
         {
            this.hidden = this.trig("storm") > 0;
         }
         if(this.id == "calam3")
         {
            this.hidden = this.trig("storm") != 1;
         }
         if(this.id == "calam4")
         {
            this.hidden = this.trig("storm") != 2 && this.trig("storm") != 3;
         }
         if(this.id == "calam5")
         {
            this.hidden = this.trig("storm") != 3;
         }
         if(this.id == "steel2")
         {
            this.hidden = this.trig("mbase_visited") > 0;
         }
         if(this.id == "steel")
         {
            this.hidden = this.trig("storm") == 5;
         }
         if(this.id == "askari")
         {
            this.hidden = this.trig("story_ranger") > 0;
         }
         if(this.id == "askari2")
         {
            this.hidden = this.trig("story_ranger") <= 0 || this.trig("storm") > 0;
         }
         if(this.id == "patient")
         {
            this.zzzGen = this.rep == 2;
         }
         if(this.id == "observer")
         {
            this.hidden = this.trig("observer") != 1;
         }
         if(this.id == "observer2")
         {
            this.hidden = this.trig("storm") != 2;
         }
         if(this.id == "askari3")
         {
            this.hidden = this.trig("storm") < 2;
         }
         if(this.id == "mentor")
         {
            this.hidden = this.trig("theend") > 0;
         }
      }
      
      public function landing() : *
      {
         if(this.id == "calam")
         {
            this.rep = 1;
         }
      }
      
      public function activate() : *
      {
         if(this.check(true) && this.npcInter != "patient")
         {
            return;
         }
         if(this.npcInter == "travel")
         {
            World.w.pip.travel = true;
            World.w.pip.onoff(3,3);
            World.w.pip.travel = true;
         }
         else if(this.npcInter == "doc" || this.npcInter == "vdoc")
         {
            this.pip(6);
         }
         else if(this.npcInter == "adoc")
         {
            if(this.rep <= 1)
            {
               this.repair();
            }
            else
            {
               this.pip(6);
            }
         }
         else if(this.npcInter == "patient")
         {
            this.patient();
         }
         else if(this.vendor)
         {
            this.pip(4);
         }
         else if(this.ndial)
         {
            World.w.gui.dialog(this.ndial);
         }
         else if(this.owner)
         {
            this.owner.command("tell","dial");
         }
      }
      
      public function pip(param1:int) : *
      {
         World.w.pip.vendor = this.vendor;
         World.w.pip.npcId = this.id;
         World.w.pip.npcInter = this.npcInter;
         World.w.pip.onoff(param1);
         if(this.owner)
         {
            this.owner.command("replicVse");
         }
      }
      
      public function check(param1:Boolean = false) : Boolean
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:Script = null;
         var _loc5_:String = null;
         var _loc6_:* = undefined;
         var _loc7_:Item = null;
         if(Boolean(this.xml) && Boolean(this.xml.dial.length()))
         {
            var _loc8_:int = 0;
            var _loc9_:* = this.xml.dial;
            while(true)
            {
               for each(_loc2_ in _loc9_)
               {
                  if(!this.trig("dial_" + _loc2_.@id))
                  {
                     if(!(Boolean(_loc2_.@lvl.length()) && _loc2_.@lvl > World.w.pers.level))
                     {
                        if(!(Boolean(_loc2_.@barter.length()) && _loc2_.@barter > World.w.pers.getSkLevel(World.w.pers.skills["barter"])))
                        {
                           if(_loc2_.@trigger.length())
                           {
                              if(_loc2_.@n.length())
                              {
                                 if(this.trig(_loc2_.@trigger) != _loc2_.@n)
                                 {
                                    continue;
                                 }
                              }
                              else if(this.trig(_loc2_.@trigger) != 1)
                              {
                                 continue;
                              }
                           }
                           if(!(Boolean(_loc2_.@prev.length()) && this.trig("dial_" + _loc2_.@prev) != 1))
                           {
                              if(!(Boolean(_loc2_.@land.length()) && !World.w.game.lands[_loc2_.@land].access))
                              {
                                 if(!(Boolean(_loc2_.@armor.length()) && (World.w.gg.currentArmor == null || World.w.gg.currentArmor.id != _loc2_.@armor)))
                                 {
                                    if(!(Boolean(_loc2_.@pet.length()) && World.w.gg.currentPet != _loc2_.@pet))
                                    {
                                       if(!_loc2_.@quest.length())
                                       {
                                          break;
                                       }
                                       _loc3_ = World.w.game.quests[_loc2_.@quest];
                                       if(!(_loc3_ == null || _loc3_.state != 1))
                                       {
                                          if(!_loc2_.@sub.length())
                                          {
                                             break;
                                          }
                                          if(!(_loc3_.subsId[_loc2_.@sub] == null || Boolean(_loc3_.subsId[_loc2_.@sub].invis)))
                                          {
                                             break;
                                          }
                                       }
                                    }
                                 }
                              }
                           }
                        }
                     }
                  }
                  continue;
               }
            }
            if(param1)
            {
               if(_loc2_.scr.length())
               {
                  _loc4_ = new Script(_loc2_.scr[0],World.w.land,this.owner,true);
                  if(World.w.dialOn)
                  {
                     _loc5_ = _loc2_.@id;
                     _loc4_.acts.unshift({
                        "act":"dialog",
                        "val":_loc5_,
                        "t":0,
                        "n":-1,
                        "opt1":0,
                        "opt2":0,
                        "targ":""
                     });
                  }
                  _loc4_.acts.push({
                     "act":"trigger",
                     "val":"dial_" + _loc2_.@id,
                     "t":0,
                     "n":1,
                     "opt1":0,
                     "opt2":0,
                     "targ":""
                  });
                  _loc4_.acts.push({
                     "act":"checkall",
                     "val":0,
                     "t":0,
                     "n":1,
                     "opt1":0,
                     "opt2":0,
                     "targ":""
                  });
                  _loc4_.start();
               }
               else
               {
                  if(World.w.dialOn)
                  {
                     World.w.gui.dialog(_loc2_.@id);
                  }
                  World.w.game.setTrigger("dial_" + _loc2_.@id);
               }
               if(_loc2_.reward.length())
               {
                  for each(_loc6_ in _loc2_.reward)
                  {
                     if(_loc6_.@id.length())
                     {
                        if(_loc6_.@kol.length())
                        {
                           _loc7_ = new Item("",_loc6_.@id,_loc6_.@kol);
                        }
                        else
                        {
                           _loc7_ = new Item("",_loc6_.@id);
                        }
                        World.w.invent.take(_loc7_,2);
                     }
                  }
               }
               if(_loc2_.@music.length())
               {
                  Snd.playMusic(_loc2_.@music);
               }
               this.check();
            }
            else if(_loc2_.@imp.length())
            {
               this.setStatus(2);
            }
            else
            {
               this.setStatus(1);
            }
            return true;
         }
         if(!param1)
         {
            this.setStatus(0);
         }
         return false;
      }
      
      public function setStatus(param1:int = 0) : *
      {
         if(param1 > 0)
         {
            this.setIco("dial" + param1);
            if(this.userAction1)
            {
               this.inter.userAction = this.userAction1;
            }
            else
            {
               this.inter.userAction = "dial";
            }
            this.owner.command("sign");
         }
         else
         {
            if(this.userAction2)
            {
               this.inter.userAction = this.userAction2;
            }
            else if(this.npcInter == "doc" || this.npcInter == "vdoc")
            {
               this.inter.userAction = "therapy";
            }
            else if(this.npcInter == "patient")
            {
               if(this.trig("patient_tr2") == "1")
               {
                  this.inter.t_action = 0;
                  this.inter.userAction = "dial";
               }
               else
               {
                  this.inter.t_action = 30;
                  this.inter.userAction = "see";
               }
            }
            else if(this.npcInter == "adoc")
            {
               if(this.rep <= 1)
               {
                  this.inter.userAction = "repair";
               }
               else
               {
                  this.inter.userAction = "therapy";
               }
            }
            else if(this.vendor)
            {
               this.inter.userAction = "trade";
            }
            else
            {
               this.inter.userAction = "dial";
            }
            this.setIco();
         }
         this.inter.update();
      }
      
      internal function setIco(param1:String = null) : *
      {
         try
         {
            if(param1 == null)
            {
               this.owner["ico"].gotoAndStop(this.owner["icoFrame"]);
            }
            else
            {
               this.owner["ico"].gotoAndStop(param1);
            }
         }
         catch(err:*)
         {
         }
      }
      
      public function repair() : *
      {
         var _loc3_:* = undefined;
         if(Boolean(this.xml) && Boolean(this.xml.quest.length()))
         {
            if(World.w.game.quests[this.xml.quest.@id] == null)
            {
               World.w.game.addQuest(this.xml.quest.@id);
               return;
            }
         }
         if(World.w.pers.skills[this.xml.@needskill] == null)
         {
            return;
         }
         var _loc1_:int = World.w.pers.getSkLevel(World.w.pers.skills[this.xml.@needskill]);
         var _loc2_:Boolean = false;
         if(_loc1_ < 2)
         {
            World.w.gui.dialog("rblAutoDocR1");
         }
         else if(_loc1_ >= 5)
         {
            World.w.gui.dialog("rblAutoDocR5");
            _loc2_ = true;
         }
         else if(this.rep == 1)
         {
            _loc2_ = true;
            for each(_loc3_ in this.xml.rep)
            {
               if(Boolean(World.w.invent.items[_loc3_.@id]) && World.w.invent.items[_loc3_.@id].kol < _loc3_.@kol)
               {
                  World.w.gui.infoText("required",World.w.invent.items[_loc3_.@id].nazv,_loc3_.@kol - World.w.invent.items[_loc3_.@id].kol);
                  _loc2_ = false;
               }
            }
            if(_loc2_)
            {
               for each(_loc3_ in this.xml.rep)
               {
                  if(World.w.invent.items[_loc3_.@id])
                  {
                     World.w.invent.minusItem(_loc3_.@id,_loc3_.@kol);
                     World.w.gui.infoText("withdraw",World.w.invent.items[_loc3_.@id].nazv,_loc3_.@kol);
                  }
               }
               World.w.gui.dialog("rblAutoDocR4");
            }
            else
            {
               World.w.gui.dialog("rblAutoDocR3");
            }
         }
         else
         {
            World.w.gui.dialog("rblAutoDocR2");
            this.rep = 1;
         }
         if(_loc2_)
         {
            this.rep = 2;
            this.inter.t_action = 0;
            this.setStatus();
            if(Boolean(this.xml) && Boolean(this.xml.quest.length()))
            {
               World.w.game.closeQuest(this.xml.quest.@id,this.xml.quest.@cid);
            }
         }
      }
      
      public function patient() : *
      {
         if(World.w.pers.skills[this.xml.@needskill] == null)
         {
            return;
         }
         var _loc1_:int = World.w.pers.getSkLevel(World.w.pers.skills[this.xml.@needskill]);
         if(this.rep == 2)
         {
            if(this.trig("patient_tr2") == "1")
            {
               if(this.owner)
               {
                  this.owner.command("openEyes");
               }
            }
            else
            {
               World.w.gui.dialog("dialPatient7");
            }
         }
         else if(this.rep == 1)
         {
            if(Boolean(World.w.invent.items[this.xml.@needitem]) && World.w.invent.items[this.xml.@needitem].kol > 0)
            {
               World.w.invent.minusItem(this.xml.@needitem,1);
               this.rep = 2;
               World.w.gui.dialog("dialPatient5");
               World.w.game.triggers["patient_tr2"] = "wait";
               World.w.game.closeQuest("patientHeal","3");
               World.w.game.showQuest("patientHeal","4");
            }
            else
            {
               World.w.gui.dialog("dialPatient8");
            }
         }
         else if(_loc1_ < 4)
         {
            World.w.gui.dialog("dialPatient2");
         }
         else
         {
            World.w.gui.dialog("dialPatient3");
            this.rep = 1;
            World.w.game.triggers["patient_tr1"] = 1;
            World.w.game.closeQuest("patientHeal","1");
            World.w.game.showQuest("patientHeal","2");
            World.w.game.showQuest("patientHeal","3");
         }
         this.refresh();
      }
   }
}

