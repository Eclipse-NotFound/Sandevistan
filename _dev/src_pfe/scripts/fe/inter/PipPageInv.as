package fe.inter
{
   import fe.*;
   import fe.serv.Item;
   import fe.unit.Armor;
   import fe.weapon.Weapon;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PipPageInv extends PipPage
   {
      
      internal var assId:String = null;
      
      internal var assArr:Array;
      
      internal var actCurrent:String = "";
      
      internal var overId:String;
      
      internal var overItem:Object;
      
      internal var over_t:int;
      
      internal var dat:Number = 0;
      
      public function PipPageInv(param1:PipBuck, param2:String)
      {
         isLC = isRC = true;
         itemClass = visPipInvItem;
         super(param1,param2);
         vis.butOk.addEventListener(MouseEvent.CLICK,this.showH);
         tips = [[],["","w1","w2","w4","w5","w6","w3"],["","armor1","armor3"],["","med",["him","pot"],"food",["equip","spell"],["book","sphera","note"],"paint"],["",["valuables","money"],["spec","key"],["impl","art","instr","equip"],["stuff","compa","compw","compe","compm"],["compp","food"],"scheme"],["","a","e"]];
         initCats();
      }
      
      override internal function setSubPages() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Weapon = null;
         var _loc3_:String = null;
         var _loc4_:Boolean = false;
         var _loc5_:Object = null;
         var _loc6_:* = undefined;
         var _loc7_:Armor = null;
         var _loc8_:XML = null;
         var _loc9_:* = undefined;
         var _loc10_:String = null;
         vis.butOk.visible = false;
         statHead.cat.visible = false;
         statHead.rid.visible = false;
         pip.vis.butHelp.visible = true;
         pip.vis.butMass.visible = World.w.hardInv;
         setIco();
         setCats();
         this.assId = null;
         this.dat = new Date().getTime();
         if(page2 != 4)
         {
            setTopText("invupr" + page2);
         }
         inv.calcMass();
         inv.calcWeaponMass();
         if(page2 == 1)
         {
            inv.getKolAmmos();
            this.assArr = new Array();
            statHead.fav.text = Res.pipText("ii1");
            statHead.nazv.text = Res.pipText("ii2");
            statHead.hp.text = Res.pipText("ii3");
            statHead.ammo.text = "";
            statHead.mass.text = "";
            statHead.ammotip.text = Res.pipText("ii4");
            for each(_loc1_ in inv.weapons)
            {
               if(_loc1_ is Weapon)
               {
                  _loc2_ = _loc1_ as Weapon;
                  if(_loc2_.respect != 3)
                  {
                     if(!(_loc2_.spell && World.w.alicorn))
                     {
                        if(!(_loc2_.spell && (inv.items[_loc2_.id] == null || inv.items[_loc2_.id].kol <= 0)))
                        {
                           _loc2_.setPers(gg,gg.pers);
                           if(_loc2_.respect == 1)
                           {
                              if(!World.w.hardInv || World.w.loc.base || World.w.loc.train)
                              {
                                 vis.butOk.visible = true;
                              }
                              if(!pip.showHidden)
                              {
                                 continue;
                              }
                           }
                           if(!(_loc2_.alicorn && !World.w.alicorn))
                           {
                              _loc3_ = "w" + _loc2_.skill;
                              if(_loc3_ == "w7")
                              {
                                 _loc3_ = "w6";
                              }
                              if(!(curTip != "" && curTip != null && curTip != _loc3_))
                              {
                                 _loc4_ = true;
                                 if(_loc2_.avail() <= -1)
                                 {
                                    _loc4_ = false;
                                 }
                                 _loc5_ = {
                                    "tip":"w",
                                    "id":_loc2_.id,
                                    "nazv":_loc2_.nazv,
                                    "respect":_loc2_.respect,
                                    "avail":_loc4_,
                                    "variant":_loc2_.variant,
                                    "trol":_loc3_
                                 };
                                 _loc5_.sort1 = 1;
                                 if(!_loc4_)
                                 {
                                    _loc5_.sort1 = 2;
                                 }
                                 if(_loc5_.respect == 1)
                                 {
                                    _loc5_.sort1 = 3;
                                 }
                                 _loc5_.sort3 = _loc2_.lvl;
                                 _loc5_.sort2 = _loc2_.skill;
                                 if(_loc2_.tip == 5)
                                 {
                                    _loc5_.sort3 = _loc2_.perslvl;
                                 }
                                 if(_loc2_.spell)
                                 {
                                    _loc5_.sort3 = 900 + _loc2_.perslvl;
                                 }
                                 _loc5_.sort3 = int(_loc5_.sort3);
                                 if(_loc2_.tip < 4)
                                 {
                                    _loc5_.hp = Math.round(_loc2_.hp / _loc2_.maxhp * 100) + "%";
                                 }
                                 if(_loc2_.ammo != "" && _loc2_.ammo != null)
                                 {
                                    if(inv.ammos[_loc2_.ammoBase] != null)
                                    {
                                       _loc5_.ammo = inv.ammos[_loc2_.ammoBase] + _loc2_.hold;
                                    }
                                    else
                                    {
                                       _loc5_.ammo = inv.items[_loc2_.ammo].kol + _loc2_.hold;
                                    }
                                    _loc5_.ammotip = _loc2_.tip != 4 ? inv.items[_loc2_.ammoBase].nazv : "";
                                 }
                                 if(_loc2_.alicorn)
                                 {
                                    _loc5_.nazv = Res.rainbow(_loc5_.nazv);
                                 }
                                 arr.push(_loc5_);
                                 this.assArr[_loc5_.id] = _loc5_;
                              }
                           }
                        }
                     }
                  }
               }
            }
            pip.reqKey = true;
            vis.butOk.text.text = Res.pipText("showhidden");
            this.actCurrent = "showhidden";
            if(arr.length)
            {
               arr.sortOn(["sort1","sort2","sort3","nazv"],[0,0,Array.NUMERIC,0]);
            }
            pip.massText = Res.txt("p","massInv0",0,true) + "<br><br>" + Res.txt("p","massInv1",0,true);
         }
         else if(page2 == 2)
         {
            statHead.fav.text = Res.pipText("ii1");
            statHead.nazv.text = Res.pipText("ii2");
            statHead.hp.text = Res.pipText("ii3");
            statHead.ammo.text = "";
            statHead.mass.text = "";
            statHead.ammotip.text = "";
            for(_loc6_ in inv.armors)
            {
               if(_loc6_ != "")
               {
                  _loc7_ = inv.armors[_loc6_];
                  if(_loc7_.lvl >= 0)
                  {
                     if(!(curTip != "" && curTip != null && curTip != "armor" + _loc7_.tip))
                     {
                        _loc5_ = {
                           "id":_loc6_,
                           "nazv":_loc7_.nazv,
                           "clo":_loc7_.clo,
                           "hp":Math.round(_loc7_.hp / _loc7_.maxhp * 100) + "%",
                           "sort":_loc7_.sort,
                           "trol":"armor" + _loc7_.tip
                        };
                        arr.push(_loc5_);
                     }
                  }
               }
            }
            pip.reqKey = true;
            if(arr.length)
            {
               arr.sortOn(["trol","sort"],[0,Array.NUMERIC]);
            }
            pip.massText = Res.txt("p","massInv0",0,true) + "<br><br>" + Res.txt("p","massInv2",0,true);
         }
         else if(page2 == 3 || page2 == 4 || page2 == 5)
         {
            this.assArr = new Array();
            statHead.fav.text = Res.pipText("ii1");
            statHead.nazv.text = Res.pipText("ii2");
            statHead.hp.text = Res.pipText("ii5");
            statHead.ammotip.text = Res.pipText("ii6");
            statHead.ammo.text = "";
            if(World.w.hardInv)
            {
               statHead.mass.text = Res.pipText("ii8");
            }
            for(_loc6_ in inv.items)
            {
               if(!(_loc6_ == "" || inv.items[_loc6_].kol <= 0 || Boolean(inv.items[_loc6_].invis)))
               {
                  _loc8_ = inv.items[_loc6_].xml;
                  if(_loc8_ != null)
                  {
                     if(inv.items[_loc6_].nov == 1 && this.dat - inv.items[_loc6_].dat > 1000 * 60 * 15)
                     {
                        inv.items[_loc6_].nov = 0;
                     }
                     if(inv.items[_loc6_].nov == 2 && this.dat - inv.items[_loc6_].dat > 1000 * 60 * 5)
                     {
                        inv.items[_loc6_].nov = 0;
                     }
                     if(checkCat(_loc8_.@tip))
                     {
                        _loc9_ = 0;
                        if(_loc8_.@tip == "a" || _loc8_.@tip == "e")
                        {
                           _loc9_ = 2;
                        }
                        else if(_loc8_.@us > 0)
                        {
                           _loc9_ = 1;
                        }
                        if(_loc9_ == 1 && page2 == 3 || _loc9_ == 0 && page2 == 4 || _loc9_ == 2 && page2 == 5)
                        {
                           if(Res.istxt("p",_loc8_.@tip))
                           {
                              _loc10_ = Res.pipText(_loc8_.@tip);
                           }
                           else
                           {
                              _loc10_ = Res.pipText("stuff");
                           }
                           _loc5_ = {
                              "tip":_loc8_.@tip,
                              "id":_loc6_,
                              "nazv":(_loc8_.@tip == "e" ? Res.txt("w",_loc6_) : inv.items[_loc6_].nazv),
                              "kol":inv.items[_loc6_].kol,
                              "drop":0,
                              "mass":inv.items[_loc6_].mass,
                              "cat":_loc10_,
                              "trol":_loc8_.@tip
                           };
                           if(_loc8_.@tip == "valuables")
                           {
                              _loc5_.price = _loc8_.@price;
                           }
                           if(_loc8_.@tip == "food" && _loc8_.@ftip == "1")
                           {
                              _loc5_.trol = "drink";
                           }
                           if(!(Boolean(_loc8_.@tip == "spell") && Boolean(inv.weapons[_loc6_]) && inv.weapons[_loc6_].respect == 1))
                           {
                              _loc5_.sort = _loc5_.cat;
                              _loc5_.sort2 = _loc8_.@sort.length() ? _loc8_.@sort : 0;
                              if(Boolean(page2 == 5 && gg.currentWeapon) && Boolean(gg.currentWeapon.tip < 4) && (gg.currentWeapon.ammoBase == _loc8_.@base || gg.currentWeapon.ammoBase == _loc8_.@id))
                              {
                                 _loc5_.sort = "0" + _loc5_.sort;
                              }
                              arr.push(_loc5_);
                              this.assArr[_loc5_.id] = _loc5_;
                           }
                        }
                     }
                  }
               }
            }
            if(page2 == 3)
            {
               pip.reqKey = true;
            }
            if(arr.length)
            {
               arr.sortOn(["sort","sort2","nazv"],[0,Array.NUMERIC,0]);
            }
            pip.massText = Res.txt("p","massInv0",0,true) + "<br><br>" + Res.txt("p","massInv3",0,true);
         }
         pip.helpText = Res.txt("p","helpInv" + page2,0,true);
         if(arr.length == 0)
         {
            vis.emptytext.text = Res.pipText("emptyinv");
            statHead.visible = false;
         }
         else
         {
            vis.emptytext.text = "";
            statHead.visible = true;
         }
         this.showBottext();
      }
      
      internal function showBottext() : *
      {
         vis.bottext.htmlText = Res.pipText("caps") + ": " + yel(pip.money);
         if(World.w.hardInv)
         {
            if(page2 == 1)
            {
               vis.bottext.htmlText = "    " + inv.retMass(4) + "    " + inv.retMass(5);
            }
            else if(page2 == 3)
            {
               vis.bottext.htmlText += "    " + inv.retMass(1);
            }
            else if(page2 == 4)
            {
               vis.bottext.htmlText += "    " + inv.retMass(3);
            }
            else if(page2 == 5)
            {
               vis.bottext.htmlText += "    " + inv.retMass(2);
            }
         }
      }
      
      override internal function setStatItem(param1:MovieClip, param2:Object) : *
      {
         var item:MovieClip = param1;
         var obj:Object = param2;
         item.id.text = obj.id;
         item.id.visible = item.rid.visible = item.cat.visible = false;
         item.alpha = 1;
         item.nazv.alpha = 1;
         item.mass.text = "";
         if(inv.favIds[obj.id])
         {
            if(inv.favIds[obj.id] == 29)
            {
               item.fav.text = World.w.ctr.retKey("keyGrenad");
            }
            else if(inv.favIds[obj.id] == 30)
            {
               item.fav.text = World.w.ctr.retKey("keyMagic");
            }
            else if(inv.favIds[obj.id] > World.kolHK * 2)
            {
               item.fav.text = World.w.ctr.retKey("keySpell" + (inv.favIds[obj.id] - World.kolHK * 2));
            }
            else if(inv.favIds[obj.id] > World.kolHK)
            {
               item.fav.text = "^" + World.w.ctr.retKey("keyWeapon" + (inv.favIds[obj.id] - World.kolHK));
            }
            else
            {
               item.fav.text = World.w.ctr.retKey("keyWeapon" + inv.favIds[obj.id]);
            }
         }
         else
         {
            item.fav.text = "";
         }
         try
         {
            item.trol.gotoAndStop(obj.trol);
         }
         catch(err:*)
         {
            item.trol.gotoAndStop(1);
         }
         if(page2 == 1)
         {
            item.ramka.visible = World.w.gg.newWeapon && World.w.gg.newWeapon.id == obj.id || World.w.gg.currentSpell && World.w.gg.currentSpell.id == obj.id;
            if(item.ramka.visible)
            {
               selItem = item;
            }
            item.nazv.htmlText = obj.nazv;
            if(obj.respect == 0 && item.fav.text == "")
            {
               item.fav.text = "☩";
            }
            item.hp.text = obj.hp == null ? "" : obj.hp;
            if(obj.ammo != null)
            {
               item.ammo.text = obj.ammo;
               item.ammotip.text = obj.ammotip;
            }
            else
            {
               item.ammo.text = item.ammotip.text = "";
            }
            if(obj.respect == 1)
            {
               item.alpha = 0.4;
            }
            if(obj.avail == false)
            {
               item.nazv.alpha = 0.6;
            }
            if(obj.variant > 0)
            {
               item.rid.text = obj.id + "^" + obj.variant;
            }
            else
            {
               item.rid.text = obj.id;
            }
         }
         else if(page2 == 2)
         {
            item.ramka.visible = false;
            if(World.w.hardInv && !World.w.loc.base && obj.trol == "armor1" && World.w.gg.prevArmor != obj.id && obj.clo == 0)
            {
               item.alpha = 0.4;
            }
            if(Boolean(World.w.gg.currentArmor) && World.w.gg.currentArmor.id == obj.id)
            {
               item.ramka.visible = true;
               item.alpha = 1;
               selItem = item;
            }
            if(Boolean(World.w.gg.currentAmul) && World.w.gg.currentAmul.id == obj.id)
            {
               item.ramka.visible = true;
            }
            item.nazv.text = obj.nazv;
            if(obj.trol == "armor3")
            {
               item.hp.text = "";
            }
            else
            {
               item.hp.text = obj.hp;
            }
            item.ammo.text = "";
            item.ammotip.text = "";
         }
         else
         {
            item.ramka.visible = World.w.gg.currentSpell && World.w.gg.currentSpell.id == obj.id;
            item.nazv.text = obj.nazv;
            item.hp.text = obj.kol;
            if(World.w.hardInv && obj.mass > 0)
            {
               item.mass.text = Res.numb(obj.kol * obj.mass);
            }
            if(Boolean(obj.price) && obj.tip == "valuables")
            {
               item.ammo.text = obj.price;
            }
            else
            {
               item.ammo.text = "";
            }
            if(item.fav.text == "")
            {
               if(inv.items[obj.id].nov == 1)
               {
                  item.fav.text = "☩";
               }
               if(inv.items[obj.id].nov == 2)
               {
                  item.fav.text = "+";
               }
            }
            if(obj.drop > 0)
            {
               item.ammotip.text = Res.pipText("drop") + ": " + obj.drop;
            }
            else
            {
               item.ammotip.text = obj.cat.substring(2);
            }
         }
      }
      
      override internal function statInfo(param1:MouseEvent) : *
      {
         this.assId = null;
         if(page2 == 1)
         {
            this.assId = param1.currentTarget.id.text;
            infoItem(Item.L_WEAPON,param1.currentTarget.rid.text,param1.currentTarget.nazv.text);
         }
         if(page2 == 2)
         {
            this.assId = param1.currentTarget.id.text;
            infoItem(Item.L_ARMOR,param1.currentTarget.id.text,param1.currentTarget.nazv.text);
         }
         if(page2 == 3 || page2 == 4)
         {
            if(page2 == 3)
            {
               this.assId = param1.currentTarget.id.text;
            }
            infoItem(Item.L_ITEM,param1.currentTarget.id.text,param1.currentTarget.nazv.text);
         }
         if(page2 == 5)
         {
            infoItem(Item.L_AMMO,param1.currentTarget.id.text,param1.currentTarget.nazv.text);
         }
         if(page2 >= 3)
         {
            if(param1.currentTarget.id.text != this.overId)
            {
               this.overId = param1.currentTarget.id.text;
               this.overItem = param1.currentTarget;
               this.over_t = 30;
            }
         }
      }
      
      override internal function itemClick(param1:MouseEvent) : *
      {
         if(pip.noAct)
         {
            World.w.gui.infoText("noAct");
            return;
         }
         if(param1.ctrlKey)
         {
            this.itemRightClick(param1);
            return;
         }
         var _loc2_:String = param1.currentTarget.id.text;
         if(page2 == 1)
         {
            World.w.gg.changeWeapon(_loc2_);
            selItem = param1.currentTarget as MovieClip;
            setStatus(false);
            pip.snd(1);
         }
         else if(page2 == 2)
         {
            if(World.w.gg.changeArmor(_loc2_))
            {
               setStatus(false);
            }
            pip.snd(1);
         }
         else if(page2 == 3)
         {
            if(_loc2_ == "retr")
            {
               if(World.w.alicorn)
               {
                  World.w.gui.infoText("alicornNot",null,null,false);
                  return false;
               }
               if(World.w.game.curLandId == World.w.game.baseId)
               {
                  return;
               }
               if(World.w.possiblyOut() >= 2)
               {
                  World.w.gui.infoText("noUseCombat");
               }
               else
               {
                  this.buttonOk("retr");
               }
            }
            else if(_loc2_ == "mworkbench" || _loc2_ == "mworkexpl" || _loc2_ == "mworklab")
            {
               if(World.w.t_battle > 0)
               {
                  World.w.gui.infoText("noUseCombat",null,null,false);
               }
               else
               {
                  pip.workTip = _loc2_;
                  pip.onoff(7);
               }
            }
            else
            {
               World.w.invent.useItem(_loc2_);
               setStatus(false);
               World.w.gui.setHp();
            }
            pip.snd(1);
            this.over_t = 2;
         }
         else if(page2 == 5)
         {
            if(gg.invent.weapons[_loc2_])
            {
               gg.invent.weapons[_loc2_].respect = 2;
               World.w.gg.changeWeapon(_loc2_);
            }
            else if(Boolean(gg.currentWeapon) && Boolean(gg.currentWeapon.tip <= 3) && gg.currentWeapon.holder > 0)
            {
               gg.currentWeapon.initReload(_loc2_);
            }
         }
         pip.setRPanel();
         this.showBottext();
      }
      
      override internal function itemRightClick(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         if(pip.noAct)
         {
            World.w.gui.infoText("noAct");
            return;
         }
         if(page2 == 1)
         {
            _loc2_ = this.assArr[param1.currentTarget.id.text];
            _loc2_.respect = World.w.invent.respectWeapon(param1.currentTarget.id.text);
            this.setStatItem(param1.currentTarget as MovieClip,_loc2_);
            pip.setRPanel();
            this.showBottext();
            pip.snd(1);
         }
         if(page2 >= 3)
         {
            if(World.w.loc.base)
            {
               World.w.gui.infoText("noDrop1",null,null,false);
               return;
            }
            _loc2_ = this.assArr[param1.currentTarget.id.text];
            if(_loc2_.mass > 0 && _loc2_.tip != "book" && _loc2_.tip != "sphera")
            {
               if(param1.shiftKey)
               {
                  _loc2_.drop = _loc2_.kol;
               }
               else
               {
                  ++_loc2_.drop;
               }
               this.setStatItem(param1.currentTarget as MovieClip,_loc2_);
               this.buttonOk("drop");
            }
            else
            {
               World.w.gui.infoText("noDrop2",null,null,false);
            }
         }
      }
      
      public function assignKey(param1:int) : *
      {
         trace("назначение клавиши",param1,this.assId);
         pip.snd(1);
         var _loc2_:* = this.assId;
         if(page2 <= 3 && this.assId != null)
         {
            World.w.invent.favItem(this.assId,param1);
            setStatus(false);
         }
         this.assId = _loc2_;
      }
      
      internal function showH(param1:MouseEvent) : *
      {
         var _loc2_:* = undefined;
         if(this.actCurrent == "showhidden")
         {
            pip.showHidden = !pip.showHidden;
            setStatus();
            pip.snd(2);
         }
         else if(this.actCurrent == "retr")
         {
            if(inv.items["retr"].kol > 0 && World.w.game.triggers["noreturn"] != 1)
            {
               inv.minusItem("retr");
               World.w.game.gotoLand(World.w.game.baseId);
            }
            vis.butOk.visible = false;
            pip.onoff(-1);
         }
         else if(this.actCurrent == "drop")
         {
            for each(_loc2_ in arr)
            {
               if(_loc2_.drop > 0)
               {
                  inv.drop(_loc2_.id,_loc2_.drop);
               }
            }
            vis.butOk.visible = false;
            pip.onoff(-1);
         }
      }
      
      internal function buttonOk(param1:String) : *
      {
         vis.butOk.visible = true;
         vis.butOk.text.text = Res.pipText(param1);
         this.actCurrent = param1;
      }
      
      override public function step() : *
      {
         if(this.over_t > 0)
         {
            --this.over_t;
         }
         if(this.over_t == 1 && Boolean(this.overItem))
         {
            try
            {
               if(this.overItem.fav.text == "☩" || this.overItem.fav.text == "+")
               {
                  this.overItem.fav.text = "";
               }
               inv.items[this.overId].nov = 0;
            }
            catch(err:*)
            {
            }
         }
      }
   }
}

