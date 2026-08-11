package fe.inter
{
   import fe.*;
   import fe.unit.Unit;
   import flash.display.MovieClip;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class Consol
   {
      
      public var vis:MovieClip;
      
      public var ist:Array;
      
      public var istN:int = 0;
      
      internal var help:XML;
      
      public var visoff:* = false;
      
      public function Consol(param1:MovieClip, param2:String = null)
      {
         var _loc3_:* = undefined;
         this.help = <chit>
			<a>all - добавить всё</a>
			<a>all weapon - добавить всё оружие</a>
			<a>all armor - добавить всю броню</a>
			<a>all item - 1000 каждого предмета</a>
			<a>all ammo - 10000 каждого патрона</a>
			<a>min - добавить необходимый минимум</a>
			<a>god - неуязвимость вкл/выкл</a>
			<a>jump - поменять режим прыжка</a>
			<a>xp X - добавить X опыта</a>
			<a>lvl X - установить уровень перса в X</a>
			<a>sp X - добавить Х скилл-поинтов</a>
			<a>pp X - добавить Х перк-поинтов</a>
			<a>money X - установить количество крышек Х</a>
			<a>weapon ID - получить оружие ID</a>
			<a>armor ID - получить броню ID</a>
			<a>item ID X - установить количество вещей ID в Х</a>
			<a>ammo ID X - установить количество патронов ID в Х</a>
			<a>skill ID n - установить скилл ID на величину n (0-20)</a>
			<a>perk ID - получить перк ID</a>
			<a>eff ID - получить эффект ID</a>
			<a>res - сброс всех эффектов</a>
			<a>testeff - все эффекты будут в 10 раз короче</a>
			<a>testdam - отменяет разброс урона</a>
			<a>hardinv - вкл/выкл ограниченный инвентарь</a>
			<a>repair - отремонтировать оружие</a>
			<a>crack X - повредить оружие на X%</a>
			<a>break X - повредить броню на X%</a>
			<a>lim X - установить лимит особого лута в X%</a>
			<a>heal - полное исцеление</a>
			<a>mana X - установить ману</a>
			<a>die - умереть</a>
			<a>check - вернуться на контрольную точку</a>
			<a>goto X Y - переместиться в локацию с координатами X Y</a>
			<a>clear - сброс некоторых переменных</a>
			<a>map - показать всю карту</a>
			<a>black - скрыть/показать туман войны</a>
			<a>enemy - вкл/выкл ИИ</a>
			<a>fly - можно включать полёт клавишей ~</a>
			<a>port - телепорт клавишей ~</a>
			<a>emit X - вызов частицы X клавишей ~</a>
			<a>refill - пополнить товары у торговцев</a>
			<a>getroom - зачистить комнату</a>
			<a>getloc - зачистить локацию</a>
			<a>dif X - изменить сложность (0-4)</a>
			<a>st X Y - установить триггер X в значение Y</a>
			<a>trigger X - получить значение триггера X</a>
			<a>triggers - получить значение триггеров</a>
		</chit>;
         super();
         this.vis = param1;
         this.ist = new Array();
         if(param2 != null)
         {
            this.ist.push(param2);
         }
         this.vis.visible = false;
         this.vis.input.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyboardDownEvent);
         this.vis.butEnter.addEventListener(MouseEvent.CLICK,this.onButEnter);
         this.vis.butClose.addEventListener(MouseEvent.CLICK,this.onButClose);
         for each(_loc3_ in this.help.a)
         {
            this.vis.help.text += _loc3_ + "\n";
         }
         for each(_loc3_ in Res.d.weapon)
         {
            this.vis.list1.text += _loc3_.@id + " \t" + _loc3_.n[0] + "\n";
         }
         for each(_loc3_ in Res.d.item)
         {
            this.vis.list2.text += _loc3_.@id + " \t" + _loc3_.n[0] + "\n";
         }
         for each(_loc3_ in Res.d.ammo)
         {
            this.vis.list2.text += _loc3_.@id + " \t" + _loc3_.n[0] + "\n";
         }
         this.vis.help.visible = this.vis.list1.visible = this.vis.list2.visible = false;
      }
      
      public function onKeyboardDownEvent(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER)
         {
            this.analis();
         }
         if(param1.keyCode == Keyboard.END || param1.keyCode == Keyboard.ESCAPE)
         {
            World.w.consolOnOff();
         }
         if(param1.keyCode == Keyboard.UP)
         {
            if(this.istN > 0)
            {
               --this.istN;
            }
            if(this.istN < this.ist.length)
            {
               this.vis.input.text = this.ist[this.istN];
            }
         }
         if(param1.keyCode == Keyboard.DOWN)
         {
            if(this.istN < this.ist.length)
            {
               ++this.istN;
            }
            if(this.istN < this.ist.length)
            {
               this.vis.input.text = this.ist[this.istN];
            }
         }
         param1.stopPropagation();
      }
      
      public function onButEnter(param1:MouseEvent) : void
      {
         this.analis();
         param1.stopPropagation();
      }
      
      public function onButClose(param1:MouseEvent) : void
      {
         World.w.consolOnOff();
         param1.stopPropagation();
      }
      
      internal function off() : *
      {
         this.visoff = true;
      }
      
      internal function analis() : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         var _loc1_:String = this.vis.input.text;
         this.ist.push(_loc1_);
         World.w.lastCom = _loc1_;
         World.w.saveConfig();
         this.istN = this.ist.length;
         this.vis.input.text = "";
         var _loc2_:Array = _loc1_.split(" ");
         if(_loc2_[0] == "clear")
         {
            try
            {
               World.w.cam.dblack = 0;
               World.w.gg.controlOn();
               World.w.gg.vis.visible = true;
               World.w.vblack.alpha = 0;
               World.w.vblack.visible = false;
               World.w.t_exit = World.w.t_die = 0;
               World.w.vgui.visible = World.w.vfon.visible = World.w.visual.visible = true;
               Snd.off = false;
               World.w.pip.noAct = false;
            }
            catch(err:*)
            {
            }
         }
         if(_loc2_[0] == "redraw")
         {
            World.w.redrawLoc();
         }
         if(_loc2_[0] == "hud")
         {
            World.w.gui.vis.visible = !World.w.gui.vis.visible;
         }
         if(_loc2_[0] == "die")
         {
            World.w.gg.damage(10000,Unit.D_INSIDE);
         }
         if(_loc2_[0] == "hardreset" && World.w.pers.dead)
         {
            World.w.pers.dead = false;
            World.w.t_die = 210;
            World.w.gg.anim("die",true);
            this.off();
         }
         if(_loc2_[0] == "hardinv")
         {
            World.w.hardInv = !World.w.hardInv;
         }
         if(_loc2_[0] == "res_watcher")
         {
            World.w.game.triggers["observer"] = 1;
         }
         if(_loc2_[0] == "mqt")
         {
            World.w.chitOn = !World.w.chitOn;
            World.w.saveConfig();
            return;
         }
         if(!World.w.chitOn)
         {
            this.off();
            return;
         }
         if(_loc1_ == "?")
         {
            this.vis.help.visible = this.vis.list1.visible = this.vis.list2.visible = !this.vis.help.visible;
            return;
         }
         if(_loc2_[0] == "hardcore")
         {
            World.w.pers.hardcore = !World.w.pers.hardcore;
         }
         if(_loc2_[0] == "testmode")
         {
            World.w.testMode = !World.w.testMode;
         }
         if(_loc2_[0] == "dif")
         {
            World.w.game.globalDif = _loc2_[1];
            if(World.w.game.globalDif < 0)
            {
               World.w.game.globalDif = 0;
            }
            if(World.w.game.globalDif > 4)
            {
               World.w.game.globalDif = 4;
            }
            World.w.pers.setGlobalDif(World.w.game.globalDif);
            World.w.pers.setParameters();
         }
         if(_loc2_[0] == "all")
         {
            if(_loc2_.length == 1)
            {
               World.w.invent.addAll();
               World.w.pers.addSkillPoint(10);
            }
            else if(_loc2_[1] == "weapon")
            {
               World.w.invent.addAllWeapon();
            }
            else if(_loc2_[1] == "ammo")
            {
               World.w.invent.addAllAmmo();
            }
            else if(_loc2_[1] == "item")
            {
               World.w.invent.addAllItem();
            }
            else if(_loc2_[1] == "armor")
            {
               World.w.invent.addAllArmor();
            }
            this.off();
         }
         if(_loc2_[0] == "min")
         {
            World.w.invent.addMin();
            this.off();
         }
         if(_loc2_[0] == "god")
         {
            World.w.godMode = !World.w.godMode;
         }
         if(_loc2_[0] == "lvl" || _loc2_[0] == "level")
         {
            World.w.pers.setForcLevel(_loc2_[1]);
         }
         if(_loc2_[0] == "xp")
         {
            World.w.pers.expa(_loc2_[1]);
         }
         if(_loc2_[0] == "sp")
         {
            if(_loc2_.length == 1)
            {
               World.w.pers.addSkillPoint();
            }
            else
            {
               World.w.pers.addSkillPoint(int(_loc2_[1]));
            }
         }
         if(_loc2_[0] == "pp")
         {
            if(_loc2_.length == 1)
            {
               ++World.w.pers.perkPoint;
            }
            else
            {
               World.w.pers.perkPoint += int(_loc2_[1]);
            }
         }
         if(_loc2_[0] == "weapon")
         {
            if(_loc2_.length == 2)
            {
               World.w.invent.addWeapon(_loc2_[1]);
            }
            else if(_loc2_.length > 2)
            {
               World.w.invent.updWeapon(_loc2_[1],1);
            }
         }
         if(_loc2_[0] == "remw")
         {
            if(_loc2_.length == 2)
            {
               World.w.invent.remWeapon(_loc2_[1]);
            }
         }
         if(_loc2_[0] == "armor")
         {
            if(_loc2_.length == 2)
            {
               World.w.invent.addArmor(_loc2_[1]);
            }
         }
         if(_loc2_[0] == "money")
         {
            if(_loc2_.length == 2)
            {
               World.w.invent.items["money"].kol = int(_loc2_[1]);
            }
         }
         if(_loc2_[0] == "item")
         {
            if(World.w.invent.items[_loc2_[1]] == null)
            {
               return;
            }
            if(_loc2_.length == 3)
            {
               World.w.invent.items[_loc2_[1]].kol = int(_loc2_[2]);
            }
            else if(_loc2_.length == 2)
            {
               ++World.w.invent.items[_loc2_[1]].kol;
            }
            World.w.game.checkQuests(_loc2_[1]);
            World.w.pers.setParameters();
         }
         if(_loc2_[0] == "ammo")
         {
            if(_loc2_.length == 3)
            {
               World.w.invent.items[_loc2_[1]].kol = int(_loc2_[2]);
            }
         }
         if(_loc2_[0] == "perk")
         {
            if(_loc2_.length == 2)
            {
               World.w.pers.addPerk(_loc2_[1]);
            }
         }
         if(_loc2_[0] == "skill")
         {
            if(_loc2_.length == 3)
            {
               World.w.pers.setSkill(_loc2_[1],_loc2_[2]);
            }
         }
         if(_loc2_[0] == "eff")
         {
            if(_loc2_.length == 2)
            {
               World.w.gg.addEffect(_loc2_[1]);
            }
         }
         if(_loc2_[0] == "res")
         {
            if(World.w.gg.effects.length > 0)
            {
               for each(_loc3_ in World.w.gg.effects)
               {
                  _loc3_.unsetEff();
               }
            }
         }
         if(_loc2_[0] == "repair")
         {
            World.w.gg.currentWeapon.repair(1000000);
         }
         if(_loc2_[0] == "refill")
         {
            World.w.game.refillVendors();
         }
         if(_loc2_[0] == "rep")
         {
            if(_loc2_.length == 2)
            {
               World.w.pers.rep = int(_loc2_[1]);
            }
         }
         if(_loc2_[0] == "crack")
         {
            if(_loc2_.length == 2 && Boolean(World.w.gg.currentWeapon))
            {
               World.w.gg.currentWeapon.hp = Math.round(World.w.gg.currentWeapon.maxhp * Number(_loc2_[1]) / 100);
            }
         }
         if(_loc2_[0] == "break")
         {
            if(_loc2_.length == 2 && Boolean(World.w.gg.currentArmor))
            {
               World.w.gg.currentArmor.hp = Math.round(World.w.gg.currentArmor.maxhp * Number(_loc2_[1]) / 100);
            }
         }
         if(_loc2_[0] == "heal")
         {
            World.w.gg.heal(10000);
         }
         if(_loc2_[0] == "rad")
         {
            World.w.gg.rad = _loc2_[1];
            World.w.gui.setAll();
         }
         if(_loc2_[0] == "mana")
         {
            World.w.pers.manaHP = int(_loc2_[1]);
            World.w.pers.setParameters();
         }
         if(_loc2_[0] == "check")
         {
            World.w.land.gotoCheckPoint();
         }
         if(_loc2_[0] == "goto")
         {
            if(_loc2_.length == 3)
            {
               World.w.land.gotoXY(_loc2_[1],_loc2_[2]);
            }
         }
         if(_loc2_[0] == "map")
         {
            World.w.drawAllMap = !World.w.drawAllMap;
         }
         if(_loc2_[0] == "black")
         {
            World.w.black = !World.w.black;
            World.w.grafon.visLight.visible = World.w.black && World.w.loc.black;
         }
         if(_loc2_[0] == "battle")
         {
            World.w.testBattle = !World.w.testBattle;
         }
         if(_loc2_[0] == "testeff")
         {
            World.w.testEff = !World.w.testEff;
         }
         if(_loc2_[0] == "testdam")
         {
            World.w.testDam = !World.w.testDam;
         }
         if(_loc2_[0] == "enemy")
         {
            if(World.w.enemyAct == 3)
            {
               World.w.enemyAct = 0;
            }
            else
            {
               World.w.enemyAct = 3;
            }
         }
         if(_loc2_[0] == "lim")
         {
            if(_loc2_.length == 2)
            {
               World.w.land.lootLimit = Number(_loc2_[1]);
            }
         }
         if(_loc2_[0] == "fly" || _loc2_[0] == "port" || _loc2_[0] == "emit")
         {
            World.w.chit = _loc2_[0];
            World.w.chitX = _loc2_[1];
         }
         if(_loc2_[0] == "getroom")
         {
            World.w.testLoot = true;
            trace("получено опыта",World.w.loc.getAll());
            World.w.testLoot = false;
         }
         if(_loc2_[0] == "err")
         {
            World.w.landError = !World.w.landError;
         }
         if(_loc2_[0] == "getloc")
         {
            World.w.testLoot = true;
            trace("получено опыта",World.w.land.getAll());
            World.w.testLoot = false;
         }
         if(_loc2_[0] == "alicorn")
         {
            if(World.w.alicorn)
            {
               World.w.gg.alicornOff();
            }
            else
            {
               World.w.gg.alicornOn();
            }
         }
         if(_loc2_[0] == "st")
         {
            if(_loc2_.length == 3)
            {
               World.w.game.triggers[_loc2_[1]] = _loc2_[2];
            }
         }
         if(_loc2_[0] == "trigger")
         {
            if(_loc2_.length == 2)
            {
               World.w.gui.infoText("trigger",_loc2_[1],World.w.game.triggers[_loc2_[1]]);
            }
         }
         if(_loc2_[0] == "triggers")
         {
            if(_loc2_.length > 1)
            {
               World.w.gui.infoText("trigger",_loc2_[1],World.w.game.triggers[_loc2_[1]]);
            }
            else
            {
               for(_loc4_ in World.w.game.triggers)
               {
                  World.w.gui.infoText("trigger",_loc4_,World.w.game.triggers[_loc4_]);
               }
            }
         }
         World.w.gui.setAll();
      }
   }
}

