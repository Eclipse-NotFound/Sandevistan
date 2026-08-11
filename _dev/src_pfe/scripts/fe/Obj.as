package fe
{
   import fe.inter.Appear;
   import fe.serv.Interact;
   import fe.weapon.Bullet;
   import flash.display.MovieClip;
   import flash.geom.ColorTransform;
   
   public class Obj extends Pt
   {
      
      public static var nullTransfom:ColorTransform = new ColorTransform();
      
      public var code:String;
      
      public var uid:String;
      
      public var prior:Number = 1;
      
      public var scX:Number = 10;
      
      public var scY:Number = 10;
      
      public var storona:int = 1;
      
      public var rasst2:Number = 0;
      
      public var massa:Number = 1;
      
      public var levit:int = 0;
      
      public var levitPoss:Boolean = true;
      
      public var fracLevit:int = 0;
      
      public var radioactiv:Number = 0;
      
      public var radrad:Number = 250;
      
      public var radtip:int = 0;
      
      public var warn:int = 0;
      
      public var nazv:String = "";
      
      public var inter:Interact;
      
      public var dist2:Number = 0;
      
      public var X1:Number;
      
      public var X2:Number;
      
      public var Y1:Number;
      
      public var Y2:Number;
      
      public var onCursor:Number = 0;
      
      public var cTransform:ColorTransform = nullTransfom;
      
      public function Obj()
      {
         super();
      }
      
      public static function setArmor(param1:MovieClip) : *
      {
         var m:MovieClip = param1;
         var aid:String = "";
         if(World.w)
         {
            if(Boolean(World.w.pip) && Boolean(World.w.pip.active) || World.w.mmArmor && World.w.allStat == 0)
            {
               aid = World.w.pip.ArmorId;
            }
            else if(World.w.armorWork != "")
            {
               aid = World.w.armorWork;
            }
            else if(World.w.alicorn)
            {
               aid = "ali";
            }
            else
            {
               aid = Appear.ggArmorId;
            }
         }
         if(aid == "")
         {
            m.gotoAndStop(1);
            return;
         }
         try
         {
            m.gotoAndStop(aid);
         }
         catch(err:*)
         {
            m.gotoAndStop(1);
         }
      }
      
      public static function setMorda(param1:MovieClip, param2:int) : *
      {
         if(Boolean(World.w) && Boolean(World.w.gg))
         {
            param1.gotoAndStop(World.w.gg.mordaN);
         }
         else
         {
            param1.gotoAndStop(1);
         }
      }
      
      public static function setColor(param1:MovieClip, param2:int) : *
      {
         if(Appear.transp)
         {
            param1.visible = false;
            return;
         }
         if(param2 == 0)
         {
            param1.transform.colorTransform = Appear.trFur;
         }
         if(param2 == 1)
         {
            param1.transform.colorTransform = Appear.trHair;
         }
         if(param2 == 2)
         {
            if(Appear.visHair1)
            {
               param1.visible = true;
               param1.transform.colorTransform = Appear.trHair1;
            }
            else
            {
               param1.visible = false;
            }
         }
         if(param2 == 3)
         {
            param1.transform.colorTransform = Appear.trEye;
         }
         if(param2 == 4)
         {
            param1.transform.colorTransform = Appear.trMagic;
         }
      }
      
      public static function setVisible(param1:MovieClip) : *
      {
         var _loc2_:int = 0;
         if(Boolean(World.w) && Boolean(World.w.pip) && World.w.pip.active)
         {
            _loc2_ = World.w.pip.hideMane;
         }
         else
         {
            _loc2_ = Appear.hideMane;
         }
         param1.visible = _loc2_ == 0;
      }
      
      public static function setEye(param1:MovieClip) : *
      {
         param1.gotoAndStop(Appear.fEye);
      }
      
      public static function setHair(param1:MovieClip) : *
      {
         param1.gotoAndStop(Appear.fHair);
      }
      
      override public function remVisual() : *
      {
         super.remVisual();
         this.onCursor = 0;
      }
      
      public function setVisState(param1:String) : *
      {
      }
      
      public function die(param1:int = 0) : *
      {
      }
      
      public function checkStay() : *
      {
      }
      
      public function getRasst2(param1:Obj = null) : Number
      {
         if(param1 == null)
         {
            param1 = World.w.gg;
         }
         var _loc2_:* = param1.X - X;
         var _loc3_:* = param1.Y - param1.scY / 2 - Y + this.scY / 2;
         if(param1 == World.w.gg)
         {
            _loc3_ = param1.Y - param1.scY * 0.75 - Y + this.scY / 2;
         }
         this.rasst2 = _loc2_ * _loc2_ + _loc3_ * _loc3_;
         if(isNaN(this.rasst2))
         {
            this.rasst2 = -1;
         }
         return this.rasst2;
      }
      
      public function save() : Object
      {
         return null;
      }
      
      public function command(param1:String, param2:String = null) : *
      {
         if(param1 == "show")
         {
            World.w.cam.showOn = true;
            World.w.cam.showX = X;
            World.w.cam.showY = Y;
         }
      }
      
      public function ggModum() : *
      {
         if(Boolean(loc == World.w.gg.loc && this.radioactiv) && Boolean(this.rasst2 >= 0) && this.rasst2 < this.radrad * this.radrad)
         {
            World.w.gg.raddamage((this.radrad - Math.sqrt(this.rasst2)) / this.radrad,this.radioactiv,this.radtip);
         }
      }
      
      override public function err() : String
      {
         if(loc)
         {
            loc.remObj(this);
         }
         return "Error obj " + this.nazv;
      }
      
      public function norma(param1:Object, param2:Number) : *
      {
         var _loc3_:* = undefined;
         if(param1.x * param1.x + param1.y * param1.y > param2 * param2)
         {
            _loc3_ = Math.sqrt(param1.x * param1.x + param1.y * param1.y);
            param1.x *= param2 / _loc3_;
            param1.y *= param2 / _loc3_;
         }
      }
      
      public function bindMove(param1:Number, param2:Number, param3:Number = -1, param4:Number = -1) : *
      {
         X = param1;
         Y = param2;
         this.X1 = X - this.scX / 2;
         this.X2 = X + this.scX / 2;
         this.Y1 = Y - this.scY;
         this.Y2 = Y;
      }
      
      public function copy(param1:Obj) : *
      {
         param1.X = X;
         param1.Y = Y;
         param1.scX = this.scX;
         param1.scY = this.scY;
         param1.Y1 = this.Y1;
         param1.Y2 = this.Y2;
         param1.X1 = this.X1;
         param1.X2 = this.X2;
         param1.storona = this.storona;
      }
      
      public function udarBullet(param1:Bullet, param2:int = 0) : int
      {
         return -1;
      }
      
      public function areaTest(param1:Obj) : Boolean
      {
         if(param1 == null || param1.X1 >= this.X2 || param1.X2 <= this.X1 || param1.Y1 >= this.Y2 || param1.Y2 <= this.Y1)
         {
            return false;
         }
         return true;
      }
      
      public function locout() : *
      {
      }
   }
}

