package fe.inter
{
   import fe.*;
   import fe.graph.Emitter;
   import fe.serv.Script;
   import fe.unit.Invent;
   import fe.unit.Unit;
   import fe.unit.UnitPlayer;
   import fe.weapon.WPaint;
   import fe.weapon.Weapon;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.text.StyleSheet;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class GUI
   {
      
      public var vis:MovieClip;
      
      public var active:Boolean = true;
      
      internal var weapon:TextField;
      
      internal var holder:TextField;
      
      internal var ammo:TextField;
      
      internal var mana:TextField;
      
      internal var celobj:TextField;
      
      internal var info:TextField;
      
      internal var item:TextField;
      
      internal var hp:TextField;
      
      internal var vitem:MovieClip;
      
      internal var mess:MovieClip;
      
      internal var dial:MovieClip;
      
      internal var inform:MovieClip;
      
      internal var imp:MovieClip;
      
      internal var pet:MovieClip;
      
      internal var pr_bar:MovieClip;
      
      internal var levit_poss:MovieClip;
      
      internal var tharrow:MovieClip;
      
      internal var txtTele:String;
      
      internal var txtOpen:String;
      
      internal var txtChance:String;
      
      internal var txtSoft:String;
      
      internal var txtHard:String;
      
      internal var txtVeryHard:String;
      
      internal var txtUnreal:String;
      
      internal var txtUndef0:String;
      
      internal var txtUndef1:String;
      
      internal var txtUndef2:String;
      
      internal var txtClose:String;
      
      internal var txtHeavy:String;
      
      internal var txtMagia:String;
      
      internal var txtArmorMana:String;
      
      internal var txtMagiaOver:String;
      
      internal var txtH2o:String;
      
      internal var txtH2oOver:String;
      
      internal var txtStam:String;
      
      internal var txtUnlock:String;
      
      internal var txtRemine:String;
      
      internal var txtUse:String;
      
      internal var txtHold:String;
      
      internal var txtLock:String;
      
      internal var txtZhopa:String;
      
      internal var txtEmpty:String;
      
      internal var txtDrop:String;
      
      internal var txtOd:String;
      
      public var gg:UnitPlayer;
      
      public var celObj:Obj;
      
      public var prevObj:Obj;
      
      public var t_show:int = 0;
      
      public var guiPause:Boolean = false;
      
      public var showDop:Boolean = false;
      
      public var showFav:Boolean = false;
      
      internal var arr:Array;
      
      internal var arrfav:Array;
      
      internal var wSelN:int = 0;
      
      internal var selMode:int = 0;
      
      internal var prevInfoText:* = "";
      
      internal var bulbText:* = "";
      
      public var style:StyleSheet = new StyleSheet();
      
      internal var styleObj:Object = new Object();
      
      internal var kolStr:int = 0;
      
      internal var t_info:int = 0;
      
      internal var t_sel:int = 0;
      
      internal var t_bulb:int = 0;
      
      internal var t_visibility:int = 30;
      
      internal var float_dy:int = 0;
      
      public var t_item:int = 200;
      
      public var t_od:int = 200;
      
      internal var screenX:int = 1200;
      
      internal var screenY:int = 800;
      
      public var t_mess:int = 0;
      
      internal var a_mess:Number = 0;
      
      internal var id_mess:String = "";
      
      internal var s_mess:String = "";
      
      internal var infoAlpha:* = 1;
      
      internal var realAlpha:* = 1;
      
      internal var kolEff:int = 12;
      
      internal var veff:Array;
      
      internal var effIsVis:Boolean = false;
      
      internal var informScript:Script;
      
      public var dialScript:Script;
      
      public function GUI(param1:MovieClip)
      {
         super();
         this.vis = param1;
         this.vis.mouseChildren = this.vis.mouseEnabled = false;
         this.styleObj.color = "#00FF99";
         this.style.setStyle(".r",this.styleObj);
         this.styleObj.color = "#999999";
         this.style.setStyle(".r0",this.styleObj);
         this.styleObj.color = "#00FFFF";
         this.style.setStyle(".r1",this.styleObj);
         this.styleObj.color = "#FFFF00";
         this.style.setStyle(".r2",this.styleObj);
         this.styleObj.color = "#FF9900";
         this.style.setStyle(".r3",this.styleObj);
         this.styleObj.color = "#FC7FED";
         this.style.setStyle(".r4",this.styleObj);
         this.styleObj.color = "#FF3333";
         this.style.setStyle(".r5",this.styleObj);
         this.styleObj.color = "#BB99FF";
         this.style.setStyle(".r6",this.styleObj);
         this.styleObj.color = "#C4926C";
         this.style.setStyle(".r7",this.styleObj);
         this.styleObj.color = "#98BD34";
         this.style.setStyle(".r8",this.styleObj);
         this.styleObj.color = "#7777FF";
         this.style.setStyle(".r9",this.styleObj);
         this.styleObj.color = "#FF3333";
         this.style.setStyle(".warn",this.styleObj);
         this.styleObj.color = "#FF236A";
         this.style.setStyle(".crim",this.styleObj);
         this.styleObj.fontWeight = "bold";
         this.styleObj.color = "#FFFF00";
         this.style.setStyle(".yel",this.styleObj);
         this.vis.toptext.visible = false;
         PipPage.setStyle(this.vis.toptext.txt);
         this.info = this.vis.info.getChildByName("infoText") as TextField;
         this.info.text = "";
         this.info.autoSize = TextFieldAutoSize.RIGHT;
         this.info.multiline = true;
         this.info.styleSheet = this.style;
         this.vis.odBar.bar.cacheAsBitmap = this.vis.odBar.bar2.cacheAsBitmap = this.vis.odBar.maska.cacheAsBitmap = this.vis.odBar.maska2.cacheAsBitmap = true;
         this.vis.odBar.bar.mask = this.vis.odBar.maska;
         this.vis.odBar.bar2.mask = this.vis.odBar.maska2;
         this.setSats(false);
         this.weapon = this.vis.textWeapon.getChildByName("weapon") as TextField;
         this.weapon.styleSheet = this.style;
         this.holder = this.vis.textWeapon.getChildByName("holder") as TextField;
         this.holder.styleSheet = this.style;
         this.ammo = this.vis.textWeapon.getChildByName("ammo") as TextField;
         this.celobj = this.vis.getChildByName("celObj") as TextField;
         this.celobj.autoSize = TextFieldAutoSize.CENTER;
         this.celobj.styleSheet = this.style;
         this.item = this.vis.textItem.getChildByName("kolItem") as TextField;
         this.mana = this.vis.textMana.getChildByName("mana") as TextField;
         this.hp = this.vis.getChildByName("hp") as TextField;
         this.vitem = this.vis.getChildByName("vItem") as MovieClip;
         this.mess = this.vis.getChildByName("mess") as MovieClip;
         this.dial = this.vis.getChildByName("dial") as MovieClip;
         this.inform = this.vis.getChildByName("inform") as MovieClip;
         this.imp = this.vis.getChildByName("imp") as MovieClip;
         this.pet = this.vis.getChildByName("hpPet") as MovieClip;
         this.pr_bar = this.vis.getChildByName("pr_bar") as MovieClip;
         this.levit_poss = this.vis.getChildByName("levit_poss") as MovieClip;
         this.tharrow = this.vis.getChildByName("tharrow") as MovieClip;
         this.vis.portCel.gotoAndStop(1);
         this.vis.portCel.visible = false;
         this.txtTele = Res.guiText("tele");
         this.txtOpen = Res.guiText("open");
         this.txtSoft = Res.guiText("soft");
         this.txtHard = Res.guiText("hard");
         this.txtVeryHard = Res.guiText("veryhard");
         this.txtUnreal = Res.guiText("unreal");
         this.txtUndef0 = Res.guiText("undef0");
         this.txtUndef1 = Res.guiText("undef1");
         this.txtUndef2 = Res.guiText("undef2");
         this.txtClose = Res.guiText("close");
         this.txtUnlock = Res.guiText("unlock");
         this.txtRemine = Res.guiText("remine");
         this.txtUse = Res.guiText("use");
         this.txtLock = Res.guiText("lock");
         this.txtZhopa = Res.guiText("zhopa");
         this.txtEmpty = Res.guiText("empty");
         this.txtDrop = Res.guiText("drop");
         this.txtHold = Res.guiText("hold");
         this.txtHeavy = Res.guiText("heavy");
         this.txtMagia = Res.guiText("magia");
         this.txtArmorMana = Res.guiText("armormana");
         this.txtChance = Res.guiText("chance");
         this.txtMagiaOver = Res.guiText("magiaover");
         this.txtH2o = Res.guiText("h2o");
         this.txtH2oOver = Res.guiText("h2over");
         this.txtStam = Res.guiText("stam");
         this.txtOd = Res.pipText("ap");
         this.vis.odBar.txt.text = this.txtOd;
         this.vis.selector.visible = false;
         this.vis.fav.visible = false;
         this.vis.status.visible = false;
         this.vis.hpbarboss.visible = false;
         this.mess.alpha = 0;
         this.mess.visible = false;
         this.mess.mess.styleSheet = this.style;
         this.mess.mess.autoSize = TextFieldAutoSize.CENTER;
         this.dial.visible = false;
         this.inform.visible = false;
         this.imp.visible = false;
         this.levit_poss.visible = false;
         this.tharrow.visible = false;
         this.dial.txt.styleSheet = this.style;
         this.inform.txt.styleSheet = this.style;
         this.imp.txt.styleSheet = this.style;
         this.veff = new Array();
         var _loc2_:* = 0;
         while(_loc2_ < this.kolEff)
         {
            this.veff[_loc2_] = this.vis["eff" + _loc2_];
            _loc2_++;
         }
         this.informScript = new Script(<scr act="inform" val="id"/>);
         this.dialScript = new Script(<scr act="dialog" val="id"/>);
         this.vis.inform.but0.addEventListener(MouseEvent.MOUSE_DOWN,this.showHelp);
         this.vis.inform.but0.text.text = Res.guiText("help");
         this.vis.blood.visible = false;
         this.vis.blood.stop();
      }
      
      public function resizeScreen(param1:int, param2:int) : *
      {
         this.screenX = param1;
         this.screenY = param2;
         this.vis.textWeapon.y = param2 - 20;
         this.vis.info.x = param1 - 20;
         this.vis.odBar.x = param1 - 10;
         this.vis.odBar.y = param2 - 10;
         this.vis.visibility.x = param1 - 10;
         this.vis.visibility.y = param2 - 50;
         this.vis.selector.x = param1 / 2;
         this.vis.selector.y = param2 / 2;
         this.vis.sats.scaleX = param1 / 100;
         this.vis.sats.scaleY = param2 / 100;
         this.vis.hpbarboss.x = param1 / 2;
         var _loc3_:* = param1 - 275 * 2;
         if(_loc3_ > 500)
         {
            this.mess.x = 275;
            this.mess.mess.width = param1 - 275 * 2;
         }
         else
         {
            this.mess.mess.width = 500;
            this.mess.x = (param1 - 500) / 2;
         }
         if(this.screenX < 1200)
         {
            this.dial.scaleX = this.dial.scaleY = this.screenX / 1200;
            this.dial.x = 0;
         }
         else
         {
            this.dial.scaleX = this.dial.scaleY = 1;
            this.dial.x = (this.screenX - 1200) / 2;
         }
         this.inform.x = Math.round(this.screenX / 2);
         this.imp.x = Math.round(this.screenX / 2);
         this.imp.y = Math.round(this.screenY / 2 - 50);
      }
      
      public function showSelector(param1:int = 0, param2:int = 0) : *
      {
         var _loc4_:* = undefined;
         var _loc5_:* = undefined;
         var _loc6_:Weapon = null;
         var _loc7_:Object = null;
         if(param1 != 0)
         {
            this.t_sel = 60;
         }
         if(this.vis.selector.visible)
         {
            this.wSelN += param1;
            if(this.wSelN < 0)
            {
               this.wSelN += this.arr.length;
            }
            if(this.wSelN >= this.arr.length)
            {
               this.wSelN -= this.arr.length;
            }
            this.setSelector();
            return;
         }
         this.selMode = param2;
         this.wSelN = 0;
         var _loc3_:Invent = World.w.invent;
         _loc3_.getKolAmmos();
         this.arr = new Array();
         this.arrfav = new Array();
         if(param2 == 0)
         {
            for each(_loc4_ in _loc3_.weapons)
            {
               if(_loc4_ is Weapon)
               {
                  _loc6_ = _loc4_ as Weapon;
                  _loc7_ = {
                     "id":_loc6_.id,
                     "nazv":_loc6_.nazv,
                     "skill":_loc6_.skill,
                     "sort1":_loc6_.skill,
                     "sort2":_loc6_.lvl
                  };
                  if(_loc3_.favIds[_loc6_.id])
                  {
                     _loc7_.fav = _loc3_.favIds[_loc6_.id];
                  }
                  if(_loc6_.tip < 4)
                  {
                     _loc7_.hp = Math.round(_loc6_.hp / _loc6_.maxhp * 100) + "%";
                  }
                  if(_loc6_.ammo != "" && _loc6_.ammo != null)
                  {
                     if(_loc3_.ammos[_loc6_.ammoBase] != null)
                     {
                        _loc7_.ammo = _loc3_.ammos[_loc6_.ammoBase] + _loc6_.hold;
                     }
                     else if(_loc3_.items[_loc6_.ammo] != null)
                     {
                        _loc7_.ammo = _loc3_.items[_loc6_.ammo].kol + _loc6_.hold;
                     }
                     if(_loc6_.ammoBase != "")
                     {
                        _loc7_.ammotip = _loc6_.tip != 4 ? _loc3_.items[_loc6_.ammoBase].nazv : "";
                     }
                  }
                  if(_loc7_.fav > 0)
                  {
                     this.arrfav[_loc7_.fav] = _loc7_;
                  }
                  if(!(_loc6_.respect == 1 || _loc6_.respect == 3 || _loc6_.spell))
                  {
                     if(!(_loc6_.avail() <= 0 && _loc6_ != this.gg.currentWeapon))
                     {
                        if(!(_loc6_.alicorn && !World.w.alicorn))
                        {
                           this.arr.push(_loc7_);
                        }
                     }
                  }
               }
            }
            if(this.arr.length > 1)
            {
               this.arr.sortOn(["sort1","sort2"],[Array.NUMERIC,Array.NUMERIC]);
            }
            for(_loc5_ in this.arr)
            {
               if(Boolean(this.gg.currentWeapon) && this.arr[_loc5_].id == this.gg.currentWeapon.id)
               {
                  this.wSelN = _loc5_;
               }
            }
            _loc5_ = 1;
            for(; _loc5_ <= World.kolHK * 2 + 7; _loc5_++)
            {
               if(_loc5_ == World.kolHK * 2 + 5)
               {
                  if(!this.gg.throwWeapon)
                  {
                     continue;
                  }
                  _loc6_ = this.gg.throwWeapon;
                  _loc7_ = {
                     "id":_loc6_.id,
                     "nazv":_loc6_.nazv,
                     "skill":_loc6_.skill,
                     "fav":_loc5_
                  };
                  if(_loc6_.ammo != "")
                  {
                     _loc7_.ammo = _loc3_.items[_loc6_.ammo].kol;
                  }
               }
               else if(_loc5_ == World.kolHK * 2 + 6)
               {
                  if(!this.gg.magicWeapon)
                  {
                     continue;
                  }
                  _loc6_ = this.gg.magicWeapon;
                  _loc7_ = {
                     "id":_loc6_.id,
                     "nazv":_loc6_.nazv,
                     "skill":_loc6_.skill,
                     "fav":_loc5_
                  };
                  if(_loc6_.ammo != "")
                  {
                     _loc7_.ammo = _loc3_.items[_loc6_.ammo].kol;
                  }
               }
               else if(_loc5_ == World.kolHK * 2 + 7)
               {
                  if(!this.gg.currentSpell)
                  {
                     continue;
                  }
                  _loc7_ = {
                     "id":this.gg.currentSpell.id,
                     "nazv":this.gg.currentSpell.nazv,
                     "fav":_loc5_
                  };
                  if(this.gg.currentSpell.t_culd > 0)
                  {
                     _loc7_.ammo = Math.ceil(this.gg.currentSpell.t_culd / World.fps) + " " + Res.guiText("sec");
                  }
                  else
                  {
                     _loc7_.ammo = Res.guiText("ready");
                  }
               }
               else
               {
                  if(Boolean(this.arrfav[_loc5_]) || _loc3_.fav[_loc5_] == null)
                  {
                     continue;
                  }
                  _loc7_ = {
                     "id":_loc3_.fav[_loc5_],
                     "fav":_loc5_
                  };
                  _loc7_.nazv = Res.txt("i",_loc7_.id);
                  if(!Res.istxt("i",_loc7_.id))
                  {
                     _loc7_.nazv = Res.txt("a",_loc7_.id);
                  }
                  else if(_loc3_.items[_loc7_.id] != null)
                  {
                     _loc7_.ammo = _loc3_.items[_loc7_.id].kol;
                  }
                  else if(_loc3_.items[_loc6_.ammoBase] != null)
                  {
                     _loc7_.ammo = _loc3_.items[_loc6_.ammoBase].kol;
                  }
                  else
                  {
                     _loc7_.ammo = _loc3_.items[_loc6_.ammo].kol;
                  }
                  if(_loc3_.spells[_loc7_.id] != null)
                  {
                     if(_loc3_.spells[_loc7_.id].t_culd > 0)
                     {
                        _loc7_.ammo = Math.ceil(_loc3_.spells[_loc7_.id].t_culd / World.fps) + " " + Res.guiText("sec");
                     }
                     else
                     {
                        _loc7_.ammo = Res.guiText("ready");
                     }
                  }
               }
               this.arrfav[_loc5_] = _loc7_;
            }
            if(this.arr.length > 1 || param1 == 0)
            {
               if(param1 != 0)
               {
                  this.showFav = true;
                  this.vis.selector.visible = true;
                  this.gg.visSel = true;
                  this.setSelector();
               }
               this.setFavs();
               this.setStatus();
            }
            this.gg.pers.setPonpon(this.vis.status.pon);
         }
         else
         {
            if(this.gg.currentWeapon == null || this.gg.currentWeapon.holder <= 0 || this.gg.currentWeapon.ammoBase == "" || this.gg.currentWeapon.recharg > 0 || this.gg.currentWeapon.alicorn || this.gg.currentWeapon.tip >= 4)
            {
               return;
            }
            for each(_loc4_ in _loc3_.items)
            {
               if(Boolean(_loc4_) && _loc4_.base == this.gg.currentWeapon.ammoBase)
               {
                  _loc7_ = {
                     "id":_loc4_.id,
                     "nazv":_loc4_.nazv,
                     "ammo":_loc4_.kol
                  };
                  this.arr.push(_loc7_);
               }
            }
            if(this.arr.length > 1)
            {
               for(_loc5_ in this.arr)
               {
                  if(this.gg.currentWeapon.ammo == this.arr[_loc5_].id)
                  {
                     this.wSelN = _loc5_;
                  }
               }
               this.vis.selector.visible = true;
               this.gg.visSel = true;
               this.setSelector();
            }
         }
      }
      
      public function setFavs() : *
      {
         var mc:MovieClip = null;
         var i:* = 1;
         while(i <= World.kolHK * 2 + 7)
         {
            mc = this.vis.fav.getChildByName("s" + i);
            if(this.arrfav[i])
            {
               mc.visible = true;
               mc.nazv.text = this.arrfav[i].nazv;
               if(this.arrfav[i].ammo != null)
               {
                  mc.ammo.text = this.arrfav[i].ammo;
               }
               else
               {
                  mc.ammo.text = "";
               }
               if(i <= World.kolHK)
               {
                  mc.fav.text = World.w.ctr.retKey("keyWeapon" + this.arrfav[i].fav);
               }
               else if(i <= World.kolHK * 2 + 4)
               {
                  if(i <= World.kolHK * 2)
                  {
                     mc.fav.text = "^" + World.w.ctr.retKey("keyWeapon" + (this.arrfav[i].fav - World.kolHK));
                  }
                  else
                  {
                     mc.fav.text = World.w.ctr.retKey("keySpell" + (this.arrfav[i].fav - World.kolHK * 2));
                  }
                  mc.x = this.screenX - 400;
               }
               else if(i == World.kolHK * 2 + 5)
               {
                  mc.fav.text = World.w.ctr.retKey("keyGrenad");
               }
               else if(i == World.kolHK * 2 + 6)
               {
                  mc.fav.text = World.w.ctr.retKey("keyMagic");
               }
               else if(i == World.kolHK * 2 + 7)
               {
                  mc.fav.text = World.w.ctr.retKey("keyDef");
               }
               try
               {
                  mc.trol.gotoAndStop("w" + this.arrfav[i].skill);
               }
               catch(err:*)
               {
                  mc.trol.gotoAndStop(1);
               }
            }
            else
            {
               mc.visible = false;
            }
            i++;
         }
      }
      
      public function setStatus() : *
      {
         if(Boolean(World.w.game) && Boolean(World.w.game.triggers["nomed"]))
         {
            return;
         }
         this.vis.status.visible = this.active;
      }
      
      public function setSelector() : *
      {
         var n:int;
         var i:*;
         var mc:MovieClip = null;
         if(this.arr == null || this.arr.length == 0)
         {
            return;
         }
         n = this.wSelN - 3;
         if(n < 0)
         {
            n += this.arr.length;
         }
         if(n < 0)
         {
            n += this.arr.length;
         }
         i = 1;
         while(i <= 7)
         {
            mc = this.vis.selector.getChildByName("s" + i);
            if(this.selMode == 1 && (i == 1 || i == 7))
            {
               mc.visible = false;
            }
            else
            {
               mc.visible = true;
            }
            mc.nazv.text = this.arr[n].nazv;
            if(this.arr[n].ammo != null)
            {
               mc.ammo.text = this.arr[n].ammo;
            }
            else
            {
               mc.ammo.text = "";
            }
            if(this.arr[n].fav > World.kolHK && this.arr[n].fav <= World.kolHK * 2)
            {
               mc.fav.text = "^" + World.w.ctr.retKey("keyWeapon" + (this.arr[n].fav - World.kolHK));
            }
            else if(this.arr[n].fav > 0 && this.arr[n].fav <= World.kolHK)
            {
               mc.fav.text = World.w.ctr.retKey("keyWeapon" + this.arr[n].fav);
            }
            else
            {
               mc.fav.text = "";
            }
            try
            {
               mc.trol.gotoAndStop("w" + this.arr[n].skill);
            }
            catch(err:*)
            {
               mc.trol.gotoAndStop(1);
            }
            n++;
            if(n >= this.arr.length)
            {
               n -= this.arr.length;
            }
            i++;
         }
      }
      
      public function unshowSelector(param1:int = 0) : *
      {
         this.t_sel = 0;
         this.vis.selector.visible = this.gg.visSel = false;
         this.showFav = false;
         this.vis.status.visible = false;
         try
         {
            if(param1 > 0)
            {
               if(this.selMode == 0 && (this.gg.currentWeapon == null || this.arr[this.wSelN].id != this.gg.currentWeapon.id))
               {
                  this.gg.changeWeapon(this.arr[this.wSelN].id);
               }
               if(Boolean(this.selMode == 1) && Boolean(this.gg.currentWeapon) && this.gg.currentWeapon.ammo != this.arr[this.wSelN].id)
               {
                  this.gg.currentWeapon.initReload(this.arr[this.wSelN].id);
               }
            }
         }
         catch(err:*)
         {
         }
      }
      
      public function hpBarOnOff(param1:Boolean = true) : *
      {
         this.vis.hpBar.visible = this.vis.hp.visible = this.vis.manaBar.visible = this.vis.xpBar.visible = param1 && this.active;
      }
      
      public function allOff() : *
      {
         this.active = false;
         this.vis.hpBar.visible = this.vis.hp.visible = this.vis.manaBar.visible = this.vis.xpBar.visible = this.vis.textItem.visible = this.vis.textWeapon.visible = this.active;
         this.vis.odBar.visible = this.vis.hpPet.visible = this.vis.vItem.visible = this.vis.textMana.visible = this.active;
         this.vis.eff0.visible = this.vis.eff1.visible = this.vis.eff2.visible = this.vis.eff3.visible = this.vis.eff4.visible = this.vis.eff5.visible = this.active;
         this.vis.hpbarboss.visible = this.active;
      }
      
      public function allOn() : *
      {
         this.active = true;
         this.vis.hpBar.visible = this.vis.hp.visible = this.vis.manaBar.visible = this.vis.xpBar.visible = this.vis.textItem.visible = this.vis.textWeapon.visible = this.vis.textMana.visible = true;
         this.setAll();
      }
      
      public function setHolder() : *
      {
         var _loc1_:Weapon = null;
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc4_:String = null;
         if(this.gg.currentWeapon)
         {
            _loc1_ = this.gg.currentWeapon;
            if(_loc1_.ammo)
            {
               _loc2_ = "";
               _loc3_ = World.w.invent.items[_loc1_.ammo].kol;
               if(_loc1_.tip != 4)
               {
                  if(_loc1_.hold < _loc1_.holder / 4)
                  {
                     _loc2_ = 2;
                  }
                  if(_loc1_.hold < _loc1_.rashod)
                  {
                     _loc2_ = 3;
                  }
                  if(_loc1_.hold + _loc3_ < _loc1_.rashod)
                  {
                     _loc2_ = 5;
                  }
               }
               _loc4_ = "<span class = \'r" + _loc2_ + "\'>";
               if(_loc1_.tip != 4)
               {
                  _loc4_ += _loc1_.hold + "/" + _loc1_.holder + " (" + _loc3_ + ")";
               }
               else
               {
                  _loc4_ += _loc3_ + _loc1_.hold;
               }
               _loc4_ += "</span>";
               this.holder.htmlText = _loc4_;
            }
            else
            {
               this.holder.htmlText = "";
            }
         }
         else
         {
            this.holder.htmlText = "";
         }
      }
      
      public function setWeapon() : *
      {
         var _loc1_:String = null;
         var _loc2_:Weapon = null;
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         if(this.gg.currentWeapon)
         {
            _loc2_ = this.gg.currentWeapon;
            _loc3_ = Math.round(_loc2_.hp / _loc2_.maxhp * 100);
            _loc4_ = "";
            if(_loc3_ <= 0)
            {
               _loc3_ = 0;
               _loc4_ = 5;
            }
            else if(_loc3_ < 20)
            {
               _loc4_ = 3;
            }
            else if(_loc3_ < 50)
            {
               _loc4_ = 2;
            }
            if(_loc2_.avail() == -1)
            {
               _loc4_ = 5;
            }
            _loc1_ = "<span class = \'r" + _loc4_ + "\'>" + _loc2_.nazv;
            if(_loc2_.tip != 0 && _loc2_.tip < 4)
            {
               _loc1_ += " (" + _loc3_ + "%)";
            }
            _loc1_ += "</span>";
            this.weapon.htmlText = _loc1_;
            this.vis.textWeapon.x = 20 + this.weapon.textWidth;
            if(_loc2_.ammo != "" && _loc2_.tip != 4)
            {
               this.ammo.text = World.w.invent.items[_loc2_.ammo].nazv;
            }
            else if(_loc2_.id == "paint")
            {
               this.ammo.text = (_loc2_ as WPaint).paintNazv;
            }
            else
            {
               this.ammo.text = "";
            }
         }
         else
         {
            this.ammo.text = "";
            this.weapon.htmlText = "";
         }
         this.setHolder();
      }
      
      public function setOd() : *
      {
         if(this.gg.currentWeapon == null || this.gg.currentWeapon.noSats)
         {
            this.vis.odBar.visible = false;
         }
         else
         {
            this.vis.odBar.visible = this.active;
         }
         this.t_od = 200;
         this.vis.odBar.bar.scaleX = World.w.sats.odv / 50;
         this.vis.odBar.bar2.scaleX = World.w.sats.od / 50;
      }
      
      public function setItems(param1:int = 0) : *
      {
         var ci:String = null;
         var turn:int = param1;
         if(turn < 0)
         {
            this.vitem.visible = this.item.visible = false;
            this.vitem.gotoAndStop(1);
            this.item.text = "";
            return;
         }
         if(World.w.invent.cItem < 0)
         {
            this.vitem.visible = this.item.visible = false;
            this.vitem.gotoAndStop(1);
            this.item.text = "";
         }
         else
         {
            this.t_item = 200;
            ci = World.w.invent.itemsId[World.w.invent.cItem];
            this.vitem.visible = this.item.visible = this.active;
            try
            {
               this.vitem.gotoAndStop(ci);
            }
            catch(err:*)
            {
               vitem.gotoAndStop(1);
            }
            this.item.text = Res.txt("i",ci) + " (" + World.w.invent.items[ci].kol + ")";
         }
         this.setOtstup();
      }
      
      public function setHp() : *
      {
         if(this.gg.hp > 0)
         {
            this.vis.hpBar.hp.scaleX = this.gg.hp / this.gg.maxhp;
            this.vis.hpBar.healhp.scaleX = Math.min(1,(this.gg.hp + this.gg.healhp) / this.gg.maxhp);
            if(this.gg.rad <= this.gg.maxhp)
            {
               this.vis.hpBar.rad.scaleX = this.gg.rad / this.gg.maxhp;
            }
            this.hp.text = Math.ceil(this.gg.hp) + "/" + Math.ceil(this.gg.maxhp);
            if(this.gg.hp / this.gg.maxhp < 0.2 && this.vis.hpBar.hp.currentFrame == 1)
            {
               this.vis.hpBar.hp.gotoAndPlay(2);
            }
            if(this.gg.hp / this.gg.maxhp >= 0.2 && this.vis.hpBar.hp.currentFrame != 1)
            {
               this.vis.hpBar.hp.gotoAndStop(1);
            }
         }
         else
         {
            this.vis.hpBar.hp.scaleX = 0;
            this.vis.hpBar.healhp.scaleX = 0;
            this.hp.text = "";
         }
         if(this.gg.drad > 1)
         {
            this.vis.hpBar.drad.alpha = 1;
         }
         else
         {
            this.vis.hpBar.drad.alpha = this.gg.drad;
         }
      }
      
      public function setVisibility() : *
      {
         if(World.w.pip.active || !this.gg.showObsInd || this.gg.obs < 3)
         {
            this.vis.visibility.visible = false;
         }
         else
         {
            this.vis.visibility.visible = true;
            this.vis.visibility.gotoAndStop(Math.floor(this.gg.obs / this.gg.maxObs * 40 + 1));
            World.w.cam.setKoord(this.vis.visibility,this.gg.X,this.gg.Y - 80);
         }
      }
      
      public function setMana() : *
      {
         if(this.gg.mana < 10)
         {
            this.mana.text = this.txtMagiaOver;
         }
         else if(this.gg.mana < 995 || this.gg.t_culd > 0 || Boolean(this.gg.currentSpell) && Boolean(this.gg.currentSpell.t_culd > 0))
         {
            this.mana.text = this.txtMagia + " " + Math.round(this.gg.mana / 10) + "%";
         }
         else
         {
            this.mana.text = "";
         }
         this.vis.manaBar.mana.scaleX = this.gg.pers.manaHP / this.gg.pers.inMaxMana;
         if(Boolean(this.gg.teleObj) && this.gg.teleObj.massa > 0.1)
         {
            this.mana.appendText(" " + Math.round(this.gg.teleObj.massa * 50) + "kg");
         }
         if(this.gg.dmana < -5)
         {
            this.mana.appendText(" (" + this.txtHeavy + ")");
         }
         if(this.gg.h2o < 500)
         {
            if(this.mana.text != "")
            {
               this.mana.text += "\n";
            }
            if(this.gg.h2o < 10)
            {
               this.mana.text += this.txtH2oOver;
            }
            else
            {
               this.mana.text += this.txtH2o + " " + Math.round(this.gg.h2o / 10) + "%";
            }
         }
         if(this.gg.stam < 500 || World.w.testBattle && this.gg.stam < 980)
         {
            if(this.mana.text != "")
            {
               this.mana.text += "\n";
            }
            if(this.gg.stam < 10)
            {
               this.mana.text += this.txtStam + " 0%";
            }
            else
            {
               this.mana.text += this.txtStam + " " + Math.round(this.gg.stam / 10) + "%";
            }
         }
         if(Boolean(this.gg.currentArmor) && this.gg.currentArmor.mana < this.gg.currentArmor.maxmana)
         {
            if(this.mana.text != "")
            {
               this.mana.text += "\n";
            }
            this.mana.text += this.txtArmorMana + " " + Math.round(this.gg.currentArmor.mana / this.gg.currentArmor.maxmana * 100) + "%";
         }
         if(this.gg.t_culd > 0 || Boolean(this.gg.currentSpell) && Boolean(this.gg.currentSpell.t_culd > 0))
         {
            this.mana.alpha = 0.6;
         }
         else
         {
            this.mana.alpha = 1;
         }
         this.setOtstup();
      }
      
      public function setXp() : *
      {
         var _loc1_:Number = (this.gg.pers.xpCur - this.gg.pers.xpPrev) / (this.gg.pers.xpNext - this.gg.pers.xpPrev);
         this.vis.xpBar.xp.scaleX = _loc1_;
      }
      
      internal function setOtstup() : *
      {
         if(this.pet.visible)
         {
            this.vitem.y = 70 + 30;
            this.vis.textItem.y = 58 + 30;
         }
         else
         {
            this.vitem.y = 70;
            this.vis.textItem.y = 58;
         }
         if(this.vitem.visible)
         {
            this.vis.textMana.y = this.vis.textItem.y + 35;
         }
         else
         {
            this.vis.textMana.y = this.vis.textItem.y;
         }
      }
      
      public function setPet() : *
      {
         if(this.gg.pet)
         {
            this.pet.visible = true;
            if(this.gg.pet.hp > 0)
            {
               this.pet.hp.visible = true;
               this.pet.hp.scaleX = this.gg.pet.hp / this.gg.pet.maxhp;
            }
            else
            {
               this.pet.hp.visible = false;
            }
            if(this.gg.noPet > 0)
            {
               this.pet.txt.text = Math.floor(this.gg.noPet / World.fps);
            }
            else
            {
               this.pet.txt.text = "";
            }
            this.pet.ico.visible = this.gg.noPet == 0;
         }
         else
         {
            this.pet.visible = false;
         }
         this.setOtstup();
      }
      
      public function offCelObj() : *
      {
         this.celObj = World.w.loc.celObj = null;
         this.celobj.visible = false;
         this.unshowSelector();
      }
      
      public function setTopText(param1:String = "") : *
      {
         var _loc2_:String = null;
         var _loc3_:RegExp = null;
         if(param1 != "")
         {
            this.vis.toptext.visible = true;
            _loc2_ = Res.txt("g",param1,0,true);
            _loc3_ = /@/g;
            this.vis.toptext.txt.htmlText = _loc2_.replace(_loc3_,"\n");
         }
         else
         {
            this.vis.toptext.visible = false;
         }
      }
      
      public function setEffects() : *
      {
         var n:int = 0;
         var t1:Boolean = false;
         var t2:Boolean = false;
         var t3:Boolean = false;
         var t4:Boolean = false;
         var i:* = undefined;
         if(!this.active)
         {
            return;
         }
         try
         {
            n = 0;
            t1 = false;
            t2 = false;
            t3 = false;
            t4 = false;
            this.effIsVis = false;
            i = 0;
            while(i < this.kolEff)
            {
               if(World.w.pip.active)
               {
                  this.veff[i].alpha = 0.2;
               }
               else
               {
                  this.veff[i].alpha = 1;
               }
               if(!t1 && this.gg.cut > 0)
               {
                  this.veff[i].visible = this.effIsVis = true;
                  this.veff[i].txt.text = Math.round(this.gg.cut * 10) / 10;
                  this.veff[i].vis.gotoAndStop("cut");
                  t1 = true;
               }
               else
               {
                  t1 = true;
                  if(!t2 && this.gg.poison > 0)
                  {
                     this.veff[i].visible = this.effIsVis = true;
                     this.veff[i].txt.text = Math.round(this.gg.poison * 10) / 10;
                     this.veff[i].vis.gotoAndStop("poison");
                     t2 = true;
                  }
                  else
                  {
                     t2 = true;
                     if(!t3 && this.gg.shithp > 0)
                     {
                        this.veff[i].visible = this.effIsVis = true;
                        this.veff[i].txt.text = Math.ceil(this.gg.shithp);
                        this.veff[i].vis.gotoAndStop("shit");
                        t3 = true;
                     }
                     else
                     {
                        t2 = true;
                        if(n < this.gg.effects.length && !this.gg.effects[n].vse)
                        {
                           this.veff[i].visible = this.effIsVis = true;
                           if(!this.gg.effects[n].forever)
                           {
                              this.veff[i].txt.text = Math.floor(this.gg.effects[n].t / 30);
                           }
                           else
                           {
                              this.veff[i].txt.text = "∞";
                           }
                           try
                           {
                              if(this.gg.effects[n].tip == 3)
                              {
                                 this.veff[i].vis.gotoAndStop("food");
                              }
                              else
                              {
                                 this.veff[i].vis.gotoAndStop(this.gg.effects[n].id);
                              }
                           }
                           catch(err:*)
                           {
                              veff[i].vis.gotoAndStop(1);
                           }
                           n++;
                        }
                        else
                        {
                           this.veff[i].visible = false;
                        }
                     }
                  }
               }
               i++;
            }
         }
         catch(err:*)
         {
         }
      }
      
      public function setCelObj() : *
      {
         var warn:*;
         var s:String = null;
         var perc:Number = NaN;
         var acts:String = null;
         this.celObj = World.w.loc.celObj;
         if(this.celObj != this.prevObj)
         {
            if(Boolean(World.w.shineObjs && this.prevObj) && Boolean(this.prevObj.vis) && this.prevObj.levit == 0)
            {
               this.prevObj.vis.transform.colorTransform = this.prevObj.cTransform;
            }
         }
         warn = "r";
         this.levit_poss.visible = false;
         if(World.w.pip.active)
         {
            return;
         }
         this.pr_bar.visible = false;
         if(this.gg.teleObj)
         {
            World.w.cur("action");
            this.celobj.visible = true;
            if(this.gg.teleObj.warn > 0)
            {
               warn = "warn";
            }
            s = "<span class = \'" + warn + "\'>" + this.gg.teleObj.nazv + "</span>";
            if(World.w.hintTele)
            {
               s += "\n" + World.w.ctr.retKey("keyTele") + " - " + this.txtDrop;
            }
            this.celobj.text = s;
            World.w.cam.setKoord(this.celobj,this.gg.teleObj.X,this.gg.teleObj.Y);
         }
         else if(this.gg.actionObj != null && Boolean(this.gg.actionObj.owner))
         {
            World.w.cur("action");
            try
            {
               this.celobj.visible = true;
               s = this.gg.actionObj.owner.nazv;
               perc = (this.gg.mt_action - this.gg.t_action) / this.gg.mt_action;
               if(perc > 1)
               {
                  perc = 1;
               }
               if(perc < 0)
               {
                  perc = 0;
               }
               this.pr_bar.visible = true;
               this.pr_bar.pr.scaleX = perc;
               s += "\n" + this.gg.actionObj.actionText;
               this.celobj.text = s;
               World.w.cam.setKoord(this.celobj,this.gg.actionObj.owner.X,this.gg.actionObj.owner.Y);
               World.w.cam.setKoord(this.pr_bar,this.gg.actionObj.owner.X,this.gg.actionObj.owner.Y);
            }
            catch(err:*)
            {
               celobj.visible = false;
            }
         }
         else if(this.celObj)
         {
            if(this.t_show > 0)
            {
               this.celobj.visible = false;
               return;
            }
            this.celobj.visible = true;
            if(this.celObj.warn > 0)
            {
               warn = "warn";
            }
            s = "<span class = \'" + warn + "\'>" + this.celObj.nazv + "</span>";
            if(Boolean(this.celObj.inter) && this.celObj.inter.stateText != "")
            {
               s += " [" + this.celObj.inter.stateText + "]";
            }
            if(!World.w.loc.base && this.celObj.stay && this.celObj.levitPoss && World.w.loc.celDist <= World.w.pers.teleDist && this.celObj.massa <= World.w.pers.maxTeleMassa)
            {
               if(World.w.hintTele)
               {
                  s += "\n" + World.w.ctr.retKey("keyTele") + " - " + this.txtTele;
               }
               if(World.w.shineObjs && Boolean(this.celObj.vis))
               {
                  this.celObj.vis.transform.colorTransform = this.gg.shineTransform;
               }
               this.levit_poss.visible = true;
               World.w.cam.setKoord(this.levit_poss,this.celObj.X,this.celObj.Y - 5);
            }
            if(Boolean(this.celObj.inter && this.celObj.inter.active && this.celObj.inter.action) && Boolean(World.w.loc.celDist <= World.w.actionDist) && World.w.gg.rat == 0)
            {
               World.w.cur("action");
               if(!World.w.loc.base && (this.celObj.inter.mine > 0 || this.celObj.inter.lock > 0) && !this.celObj.inter.is_act || Boolean(this.celObj.inter.t_action))
               {
                  if(Boolean(this.celObj.inter.mine <= 0 && this.celObj.inter.lock > 0) && Boolean(this.celObj.inter.lockKey) && Boolean(this.gg.invent.items[this.celObj.inter.lockKey]) && this.gg.invent.items[this.celObj.inter.lockKey].kol > 0)
                  {
                     s += "\n";
                     if(World.w.hintKeys)
                     {
                        s += World.w.ctr.retKey("keyAction") + " (" + this.txtHold + ") - ";
                     }
                     s += Res.guiText("usekey");
                  }
                  else if(Boolean(this.celObj.inter.mine <= 0 && this.celObj.inter.lock > 0) && Boolean(this.celObj.inter.lockKey) && this.celObj.inter.lockTip == 0)
                  {
                     s += "\n(<span class = \'r5\'>" + Res.guiText("required") + " " + Res.txt("i",this.celObj.inter.lockKey) + "</span>)";
                  }
                  else if(this.celObj.inter.lock < 100)
                  {
                     if(this.celObj.inter.mine == 0 && this.celObj.inter.lock > 0 && this.celObj.inter.lockTip == 0)
                     {
                        s += "\n(<span class = \'r3\'>" + this.txtUndef0 + "</span>)";
                     }
                     else if(this.celObj.inter.actionText != "")
                     {
                        acts = "\n";
                        if(World.w.hintKeys)
                        {
                           acts += World.w.ctr.retKey("keyAction") + " (" + this.txtHold + ") - ";
                        }
                        acts += this.celObj.inter.actionText;
                        if(this.celObj.inter.mine > 0)
                        {
                           s += acts + this.dif(this.celObj.inter.mine,this.celObj.inter.mineTip);
                        }
                        else if(this.celObj.inter.lock > 0)
                        {
                           if(this.celObj.inter.lockTip == 1 || this.celObj.inter.lockTip == 2)
                           {
                              if(World.w.pers.getLockMaster(this.celObj.inter.lockTip) < this.celObj.inter.lockLevel)
                              {
                                 s += "\n(<span class = \'r3\'>" + this["txtUndef" + this.celObj.inter.lockTip] + "</span>)";
                              }
                              else
                              {
                                 s += acts + "\n" + this.diflock(this.celObj.inter.getChance(this.celObj.inter.lock - World.w.pers.getLockTip(this.celObj.inter.lockTip)));
                              }
                           }
                           else
                           {
                              s += acts + this.dif(this.celObj.inter.lock,this.celObj.inter.lockTip);
                           }
                        }
                        else
                        {
                           s += acts;
                        }
                        if(Boolean(this.celObj.inter.lockTip == 1 && this.celObj.inter.lock > 0 && this.celObj.inter.mine == 0) && Boolean(World.w.invent) && World.w.invent.pin.kol > 0)
                        {
                           s += " {<span class = \'r2\'>" + World.w.invent.pin.kol + "</span>}";
                        }
                        if(this.celObj.inter.cons)
                        {
                           s += "\n(" + Res.guiText("required") + ": " + Res.txt("i",this.celObj.inter.cons) + ")";
                        }
                     }
                  }
               }
               else
               {
                  s += "\n";
                  if(World.w.hintKeys)
                  {
                     s += World.w.ctr.retKey("keyAction") + " - ";
                  }
                  s += this.celObj.inter.actionText;
               }
            }
            else if(this.celObj.warn > 0)
            {
               World.w.cur("combat");
            }
            else
            {
               World.w.cur("target");
            }
            if(Boolean(this.celObj.inter) && World.w.loc.celDist <= World.w.actionDist)
            {
               acts = "\n<span class = \'r3\'>";
               if(World.w.hintKeys)
               {
                  acts += World.w.ctr.retKey("keyCrack") + " - ";
               }
               if(this.celObj.inter.mineTip == 6 && this.celObj.inter.mine > 0)
               {
                  s += acts + Res.guiText("actalarm") + "</span>";
               }
               else if(this.celObj.inter.lockTip == 1 && Boolean(this.celObj.inter.needRuna(this.gg)))
               {
                  s += acts + Res.guiText("runa") + "</span>";
               }
               else if(this.celObj.inter.lockTip == 2 && Boolean(this.celObj.inter.needRuna(this.gg)))
               {
                  s += acts + Res.guiText("reboot") + "</span>";
               }
            }
            if(this.gg.showObsInd && this.celObj is Unit && (this.celObj as Unit).fraction != Unit.F_PLAYER && !(this.celObj as Unit).doop && (this.celObj as Unit).observ > this.gg.sneak + 1)
            {
               s += " <span class = \'r1\'>(ʘ)</span>";
            }
            this.celobj.htmlText = s;
            World.w.cam.setKoord(this.celobj,this.celObj.X,this.celObj.Y);
         }
         else
         {
            this.celobj.visible = false;
            World.w.cur("target");
         }
         if(this.celobj.visible)
         {
            this.celobj.x -= this.celobj.width / 2;
            if(this.celobj.y > World.w.cam.screenY - 40 - this.celobj.height)
            {
               this.celobj.y = this.pr_bar.y = World.w.cam.screenY - 40 - this.celobj.height;
            }
         }
         this.prevObj = this.celObj;
      }
      
      internal function dif(param1:int, param2:int) : String
      {
         var _loc3_:* = World.w.pers.getLockTip(param2);
         var _loc4_:String = "";
         if(param1 < _loc3_)
         {
            _loc4_ = this.txtSoft;
         }
         else if(param1 > _loc3_ + 2)
         {
            _loc4_ = "<span class = \'warn\'>" + this.txtUnreal + "</span>";
         }
         else if(param1 > _loc3_ + 1)
         {
            _loc4_ = "<span class = \'r3\'>" + this.txtVeryHard + "</span>";
         }
         else if(param1 > _loc3_)
         {
            _loc4_ = "<span class = \'r2\'>" + this.txtHard + "</span>";
         }
         if(_loc4_ != "")
         {
            return "\n (" + _loc4_ + ")";
         }
         return "";
      }
      
      internal function diflock(param1:Number) : String
      {
         var _loc2_:String = this.txtChance + ": ";
         if(param1 < 0.1)
         {
            _loc2_ += "<span class = \'warn\'>";
         }
         else if(param1 < 0.3)
         {
            _loc2_ += "<span class = \'r3\'>";
         }
         else if(param1 < 0.5)
         {
            _loc2_ += "<span class = \'r2\'>";
         }
         else
         {
            _loc2_ += "<span>";
         }
         return _loc2_ + (Math.round(param1 * 100) + "%</span>");
      }
      
      public function setAll() : *
      {
         this.setWeapon();
         this.setItems();
         this.setMana();
         this.setHp();
         this.setXp();
         this.setOd();
         this.setEffects();
         this.setPet();
      }
      
      internal function showPortCel() : *
      {
         this.vis.portCel.visible = true;
         var _loc1_:* = Math.round(World.w.celX / World.tileX) * World.tileX;
         var _loc2_:* = Math.round(World.w.celY / World.tileY) * World.tileY;
         World.w.cam.setKoord(this.vis.portCel,_loc1_,_loc2_);
         if(this.gg.checkPort())
         {
            if(this.gg.t_port < this.gg.pers.portTime)
            {
               this.vis.portCel.gotoAndStop(1);
            }
            else
            {
               this.vis.portCel.gotoAndStop(2);
            }
         }
         else
         {
            this.vis.portCel.gotoAndStop(3);
         }
      }
      
      public function infoText(param1:String, param2:* = 0, param3:* = null, param4:Boolean = true) : *
      {
         var _loc5_:String = Res.txt("f",param1);
         _loc5_ = _loc5_.replace("@1","<b>" + param2 + "</b>");
         if(param3 != null)
         {
            _loc5_ = _loc5_.replace("@2",param3);
         }
         if(_loc5_ != this.prevInfoText)
         {
            this.bulbText = _loc5_;
            this.info.htmlText += this.bulbText + "<br>";
            if(param4)
            {
               World.w.log += this.bulbText + "<br>";
            }
            ++this.kolStr;
            this.t_info = 150;
            if(this.kolStr > 6)
            {
               this.remStr();
            }
         }
         this.prevInfoText = _loc5_;
      }
      
      public function infoEffText(param1:String) : *
      {
         var _loc2_:String = Res.txt("e",param1,2);
         if(_loc2_ == null || _loc2_ == "")
         {
            return;
         }
         this.info.htmlText += _loc2_ + "<br>";
         ++this.kolStr;
         this.t_info = 150;
         if(this.kolStr > 6)
         {
            this.remStr();
         }
      }
      
      public function bulb(param1:int, param2:int) : *
      {
         if(this.t_bulb > 0)
         {
            return;
         }
         Emitter.emit("gui",World.w.loc,param1,param2 - 110,{
            "txt":this.bulbText,
            "ry":50
         });
         this.t_bulb = 20;
      }
      
      public function floatText(param1:String, param2:int, param3:int, param4:int = -1) : *
      {
         var _loc5_:String = param1;
         if(param4 >= 0)
         {
            _loc5_ = "<span class = \'r" + param4 + "\'>" + param1 + "</span>";
         }
         if(this.t_bulb <= 0)
         {
            this.float_dy = 0;
         }
         else
         {
            this.float_dy -= 20;
         }
         param3 = param3 - 80 + this.float_dy;
         if(param3 < 40)
         {
            param3 -= 100;
         }
         if(param2 < 50)
         {
            param2 = 50;
         }
         if(param2 > World.w.loc.limX - 50)
         {
            param2 = World.w.loc.limX - 50;
         }
         Emitter.emit("take",World.w.loc,param2,param3,{"txt":_loc5_});
         this.t_bulb = 10;
      }
      
      public function remStr() : *
      {
         if(this.kolStr <= 1)
         {
            this.info.htmlText = "";
         }
         else
         {
            this.info.htmlText = this.info.htmlText.substr(this.info.htmlText.search("<br>") + 4);
         }
         if(this.kolStr > 0)
         {
            --this.kolStr;
         }
      }
      
      public function messText(param1:String, param2:String = "", param3:Boolean = false, param4:Boolean = false, param5:* = 150) : *
      {
         this.t_mess = param5;
         var _loc6_:String = "";
         if(param1 != "" && param1 + "_" + param2 != this.id_mess)
         {
            if(param1 != "")
            {
               _loc6_ = Res.messText(param1);
            }
            this.id_mess = param1 + "_" + param2;
         }
         if(param2 != "")
         {
            _loc6_ += " " + param2;
         }
         if(_loc6_ != "")
         {
            if(param4)
            {
               this.mess.mess.htmlText += "<br>" + _loc6_;
            }
            else
            {
               this.mess.mess.htmlText = _loc6_;
            }
            if(param3)
            {
               this.mess.y = this.screenY - 50 - this.mess.height;
            }
            else
            {
               this.mess.y = 50;
            }
         }
      }
      
      public function hpBarBoss(param1:Number = 0) : *
      {
         if(param1 <= 0)
         {
            this.vis.hpbarboss.visible = false;
         }
         else
         {
            this.vis.hpbarboss.visible = true;
            this.vis.hpbarboss.bar.scaleX = param1;
         }
      }
      
      public function informText(param1:String, param2:Boolean = false) : *
      {
         if(param2)
         {
            this.vis.mouseChildren = this.vis.mouseEnabled = true;
         }
         this.informScript.acts[0].val = param1;
         this.informScript.acts[0].opt2 = param2 ? 2 : 1;
         this.informScript.start();
      }
      
      public function dialog(param1:String) : *
      {
         this.dialScript.acts[0].val = param1;
         this.dialScript.start();
      }
      
      public function showHelp(param1:MouseEvent) : *
      {
         World.w.ctr.active = false;
         World.w.ctr.keyPressed = false;
         if(World.w.loc.prob)
         {
            this.informText(World.w.loc.prob.info + "<br><br>" + World.w.loc.prob.help);
         }
         param1.stopPropagation();
      }
      
      public function scrollClick(param1:MouseEvent) : *
      {
         World.w.ctr.active = false;
         World.w.ctr.keyPressed = false;
         param1.stopPropagation();
      }
      
      public function dialText(param1:* = null, param2:int = -1, param3:Boolean = false, param4:Boolean = true) : Boolean
      {
         var reg:int;
         var s:String;
         var i:*;
         var xml:* = undefined;
         var sar:Array = null;
         var sp:String = null;
         var id:* = param1;
         var n:int = param2;
         var down:Boolean = param3;
         var wait:Boolean = param4;
         if(id == null)
         {
            this.dial.visible = this.inform.visible = false;
            this.vis.mouseChildren = this.vis.mouseEnabled = false;
            return false;
         }
         if(id is String)
         {
            xml = Res.d.txt.(@id == id);
            if(xml.length() == 0)
            {
               xml = Res.e.txt.(@id == id);
            }
            if(xml.length() == 0)
            {
               return false;
            }
            xml = xml.n[0];
            if(xml.length() == 0)
            {
               return false;
            }
            if(n >= 0)
            {
               xml = xml.r[n];
               if(xml == null)
               {
                  return false;
               }
            }
            World.w.game.addNote(id);
         }
         else if(id is XML)
         {
            xml = id;
         }
         reg = 0;
         if(xml.@mod.length())
         {
            reg = int(xml.@mod);
         }
         if(reg == 0)
         {
            this.dial.visible = true;
         }
         else
         {
            this.inform.visible = true;
         }
         s = xml.toString();
         if(Boolean(xml) && Boolean(xml.@m.length()))
         {
            sar = s.split("|");
            if(sar)
            {
               if(World.w.matFilter && sar.length > 1)
               {
                  s = sar[1];
               }
               else
               {
                  s = sar[0];
               }
            }
         }
         i = 1;
         while(i <= 5)
         {
            if(xml.attribute("s" + i).length())
            {
               s = s.replace("@" + i,"<span class=\'imp\'>" + World.w.ctr.retKey(xml.attribute("s" + i)) + "</span>");
            }
            i++;
         }
         s = s.replace(/\[/g,"<span class=\'yel\'>");
         s = s.replace(/\]/g,"</span>");
         s = s.replace(/[\b\r\t]/g,"");
         s = Res.lpName(s);
         if(reg == 0)
         {
            this.inform.visible = false;
            this.dial.portret.gotoAndStop(1);
            if(xml.@p.length())
            {
               sp = xml.@p;
               if(sp.substr(0,2) == "lp" && World.w.alicorn)
               {
                  sp = "lpa";
                  s = "<span class=\'crim\'>" + s + "</span>";
               }
               try
               {
                  this.dial.portret.gotoAndStop(sp);
               }
               catch(err:*)
               {
                  dial.portret.gotoAndStop(1);
               }
            }
            if(xml.@push > 0)
            {
               this.dial.txt.htmlText += "<br>" + s;
            }
            else
            {
               this.dial.txt.htmlText = s;
            }
            this.dial.lmb.visible = wait;
            if(wait)
            {
               this.dial.lmb.play();
            }
            else
            {
               this.dial.lmb.stop();
            }
         }
         else if(reg >= 1)
         {
            this.dial.visible = false;
            if(xml.@push > 0)
            {
               this.inform.txt.htmlText += "<br><br>" + s;
            }
            else
            {
               this.inform.txt.htmlText = s;
            }
            this.inform.txt.scrollV = 0;
            this.inform.lmb.visible = wait;
            if(wait)
            {
               this.inform.lmb.play();
            }
            else
            {
               this.inform.lmb.stop();
            }
            this.inform.but0.visible = reg == 2;
            if(this.inform.scText)
            {
               this.inform.scText.visible = false;
            }
            if(this.inform.txt.height < this.inform.txt.textHeight && Boolean(this.inform.scText))
            {
               this.inform.scText.maxScrollPosition = this.inform.txt.maxScrollV;
               this.inform.scText.visible = true;
            }
         }
         return true;
      }
      
      public function impMess(param1:String, param2:String, param3:String = "") : *
      {
         var ntitle:String = param1;
         var ntext:String = param2;
         var nico:String = param3;
         World.w.ctr.active = false;
         World.w.ctr.keyPressed = false;
         this.imp.ico.gotoAndStop(1);
         if(nico != "")
         {
            try
            {
               this.imp.ico.gotoAndStop(nico);
            }
            catch(err:*)
            {
               imp.ico.gotoAndStop(1);
            }
         }
         this.imp.title.text = ntitle;
         this.imp.txt.y = this.imp.ico.y + this.imp.ico.height + 15;
         this.imp.txt.htmlText = ntext;
         this.imp.visible = true;
         Snd.ps("quest");
         this.t_bulb = 30;
         this.gg.stopAnim();
         this.guiPause = true;
      }
      
      public function critHP() : *
      {
         Snd.ps("lowhp");
         if(this.vis.blood)
         {
            this.vis.blood.visible = true;
            this.vis.blood.gotoAndPlay(1);
         }
      }
      
      public function step() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         var _loc3_:Number = NaN;
         this.setCelObj();
         if(this.kolStr > 0 && !this.dialScript.running)
         {
            --this.t_info;
            if(this.t_info == 0)
            {
               this.remStr();
            }
            if(this.t_info == 100)
            {
               this.prevInfoText = "";
            }
            if(this.t_info <= 0 && this.kolStr > 0)
            {
               this.t_info = 60;
            }
         }
         if(Math.abs(this.infoAlpha - this.realAlpha) > 0.01)
         {
            if(this.infoAlpha > this.realAlpha)
            {
               this.realAlpha += 0.1;
            }
            if(this.infoAlpha < this.realAlpha)
            {
               this.realAlpha -= 0.1;
            }
         }
         if(this.gg.t_port > 15)
         {
            this.showPortCel();
         }
         else
         {
            this.vis.portCel.visible = false;
         }
         if(Math.abs(this.vis.info.alpha - this.realAlpha) > 0.05)
         {
            this.vis.info.alpha = this.realAlpha;
         }
         if(Boolean(this.gg.h2o < 500 || this.gg.stam < 500 || this.gg.mana < 1000 || this.gg.teleObj || this.gg.t_culd > 0 || this.gg.currentArmor && this.gg.currentArmor.mana < this.gg.currentArmor.maxmana) || Boolean(World.w.testBattle && this.gg.stam < 980) || Boolean(this.gg.currentSpell) && Boolean(this.gg.currentSpell.t_culd > 0))
         {
            this.setMana();
         }
         else if(this.mana.text != "")
         {
            this.mana.text = "";
         }
         if(Boolean(this.gg.effects.length || this.gg.poison > 0 || this.gg.cut > 0) || Boolean(this.gg.shithp > 0) || this.effIsVis)
         {
            this.setEffects();
         }
         if(this.t_sel > 0)
         {
            --this.t_sel;
         }
         if(this.t_sel == 1)
         {
            this.unshowSelector(1);
         }
         if(this.t_od > 0)
         {
            --this.t_od;
         }
         if(this.t_od == 1)
         {
            this.vis.odBar.visible = false;
         }
         if(this.t_bulb > 0)
         {
            --this.t_bulb;
         }
         if(this.t_item > 0)
         {
            --this.t_item;
         }
         if(this.t_item == 1)
         {
            this.setItems(-1);
         }
         if(this.gg.currentWeapon)
         {
            this.setHolder();
         }
         this.setVisibility();
         if(this.t_mess > 0)
         {
            --this.t_mess;
            if(this.mess.alpha < 1)
            {
               this.mess.alpha += 0.1;
            }
            if(this.mess.alpha > 1)
            {
               this.mess.alpha = 1;
            }
            if(!this.mess.visible)
            {
               this.mess.visible = true;
            }
         }
         else
         {
            if(this.mess.alpha > 0)
            {
               this.mess.alpha -= 0.01;
            }
            if(this.mess.alpha <= 0 && this.mess.visible)
            {
               this.mess.visible = false;
            }
         }
         if(this.informScript.running)
         {
            this.informScript.step();
         }
         if(this.dialScript.running)
         {
            this.dialScript.step();
         }
         if(World.w.ctr.active && this.guiPause)
         {
            if(this.t_bulb <= 0)
            {
               this.guiPause = false;
               this.imp.visible = false;
            }
            else
            {
               World.w.ctr.active = false;
            }
         }
         if(Boolean(this.gg.teleObj) && Boolean(this.gg.pers.throwForce > 0) && this.gg.teleObj.massa > 0.1)
         {
            this.tharrow.visible = true;
            _loc1_ = this.gg.teleObj.X - this.gg.X;
            _loc2_ = this.gg.teleObj.Y - this.gg.teleObj.scY / 2 - this.gg.Y + this.gg.scY / 2 - 10;
            World.w.cam.setKoord(this.tharrow,World.w.gg.teleObj.X,World.w.gg.teleObj.Y - World.w.gg.teleObj.scY / 2);
            this.tharrow.rotation = Math.atan2(_loc2_,_loc1_) / Math.PI * 180;
            _loc3_ = this.gg.throwForceRelat();
            this.tharrow.alpha = _loc3_;
            if(_loc3_ >= 0.99)
            {
               this.tharrow.gotoAndStop(1);
            }
            else
            {
               this.tharrow.gotoAndStop(2);
            }
         }
         else
         {
            this.tharrow.visible = false;
         }
         if(this.showDop && !World.w.sats.active && !this.vis.fav.visible && !World.w.catPause)
         {
            this.showSelector();
         }
         this.vis.fav.visible = this.vis.status.visible = (this.showFav || this.showDop) && !World.w.sats.active && !World.w.catPause;
      }
      
      public function setSats(param1:Boolean) : *
      {
         this.vis.sats.visible = param1 && this.active;
      }
   }
}

