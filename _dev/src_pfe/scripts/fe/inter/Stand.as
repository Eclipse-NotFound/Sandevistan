package fe.inter
{
   import fe.*;
   import fe.serv.Item;
   import fe.unit.Invent;
   import fe.weapon.Weapon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Matrix;
   
   public class Stand
   {
      
      public var active:Boolean = false;
      
      internal var vis:MovieClip;
      
      internal var visX:* = 1200;
      
      internal var visY:* = 800;
      
      internal var pages:Array;
      
      internal var buttons:Array;
      
      internal var weapons:Array;
      
      internal var arts:Array;
      
      internal var armors:Array;
      
      public var inv:Invent;
      
      internal var kolPages:int = 9;
      
      internal var kolLevels:int = 6;
      
      internal var page:int = 0;
      
      internal var ls:*;
      
      internal var itemFilter:GlowFilter;
      
      internal var clearFilter:GlowFilter;
      
      internal var glowFilter:GlowFilter;
      
      internal var info:MovieClip;
      
      public function Stand(param1:MovieClip, param2:Invent)
      {
         var _loc4_:MovieClip = null;
         var _loc5_:MovieClip = null;
         this.ls = ["stat_aj","stat_tw","stat_fl","stat_rr","stat_rd","stat_pp"];
         this.itemFilter = new GlowFilter(65433,1,3,3,4,1,false,false);
         this.clearFilter = new GlowFilter(65433,1,3,3,1,1,false,true);
         this.glowFilter = new GlowFilter(65433,1,10,6,2,3);
         super();
         this.vis = param1;
         this.inv = param2;
         this.pages = new Array();
         this.buttons = new Array();
         this.weapons = new Array();
         this.armors = new Array();
         this.arts = new Array();
         var _loc3_:* = 0;
         while(_loc3_ < this.kolPages)
         {
            _loc4_ = new MovieClip();
            _loc4_.x = 200;
            _loc4_.visible = false;
            this.vis.addChild(_loc4_);
            this.pages[_loc3_] = _loc4_;
            _loc5_ = new butStand();
            _loc5_.id.text = _loc3_;
            _loc5_.id.visible = false;
            _loc5_.ico.gotoAndStop(_loc3_ + 2);
            _loc5_.text.text = Res.guiText("stand" + _loc3_);
            _loc5_.y = 25 + 75 * _loc3_;
            _loc5_.x = 20;
            _loc5_.stop();
            this.vis.addChild(_loc5_);
            this.buttons[_loc3_] = _loc5_;
            _loc5_.addEventListener(MouseEvent.CLICK,this.standBut);
            _loc3_++;
         }
         this.vis.butclose.addEventListener(MouseEvent.CLICK,this.standClose);
         this.vis.butclose.id.visible = false;
         this.vis.butclose.text.text = Res.guiText("close");
         this.resizeScreen(1200,800);
         this.createWeaponLists(0);
         this.createWeaponLists(1);
         this.createWeaponLists(2);
         this.createWeaponLists(3);
         this.createWeaponLists(4);
         this.createWeaponLists(5);
         this.createArmorList(6);
         this.createArmorList(7);
         this.createArtList(8);
         this.showWeaponList(0);
         this.info = new visualStandInfo();
         this.vis.addChild(this.info);
         this.info.visible = false;
         PipPage.setStyle(this.info.info);
         this.info.info.autoSize = "left";
         this.vis.toptext.visible = false;
         PipPage.setStyle(this.vis.bottext);
         PipPage.setStyle(this.vis.toptext.txt);
         this.vis.bottext.htmlText = "";
      }
      
      public function standClose(param1:MouseEvent) : *
      {
         this.onoff(-1);
      }
      
      public function standBut(param1:MouseEvent) : *
      {
         this.page = param1.currentTarget.id.text;
         this.setButtons();
         this.showWeaponList(this.page);
      }
      
      internal function createWeaponLists(param1:int) : *
      {
         var weap:* = undefined;
         var item:* = undefined;
         var infIco:MovieClip = null;
         var r:Number = NaN;
         var vWeapon:Class = null;
         var n:int = param1;
         var levels:Array = [0,0,0,0,0,0,0];
         var stolb:int = -1;
         for each(weap in AllData.d.weapon.(@tip > 0))
         {
            if(weap.@nostand <= 0)
            {
               if(n == 0 && weap.@skill == 1 || n == 1 && weap.@skill == 2 || n == 2 && weap.@skill == 4 || n == 3 && weap.@skill == 5 || n == 4 && weap.@skill == 3 || n == 5 && weap.@skill >= 6)
               {
                  item = new itemStand();
                  if(weap.@tip == 5)
                  {
                     stolb++;
                     if(stolb >= this.kolLevels)
                     {
                        stolb = 0;
                     }
                  }
                  else
                  {
                     stolb = int(weap.@lvl);
                  }
                  ++levels[stolb];
                  item.x = 80 + stolb * 160;
                  item.y = 40 + levels[stolb] * 100;
                  item.id.text = weap.@id;
                  item.id.visible = false;
                  item.dop.visible = false;
                  item.goldstar.stop();
                  item.nazv.text = Res.txt("w",weap.@id);
                  r = 1;
                  if(weap.@tip == 5)
                  {
                     infIco = new itemIco();
                     try
                     {
                        infIco.gotoAndStop(weap.@id);
                     }
                     catch(err:*)
                     {
                        infIco.stop();
                     }
                     item.goldstar.y = -85;
                     item.zad.scaleY = 1.35;
                     item.y = 40 + levels[stolb] * 140;
                     if(weap.@spell > 0)
                     {
                        item.nazv.text = Res.txt("i",weap.@id);
                     }
                  }
                  else
                  {
                     vWeapon = null;
                     if(Boolean(weap.vis.length()) && Boolean(weap.vis[0].@vico.length()))
                     {
                        vWeapon = Res.getClass(weap.vis[0].@vico,null);
                     }
                     if(vWeapon == null)
                     {
                        vWeapon = Res.getClass("vis" + weap.@id,null);
                     }
                     if(vWeapon != null)
                     {
                        infIco = new vWeapon();
                     }
                  }
                  if(Boolean(weap.vis.length()) && Boolean(weap.vis.@icomult.length()))
                  {
                     r = infIco.scaleX = infIco.scaleY = weap.vis.@icomult;
                  }
                  infIco.x = -infIco.getRect(infIco).left * r - infIco.width / 2;
                  infIco.y = -infIco.height - infIco.getRect(infIco).top;
                  infIco.stop();
                  if(infIco.lez)
                  {
                     infIco.lez.stop();
                  }
                  item.weapon.addChild(infIco);
                  if(weap.char.length() > 1)
                  {
                     if(Res.istxt("w",weap.@id + "^1"))
                     {
                        item.nazv2.text = Res.txt("w",weap.@id + "^1");
                     }
                     else
                     {
                        item.nazv2.text = Res.txt("w",weap.@id) + Weapon.variant2;
                     }
                     item.dop.text = "1";
                     item.goldstar.gotoAndStop(2);
                     vWeapon = Res.getClass("vis" + weap.@id + "_1",null);
                     if(vWeapon != null)
                     {
                        infIco = new vWeapon();
                        infIco.x = -infIco.getRect(infIco).left * r - infIco.width / 2;
                        infIco.y = -infIco.height - infIco.getRect(infIco).top;
                        infIco.stop();
                        if(infIco.lez)
                        {
                           infIco.lez.stop();
                        }
                        item.weapon2.addChild(infIco);
                        item.dop.text = "2";
                     }
                  }
                  this.pages[n].addChild(item);
                  this.weapons[weap.@id] = item;
               }
            }
         }
      }
      
      internal function createArtList(param1:int) : *
      {
         var _loc3_:* = undefined;
         var _loc2_:* = 0;
         while(_loc2_ < 6)
         {
            _loc3_ = new itemArt();
            _loc3_.x = 80 + _loc2_ * 160;
            _loc3_.y = 40;
            _loc3_.art.gotoAndStop(this.ls[_loc2_]);
            _loc3_.nazv.text = Res.txt("i",this.ls[_loc2_]);
            _loc3_.id.text = this.ls[_loc2_];
            _loc3_.id.visible = false;
            this.pages[param1].addChild(_loc3_);
            this.arts[_loc2_] = _loc3_;
            _loc2_++;
         }
      }
      
      internal function createArmorList(param1:int) : *
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Matrix = null;
         var _loc12_:BitmapData = null;
         var _loc13_:Bitmap = null;
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc4_:MovieClip = new visBodyStay();
         var _loc5_:Number = 1.5;
         var _loc6_:* = Appear.ggArmorId;
         Appear.transp = true;
         for each(_loc7_ in AllData.d.armor)
         {
            if(!(param1 == 6 && _loc7_.@tip > 1 || param1 == 7 && _loc7_.@tip != 3))
            {
               _loc8_ = new itemArt();
               _loc8_.x = 80 + _loc2_ * 160;
               _loc8_.y = _loc3_ * 180;
               if(++_loc2_ >= 6)
               {
                  _loc2_ = 0;
                  _loc3_++;
               }
               _loc8_.id.text = _loc7_.@id;
               _loc8_.id.visible = false;
               _loc8_.nazv.text = Res.txt("a",_loc7_.@id);
               this.pages[param1].addChild(_loc8_);
               this.armors[_loc7_.@id] = _loc8_;
               if(param1 == 6)
               {
                  World.w.armorWork = _loc7_.@id;
                  _loc4_.gotoAndStop(2);
                  _loc4_.gotoAndStop(1);
                  _loc9_ = _loc4_.width * _loc5_ + 2;
                  _loc10_ = _loc4_.height * _loc5_ + 2;
                  _loc11_ = new Matrix();
                  _loc11_.tx = -_loc4_.getRect(_loc4_).left + 1;
                  _loc11_.ty = -_loc4_.getRect(_loc4_).top + 1;
                  _loc11_.scale(_loc5_,_loc5_);
                  try
                  {
                     _loc4_.pip1.visible = _loc4_.sleg1.mark.visible = _loc4_.sleg2.mark.visible = _loc4_.head.morda.magic.visible = _loc4_.head.morda.eye.visible = false;
                  }
                  catch(err:*)
                  {
                  }
                  _loc12_ = new BitmapData(_loc9_,_loc10_,true,0);
                  _loc12_.draw(_loc4_,_loc11_);
                  _loc13_ = new Bitmap(_loc12_);
                  _loc8_.art.addChild(_loc13_);
                  _loc13_.x = -_loc13_.width / 2 - 10;
                  _loc13_.y = 100;
               }
               else if(param1 == 7)
               {
                  _loc8_.art.gotoAndStop(_loc7_.@id);
                  _loc8_.art.y = 100;
               }
            }
         }
         Appear.transp = false;
         World.w.armorWork = "";
      }
      
      internal function showMass() : *
      {
         this.vis.bottext.htmlText = "";
         try
         {
            if(this.page <= 4)
            {
               this.vis.bottext.htmlText = this.inv.retMass(4);
            }
            if(this.page == 5)
            {
               this.vis.bottext.htmlText = this.inv.retMass(5);
            }
         }
         catch(err:*)
         {
         }
      }
      
      internal function showWeaponList(param1:int) : *
      {
         var i:* = undefined;
         var weap:* = undefined;
         var arm:* = undefined;
         var n:int = param1;
         i = 0;
         while(i < this.kolPages)
         {
            this.pages[i].visible = false;
            i++;
         }
         if(World.w.hardInv)
         {
            this.showMass();
         }
         this.pages[n].visible = true;
         if(n < 5)
         {
            this.vis.toptext.txt.htmlText = Res.txt("p","infostand",0,true);
         }
         if(n == 5)
         {
            this.vis.toptext.txt.htmlText = Res.txt("p","infostand",0,true);
         }
         this.vis.toptext.visible = n <= 5;
         for each(weap in AllData.d.weapon.(@tip > 0))
         {
            if(n == 0 && weap.@skill == 1 || n == 1 && weap.@skill == 2 || n == 2 && weap.@skill == 4 || n == 3 && weap.@skill == 5 || n == 4 && weap.@skill == 3 || n == 5 && weap.@skill >= 6)
            {
               if(this.weapons[weap.@id] != null)
               {
                  if(weap.@spell > 0 && (this.inv.items[weap.@id] == null || this.inv.items[weap.@id].kol <= 0))
                  {
                     this.showWeapon(this.weapons[weap.@id],0,0);
                  }
                  else if(this.inv.weapons[weap.@id] == null || this.inv.weapons[weap.@id].respect == 3)
                  {
                     this.showWeapon(this.weapons[weap.@id],0,0);
                  }
                  else
                  {
                     this.showWeapon(this.weapons[weap.@id],this.inv.weapons[weap.@id].variant + 1,this.inv.weapons[weap.@id].respect);
                  }
               }
            }
         }
         for each(arm in AllData.d.armor)
         {
            if(this.armors[arm.@id])
            {
               if(Boolean(this.inv.armors[arm.@id]) && this.inv.armors[arm.@id].lvl >= 0)
               {
                  this.armors[arm.@id].nazv.visible = true;
                  this.armors[arm.@id].art.filters = [this.itemFilter,this.glowFilter];
               }
               else
               {
                  this.armors[arm.@id].nazv.visible = false;
                  this.armors[arm.@id].art.filters = [this.clearFilter];
               }
            }
         }
         for(i in this.ls)
         {
            if(this.inv.items[this.ls[i]].kol)
            {
               this.arts[i].nazv.visible = true;
               this.arts[i].art.filters = [this.itemFilter,this.glowFilter];
            }
            else
            {
               this.arts[i].nazv.visible = false;
               this.arts[i].art.filters = [this.clearFilter];
            }
         }
      }
      
      internal function showWeapon(param1:MovieClip, param2:int, param3:int) : *
      {
         if(param2 == 0)
         {
            param1.weapon.filters = [this.clearFilter,this.glowFilter];
            param1.weapon2.filters = [this.clearFilter,this.glowFilter];
            param1.nazv.visible = param1.nazv2.visible = false;
            param1.weapon.visible = true;
            param1.weapon2.visible = false;
            param1.goldstar.visible = false;
         }
         else if(param2 == 1)
         {
            param1.nazv.visible = true;
            param1.nazv2.visible = false;
            param1.weapon.visible = true;
            param1.weapon2.visible = false;
            param1.goldstar.visible = true;
         }
         else if(param2 == 2)
         {
            param1.nazv.visible = false;
            param1.nazv2.visible = true;
            if(param1.dop.text == "2")
            {
               param1.weapon.visible = false;
               param1.weapon2.visible = true;
            }
            else
            {
               param1.weapon.visible = true;
               param1.weapon2.visible = false;
            }
            param1.goldstar.gotoAndStop(3);
            param1.goldstar.visible = true;
         }
         if(Boolean(param1.nazv.visible) || Boolean(param1.nazv2.visible))
         {
            if(param3 == 1)
            {
               param1.weapon.alpha = 0.5;
               param1.weapon.filters = [this.itemFilter];
               param1.weapon2.filters = [this.itemFilter];
               param1.nazv.alpha = 0.35;
               param1.nazv2.alpha = 0.35;
            }
            else
            {
               param1.weapon.filters = [this.itemFilter,this.glowFilter];
               param1.weapon2.filters = [this.itemFilter,this.glowFilter];
               param1.nazv.alpha = 1;
               param1.nazv2.alpha = 1;
               param1.weapon.alpha = 1;
            }
         }
      }
      
      internal function setButtons() : *
      {
         var _loc2_:MovieClip = null;
         var _loc1_:* = 0;
         while(_loc1_ < this.kolPages)
         {
            _loc2_ = this.buttons[_loc1_];
            if(this.page == _loc1_)
            {
               _loc2_.gotoAndStop(2);
            }
            else
            {
               _loc2_.gotoAndStop(1);
            }
            _loc1_++;
         }
      }
      
      public function itemClick(param1:MouseEvent) : *
      {
         var _loc2_:* = param1.currentTarget.id.text;
         if(this.inv.weapons[_loc2_] == null || this.inv.weapons[_loc2_].respect == 3)
         {
            return;
         }
         var _loc3_:* = this.inv.respectWeapon(_loc2_);
         this.showWeapon(param1.currentTarget as MovieClip,-1,_loc3_);
         if(World.w.hardInv)
         {
            this.showMass();
         }
      }
      
      public function itemOver(param1:MouseEvent) : *
      {
         if(this.inv.weapons[param1.currentTarget.id.text] == null)
         {
            return;
         }
         if(!param1.currentTarget.nazv.visible && !param1.currentTarget.nazv2.visible)
         {
            return;
         }
         this.info.nazv.text = param1.currentTarget.nazv.visible ? param1.currentTarget.nazv.text : param1.currentTarget.nazv2.text;
         if(param1.currentTarget.nazv2.visible)
         {
            this.info.info.htmlText = PipPage.infoStr(Item.L_WEAPON,param1.currentTarget.id.text + "^" + this.inv.weapons[param1.currentTarget.id.text].variant);
         }
         else
         {
            this.info.info.htmlText = PipPage.infoStr(Item.L_WEAPON,param1.currentTarget.id.text);
         }
         this.info.visible = true;
         this.info.fon.height = this.info.info.height + this.info.info.y + 8;
         var _loc2_:* = param1.currentTarget.x + param1.currentTarget.parent.x + 80;
         var _loc3_:* = param1.currentTarget.y + param1.currentTarget.parent.y - 50;
         if(_loc3_ + this.vis.y + this.info.height > World.w.cam.screenY - 10)
         {
            _loc3_ = World.w.cam.screenY - this.vis.y - this.info.height - 10;
         }
         if(_loc2_ + this.vis.x + this.info.width > World.w.cam.screenX - 10)
         {
            _loc2_ = param1.currentTarget.x + param1.currentTarget.parent.x - 80 - this.info.width;
         }
         this.info.x = _loc2_;
         this.info.y = _loc3_;
      }
      
      public function itemOver2(param1:MouseEvent) : *
      {
         if(!param1.currentTarget.nazv.visible)
         {
            return;
         }
         this.info.nazv.text = param1.currentTarget.nazv.text;
         this.info.info.htmlText = PipPage.infoStr(Item.L_ARMOR,param1.currentTarget.id.text);
         this.info.visible = true;
         this.info.fon.height = this.info.info.height + this.info.info.y + 8;
         var _loc2_:* = param1.currentTarget.x + param1.currentTarget.parent.x + 80;
         var _loc3_:* = param1.currentTarget.y + param1.currentTarget.parent.y + 20;
         if(_loc3_ + this.vis.y + this.info.height > World.w.cam.screenY - 10)
         {
            _loc3_ = World.w.cam.screenY - this.vis.y - this.info.height - 10;
         }
         if(_loc2_ + this.vis.x + this.info.width > World.w.cam.screenX - 10)
         {
            _loc2_ = param1.currentTarget.x + param1.currentTarget.parent.x - 80 - this.info.width;
         }
         this.info.x = _loc2_;
         this.info.y = _loc3_;
      }
      
      public function itemOut(param1:MouseEvent) : *
      {
         this.info.visible = false;
      }
      
      public function onoff(param1:int = 0) : *
      {
         var _loc2_:* = undefined;
         if(param1 == 0)
         {
            this.active = !this.active;
         }
         else if(param1 > 0)
         {
            this.active = true;
            World.w.pip.onoff(-1);
            World.w.ctr.clearAll();
         }
         else
         {
            this.active = false;
         }
         this.vis.visible = this.active;
         if(this.active)
         {
            World.w.cur();
            this.setButtons();
            this.showWeaponList(this.page);
            for each(_loc2_ in this.weapons)
            {
               if(!_loc2_.hasEventListener(MouseEvent.CLICK))
               {
                  _loc2_.addEventListener(MouseEvent.CLICK,this.itemClick);
                  _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.itemOver);
                  _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.itemOut);
               }
            }
            for each(_loc2_ in this.armors)
            {
               _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.itemOver2);
               _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.itemOut);
            }
            for each(_loc2_ in this.arts)
            {
               _loc2_.addEventListener(MouseEvent.MOUSE_OVER,this.itemOver2);
               _loc2_.addEventListener(MouseEvent.MOUSE_OUT,this.itemOut);
            }
         }
         else
         {
            for each(_loc2_ in this.weapons)
            {
               if(_loc2_.hasEventListener(MouseEvent.CLICK))
               {
                  _loc2_.removeEventListener(MouseEvent.CLICK,this.itemClick);
                  _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.itemOver);
                  _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.itemOut);
               }
            }
            for each(_loc2_ in this.armors)
            {
               _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.itemOver2);
               _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.itemOut);
            }
            for each(_loc2_ in this.arts)
            {
               _loc2_.removeEventListener(MouseEvent.MOUSE_OVER,this.itemOver2);
               _loc2_.removeEventListener(MouseEvent.MOUSE_OUT,this.itemOut);
            }
         }
      }
      
      public function resizeScreen(param1:int, param2:int) : *
      {
         if(param1 >= 1200 && param2 >= 800)
         {
            this.vis.x = (param1 - this.visX) / 2;
            this.vis.y = (param2 - this.visY) / 2;
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
   }
}

