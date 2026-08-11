package fe.inter
{
   import fe.*;
   import fe.unit.Unit;
   import fe.unit.UnitPlayer;
   import fe.weapon.Weapon;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   
   public class Sats
   {
      
      public var vis:MovieClip;
      
      public var trasser:MovieClip;
      
      public var radius:MovieClip;
      
      public var active:Boolean = false;
      
      public var que:Array;
      
      public var weapon:Weapon;
      
      public var gg:UnitPlayer;
      
      public var skillConf:Number = 1;
      
      public var units:Array;
      
      public var ct:ColorTransform = new ColorTransform(1,1,1,1,0,100,0,0);
      
      internal var fGlow:GlowFilter = new GlowFilter(16711680,1,3,3,4,1);
      
      internal var fShad:GlowFilter = new GlowFilter(0,1,3,3,3,1);
      
      public var od:Number = 80;
      
      public var odv:Number = 80;
      
      public var odd:Number = 0.1;
      
      public var limOd:Number = 200;
      
      public function Sats(param1:MovieClip)
      {
         super();
         this.vis = param1;
         this.vis.visible = false;
         this.trasser = new MovieClip();
         this.radius = new satsRadius();
         this.vis.addChild(this.trasser);
         this.vis.addChild(this.radius);
         this.que = new Array();
         this.units = new Array();
      }
      
      public function onoff(param1:int = 0) : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         if(param1 == 0)
         {
            this.active = !this.active;
         }
         else if(param1 > 0)
         {
            this.active = true;
         }
         else
         {
            this.active = false;
         }
         if(this.active)
         {
            if(World.w.loc.base || World.w.alicorn)
            {
               this.active = false;
               return;
            }
            this.gg = World.w.gg;
            this.weapon = this.gg.currentWeapon;
            if(this.weapon == null)
            {
               World.w.gui.infoText("noSats");
               this.active = false;
            }
            else if(this.weapon.noSats)
            {
               World.w.gui.infoText("noSats");
               this.active = false;
            }
            else
            {
               _loc2_ = this.weapon.status();
               if(_loc2_ == 4)
               {
                  World.w.gui.infoText("noAmmo","");
                  this.active = false;
               }
               if(_loc2_ == 5)
               {
                  World.w.gui.infoText("brokenWeapon","");
                  this.active = false;
               }
               if(_loc2_ == 6)
               {
                  World.w.gui.infoText("noMana","");
                  this.active = false;
               }
            }
         }
         if(this.active)
         {
            if(this.weapon.tip > 1)
            {
               this.trasser.visible = true;
               this.trass();
            }
            else
            {
               this.trasser.visible = false;
               this.radius.visible = true;
               this.radius.x = this.gg.X + this.gg.pers.meleeS * this.gg.storona;
               this.radius.y = this.gg.Y - this.gg.scY / 2;
               this.radius.scaleX = this.radius.scaleY = this.gg.pers.meleeR / 100;
            }
            this.skillConf = 1;
            if(World.w.weaponsLevelsOff)
            {
               _loc3_ = this.weapon.lvl - this.gg.pers.getWeapLevel(this.weapon.skill);
               if(_loc3_ == 1)
               {
                  this.skillConf = 0.8;
               }
               else if(_loc3_ == 2)
               {
                  this.skillConf = 0.6;
               }
               else if(_loc3_ > 2)
               {
                  this.skillConf = 0;
                  World.w.gui.infoText("weaponSkillLevel");
                  this.active = false;
                  return;
               }
            }
            if(this.que.length > 0)
            {
               this.clearAll();
            }
            World.w.grafon.drawSats();
            World.w.grafon.onSats(true);
            this.getUnits();
            World.w.gui.offCelObj();
            this.odv = this.od;
            World.w.gui.setOd();
            World.w.swfStage.addEventListener(MouseEvent.MOUSE_MOVE,this.mMove);
            World.w.gui.setTopText("infosats");
         }
         else
         {
            World.w.grafon.onSats(false);
            this.offUnits();
            World.w.swfStage.removeEventListener(MouseEvent.MOUSE_MOVE,this.mMove);
            World.w.ctr.clearAll();
            World.w.gui.setTopText("");
         }
         this.vis.visible = this.active;
         World.w.gui.setSats(this.active);
      }
      
      public function step() : *
      {
         if(this.active)
         {
            if(World.w.ctr.keyAttack)
            {
               this.setCel();
               World.w.ctr.keyAttack = false;
            }
            if(World.w.ctr.keyTele)
            {
               this.unsetCel();
               World.w.ctr.keyTele = false;
            }
            if(World.w.ctr.keyAction)
            {
               this.onoff(-1);
               World.w.ctr.keyAction = false;
            }
         }
      }
      
      public function step2() : *
      {
         if(this.que.length > 0 && World.w.ctr.keyAttack)
         {
            this.clearAll();
         }
         if(this.que.length > 0 && this.weapon.satsCons * this.weapon.consMult * this.weapon.consMult / this.skillConf * this.gg.pers.satsMult / this.weapon.satsQue > this.od)
         {
            World.w.gui.infoText("noOd");
            this.clearAll();
         }
         if(this.que.length == 0 && this.od < this.gg.pers.maxOd)
         {
            this.od += this.odd;
            this.odv = this.od;
            World.w.gui.setOd();
         }
      }
      
      public function clearAll() : *
      {
         var _loc3_:SatsCel = null;
         var _loc1_:* = this.que.length;
         var _loc2_:* = 0;
         while(_loc2_ < _loc1_)
         {
            _loc3_ = this.que.shift();
            _loc3_.remove();
            _loc2_++;
         }
         this.odv = this.od;
         World.w.gui.setOd();
      }
      
      public function setCel() : *
      {
         var _loc1_:SatsCel = null;
         var _loc2_:* = undefined;
         if(this.weapon.satsCons * this.weapon.consMult / this.skillConf * this.gg.pers.satsMult > this.odv)
         {
            World.w.gui.infoText("noOd");
            return;
         }
         if(this.units.length)
         {
            for each(_loc2_ in this.units)
            {
               if(_loc2_.du.filters.length > 0)
               {
                  _loc1_ = new SatsCel(_loc2_,0,0,this.weapon.satsCons * this.weapon.consMult / this.skillConf * this.gg.pers.satsMult,this.weapon.satsQue);
                  break;
               }
            }
         }
         if(_loc1_ == null)
         {
            _loc1_ = new SatsCel(null,World.w.celX,World.w.celY,this.weapon.satsCons * this.weapon.consMult / this.skillConf * this.gg.pers.satsMult,this.weapon.satsQue);
         }
         this.weapon.ready = false;
         this.odv -= this.weapon.satsCons * this.weapon.consMult / this.skillConf * this.gg.pers.satsMult;
         World.w.gui.setOd();
         this.que.push(_loc1_);
      }
      
      public function unsetCel(param1:Boolean = false) : *
      {
         var _loc2_:SatsCel = null;
         if(this.que.length == 0)
         {
            this.onoff(-1);
            return;
         }
         if(param1)
         {
            _loc2_ = this.que.shift();
         }
         else
         {
            _loc2_ = this.que.pop();
         }
         if(_loc2_.un)
         {
            --_loc2_.un.n;
         }
         _loc2_.remove();
         this.odv += this.weapon.satsCons * this.weapon.consMult / this.skillConf * this.gg.pers.satsMult;
         if(this.que.length == 0)
         {
            this.onoff(-1);
            this.odv = this.od;
         }
         World.w.gui.setOd();
      }
      
      public function getReady() : Boolean
      {
         if(this.que.length > 0 && (Boolean(this.que[0].un == null || this.que[0].begined) || Boolean(this.que[0].un.u.sost < 3)))
         {
            return true;
         }
         return false;
      }
      
      public function act() : *
      {
         var _loc1_:SatsCel = null;
         this.od -= this.que[0].cons;
         World.w.gui.setOd();
         if(this.que[0].kol > 1 && this.weapon.status() <= 1)
         {
            --this.que[0].kol;
            this.que[0].begined = true;
         }
         else
         {
            _loc1_ = this.que.shift();
            _loc1_.remove();
         }
      }
      
      public function getPrec(param1:Unit) : Number
      {
         var _loc7_:* = undefined;
         var _loc8_:* = undefined;
         var _loc2_:Number = 1;
         var _loc3_:* = this.gg.pers.weaponSkills[this.weapon.skill];
         var _loc4_:* = this.weapon.X - param1.X;
         var _loc5_:* = this.weapon.Y - param1.Y;
         var _loc6_:* = Math.sqrt(_loc4_ * _loc4_ + _loc5_ * _loc5_);
         if(this.weapon.precision > 0)
         {
            _loc2_ = this.weapon.resultPrec(1,_loc3_) / _loc6_ / (param1.dexter + 0.1) * this.skillConf;
         }
         if(this.weapon.antiprec > 0 && _loc6_ < this.weapon.antiprec)
         {
            _loc2_ = (_loc6_ / this.weapon.antiprec * 0.75 + 0.25) / (param1.dexter + 0.1) * this.skillConf;
         }
         if(this.weapon.deviation > 0 || this.gg.mazil > 0)
         {
            _loc7_ = Math.atan2(param1.scY,_loc6_) * 180 / Math.PI;
            _loc8_ = this.weapon.deviation / (_loc3_ + 0.01) + this.gg.mazil;
            if(_loc8_ > _loc7_)
            {
               _loc2_ = _loc2_ * _loc7_ / _loc8_;
            }
         }
         if(_loc2_ > 0.95)
         {
            _loc2_ = 0.95;
         }
         if(_loc2_ > this.skillConf)
         {
            _loc2_ = this.skillConf;
         }
         return _loc2_;
      }
      
      public function drawUnit(param1:Unit) : MovieClip
      {
         var _loc2_:BitmapData = new BitmapData(param1.vis.width,param1.vis.height,true,0);
         var _loc3_:Matrix = new Matrix();
         var _loc4_:Rectangle = param1.vis.getBounds(param1.vis);
         _loc3_.tx = -_loc4_.left;
         _loc3_.ty = -_loc4_.top;
         var _loc5_:Boolean = false;
         if(Boolean(param1.hpbar) && param1.hpbar.visible)
         {
            _loc5_ = true;
         }
         if(_loc5_)
         {
            param1.hpbar.visible = false;
         }
         _loc2_.draw(param1.vis,_loc3_,this.ct);
         if(_loc5_)
         {
            param1.hpbar.visible = true;
         }
         var _loc6_:MovieClip = new MovieClip();
         _loc6_.scaleX = param1.vis.scaleX;
         _loc6_.scaleY = param1.vis.scaleY;
         _loc6_.rotation = param1.vis.rotation;
         var _loc7_:Bitmap = new Bitmap(_loc2_);
         _loc6_.addChild(_loc7_);
         _loc7_.x = _loc4_.left;
         _loc7_.y = _loc4_.top;
         _loc6_.addEventListener(MouseEvent.MOUSE_OVER,this.mOver);
         _loc6_.addEventListener(MouseEvent.MOUSE_OUT,this.mOut);
         return _loc6_;
      }
      
      public function mOver(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         if(this.active && !this.weapon.noPerc)
         {
            (param1.currentTarget as MovieClip).filters = [this.fGlow];
         }
         try
         {
            _loc2_ = (param1.currentTarget.parent as MovieClip).getChildAt(1)["info"];
            _loc2_.visible = true;
         }
         catch(err:*)
         {
         }
      }
      
      public function mOut(param1:MouseEvent) : void
      {
         var _loc2_:TextField = null;
         if(this.active && !this.weapon.noPerc)
         {
            (param1.currentTarget as MovieClip).filters = [];
         }
         try
         {
            _loc2_ = (param1.currentTarget.parent as MovieClip).getChildAt(1)["info"];
            _loc2_.visible = false;
         }
         catch(err:*)
         {
         }
      }
      
      public function offUnits() : *
      {
         var _loc1_:* = undefined;
         if(Boolean(this.units) && Boolean(this.units.length))
         {
            for each(_loc1_ in this.units)
            {
               try
               {
                  this.vis.removeChild(_loc1_.v);
                  _loc1_.v.removeEventListener(MouseEvent.MOUSE_OVER,this.mOver);
                  _loc1_.v.removeEventListener(MouseEvent.MOUSE_OUT,this.mOut);
               }
               catch(err:*)
               {
               }
            }
         }
         this.units = new Array();
         for each(_loc1_ in this.que)
         {
            _loc1_.vis.visible = false;
         }
      }
      
      public function getUnits() : *
      {
         var _loc1_:Unit = null;
         var _loc2_:MovieClip = null;
         var _loc3_:MovieClip = null;
         var _loc4_:MovieClip = null;
         var _loc5_:TextField = null;
         var _loc6_:TextField = null;
         var _loc7_:Number = NaN;
         for each(_loc1_ in World.w.loc.units)
         {
            if(!(!this.gg.isMeet(_loc1_) || !_loc1_.isSats || _loc1_.sost >= 3 || _loc1_.invis))
            {
               if(this.weapon.satsMelee)
               {
                  if(this.gg.look(_loc1_,false,0,this.gg.pers.meleeR * 1.2 + 100) <= 0)
                  {
                     continue;
                  }
               }
               else if(this.gg.look(_loc1_) <= 0 || !_loc1_.getTileVisi())
               {
                  continue;
               }
               _loc2_ = new MovieClip();
               _loc2_.x = _loc1_.vis.x;
               _loc2_.y = _loc1_.vis.y;
               this.vis.addChild(_loc2_);
               _loc3_ = this.drawUnit(_loc1_);
               _loc4_ = new satsUnit();
               _loc4_.filters = [this.fShad];
               _loc4_.scaleX = _loc4_.scaleY = 1 / World.w.cam.scaleV;
               _loc5_ = _loc4_.txt;
               _loc6_ = _loc4_.info;
               _loc5_.y = 3;
               _loc5_.autoSize = TextFieldAutoSize.CENTER;
               if(!this.weapon.noPerc)
               {
                  _loc7_ = this.getPrec(_loc1_);
               }
               _loc5_.text = _loc1_.nazv;
               _loc5_.selectable = false;
               if(!this.weapon.noPerc)
               {
                  _loc5_.text += "\n" + Math.round(_loc7_ * 100) + "%";
               }
               _loc6_.autoSize = TextFieldAutoSize.CENTER;
               _loc6_.selectable = false;
               _loc6_.visible = false;
               _loc6_.text = "";
               if(Boolean(World.w.pers) && Boolean(World.w.pers.modAnalis))
               {
                  _loc6_.text += "\n" + Res.pipText("level") + ": " + (_loc1_.level + 1);
                  _loc6_.text += "\n" + Res.pipText("hp") + ": " + Math.ceil(_loc1_.hp) + "/" + Math.ceil(_loc1_.maxhp);
                  if(_loc1_.skin > 0)
                  {
                     _loc6_.text += "\n" + Res.pipText("skin") + ": " + Math.ceil(_loc1_.skin);
                  }
                  if(_loc1_.armor_qual > 0 && _loc1_.armor > 0)
                  {
                     _loc6_.text += "\n" + Res.pipText("armor") + ": " + Math.ceil(_loc1_.armor + _loc1_.skin) + " (" + Math.round(_loc1_.armor_qual * 100) + "%)";
                  }
                  if(_loc1_.armor_qual > 0 && _loc1_.marmor > 0)
                  {
                     _loc6_.text += "\n" + Res.pipText("marmor") + ": " + Math.ceil(_loc1_.marmor + _loc1_.skin) + " (" + Math.round(_loc1_.armor_qual * 100) + "%)";
                  }
                  if(_loc2_.y < 150)
                  {
                     _loc6_.y = 50;
                  }
                  else
                  {
                     _loc6_.y = -_loc1_.scY - _loc6_.textHeight - 20;
                  }
               }
               _loc4_.name = "su";
               _loc2_.addChild(_loc3_);
               _loc2_.addChild(_loc4_);
               this.units.push({
                  "u":_loc1_,
                  "v":_loc2_,
                  "du":_loc3_,
                  "p":_loc7_,
                  "n":0
               });
            }
         }
      }
      
      public function mMove(param1:MouseEvent) : void
      {
         this.trass();
      }
      
      public function trass() : *
      {
         if(this.weapon.noTrass)
         {
            return;
         }
         this.weapon.setTrass(this.trasser.graphics);
         if(this.weapon.explRadius)
         {
            this.radius.visible = true;
            this.radius.scaleX = this.radius.scaleY = this.weapon.explRadius / 100;
            this.radius.cacheAsBitmap = true;
            this.radius.x = this.weapon.trasser.X;
            this.radius.y = this.weapon.trasser.Y;
         }
         else
         {
            this.radius.visible = false;
         }
      }
   }
}

