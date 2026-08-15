package fe.inter
{
   import fe.*;
   import fe.serv.Item;
   import fe.unit.Armor;
   import fe.unit.UnitPet;
   import fe.weapon.Weapon;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PipPageWork extends PipPage
   {
      
      internal var assId:String = null;
      
      internal var assArr:Array;
      
      internal var owlRep:int = 100;
      
      public function PipPageWork(param1:PipBuck, param2:String)
      {
         isLC = true;
         itemClass = visPipInvItem;
         super(param1,param2);
         vis.but4.visible = vis.but5.visible = false;
      }
      
      override internal function setSubPages() : *
      {
         var n:* = undefined;
         var s:String = null;
         var node:* = undefined;
         var ok:int = 0;
         var wid:String = null;
         var node1:* = undefined;
         var weap:Weapon = null;
         var arm:Armor = null;
         var w:Weapon = null;
         var a:Armor = null;
         if(pip.workTip == "mworklab")
         {
            pip.workTip = "lab";
         }
         if(pip.workTip == "mworkexpl")
         {
            pip.workTip = "expl";
         }
         vis.but1.visible = vis.but2.visible = vis.but3.visible = true;
         if(pip.workTip == "mworkbench")
         {
            vis.but1.visible = vis.but2.visible = false;
            page2 = 3;
         }
         else if(pip.workTip == "stove" || pip.workTip == "lab" || pip.workTip == "expl")
         {
            vis.but2.visible = vis.but3.visible = false;
            page2 = 1;
         }
         vis.bottext.text = Res.pipText("caps") + ": " + pip.money;
         vis.butOk.visible = false;
         statHead.cat.visible = false;
         setIco();
         this.assId = null;
         statHead.rid.visible = false;
         statHead.mass.text = "";
         vis.bottext.text = "";
         if(page2 == 1)
         {
            this.assArr = new Array();
            statHead.fav.text = "";
            statHead.nazv.text = Res.pipText("work1");
            statHead.hp.text = Res.pipText("iv6");
            statHead.ammo.text = "";
            statHead.ammotip.text = "";
            for(s in inv.items)
            {
               if(!(s == "" || inv.items[s] == null || inv.items[s].kol <= 0))
               {
                  node = inv.items[s].xml;
                  if(node != null)
                  {
                     if(node.@tip == "scheme" && (node.@work.length() == 0 || node.@work == pip.workTip || node.@work == "expl" && pip.workTip == "work"))
                     {
                        ok = 1;
                        if(Boolean(node.@skill.length()) && Boolean(node.@lvl.length()) && gg.pers.getSkillLevel(node.@skill) < node.@lvl)
                        {
                           ok = 2;
                        }
                        wid = s.substr(2);
                        if(inv.weapons[wid])
                        {
                           if(inv.weapons[wid].respect == 3 || inv.weapons[wid].tip == 4)
                           {
                              n = {
                                 "tip":Item.L_WEAPON,
                                 "id":wid,
                                 "nazv":Res.txt("w",wid),
                                 "ok":ok,
                                 "sort":node.@skill + node.@lvl
                              };
                              if(Boolean(inv.items[wid]) && inv.items[wid].kol > 0)
                              {
                                 n.kol = inv.items[wid].kol;
                              }
                              arr.push(n);
                              this.assArr[n.id] = n;
                           }
                        }
                        else if(inv.armors[wid])
                        {
                           if(inv.armors[wid].lvl < 0)
                           {
                              n = {
                                 "tip":Item.L_ARMOR,
                                 "id":wid,
                                 "nazv":Res.txt("a",wid),
                                 "ok":ok,
                                 "sort":node.@skill + node.@lvl
                              };
                              arr.push(n);
                           }
                        }
                        else
                        {
                           node1 = AllData.d.item.(@id == wid);
                           if(node1.length() != 0)
                           {
                              if(!((node1.@tip == Item.L_IMPL || node1.@one > 0) && inv.items[wid].kol > 0))
                              {
                                 n = {
                                    "tip":(node1.@tip == Item.L_IMPL ? Item.L_IMPL : Item.L_ITEM),
                                    "kol":inv.items[wid].kol,
                                    "id":wid,
                                    "nazv":Res.txt("i",wid),
                                    "ok":ok,
                                    "sort":node.@skill + node.@lvl
                                 };
                                 arr.push(n);
                                 this.assArr[n.id] = n;
                              }
                           }
                        }
                     }
                  }
               }
            }
            if(arr.length)
            {
               arr.sortOn(["ok","sort"]);
               vis.emptytext.text = "";
               statHead.visible = true;
            }
            else
            {
               vis.emptytext.text = Res.pipText("emptycreate");
               statHead.visible = false;
            }
         }
         else if(page2 == 2)
         {
            statHead.fav.text = "";
            statHead.nazv.text = "";
            statHead.hp.text = "";
            statHead.ammo.text = "";
            statHead.ammotip.text = "";
            if(gg.pers.maxArmorLvl > 0)
            {
               for each(arm in inv.armors)
               {
                  if(arm.lvl >= 0 && arm.lvl < arm.maxlvl && arm.lvl < gg.pers.maxArmorLvl)
                  {
                     n = {
                        "tip":Item.L_ARMOR,
                        "id":arm.id,
                        "nazv":arm.nazv,
                        "lvl":arm.lvl,
                        "sort":"a" + arm.sort
                     };
                     arr.push(n);
                  }
               }
            }
            for each(weap in inv.weapons)
            {
               if(weap != null)
               {
                  if(weap.skill == 3 && weap.variant == 0 && weap.respect != 3)
                  {
                     n = {
                        "tip":Item.L_WEAPON,
                        "id":weap.id,
                        "nazv":weap.nazv,
                        "sort":"w" + weap.nazv
                     };
                     arr.push(n);
                  }
               }
            }
            if(arr.length)
            {
               arr.sortOn("sort");
               vis.emptytext.text = "";
               statHead.visible = true;
            }
            else
            {
               vis.emptytext.text = Res.pipText("emptyupgrade");
               statHead.visible = false;
            }
         }
         else if(page2 == 3)
         {
            this.assArr = new Array();
            statHead.fav.text = "";
            statHead.nazv.text = Res.pipText("ii2");
            statHead.hp.text = Res.pipText("ii3");
            statHead.ammo.text = "";
            statHead.ammotip.text = Res.pipText("repairto");
            setTopText("inforepair");
            if(Boolean(inv.items["owl"]) && Boolean(inv.items["owl"].kol))
            {
               World.w.pers.setRoboowl();
               if(World.w.pers.owlhpProc < 1)
               {
                  n = {
                     "tip":Item.L_INSTR,
                     "id":"owl",
                     "nazv":inv.items["owl"].nazv,
                     "hp":World.w.pers.owlhp * World.w.pers.owlhpProc,
                     "maxhp":World.w.pers.owlhp,
                     "rep":this.owlRep / World.w.pers.owlhp
                  };
                  arr.push(n);
                  this.assArr[n.id] = n;
               }
            }
            for each(w in inv.weapons)
            {
               if(w != null)
               {
                  if(w.tip != 0 && w.tip != 4 && w.respect != 1 && w.hp < w.maxhp)
                  {
                     n = {
                        "tip":Item.L_WEAPON,
                        "id":w.id,
                        "nazv":w.nazv,
                        "hp":w.hp,
                        "maxhp":w.maxhp,
                        "rep":w.rep_eff * 0.25
                     };
                     arr.push(n);
                     this.assArr[n.id] = n;
                  }
               }
            }
            for each(a in inv.armors)
            {
               if(!a.norep && !a.und && a.hp < a.maxhp)
               {
                  n = {
                     "tip":Item.L_ARMOR,
                     "id":a.id,
                     "nazv":a.nazv,
                     "hp":a.hp,
                     "maxhp":a.maxhp,
                     "rep":1 / a.kolComp
                  };
                  arr.push(n);
                  this.assArr[n.id] = n;
               }
            }
            if(arr.length)
            {
               vis.emptytext.text = "";
               statHead.visible = true;
            }
            else
            {
               vis.emptytext.text = Res.pipText("emptyrep");
               statHead.visible = false;
            }
         }
      }
      
      override internal function setStatItem(param1:MovieClip, param2:Object) : *
      {
         param1.rid.visible = false;
         param1.id.text = param2.id;
         param1.cat.text = param2.tip;
         param1.nazv.text = param2.nazv;
         param1.id.visible = param1.cat.visible = false;
         param1.ramka.visible = false;
         param1.mass.text = "";
         param1.fav.text = "";
         param1.hp.text = param1.ammotip.text = "";
         param1.alpha = 1;
         if(page2 == 1)
         {
            if(param2.ok > 1)
            {
               param1.alpha = 0.5;
            }
            if(param2.kol > 0)
            {
               param1.hp.text = param2.kol;
            }
         }
         else if(page2 != 2)
         {
            if(page2 == 3)
            {
               param1.hp.text = Math.round(param2.hp / param2.maxhp * 1000) / 10 + "%";
               param1.ammotip.text = Math.round(param2.rep * gg.pers.repairMult * 1000) / 10 + "%";
            }
         }
         param1.ammo.text = "";
      }
      
      override internal function statInfo(param1:MouseEvent) : *
      {
         this.assId = null;
         if(page2 == 1)
         {
            infoItem(param1.currentTarget.cat.text,param1.currentTarget.id.text,param1.currentTarget.nazv.text,1);
         }
         if(page2 == 2)
         {
            if(param1.currentTarget.cat.text == Item.L_ARMOR)
            {
               infoItem(param1.currentTarget.cat.text,param1.currentTarget.id.text,param1.currentTarget.nazv.text,2);
            }
            else
            {
               infoItem(param1.currentTarget.cat.text,param1.currentTarget.id.text + "^1",param1.currentTarget.nazv.text + " - II",2);
            }
         }
         if(page2 == 3)
         {
            infoItem(param1.currentTarget.cat.text,param1.currentTarget.id.text,param1.currentTarget.nazv.text);
            if(param1.currentTarget.cat.text == Item.L_ARMOR)
            {
               this.showBottext(inv.armors[param1.currentTarget.id.text].idComp);
            }
            if(param1.currentTarget.cat.text == Item.L_WEAPON)
            {
               this.showBottext("frag");
            }
            if(param1.currentTarget.cat.text == Item.L_INSTR)
            {
               this.showBottext("scrap");
            }
         }
      }
      
      internal function showBottext(param1:*) : *
      {
         if(inv.items[param1])
         {
            vis.bottext.htmlText = Res.txt("i",param1) + ": " + yel(inv.items[param1].kol);
            if(World.w.loc.base && inv.items[param1].vault > 0)
            {
               vis.bottext.htmlText += " (+" + yel(inv.items[param1].vault) + " " + Res.pipText("invault") + ")";
            }
         }
         else
         {
            vis.bottext.htmlText = "";
         }
      }
      
      internal function checkScheme(param1:XML) : Boolean
      {
         var _loc2_:* = undefined;
         if(Boolean(param1.@skill.length()) && Boolean(param1.@lvl.length()) && gg.pers.getSkillLevel(param1.@skill) < param1.@lvl)
         {
            World.w.gui.infoText("needSkill",Res.txt("e",param1.@skill),param1.@lvl);
            return false;
         }
         for each(_loc2_ in param1.craft)
         {
            if(inv.items[_loc2_.@id] == null || inv.items[_loc2_.@id].kol + inv.items[_loc2_.@id].vault < _loc2_.@kol)
            {
               World.w.gui.infoText("noMaterials");
               return false;
            }
         }
         return true;
      }
      
      internal function minusCraftComp(param1:*) : *
      {
         var _loc2_:* = undefined;
         for each(_loc2_ in param1.craft)
         {
            inv.minusItem(_loc2_.@id,_loc2_.@kol,false);
         }
      }
      
      override internal function itemClick(param1:MouseEvent) : *
      {
         var cid:String;
         var ccat:String;
         var cnazv:String;
         var w:Weapon = null;
         var arm:Armor = null;
         var sch:* = undefined;
         var kol:int = 0;
         var obj:* = undefined;
         var lmess:String = null;
         var cid2:String = null;
         var owl:UnitPet = null;
         var event:MouseEvent = param1;
         if(pip.noAct)
         {
            World.w.gui.infoText("noAct");
            return;
         }
         cid = event.currentTarget.id.text;
         ccat = event.currentTarget.cat.text;
         cnazv = event.currentTarget.nazv.text;
         if(page2 == 1)
         {
            sch = AllData.d.item.(@id == "s_" + cid);
            if(sch.length())
            {
               sch = sch[0];
            }
            kol = 1;
            if(sch.@kol.length())
            {
               kol = int(sch.@kol);
            }
            if(sch.@perk == "potmaster" && Boolean(gg.pers.potmaster))
            {
               kol *= 2;
            }
            if(!this.checkScheme(sch))
            {
               return;
            }
            if(ccat == Item.L_WEAPON)
            {
               w = inv.weapons[cid];
               obj = this.assArr[cid];
               if(w.tip != 4 && w.respect != 3)
               {
                  return;
               }
               this.minusCraftComp(sch);
               if(w.tip != 4)
               {
                  w.respect = 0;
                  w.hold = w.holder;
                  World.w.gui.infoText("created",cnazv);
                  setStatus();
               }
               else
               {
                  inv.plusItem(w.id,kol);
                  obj.kol = inv.items[w.id].kol;
                  World.w.gui.infoText("created2",cnazv,inv.items[cid].kol);
                  infoItem(ccat,cid,cnazv,1);
                  this.setStatItem(event.currentTarget as MovieClip,obj);
               }
               inv.calcWeaponMass();
            }
            else if(ccat == Item.L_ARMOR)
            {
               arm = inv.armors[cid];
               if(arm.lvl >= 0)
               {
                  return;
               }
               this.minusCraftComp(sch);
               arm.lvl = 0;
               World.w.gui.infoText("created3",cnazv);
               setStatus();
            }
            else if(ccat == Item.L_IMPL)
            {
               this.minusCraftComp(sch);
               inv.plusItem(cid,1);
               inv.takeScript(cid);
               World.w.gui.infoText("created4",cnazv);
               gg.pers.setParameters();
               setStatus();
            }
            else if(ccat == Item.L_ITEM)
            {
               obj = this.assArr[cid];
               this.minusCraftComp(sch);
               inv.plusItem(cid,kol);
               obj.kol = inv.items[cid].kol;
               World.w.gui.infoText("created2",cnazv,inv.items[cid].kol);
               infoItem(ccat,cid,cnazv,1);
               if(Boolean(inv.items[cid].xml) && inv.items[cid].xml.@one == "1")
               {
                  setStatus();
               }
               this.setStatItem(event.currentTarget as MovieClip,obj);
            }
            World.w.game.checkQuests(cid);
            if(World.w.helpMess && Boolean(inv.items[cid]))
            {
               lmess = inv.items[cid].mess;
               if(lmess != null && World.w.game.triggers["mess_" + lmess] <= 0)
               {
                  World.w.game.triggers["mess_" + lmess] = 1;
                  World.w.gui.impMess(Res.txt("i",lmess),Res.txt("i",lmess,2),lmess);
                  pip.onoff(-1);
               }
            }
         }
         else if(page2 == 2)
         {
            if(ccat == Item.L_ARMOR)
            {
               arm = inv.armors[cid];
               if(arm == null)
               {
                  return;
               }
               kol = arm.needComp();
               if(inv.checkKol(arm.idComp,kol))
               {
                  inv.minusItem(arm.idComp,kol,false);
                  arm.upgrade();
                  gg.pers.setParameters();
                  World.w.gui.infoText("upArmor");
                  setStatus();
               }
               else
               {
                  World.w.gui.infoText("noMaterials");
               }
            }
            else if(ccat == Item.L_WEAPON)
            {
               sch = AllData.d.item.(@id == "s_" + cid);
               if(sch.length())
               {
                  sch = sch[0];
               }
               if(!this.checkScheme(sch))
               {
                  return;
               }
               this.minusCraftComp(sch);
               inv.updWeapon(cid,1);
               World.w.gui.infoText("created",cnazv + Weapon.variant2);
               setStatus();
            }
         }
         else if(page2 == 3)
         {
            obj = this.assArr[cid];
            if(ccat == Item.L_ARMOR)
            {
               arm = inv.armors[cid];
               if(arm.hp >= arm.maxhp)
               {
                  World.w.gui.infoText("noRepair");
                  return;
               }
               cid2 = inv.armors[cid].idComp;
               if(inv.checkKol(cid2))
               {
                  arm.repair(arm.maxhp * gg.pers.repairMult / arm.kolComp);
                  inv.minusItem(cid2);
                  obj.hp = arm.hp;
                  this.showBottext(cid2);
               }
               else
               {
                  World.w.gui.infoText("noMaterials");
               }
            }
            else if(ccat == Item.L_WEAPON)
            {
               if(inv.checkKol("frag"))
               {
                  w = inv.weapons[cid];
                  if(inv.repWeapon(w,0.25))
                  {
                     inv.minusItem("frag");
                     obj.hp = w.hp;
                     this.showBottext("frag");
                  }
               }
               else
               {
                  World.w.gui.infoText("noMaterials");
               }
            }
            else if(ccat == Item.L_INSTR)
            {
               if(inv.checkKol("scrap"))
               {
                  owl = gg.pets[cid];
                  if(owl.repair(this.owlRep * gg.pers.repairMult))
                  {
                     inv.minusItem("scrap");
                     obj.hp = owl.hp;
                     this.showBottext("scrap");
                  }
               }
               else
               {
                  World.w.gui.infoText("noMaterials");
               }
            }
            this.setStatItem(event.currentTarget as MovieClip,obj);
         }
         pip.snd(1);
         inv.calcMass();
         pip.setRPanel();
      }
   }
}

