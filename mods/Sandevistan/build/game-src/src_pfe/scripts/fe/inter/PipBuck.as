package fe.inter
{
   import fe.*;
   import fe.serv.Vendor;
   import fe.unit.Armor;
   import fe.unit.Invent;
   import fe.unit.Pers;
   import fe.unit.Unit;
   import fe.unit.UnitPlayer;
   import fe.weapon.Weapon;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class PipBuck
   {
      
      public var light:Boolean = false;
      
      internal var vis:MovieClip;
      
      internal var vissetkey:MovieClip;
      
      internal var vishelp:MovieClip;
      
      public var active:Boolean = false;
      
      public var noAct:Boolean = false;
      
      internal var noAct2:Boolean = false;
      
      public var ArmorId:String;
      
      public var hideMane:int = 0;
      
      internal var visX:* = 1200;
      
      internal var visY:* = 800;
      
      internal var page:int = 1;
      
      internal var kolPages:int = 5;
      
      internal var pages:Array;
      
      public var currentPage:PipPage;
      
      internal var inv:Invent;
      
      internal var gg:UnitPlayer;
      
      internal var money:int = 0;
      
      public var helpText:String = "";
      
      public var massText:String = "";
      
      internal var showHidden:Boolean = false;
      
      public var reqKey:Boolean = false;
      
      public var arrWeapon:Array;
      
      public var arrArmor:Array;
      
      public var vendor:Vendor;
      
      public var npcInter:String = "";
      
      public var npcId:String = "";
      
      public var workTip:String = "work";
      
      public var travel:Boolean = false;
      
      public var isSaveConf:Boolean = false;
      
      public var pipVol:Number = 0.25;
      
      internal var kolRItems:int = 15;
      
      public var ritems:Array;
      
      internal var ritemsNazv:*;
      
      public function PipBuck(param1:MovieClip)
      {
         var _loc2_:* = undefined;
         var _loc3_:MovieClip = null;
         this.ritemsNazv = ["hp","head","tors","legs","blood","mana","pet","inv1","inv1","caps"];
         super();
         this.light = true;
         this.vis = param1;
         this.vis.visible = false;
         if(this.light)
         {
            this.vis.skin.visible = false;
            this.vis.fon.visible = false;
         }
         _loc2_ = 0;
         while(_loc2_ <= this.kolPages)
         {
            _loc3_ = this.vis.getChildByName("but" + _loc2_) as MovieClip;
            _loc3_.id.visible = false;
            _loc3_.visible = false;
            _loc3_.mouseChildren = false;
            _loc2_++;
         }
         this.vis.but0.visible = true;
         this.vis.but0.addEventListener(MouseEvent.CLICK,this.pipClose);
         this.vis.but0.text.text = Res.pipText("mainclose");
         this.pages = [null,new PipPageStat(this,"stat"),new PipPageInv(this,"inv"),new PipPageInfo(this,"info"),new PipPageVend(this,"vend"),new PipPageOpt(this,"opt"),new PipPageMed(this,"med"),new PipPageWork(this,"work"),new PipPageApp(this,"app"),new PipPageVault(this,"vault")];
         this.page = this.kolPages;
         this.currentPage = this.pages[this.page];
         this.vishelp = new visPipHelp();
         this.vishelp.x = 168;
         this.vishelp.y = 138;
         this.vis.addChild(this.vishelp);
         this.vissetkey = new visSetKey();
         this.vissetkey.visible = false;
         this.vissetkey.x = 600;
         this.vissetkey.y = 400;
         this.vis.addChild(this.vissetkey);
         this.vishelp.visible = false;
         PipPage.setStyle(this.vishelp.txt);
         this.vis.butHelp.addEventListener(MouseEvent.MOUSE_OVER,this.helpShow);
         this.vis.butHelp.addEventListener(MouseEvent.MOUSE_OUT,this.helpUnshow);
         this.vis.butMass.addEventListener(MouseEvent.MOUSE_OVER,this.massShow);
         this.vis.butMass.addEventListener(MouseEvent.MOUSE_OUT,this.massUnshow);
         PipPage.setStyle(this.vis.toptext.txt);
         this.vis.pr.visible = false;
         this.ritems = new Array();
         _loc2_ = 0;
         while(_loc2_ < this.kolRItems)
         {
            _loc3_ = new visPipRItem();
            this.ritems[_loc2_] = _loc3_;
            this.vis.pr.addChild(_loc3_);
            _loc3_.x = 5;
            _loc3_.y = 40 + _loc2_ * 30;
            PipPage.setStyle(_loc3_.txt);
            _loc3_.trol.gotoAndStop(_loc2_ + 1);
            _loc3_.nazv.visible = false;
            _loc2_++;
         }
      }
      
      public function updateLang() : *
      {
         var _loc1_:* = undefined;
         this.vis.but0.text.text = Res.pipText("mainclose");
         for each(_loc1_ in this.pages)
         {
            if(_loc1_ is PipPage)
            {
               _loc1_.updateLang();
            }
         }
         this.currentPage.setStatus();
      }
      
      public function toNormalMode() : *
      {
         var _loc2_:MovieClip = null;
         this.light = false;
         this.vis.skin.visible = true;
         this.vis.fon.visible = true;
         var _loc1_:* = 1;
         while(_loc1_ <= this.kolPages)
         {
            _loc2_ = this.vis.getChildByName("but" + _loc1_) as MovieClip;
            _loc2_.addEventListener(MouseEvent.CLICK,this.pageClick);
            _loc2_.text.text = Res.pipText("main" + _loc1_);
            _loc2_.id.text = _loc1_;
            _loc2_.visible = true;
            _loc1_++;
         }
         this.vis.but0.text.text = Res.pipText("main0");
         this.page = 1;
         this.allItems();
      }
      
      public function pageClick(param1:MouseEvent) : *
      {
         if(World.w.ctr.setkeyOn)
         {
            return;
         }
         if(Boolean(World.w.gg) && Boolean(World.w.gg.pipOff))
         {
            return;
         }
         this.page = int(param1.currentTarget.id.text);
         this.setPage();
         this.setButtons();
         this.snd(2);
      }
      
      public function pipClose(param1:MouseEvent) : *
      {
         if(World.w.ctr.setkeyOn)
         {
            return;
         }
         this.onoff(-1);
      }
      
      internal function setButtons() : *
      {
         var _loc2_:MovieClip = null;
         var _loc1_:* = 0;
         while(_loc1_ <= this.kolPages)
         {
            _loc2_ = this.vis.getChildByName("but" + _loc1_) as MovieClip;
            if(this.page == _loc1_)
            {
               _loc2_.gotoAndStop(2);
            }
            else
            {
               _loc2_.gotoAndStop(1);
            }
            if(_loc1_ == 4 && (this.page == 6 || this.page == 7 || this.page == 8 || this.page == 9))
            {
               _loc2_.gotoAndStop(2);
            }
            _loc1_++;
         }
      }
      
      public function snd(param1:int) : *
      {
         Snd.ps("pip" + param1,-1000,-1000,0,this.pipVol);
      }
      
      public function onoff(param1:int = 0, param2:int = 0) : *
      {
         this.reqKey = false;
         if(this.active && param1 == 11)
         {
            return;
         }
         if(param1 == 0)
         {
            this.active = !this.active;
            if(this.page >= 4 && !this.light)
            {
               this.page = 1;
            }
            this.snd(3);
         }
         else if(param1 > 0)
         {
            if(param1 < 10)
            {
               this.page = param1;
            }
            else if(this.page >= 4)
            {
               this.page = 1;
            }
            this.active = true;
         }
         else
         {
            if(this.active)
            {
               this.snd(3);
            }
            this.active = false;
         }
         if(Boolean(!this.light) && Boolean(World.w.loc) && World.w.loc.base)
         {
            this.travel = true;
         }
         this.vis.but4.visible = false;
         if(param1 == 4 || param1 >= 6 && param1 <= 9)
         {
            this.vis.but4.id.text = param1;
            this.vis.but4.text.text = Res.pipText("main" + param1);
            this.vis.but4.visible = true;
         }
         this.vis.visible = this.active;
         if(this.active)
         {
            World.w.cur();
            this.showHidden = false;
            if(this.vendor)
            {
               this.vendor.reset();
            }
            World.w.ctr.clearAll();
            if(World.w.stand)
            {
               World.w.stand.onoff(-1);
            }
            this.setPage(param2);
            if(!this.light)
            {
               World.w.gui.offCelObj();
               if(World.w.gui.t_mess > 30)
               {
                  World.w.gui.t_mess = 30;
               }
            }
            if(World.w.gui)
            {
               World.w.gui.dial.alpha = World.w.gui.inform.alpha = 0;
            }
            if(Boolean(World.w.gg) && Boolean(World.w.gg.rat > 0) || World.w.catPause)
            {
               this.noAct2 = this.noAct;
               this.noAct = true;
            }
            World.w.gc();
         }
         else
         {
            if(this.isSaveConf)
            {
               World.w.saveConfig();
               this.isSaveConf = false;
            }
            this.vendor = null;
            this.npcId = "";
            World.w.ctr.clearAll();
            World.w.app.detach();
            if(World.w.gui)
            {
               World.w.gui.dial.alpha = World.w.gui.inform.alpha = 1;
            }
            if(Boolean(World.w.gg) && World.w.gg.rat > 0)
            {
               this.noAct = this.noAct2;
            }
         }
         if(!this.light)
         {
            World.w.gui.setEffects();
            this.vis.pr.visible = true;
         }
         this.setButtons();
         if(Boolean(!this.light) && Boolean(World.w.loc) && !World.w.loc.base)
         {
            this.travel = false;
         }
         if(Boolean(World.w) && Boolean(World.w.gg) && Boolean(World.w.gg.pipOff))
         {
            this.supply(-1);
         }
         else
         {
            this.supply(1);
         }
         World.w.ctr.keyPressed = false;
      }
      
      public function resizeScreen(param1:int, param2:int) : *
      {
         if(param1 >= 1200 && param2 >= 800)
         {
            if(param1 > 1320)
            {
               this.vis.x = (param1 - this.visX) / 2 - 60;
               this.vis.y = (param2 - this.visY) / 2;
            }
            else
            {
               this.vis.x = this.vis.y = 0;
            }
            this.vis.scaleX = this.vis.scaleY = 1;
         }
         else
         {
            this.vis.x = this.vis.y = 0;
            if(param1 / 1200 < param2 / 800)
            {
               this.vis.scaleX = this.vis.scaleY = param1 / 1200;
            }
            else
            {
               this.vis.scaleX = this.vis.scaleY = param2 / 800;
            }
         }
      }
      
      public function supply(param1:int = -1) : *
      {
         var _loc2_:String = null;
         if(param1 < 0)
         {
            this.currentPage.vis.visible = false;
            this.vis.toptext.visible = false;
            this.vis.pipError.visible = true;
            this.vis.pipError.nazv.text = Res.pipText("piperror");
            _loc2_ = Res.txt("p","piperror",1);
            this.vis.pipError.info.text = _loc2_.replace(/[\b\r\t]/g,"");
         }
         else
         {
            this.vis.pipError.visible = false;
         }
      }
      
      public function setPage(param1:int = 0) : *
      {
         var _loc2_:* = undefined;
         if(!this.light)
         {
            this.gg = World.w.gg;
            this.inv = World.w.invent;
            this.money = this.inv.money.kol;
            if(this.vendor)
            {
               this.vendor.multPrice = World.w.pers.barterMult;
            }
         }
         for(_loc2_ in this.pages)
         {
            if(this.pages[_loc2_] is PipPage)
            {
               this.pages[_loc2_].vis.visible = false;
            }
         }
         this.currentPage = this.pages[this.page];
         if(this.currentPage is PipPage)
         {
            if(param1 > 0)
            {
               this.currentPage.page2 = param1;
            }
            this.currentPage.setStatus();
         }
         if(!this.light)
         {
            this.setRPanel();
         }
         this.vishelp.visible = false;
      }
      
      public function assignKey(param1:int) : *
      {
         if(!this.active)
         {
            return;
         }
         if(this.currentPage is PipPageInv)
         {
            (this.currentPage as PipPageInv).assignKey(param1);
         }
      }
      
      public function helpShow(param1:MouseEvent) : *
      {
         this.vishelp.txt.htmlText = this.helpText;
         this.vishelp.visible = true;
      }
      
      public function helpUnshow(param1:MouseEvent) : *
      {
         this.vishelp.visible = false;
      }
      
      public function massShow(param1:MouseEvent) : *
      {
         this.vishelp.txt.htmlText = this.massText;
         this.vishelp.visible = true;
      }
      
      public function massUnshow(param1:MouseEvent) : *
      {
         this.vishelp.visible = false;
      }
      
      public function allItems() : *
      {
         var owner:Unit;
         var w:Weapon = null;
         var a:Armor = null;
         var weap:* = undefined;
         var armor:* = undefined;
         this.arrWeapon = new Array();
         this.arrArmor = new Array();
         owner = new Unit();
         for each(weap in AllData.d.weapon.(@tip > 0))
         {
            w = Weapon.create(owner,weap.@id,0);
            this.arrWeapon[weap.@id] = w;
            if(weap.char.length() > 1)
            {
               w = Weapon.create(owner,weap.@id,1);
               this.arrWeapon[weap.@id + "^" + 1] = w;
            }
         }
         for each(armor in AllData.d.armor)
         {
            a = new Armor(armor.@id);
            this.arrArmor[armor.@id] = a;
         }
      }
      
      public function setRPanel() : *
      {
         if(this.light || !this.active)
         {
            return;
         }
         var _loc1_:UnitPlayer = World.w.gg;
         var _loc2_:Pers = World.w.pers;
         this.ritem1(0,_loc1_.hp,_loc1_.maxhp);
         this.ritem1(1,_loc2_.headHP,_loc2_.inMaxHP,!World.w.game.triggers["nomed"]);
         this.ritem1(2,_loc2_.torsHP,_loc2_.inMaxHP,!World.w.game.triggers["nomed"]);
         this.ritem1(3,_loc2_.legsHP,_loc2_.inMaxHP,!World.w.game.triggers["nomed"]);
         this.ritem1(4,_loc2_.bloodHP,_loc2_.inMaxHP,!World.w.game.triggers["nomed"]);
         this.ritem1(5,_loc2_.manaHP,_loc2_.inMaxMana,!World.w.game.triggers["nomed"]);
         if(_loc1_.pet)
         {
            this.ritem1(6,_loc1_.pet.hp,_loc1_.pet.maxhp);
         }
         else
         {
            this.ritem1(6,0,0,false);
         }
         if(Boolean(_loc1_.currentWeapon) && _loc1_.currentWeapon.tip <= 3)
         {
            this.ritem2(7,_loc1_.currentWeapon.hp,_loc1_.currentWeapon.maxhp);
         }
         else
         {
            this.ritem1(7,0,0,false);
         }
         if(_loc1_.currentArmor)
         {
            this.ritem2(8,_loc1_.currentArmor.hp,_loc1_.currentArmor.maxhp);
         }
         else
         {
            this.ritem1(8,0,0,false);
         }
         this.ritems[9].txt.htmlText = "<span class = \'yel\'>" + _loc1_.invent.money.kol + "</span>";
         this.ritem3(10,this.inv.massW,_loc2_.maxmW,World.w.hardInv);
         this.ritem3(11,this.inv.massM,_loc2_.maxmM,World.w.hardInv);
         this.ritem3(12,this.inv.mass[1],_loc2_.maxm1,World.w.hardInv);
         this.ritem3(13,this.inv.mass[2],_loc2_.maxm2,World.w.hardInv);
         this.ritem3(14,this.inv.mass[3],_loc2_.maxm3,World.w.hardInv);
      }
      
      internal function ritem1(param1:int, param2:Number, param3:Number, param4:* = true) : *
      {
         this.ritems[param1].visible = param4;
         if(param4)
         {
            this.ritems[param1].txt.htmlText = "<span class = \'" + this.med(param2,param3) + "\'>" + Math.round(param2) + "</span>" + " / " + Math.round(param3);
         }
         else
         {
            this.ritems[param1].txt.htmlText = "";
         }
      }
      
      internal function ritem2(param1:int, param2:Number, param3:Number, param4:* = true) : *
      {
         this.ritems[param1].visible = param4;
         if(param4)
         {
            this.ritems[param1].txt.htmlText = "<span class = \'" + this.med(param2,param3) + "\'>" + Math.round(param2 / param3 * 100) + "%</span>";
         }
         else
         {
            this.ritems[param1].txt.htmlText = "";
         }
      }
      
      internal function ritem3(param1:int, param2:Number, param3:Number, param4:* = true) : *
      {
         this.ritems[param1].visible = param4;
         if(param4)
         {
            this.ritems[param1].txt.htmlText = "<span class=\'mass\'><span class = \'" + (param2 > param3 ? "red" : "") + "\'>" + Math.round(param2) + "</span>" + " / " + Math.round(param3) + "</span>";
         }
         else
         {
            this.ritems[param1].txt.htmlText = "";
         }
      }
      
      internal function med(param1:Number, param2:Number) : String
      {
         if(param1 < param2 * 0.25)
         {
            return "red";
         }
         if(param1 < param2 * 0.5)
         {
            return "or";
         }
         return "";
      }
      
      public function setArmor(param1:String) : *
      {
         var aid:String = param1;
         this.ArmorId = aid;
         try
         {
            this.hideMane = AllData.d.armor.(@id == aid).@hide;
         }
         catch(err:*)
         {
            hideMane = 0;
         }
      }
      
      public function step() : *
      {
         if(this.currentPage)
         {
            this.currentPage.step();
         }
      }
   }
}

