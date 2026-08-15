package fe.inter
{
   import fe.*;
   import fe.loc.LandAct;
   import fe.loc.Quest;
   import fe.serv.Item;
   import fe.unit.Armor;
   import fe.unit.Invent;
   import fe.unit.Unit;
   import fe.unit.UnitPet;
   import fe.unit.UnitPlayer;
   import fe.weapon.Weapon;
   import fl.controls.ScrollBar;
   import fl.events.ScrollEvent;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   
   public class PipPage
   {
      
      internal var vis:MovieClip;
      
      internal var arr:Array;
      
      internal var statArr:Array;
      
      internal var statHead:MovieClip;
      
      internal var pageClass:Class;
      
      internal var itemClass:Class;
      
      internal var maxrows:int = 18;
      
      internal var selItem:MovieClip;
      
      internal var pip:PipBuck;
      
      internal var inv:Invent;
      
      internal var gg:UnitPlayer;
      
      internal var isLC:Boolean = false;
      
      internal var isRC:Boolean = false;
      
      internal var signs:Array;
      
      internal var page2:int = 1;
      
      internal var scrl:int = 0;
      
      internal var infIco:MovieClip;
      
      internal var itemFilter:GlowFilter;
      
      internal var itemTrans:ColorTransform;
      
      internal var pp:String;
      
      internal var kolCats:int = 6;
      
      internal var cat:Array;
      
      internal var curTip:* = "";
      
      internal var tips:Array;
      
      public function PipPage(param1:PipBuck, param2:String)
      {
         var _loc3_:MovieClip = null;
         this.signs = [0,0,0,0,0,0];
         this.itemFilter = new GlowFilter(65416,1,3,3,3,1);
         this.itemTrans = new ColorTransform(1,1,1);
         this.cat = [0,0,0,0,0,0,0];
         this.tips = [[]];
         super();
         this.pip = param1;
         this.pp = param2;
         if(this.pageClass == null)
         {
            this.pageClass = visPipInv;
         }
         this.vis = new this.pageClass();
         this.vis.x = 165;
         this.vis.y = 72;
         this.vis.visible = false;
         if(this.vis.pers)
         {
            this.vis.pers.visible = false;
         }
         if(this.vis.skill)
         {
            this.vis.skill.visible = false;
         }
         if(this.vis.item)
         {
            this.vis.item.visible = false;
         }
         this.pip.vis.addChild(this.vis);
         this.vis.scBar.addEventListener(ScrollEvent.SCROLL,this.statScroll);
         this.vis.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel1);
         this.statArr = new Array();
         var _loc4_:* = -1;
         while(_loc4_ < this.maxrows)
         {
            _loc3_ = new this.itemClass();
            _loc3_.x = 30;
            _loc3_.y = 100 + _loc4_ * 30;
            if(_loc3_.nazv)
            {
               setStyle(_loc3_.nazv);
            }
            this.vis.addChild(_loc3_);
            if(_loc3_.ramka)
            {
               _loc3_.ramka.visible = false;
            }
            if(_loc4_ < 0)
            {
               _loc3_.back.visible = false;
               this.statHead = _loc3_;
            }
            else
            {
               if(this.isLC)
               {
                  _loc3_.addEventListener(MouseEvent.CLICK,this.itemClick);
               }
               if(this.isRC)
               {
                  _loc3_.addEventListener(MouseEvent.RIGHT_CLICK,this.itemRightClick);
               }
               _loc3_.addEventListener(MouseEvent.MOUSE_OVER,this.statInfo);
               this.statArr.push(_loc3_);
            }
            _loc4_++;
         }
         _loc4_ = 1;
         while(_loc4_ <= 5)
         {
            _loc3_ = this.vis.getChildByName("but" + _loc4_) as MovieClip;
            _loc3_.addEventListener(MouseEvent.CLICK,this.page2Click);
            _loc3_.text.text = Res.pipText(this.pp + _loc4_);
            _loc3_.id.text = _loc4_;
            _loc3_.id.visible = false;
            _loc4_++;
         }
         this.vis.butOk.visible = false;
         this.vis.butDef.visible = false;
         if(this.vis.cats)
         {
            this.vis.cats.visible = false;
         }
         setStyle(this.vis.info);
         setStyle(this.vis.bottext);
      }
      
      public static function setStyle(param1:TextField) : *
      {
         var _loc2_:StyleSheet = new StyleSheet();
         var _loc3_:Object = new Object();
         _loc3_.color = "#00FF99";
         _loc2_.setStyle(".r0",_loc3_);
         _loc3_.color = "#FF3333";
         _loc2_.setStyle(".red",_loc3_);
         _loc3_.color = "#FFFF33";
         _loc2_.setStyle(".yel",_loc3_);
         _loc3_.color = "#FF9900";
         _loc2_.setStyle(".or",_loc3_);
         _loc3_.color = "#FC7FED";
         _loc2_.setStyle(".pink",_loc3_);
         _loc3_.color = "#00FFFF";
         _loc2_.setStyle(".blu",_loc3_);
         _loc3_.color = "#99CCFF";
         _loc2_.setStyle(".mass",_loc3_);
         _loc3_.color = "#007E4B";
         _loc2_.setStyle(".dark",_loc3_);
         _loc3_.color = "#8AFFD0";
         _loc2_.setStyle(".light",_loc3_);
         _loc3_.color = "#33FF33";
         _loc2_.setStyle(".green",_loc3_);
         _loc3_.color = "#B466FF";
         _loc2_.setStyle(".purp",_loc3_);
         param1.styleSheet = _loc2_;
      }
      
      public static function yel(param1:*) : String
      {
         return "<span class = \'yel\'>" + param1 + "</span>";
      }
      
      public static function red(param1:*) : String
      {
         return "<span class = \'red\'>" + param1 + "</span>";
      }
      
      public static function pink(param1:*) : String
      {
         return "<span class = \'pink\'>" + param1 + "</span>";
      }
      
      public static function mass(param1:*) : String
      {
         return "<span class = \'mass\'>" + param1 + "</span>";
      }
      
      public static function blue(param1:*) : String
      {
         return "<span class = \'blu\'>" + param1 + "</span>";
      }
      
      public static function addVar(param1:String, param2:*) : String
      {
         var _loc3_:* = 1;
         while(_loc3_ <= 5)
         {
            if(param2.attribute("s" + _loc3_).length())
            {
               param1 = param1.replace("#" + _loc3_,"<span class=\'yel\'>" + param2.attribute("s" + _loc3_) + "</span>");
            }
            _loc3_++;
         }
         return param1;
      }
      
      public static function effStr(param1:String, param2:String, param3:int = 0) : String
      {
         var dp:*;
         var lvl:*;
         var pers:*;
         var s:String = null;
         var ad:* = undefined;
         var eff:* = undefined;
         var sk:* = undefined;
         var add:* = undefined;
         var req:* = undefined;
         var reqlevel:int = 0;
         var s1:String = null;
         var ok:Boolean = false;
         var tip:String = param1;
         var id:String = param2;
         var dlvl:int = param3;
         if(tip == "item")
         {
            s = Res.txt("i",id,1);
         }
         else
         {
            s = Res.txt("e",id,1);
         }
         if(id.substr(-3) == "_ad")
         {
            id = id.substr(0,id.length - 3);
         }
         dp = AllData.d[tip];
         if(dp.length() == 0)
         {
            return s;
         }
         dp = dp.(@id == id);
         if(dp.length() == 0)
         {
            return s;
         }
         dp = dp[0];
         lvl = 1;
         pers = World.w.pers;
         if(tip == "perk")
         {
            lvl = pers.perks[id];
            if(lvl == null)
            {
               lvl = 0;
            }
         }
         else if(tip == "skill")
         {
            lvl = pers.getSkLevel(pers.skills[id]);
         }
         else if(dp.@him == "2")
         {
            ad = pers.addictions[id];
            if(ad >= pers.ad2)
            {
               lvl = 2;
            }
            if(ad >= pers.ad3)
            {
               lvl = 3;
            }
         }
         else if(dp.@him == "1")
         {
            lvl = pers.himLevel;
         }
         lvl += dlvl;
         if(lvl > 1 && Boolean(dp.textvar[lvl - 1]))
         {
            s = addVar(s,dp.textvar[lvl - 1]);
         }
         else if(dp.textvar.length())
         {
            s = addVar(s,dp.textvar[0]);
         }
         if(Boolean(dp.eff.length()) && lvl > 0)
         {
            s += "<br>";
            for each(eff in dp.eff)
            {
               s += "<br>" + (eff.@id.length() ? Res.pipText(eff.@id) : Res.pipText("refeff")) + ": " + yel(eff.attribute("n" + lvl));
            }
         }
         if(World.w.hardInv && Boolean(dp.sk.length()))
         {
            s += "<br>";
            for each(sk in dp.sk)
            {
               if(sk.@tip == "m")
               {
                  add = mass("+1");
                  if(sk.@vd > 0)
                  {
                     add = mass("+" + sk.@vd) + " " + Res.pipText("perlevel");
                  }
                  if(sk.@v1 > 0)
                  {
                     add = mass("+" + sk.@v1);
                  }
                  s += "<br>" + Res.pipText("add_" + sk.@id) + " " + add;
               }
            }
         }
         if(dp.req.length())
         {
            s += "<br><br>" + Res.pipText("requir");
            lvl--;
            for each(req in dp.req)
            {
               reqlevel = 1;
               if(req.@lvl.length())
               {
                  reqlevel = int(req.@lvl);
               }
               if(lvl > 0 && Boolean(req.@dlvl.length()))
               {
                  reqlevel += lvl * req.@dlvl;
               }
               s1 = "<br>";
               ok = true;
               if(req.@id == "level")
               {
                  s1 += Res.pipText("level");
                  if(pers.level < reqlevel)
                  {
                     ok = false;
                  }
               }
               else if(req.@id == "guns")
               {
                  s1 += Res.txt("e","smallguns") + " " + Res.pipText("or") + " " + Res.txt("e","energy");
                  if(pers.getSkLevel(pers.skills["smallguns"]) < reqlevel && pers.getSkLevel(pers.skills["energy"]) < reqlevel)
                  {
                     ok = false;
                  }
               }
               else
               {
                  s1 += Res.txt("e",req.@id);
                  if(pers.getSkLevel(pers.skills[req.@id]) < reqlevel)
                  {
                     ok = false;
                  }
               }
               s1 += ": " + reqlevel;
               if(ok)
               {
                  s += yel(s1);
               }
               else
               {
                  s += red(s1);
               }
            }
         }
         return s;
      }
      
      public static function infoStr(param1:String, param2:String) : String
      {
         var w:Weapon = null;
         var skillConf:* = undefined;
         var razn:* = undefined;
         var wdam:* = undefined;
         var wdamexpl:* = undefined;
         var wrapid:* = undefined;
         var sinf:* = undefined;
         var a:Armor = null;
         var ammo:* = undefined;
         var hhp:Number = NaN;
         var pot:* = undefined;
         var pet:UnitPet = null;
         var tip:String = param1;
         var id:String = param2;
         var s:String = "";
         var pip:* = World.w.pip;
         var gg:* = World.w.gg;
         var inv:Invent = World.w.invent;
         if(tip == Item.L_ARMOR && inv.armors[id] == null && pip.arrArmor[id] == null)
         {
            tip = Item.L_ITEM;
         }
         if(Boolean(tip == Item.L_WEAPON) && Boolean(inv.weapons[id]) && Boolean(inv.weapons[id].spell))
         {
            tip = Item.L_ITEM;
         }
         if(tip == Item.L_WEAPON || tip == Item.L_EXPL)
         {
            w = pip.arrWeapon[id];
            if(w == null)
            {
               return "";
            }
            w.setPers(gg,gg.pers);
            skillConf = 1;
            razn = w.lvl - gg.pers.getWeapLevel(w.skill);
            if(razn == 1)
            {
               skillConf = 0.75;
            }
            if(razn >= 2)
            {
               skillConf = 0.5;
            }
            w.skillConf = skillConf;
            s += Res.pipText("weapontip") + ": " + yel(Res.pipText("weapontip" + w.skill));
            if(w.lvl > 0)
            {
               s += "\n" + Res.pipText("lvl") + ": " + yel(w.lvl);
               s += "\n" + Res.pipText("islvl") + ": " + yel(gg.pers.getWeapLevel(w.skill));
               if(razn > 0)
               {
                  s += "<span class = \'red\'>";
               }
               if(w.lvlNoUse && razn > 0 || razn > 2)
               {
                  s += " (" + Res.pipText("weapnouse") + ")</span>";
               }
               else if(razn > 0)
               {
                  if(razn == 2)
                  {
                     s += " (-40% ";
                  }
                  else if(razn == 1)
                  {
                     s += " (-20% ";
                  }
                  if(w.tip == 1)
                  {
                     s += Res.pipText("rapid");
                  }
                  else if(w.tip == 4)
                  {
                     s += Res.pipText("distance");
                  }
                  else
                  {
                     s += Res.pipText("precision");
                  }
                  s += ")</span>";
               }
            }
            if(w.perslvl > 0)
            {
               s += "\n" + Res.pipText("perslvl") + ": " + yel(w.perslvl);
               s += "\n" + Res.pipText("isperslvl") + ": " + yel(gg.pers.level);
               if(gg.pers.level < w.perslvl)
               {
                  s += red(" (" + Res.pipText("weapnouse") + ")");
               }
            }
            s += "\n" + Res.pipText("damage") + ": ";
            wdam = w.damage;
            wdamexpl = w.damageExpl;
            if(w.damage > 0)
            {
               s += yel(Math.round(w.damage * 10) / 10);
               wdam = w.resultDamage(w.damage,gg.pers.weaponSkills[w.skill]);
               if(wdam != w.damage)
               {
                  s += " (" + yel(Math.round(wdam * 10) / 10) + ")";
               }
            }
            if(w.damage > 0 && w.damageExpl > 0)
            {
               s += " + ";
            }
            if(w.damageExpl > 0)
            {
               s += yel(Math.round(w.damageExpl * w.damMult * 10) / 10);
               wdamexpl = w.resultDamage(w.damageExpl,gg.pers.weaponSkills[w.skill]);
               if(wdamexpl != w.damageExpl)
               {
                  s += " (" + yel(Math.round(wdamexpl * 10) / 10) + ")";
               }
               s += " " + Res.pipText("expldam");
            }
            if(w.kol > 1)
            {
               s += " [x" + w.kol + "]";
            }
            if(w.explKol > 1)
            {
               s += " [x" + w.explKol + "]";
            }
            wrapid = w.resultRapid(w.rapid);
            if(w.tip != 4)
            {
               s += "\n" + Res.pipText("aps") + ": " + yel(Number(World.fps / wrapid).toFixed(1));
               s += "\n" + Res.pipText("dps") + ": " + yel(Number((wdam + wdamexpl) * w.kol * World.fps / wrapid).toFixed(1));
               if(w.holder)
               {
                  s += " (" + yel(Number((wdam + wdamexpl) * w.kol * World.fps / (wrapid + w.reload * w.reloadMult / w.holder * w.rashod)).toFixed(1)) + ")";
               }
            }
            s += "\n" + Res.pipText("critch") + ": " + yel(Math.round((w.critCh + w.critchAdd + gg.critCh) * 100) + "%");
            s += "\n" + Res.pipText("tipdam") + ": " + blue(Res.pipText("tipdam" + w.tipDamage));
            if(w.tip < 4 && w.holder > 0)
            {
               s += "\n" + Res.pipText("inv5") + ": " + yel(Res.txt("i",w.ammo));
            }
            if(w.tip < 4 && w.holder > 0)
            {
               s += "\n" + Res.pipText("holder") + ": " + yel(w.holder);
            }
            if(w.rashod > 1)
            {
               s += " (" + yel(w.rashod) + " " + Res.pipText("rashod") + ")";
            }
            if(w.tip == 5)
            {
               s += "\n" + Res.pipText("dmana") + ": " + yel(Math.round(w.mana));
            }
            if(w.precision > 0)
            {
               s += "\n" + Res.pipText("prec") + ": " + yel(Math.round(w.precision * w.precMult / 40));
            }
            if(w.pier + w.pierAdd > 0)
            {
               s += "\n" + Res.pipText("pier") + ": " + yel(Math.round(w.pier + w.pierAdd));
            }
            if(!w.noSats)
            {
               s += "\n" + Res.pipText("ap") + ": ";
               if(razn > 0)
               {
                  s += "<span class = \'red\'>";
               }
               else
               {
                  s += "<span class = \'yel\'>";
               }
               s += Math.round(w.satsCons * w.consMult / skillConf * gg.pers.satsMult);
               s += "</span>";
               if(w.satsQue > 1)
               {
                  s += " (x" + yel(w.satsQue) + ")";
               }
            }
            if(w.destroy >= 100)
            {
               s += "\n" + Res.pipText("destroy");
            }
            if(Boolean(w.opt) && Boolean(w.opt.perk))
            {
               s += "\n" + Res.pipText("refperk") + ": " + pink(Res.txt("e",w.opt.perk));
            }
            sinf = Res.txt("w",id,1);
            if(sinf == "")
            {
               sinf = Res.txt("w",w.id,1);
            }
            if(World.w.hardInv && w.tip < 4)
            {
               s += "\n" + Res.pipText("mass2") + ": <span class = \'mass\'>" + w.mass + "</span>";
            }
            if(World.w.hardInv && w.tip == 4)
            {
               s += "\n\n" + Res.pipText("mass") + ": <span class = \'mass\'>" + inv.items[id].xml.@m + "</span> (" + Res.pipText("vault" + inv.items[id].invCat) + ")";
            }
            s += "\n\n" + sinf;
         }
         else if(tip == Item.L_ARMOR)
         {
            a = inv.armors[id];
            if(a == null)
            {
               a = pip.arrArmor[id];
            }
            if(a.armor_qual > 0)
            {
               s += Res.pipText("aqual") + ": " + yel(Math.round(a.armor_qual * 100) + "%");
            }
            if(a.armor > 0)
            {
               s += "\n" + Res.pipText("armor") + ": " + yel(Math.round(a.armor));
            }
            if(a.marmor > 0)
            {
               s += "\n" + Res.pipText("marmor") + ": " + yel(Math.round(a.marmor));
            }
            if(a.dexter != 0)
            {
               s += "\n" + Res.pipText("dexter") + ": " + yel(Math.round(a.dexter * 100) + "%");
            }
            if(a.sneak != 0)
            {
               s += "\n" + Res.pipText("sneak") + ": " + yel(Math.round(a.sneak * 100) + "%");
            }
            if(a.meleeMult != 1)
            {
               s += "\n" + Res.pipText("meleedamage") + ": +" + yel(Math.round((a.meleeMult - 1) * 100) + "%");
            }
            if(a.gunsMult != 1)
            {
               s += "\n" + Res.pipText("gunsdamage") + ": +" + yel(Math.round((a.gunsMult - 1) * 100) + "%");
            }
            if(a.magicMult != 1)
            {
               s += "\n" + Res.pipText("spelldamage") + ": +" + yel(Math.round((a.magicMult - 1) * 100) + "%");
            }
            if(a.crit != 0)
            {
               s += "\n" + Res.pipText("critch") + ": +" + yel(Math.round(a.crit * 100) + "%");
            }
            if(a.radVul < 1)
            {
               s += "\n" + Res.pipText("radx") + ": " + yel(Math.round((1 - a.radVul) * 100) + "%");
            }
            if(a.resist[Unit.D_BUL] != 0)
            {
               s += "\n" + Res.pipText("bullet") + ": " + yel(Math.round(a.resist[Unit.D_BUL] * 100) + "%");
            }
            if(a.resist[Unit.D_EXPL] != 0)
            {
               s += "\n" + Res.pipText("expl") + ": " + yel(Math.round(a.resist[Unit.D_EXPL] * 100) + "%");
            }
            if(a.resist[Unit.D_PHIS] != 0)
            {
               s += "\n" + Res.pipText("phis") + ": " + yel(Math.round(a.resist[Unit.D_PHIS] * 100) + "%");
            }
            if(a.resist[Unit.D_BLADE] != 0)
            {
               s += "\n" + Res.pipText("blade") + ": " + yel(Math.round(a.resist[Unit.D_BLADE] * 100) + "%");
            }
            if(a.resist[Unit.D_FANG] != 0)
            {
               s += "\n" + Res.pipText("fang") + ": " + yel(Math.round(a.resist[Unit.D_FANG] * 100) + "%");
            }
            if(a.resist[Unit.D_FIRE] != 0)
            {
               s += "\n" + Res.pipText("fire") + ": " + yel(Math.round(a.resist[Unit.D_FIRE] * 100) + "%");
            }
            if(a.resist[Unit.D_LASER] != 0)
            {
               s += "\n" + Res.pipText("laser") + ": " + yel(Math.round(a.resist[Unit.D_LASER] * 100) + "%");
            }
            if(a.resist[Unit.D_PLASMA] != 0)
            {
               s += "\n" + Res.pipText("plasma") + ": " + yel(Math.round(a.resist[Unit.D_PLASMA] * 100) + "%");
            }
            if(a.resist[Unit.D_SPARK] != 0)
            {
               s += "\n" + Res.pipText("spark") + ": " + yel(Math.round(a.resist[Unit.D_SPARK] * 100) + "%");
            }
            if(a.resist[Unit.D_CRIO] != 0)
            {
               s += "\n" + Res.pipText("crio") + ": " + yel(Math.round(a.resist[Unit.D_CRIO] * 100) + "%");
            }
            if(a.resist[Unit.D_VENOM] != 0)
            {
               s += "\n" + Res.pipText("venom") + ": " + yel(Math.round(a.resist[Unit.D_VENOM] * 100) + "%");
            }
            if(a.resist[Unit.D_ACID] != 0)
            {
               s += "\n" + Res.pipText("acid") + ": " + yel(Math.round(a.resist[Unit.D_ACID] * 100) + "%");
            }
            if(a.resist[Unit.D_NECRO] != 0)
            {
               s += "\n" + Res.pipText("necro") + ": " + yel(Math.round(a.resist[Unit.D_NECRO] * 100) + "%");
            }
            s += "\n\n" + Res.txt("a",id,1);
         }
         else if(tip == Item.L_AMMO)
         {
            ammo = inv.items[id].xml;
            if(AllData.d.weapon.(@id == id).length())
            {
               s = Res.txt("w",id,1);
            }
            else if(ammo.@base.length())
            {
               s = Res.txt("i",ammo.@base,1);
               if(ammo.@mod > 0)
               {
                  s += "\n\n" + Res.txt("p","ammomod_" + ammo.@mod,1);
               }
            }
            else
            {
               s = Res.txt("i",id,1);
            }
            s += "\n";
            if(ammo.@damage.length())
            {
               s += "\n" + Res.pipText("damage") + ": x" + yel(ammo.@damage);
            }
            if(ammo.@pier.length())
            {
               s += "\n" + Res.pipText("pier") + ": " + yel(ammo.@pier);
            }
            if(ammo.@armor.length())
            {
               s += "\n" + Res.pipText("tarmor") + ": x" + yel(ammo.@armor);
            }
            if(ammo.@prec.length())
            {
               s += "\n" + Res.pipText("prec") + ": x" + yel(ammo.@prec);
            }
            if(ammo.@det > 0)
            {
               s += "\n" + Res.pipText("det");
            }
            if(World.w.hardInv && ammo.@m > 0)
            {
               s += "\n\n" + Res.pipText("mass") + ": <span class = \'mass\'>" + ammo.@m + "</span> (" + Res.pipText("vault" + inv.items[id].invCat) + ")";
            }
            if(ammo.@sell > 0)
            {
               s += "\n" + Res.pipText("sell") + ": " + yel(ammo.@sell);
            }
         }
         else
         {
            hhp = 0;
            s = Res.txt("i",id,1) + "\n";
            pot = inv.items[id].xml;
            tip = pot.@tip;
            if(tip == "instr" || tip == "impl" || tip == "art")
            {
               s = effStr("item",id) + "\n";
            }
            if(tip == "med" || tip == "food" || tip == "pot" || tip == "him")
            {
               if(Boolean(pot.@hhp.length()) || Boolean(pot.@hhplong.length()))
               {
                  s += "\n" + Res.pipText("healhp") + ": " + yel(Math.round(pot.@hhp * World.w.pers.healMult));
               }
               if(pot.@hhplong.length())
               {
                  s += "+" + yel(Math.round(pot.@hhplong * World.w.pers.healMult));
               }
               if(pot.@hrad.length())
               {
                  s += "\n" + Res.pipText("healrad") + ": " + yel(Math.round(pot.@hrad * World.w.pers.healMult));
               }
               if(pot.@hcut.length())
               {
                  s += "\n" + Res.pipText("healcut") + ": " + yel(Math.round(pot.@hcut));
               }
               if(pot.@hpoison.length())
               {
                  s += "\n" + Res.pipText("healpoison") + ": " + yel(Math.round(pot.@hpoison));
               }
               if(pot.@horgan.length())
               {
                  s += "\n" + Res.pipText("healorgan") + ": " + yel(Math.round(pot.@horgan));
               }
               if(pot.@horgans.length())
               {
                  s += "\n" + Res.pipText("healorgans") + ": " + yel(Math.round(pot.@horgans));
               }
               if(pot.@hblood.length())
               {
                  s += "\n" + Res.pipText("healblood") + ": " + yel(Math.round(pot.@hblood));
               }
               if(pot.@hmana.length())
               {
                  s += "\n" + Res.pipText("healmana") + ": " + yel(Math.round(pot.@hmana * World.w.pers.healManaMult));
               }
               if(pot.@alc.length())
               {
                  s += "\n" + Res.pipText("alcohol") + ": " + yel(Math.round(pot.@alc));
               }
               if(pot.@rad.length())
               {
                  s += "\n" + Res.pipText("rad") + ": " + yel(Math.round(pot.@rad));
               }
               if(pot.@effect.length())
               {
                  s += "\n" + Res.pipText("refeff") + ": " + effStr("eff",pot.@effect);
               }
               if(pot.@perk.length())
               {
                  s += "\n" + pink(Res.txt("e",pot.@perk)) + ": " + Res.pipText("level") + " " + (World.w.pers.perks[pot.@perk] > 0 ? World.w.pers.perks[pot.@perk] : "0");
               }
               if(pot.@maxperk.length())
               {
                  s += "/" + pot.@maxperk;
               }
            }
            if(tip == "book")
            {
               if(World.w.pers.skills[id] != null)
               {
                  s += "\n" + Res.pipText("skillup") + ": " + pink(Res.txt("e",id));
               }
            }
            if(tip == "spell")
            {
               s += "\n" + Res.pipText("dmana2") + ": " + yel(pot.@mana) + " (" + yel(Math.round(pot.@mana * World.w.pers.allDManaMult)) + ")";
               s += "\n" + Res.pipText("culd") + ": " + yel(pot.@culd + Res.guiText("sec")) + " (" + yel(Math.round(pot.@culd * World.w.pers.spellDown) + Res.guiText("sec")) + ")";
               s += "\n" + Res.pipText("is1") + ": " + pink(pot.@tele > 0 ? Res.txt("e","tele") : Res.txt("e","magic"));
            }
            if(id == "rep")
            {
               if(pot.@hp.length())
               {
                  hhp = pot.@hp * gg.pers.repairMult;
               }
               if(hhp > 0)
               {
                  s += "\n" + Res.pipText("effect") + ": " + yel(Math.round(hhp));
               }
            }
            if(pot.@pet_info.length())
            {
               pet = gg.pets[pot.@pet_info];
               if(pet)
               {
                  s += "\n" + Res.pipText("hp") + ": " + yel(Math.round(pet.hp)) + "/" + yel(Math.round(pet.maxhp));
                  s += "\n" + Res.pipText("skin") + ": " + yel(Math.round(pet.skin));
                  if(pet.allVulnerMult < 1)
                  {
                     s += "\n" + Res.pipText("allresist") + ": " + yel(Math.round((1 - pet.allVulnerMult) * 100) + "%");
                  }
                  s += "\n" + Res.pipText("damage") + ": " + yel(Math.round(pet.dam));
               }
            }
            if(tip == "paint")
            {
               s = Res.txt("p","paint",1);
            }
            if(World.w.hardInv && pot.@m > 0)
            {
               s += "\n\n" + Res.pipText("mass") + ": <span class = \'mass\'>" + pot.@m + "</span> (" + Res.pipText("vault" + inv.items[id].invCat) + ")";
            }
            if(pot.@sell > 0)
            {
               s += "\n" + Res.pipText("sell") + ": " + yel(pot.@sell);
            }
         }
         return s;
      }
      
      public function updateLang() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:* = 1;
         while(_loc1_ <= 5)
         {
            _loc2_ = this.vis.getChildByName("but" + _loc1_) as MovieClip;
            _loc2_.text.text = Res.pipText(this.pp + _loc1_);
            _loc1_++;
         }
      }
      
      public function page2Click(param1:MouseEvent) : *
      {
         if(World.w.ctr.setkeyOn)
         {
            return;
         }
         this.page2 = int(param1.currentTarget.id.text);
         this.setStatus();
         this.pip.snd(2);
      }
      
      internal function setButtons() : *
      {
         var _loc2_:MovieClip = null;
         var _loc1_:* = 1;
         while(_loc1_ <= 5)
         {
            _loc2_ = this.vis.getChildByName("but" + _loc1_) as MovieClip;
            if(this.page2 == _loc1_)
            {
               _loc2_.gotoAndStop(2);
            }
            else if(this.signs[_loc1_] > 0)
            {
               _loc2_.gotoAndStop(this.signs[_loc1_] + 2);
            }
            else
            {
               _loc2_.gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      public function setStatus(param1:Boolean = true) : *
      {
         this.pip.reqKey = false;
         this.statHead.id.text = "";
         this.vis.visible = true;
         this.vis.info.text = "";
         this.vis.nazv.text = "";
         this.vis.bottext.text = "";
         this.vis.emptytext.text = "";
         this.arr = new Array();
         if(param1)
         {
            this.scrl = 0;
         }
         if(this.vis.scText)
         {
            this.vis.scText.visible = false;
         }
         this.gg = this.pip.gg;
         this.inv = this.pip.inv;
         this.pip.vis.toptext.visible = false;
         this.pip.vis.butHelp.visible = this.pip.vis.butMass.visible = false;
         this.pip.vishelp.visible = false;
         this.setSubPages();
         this.setStatItems(param1 ? 0 : -1);
         var _loc2_:ScrollBar = this.vis.scBar;
         if(this.arr.length > this.maxrows)
         {
            _loc2_.visible = true;
            _loc2_.minScrollPosition = 0;
            _loc2_.maxScrollPosition = this.arr.length - this.maxrows;
            _loc2_.scrollPosition = this.scrl;
         }
         else
         {
            _loc2_.visible = false;
         }
         this.setSigns();
         this.setButtons();
      }
      
      internal function setSubPages() : *
      {
      }
      
      internal function setSigns() : *
      {
         this.signs = [0,0,0,0,0,0];
      }
      
      internal function setStatItem(param1:MovieClip, param2:Object) : *
      {
      }
      
      internal function statInfo(param1:MouseEvent) : *
      {
      }
      
      internal function itemClick(param1:MouseEvent) : *
      {
      }
      
      internal function itemRightClick(param1:MouseEvent) : *
      {
      }
      
      public function setStatItems(param1:int = -1) : *
      {
         if(param1 >= 0)
         {
            this.scrl = param1;
         }
         var _loc2_:* = 0;
         while(_loc2_ < this.statArr.length)
         {
            if(_loc2_ + this.scrl >= this.arr.length)
            {
               this.statArr[_loc2_].visible = false;
            }
            else
            {
               this.statArr[_loc2_].visible = true;
               this.setStatItem(this.statArr[_loc2_],this.arr[_loc2_ + this.scrl]);
            }
            _loc2_++;
         }
      }
      
      public function setIco(param1:int = 0, param2:String = "") : *
      {
         var w:Weapon = null;
         var vWeapon:Class = null;
         var node:* = undefined;
         var r:Number = NaN;
         var tip:int = param1;
         var id:String = param2;
         if(Boolean(this.infIco) && Boolean(this.vis.ico.contains(this.infIco)))
         {
            this.vis.ico.removeChild(this.infIco);
         }
         this.vis.pers.visible = this.vis.skill.visible = false;
         this.vis.item.gotoAndStop(1);
         this.vis.info.y = this.vis.ico.y;
         if(tip == 1)
         {
            w = this.pip.arrWeapon[id];
            if(w.tip == 5)
            {
               tip = 3;
               if(id.charAt(id.length - 2) == "^")
               {
                  id = id.substr(0,id.length - 2);
               }
            }
            else
            {
               vWeapon = w.vWeapon;
               node = AllData.d.weapon.(@id == id);
               if(node.length())
               {
                  node = node[0];
                  if(Boolean(node.vis.length()) && Boolean(node.vis[0].@vico.length()))
                  {
                     vWeapon = Res.getClass(node.vis[0].@vico,null);
                  }
               }
               if(vWeapon == null)
               {
                  vWeapon = Res.getClass("vis" + id,null);
               }
               if(vWeapon != null)
               {
                  this.infIco = new vWeapon();
                  this.infIco.stop();
                  if(this.infIco.lez)
                  {
                     this.infIco.lez.stop();
                  }
                  r = 1;
                  if(Boolean(node.length()) && Boolean(node.vis.length()))
                  {
                     if(node.vis.@icomult.length())
                     {
                        r = this.infIco.scaleX = this.infIco.scaleY = node.vis.@icomult;
                     }
                  }
                  this.infIco.x = -this.infIco.getRect(this.infIco).left * r + 140 - this.infIco.width / 2;
                  this.infIco.y = -this.infIco.getRect(this.infIco).top;
                  this.vis.ico.addChild(this.infIco);
                  this.vis.info.y = this.vis.ico.y + this.vis.ico.height + 10;
                  this.infIco.transform.colorTransform = this.itemTrans;
                  this.infIco.filters = [this.itemFilter];
               }
            }
         }
         if(tip == 2)
         {
            this.pip.setArmor(id);
            this.vis.pers.gotoAndStop(2);
            this.vis.pers.gotoAndStop(1);
            this.vis.pers.head.morda.magic.visible = false;
            this.vis.pers.visible = true;
            this.vis.info.y = this.vis.pers.y + 25;
         }
         if(tip == 3)
         {
            this.vis.item.visible = true;
            try
            {
               this.vis.item.gotoAndStop(id);
               this.vis.info.y = this.vis.item.y + this.vis.item.height + 25;
            }
            catch(err:*)
            {
               vis.item.gotoAndStop(1);
               vis.item.visible = false;
               vis.info.y = vis.ico.y;
            }
         }
         if(tip == 5)
         {
            this.vis.skill.visible = true;
            try
            {
               this.vis.skill.gotoAndStop(id);
               this.vis.info.y = this.vis.ico.y + 220;
            }
            catch(err:*)
            {
               vis.skill.visible = false;
               vis.info.y = vis.ico.y;
            }
         }
      }
      
      internal function infoItem(param1:String, param2:String, param3:String, param4:int = 0) : *
      {
         var s:String;
         var a:Armor = null;
         var cid:String = null;
         var kolcomp:int = 0;
         var ammo:* = undefined;
         var tip:String = param1;
         var id:String = param2;
         var nazv:String = param3;
         var craft:int = param4;
         this.vis.nazv.text = nazv;
         s = "";
         if(id.substr(0,2) == "s_")
         {
            id = id.substr(2);
            craft = 1;
            if(AllData.d.weapon.(@id == id).length())
            {
               tip = Item.L_WEAPON;
            }
            else if(AllData.d.armor.(@id == id).length())
            {
               tip = Item.L_ARMOR;
            }
            else
            {
               tip = Item.L_ITEM;
            }
         }
         if(tip == Item.L_WEAPON || tip == Item.L_EXPL)
         {
            if(craft > 0)
            {
               this.setIco();
            }
            else
            {
               this.setIco(1,id);
            }
            s = infoStr(tip,id);
            if(craft == 1)
            {
               s += this.craftInfo(id);
            }
            if(craft == 2)
            {
               s += this.craftInfo(id.substr(0,id.length - 2));
            }
         }
         else if(tip == Item.L_ARMOR)
         {
            a = this.inv.armors[id];
            if(a == null)
            {
               a = this.pip.arrArmor[id];
            }
            if(craft > 0)
            {
               this.setIco();
            }
            else if(a.tip == 3)
            {
               this.setIco(3,id);
            }
            else
            {
               this.setIco(2,id);
            }
            s = infoStr(tip,id);
            if(craft == 2)
            {
               cid = a.idComp;
               kolcomp = a.needComp();
               s += "\n\n<span class = \'or\'>" + Res.txt("i",cid) + " - " + kolcomp + " <span ";
               if(!World.w.loc.base && kolcomp > this.inv.items[cid].kol || World.w.loc.base && kolcomp > this.inv.items[cid].kol + this.inv.items[cid].vault)
               {
                  s += "class=\'red\'";
               }
               s += "> (" + this.inv.items[cid].kol;
               if(World.w.loc.base && this.inv.items[cid].vault > 0)
               {
                  s += " +" + this.inv.items[cid].vault;
               }
               s += ")</span></span>";
            }
            if(craft == 1)
            {
               s += this.craftInfo(id);
            }
         }
         else if(tip == Item.L_AMMO)
         {
            ammo = this.inv.items[id].xml;
            if(ammo.@base.length())
            {
               this.vis.nazv.text = Res.txt("i",ammo.@base);
               if(ammo.@mod > 0)
               {
                  this.vis.nazv.text += "\n" + Res.pipText("ammomod_" + ammo.@mod);
               }
               else
               {
                  this.vis.nazv.text += "\n" + Res.pipText("ammomod_0");
               }
            }
            this.setIco();
            s = infoStr(tip,id);
         }
         else
         {
            if(craft > 0)
            {
               this.setIco();
            }
            else
            {
               this.setIco(3,id);
            }
            s = infoStr(tip,id);
            if(craft == 1)
            {
               s += this.craftInfo(id);
            }
         }
         this.vis.info.htmlText = s;
         this.vis.info.height = 680 - this.vis.info.y;
         this.vis.info.scaleX = this.vis.info.scaleY = 1;
         if(this.vis.scText)
         {
            this.vis.scText.visible = false;
         }
         if(this.vis.info.height < this.vis.info.textHeight && Boolean(this.vis.scText))
         {
            this.vis.scText.maxScrollPosition = this.vis.info.maxScrollV;
            this.vis.scText.visible = true;
         }
      }
      
      public function craftInfo(param1:String) : String
      {
         var s:String = null;
         var sch:* = undefined;
         var kol:int = 0;
         var c:* = undefined;
         var id:String = param1;
         s = "\n";
         sch = AllData.d.item.(@id == "s_" + id);
         if(sch.length())
         {
            sch = sch[0];
            kol = 1;
            if(sch.@kol.length())
            {
               kol = int(sch.@kol);
            }
            if(sch.@perk == "potmaster" && Boolean(this.gg.pers.potmaster))
            {
               kol *= 2;
            }
            if(kol > 1)
            {
               s += Res.pipText("crekol") + ": " + kol + "\n";
            }
            if(Boolean(sch.@skill.length()) && Boolean(sch.@lvl.length()))
            {
               s += "\n" + Res.pipText("needskill") + ": <span class = \'";
               if(this.gg.pers.getSkillLevel(sch.@skill) < sch.@lvl)
               {
                  s += "red";
               }
               else
               {
                  s += "pink";
               }
               s += "\'>" + Res.txt("e",sch.@skill) + " - " + sch.@lvl + "</span>\n";
            }
            for each(c in sch.craft)
            {
               s += "\n<span class = \'or\'>" + Res.txt("i",c.@id) + " - " + c.@kol + " <span ";
               if(!World.w.loc.base && c.@kol > this.inv.items[c.@id].kol || World.w.loc.base && c.@kol > this.inv.items[c.@id].kol + this.inv.items[c.@id].vault)
               {
                  s += "class=\'red\'";
               }
               s += ">(" + this.inv.items[c.@id].kol;
               if(World.w.loc.base && this.inv.items[c.@id].vault > 0)
               {
                  s += " +" + this.inv.items[c.@id].vault;
               }
               s += ")</span></span>";
            }
            return s;
         }
         return "";
      }
      
      internal function infoQuest(param1:String) : String
      {
         var _loc5_:Quest = null;
         var _loc2_:Quest = World.w.game.quests[param1];
         if(_loc2_ == null)
         {
            return "";
         }
         this.vis.nazv.text = _loc2_.nazv;
         var _loc3_:String = _loc2_.info;
         if(_loc2_.empl)
         {
            _loc3_ += "<br><br>" + Res.txt("u",_loc2_.empl);
         }
         _loc3_ += "\n";
         var _loc4_:int = 1;
         for each(_loc5_ in _loc2_.subs)
         {
            if(!(_loc5_.invis && _loc5_.state < 2))
            {
               _loc3_ += "\n";
               if(_loc5_.state == 2)
               {
                  _loc3_ += "<span class = \'dark\'>";
               }
               _loc3_ += yel(_loc4_ + ".") + " ";
               if(_loc5_.hidden && _loc5_.state < 2 && _loc5_.est <= 0)
               {
                  _loc3_ += "?????";
               }
               else
               {
                  _loc3_ += _loc5_.nazv;
               }
               if(Boolean(_loc5_.collect) && _loc5_.colTip == 0)
               {
                  if(_loc5_.give)
                  {
                     _loc3_ += " (" + yel(_loc5_.gived + "/" + _loc5_.kol) + ")";
                     if(_loc5_.est > 0 && _loc5_.state < 2)
                     {
                        _loc3_ += " (" + yel("+" + _loc5_.est) + ")";
                     }
                  }
                  else
                  {
                     _loc3_ += " (" + yel(_loc5_.est + "/" + _loc5_.kol) + ")";
                  }
               }
               if(_loc5_.nn)
               {
                  _loc3_ += " (" + Res.pipText("nn") + ")";
               }
               if(_loc5_.state == 2)
               {
                  _loc3_ += "</span>";
               }
               _loc4_++;
            }
         }
         return _loc3_;
      }
      
      public function factor(param1:String) : String
      {
         var s1:String = null;
         var xml:* = undefined;
         var obj:* = undefined;
         var id:String = param1;
         var s:String = "";
         var ok:* = false;
         if(World.w.pers.factor[id] is Array)
         {
            xml = AllData.d.param.(@v == id);
            if(xml.@tip == "4")
            {
               s += "- " + Res.pipText("begvulner") + ": " + yel("100%") + "\n";
            }
            for each(obj in World.w.pers.factor[id])
            {
               if(obj.id == "beg")
               {
                  if(xml.@nobeg <= 0)
                  {
                     if(xml.@tip == "0")
                     {
                        if(obj.res != 0)
                        {
                           s += "- " + Res.pipText("begval") + ": " + yel(Res.numb(obj.res)) + "\n";
                        }
                     }
                     else if(xml.@tip == "3")
                     {
                        s += "- " + Res.pipText("begvulner") + ": " + yel(Res.numb(obj.res * 100) + "%") + "\n";
                     }
                     else
                     {
                        s += "- " + Res.pipText("begval") + ": " + yel(Res.numb(obj.res * 100) + "%") + "\n";
                     }
                  }
               }
               else if(!(obj.ref == "add" && obj.val == 0 || obj.ref == "mult" && obj.val == 1))
               {
                  ok = true;
                  if(obj.tip != null)
                  {
                     s1 = Res.txt(obj.tip,obj.id);
                  }
                  else if(Res.istxt("e",obj.id))
                  {
                     s1 = Res.txt("e",obj.id);
                  }
                  else if(Res.istxt("i",obj.id))
                  {
                     s1 = Res.txt("i",obj.id);
                  }
                  else if(Res.istxt("a",obj.id))
                  {
                     s1 = Res.txt("a",obj.id);
                  }
                  else
                  {
                     s1 = "???";
                  }
                  if(s1.substr(0,6) == "*eff_f")
                  {
                     s1 = Res.txt("e","food");
                  }
                  s += "- " + s1 + ": ";
                  if(obj.ref == "add")
                  {
                     if(xml.@tip == "0")
                     {
                        s += (obj.val > 0 ? "+" : "-") + " " + yel(Math.abs(obj.val));
                        s += " = " + yel(Res.numb(obj.res));
                     }
                     else
                     {
                        s += (obj.val > 0 ? "+" : "-") + " " + yel(Res.numb(Math.abs(obj.val * 100)) + "%");
                        s += " = " + yel(Res.numb(obj.res * 100) + "%");
                     }
                  }
                  else if(obj.ref == "mult")
                  {
                     if(xml.@tip == "0")
                     {
                        s += "× " + yel(obj.val) + " = " + yel(Res.numb(obj.res));
                     }
                     else if(xml.@tip == "3" || xml.@tip == "4")
                     {
                        s += "× (1 " + (obj.val < 1 ? "-" : "+") + " " + yel(Math.abs(Math.round(100 - obj.val * 100)) * 0.01) + ")";
                        s += " = " + yel(Res.numb(obj.res * 100) + "%");
                     }
                     else
                     {
                        s += "× " + yel(obj.val);
                        s += " = " + yel(Res.numb(obj.res * 100) + "%");
                     }
                  }
                  else if(obj.ref == "min")
                  {
                     s += "- " + yel(Res.numb(Math.abs(obj.val * 100)) + "%");
                     s += " = " + yel(Res.numb(obj.res * 100) + "%");
                  }
                  else if(xml.@tip == "0")
                  {
                     s += yel(obj.val);
                  }
                  else
                  {
                     s += yel(Res.numb(obj.val * 100) + "%");
                  }
                  s += "\n";
               }
            }
            if(Boolean(obj) && (xml.@tip == "3" || xml.@tip == "4"))
            {
               s += "- " + Res.pipText("result") + ": 100% - " + yel(Res.numb(obj.res * 100) + "%") + " = " + yel(Res.numb((1 - obj.res) * 100) + "%");
            }
         }
         if(ok)
         {
            s = Res.pipText("factor") + ":\n" + s;
            return s;
         }
         return "";
      }
      
      public function setTopText(param1:String = "") : *
      {
         var _loc2_:String = null;
         var _loc3_:RegExp = null;
         if(param1 == "")
         {
            this.pip.vis.toptext.visible = false;
         }
         else
         {
            this.pip.vis.toptext.visible = true;
            _loc2_ = Res.txt("p",param1,0,true);
            _loc3_ = /@/g;
            this.pip.vis.toptext.txt.htmlText = _loc2_.replace(_loc3_,"\n");
         }
      }
      
      public function checkQuest(param1:*) : Boolean
      {
         var _loc2_:LandAct = null;
         if(param1.@land.length())
         {
            _loc2_ = World.w.game.lands[param1.@land];
            if(_loc2_ == null)
            {
               return false;
            }
            if(!_loc2_.access && !_loc2_.visited && World.w.pers.level < _loc2_.dif)
            {
               return false;
            }
         }
         if(param1.@trigger.length())
         {
            if(World.w.game.triggers[param1.@trigger] != 1)
            {
               return false;
            }
         }
         if(Boolean(param1.@skill.length()) && Boolean(param1.@skilln.length()))
         {
            if(World.w.pers.skills[param1.@skill] < param1.@skilln)
            {
               return false;
            }
         }
         return true;
      }
      
      internal function initCats() : *
      {
         var _loc1_:* = 0;
         while(_loc1_ <= this.kolCats)
         {
            this.vis.cats["cat" + _loc1_].addEventListener(MouseEvent.CLICK,this.selCatEvent);
            _loc1_++;
         }
         this.selCat();
      }
      
      internal function setCats() : *
      {
         var ntip:* = undefined;
         var i:* = undefined;
         var arr:* = this.tips[this.page2];
         if(arr == null)
         {
            this.vis.cats.visible = false;
            return;
         }
         this.vis.cats.visible = true;
         i = 0;
         for(; i <= this.kolCats; i++)
         {
            ntip = arr[i];
            if(ntip != null)
            {
               if(ntip is Array)
               {
                  ntip = ntip[0];
               }
               this.vis.cats["cat" + i].visible = true;
               try
               {
                  this.vis.cats["cat" + i].ico.gotoAndStop(ntip);
               }
               catch(err:*)
               {
                  vis.cats["cat" + i].ico.gotoAndStop(1);
               }
               continue;
            }
            this.vis.cats["cat" + i].visible = false;
         }
         this.selCat(this.cat[this.page2]);
      }
      
      internal function selCatEvent(param1:MouseEvent) : *
      {
         var _loc2_:int = int(param1.currentTarget.name.substr(3));
         this.cat[this.page2] = _loc2_;
         this.setStatus();
      }
      
      internal function selCat(param1:int = 0) : *
      {
         var n:int = param1;
         var i:* = 0;
         while(i <= this.kolCats)
         {
            this.vis.cats["cat" + i].fon.gotoAndStop(1);
            i++;
         }
         this.vis.cats["cat" + n].fon.gotoAndStop(2);
         try
         {
            this.curTip = this.tips[this.page2][n];
         }
         catch(err:*)
         {
            curTip = "";
         }
         if(this.curTip == null)
         {
            this.curTip = "";
         }
      }
      
      internal function checkCat(param1:String) : Boolean
      {
         var _loc2_:* = undefined;
         if(this.curTip == "" || this.curTip == null || this.curTip == param1)
         {
            return true;
         }
         if(this.curTip is Array)
         {
            for each(_loc2_ in this.curTip)
            {
               if(_loc2_ == param1)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public function statScroll(param1:ScrollEvent) : *
      {
         this.setStatItems(param1.position);
      }
      
      public function onMouseWheel1(param1:MouseEvent) : void
      {
         if(World.w.ctr.setkeyOn)
         {
            return;
         }
         try
         {
            if(Boolean(this.vis.scText) && Boolean(this.vis.scText.visible) && this.vis.mouseX > this.vis.info.x)
            {
               return;
            }
         }
         catch(err:*)
         {
         }
         this.scroll(param1.delta);
         if(!this.vis.scBar.visible)
         {
            return;
         }
         if(param1.delta < 0)
         {
            ++(param1.currentTarget as MovieClip).scBar.scrollPosition;
         }
         if(param1.delta > 0)
         {
            --(param1.currentTarget as MovieClip).scBar.scrollPosition;
         }
         param1.stopPropagation();
      }
      
      public function scroll(param1:int = 0) : *
      {
      }
      
      public function step() : *
      {
      }
   }
}

