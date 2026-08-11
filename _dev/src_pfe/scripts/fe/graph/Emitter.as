package fe.graph
{
   import fe.*;
   import fe.loc.Location;
   import flash.filters.GlowFilter;
   
   public class Emitter
   {
      
      public static var arr:Array;
      
      public static var kols:Array = [0,0,0,0,0,0];
      
      public static var kol1:int = 0;
      
      public static var kol2:int = 0;
      
      public static var fils:Array = new Array();
      
      fils["bur"] = [new GlowFilter(16742144,1,8,8,1,1)];
      fils["plav"] = [new GlowFilter(65280,1,8,8,1,1)];
      
      public var id:String;
      
      public var vis:String;
      
      public var visClass:Class;
      
      public var sloy:* = 3;
      
      public var imp:int = 0;
      
      public var blit:String;
      
      public var blitx:int = 0;
      
      public var blity:int = 0;
      
      public var blitf:int = -1;
      
      public var blitd:Number = 1;
      
      public var ctrans:Boolean = false;
      
      public var alph:Boolean = false;
      
      public var prealph:Boolean = false;
      
      public var anim:int = 0;
      
      public var blend:String = "normal";
      
      public var rsc:Number = 0;
      
      public var scale:Number = 1;
      
      public var frame:int = 0;
      
      public var dframe:int = 0;
      
      public var otklad:int = 0;
      
      public var filter:String;
      
      public var move:Boolean = false;
      
      public var minliv:int = 20;
      
      public var rliv:int = 0;
      
      public var minv:Number = 0;
      
      public var rv:Number = 0;
      
      public var rx:Number = 0;
      
      public var ry:Number = 0;
      
      public var rdx:Number = 0;
      
      public var rdy:Number = 0;
      
      public var rdr:Number = 0;
      
      public var dx:Number = 0;
      
      public var dy:Number = 0;
      
      public var rot:int = 0;
      
      public var brake:Number = 1;
      
      public var grav:Number = 0;
      
      public var rgrav:Number = 0;
      
      public var water:int = 0;
      
      public var maxkol:int = 0;
      
      public var camscale:Boolean = false;
      
      public function Emitter(param1:XML)
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         super();
         for(_loc2_ in param1.attributes())
         {
            _loc3_ = param1.attributes()[_loc2_].name();
            if(this.hasOwnProperty(_loc3_))
            {
               if(this[_loc3_] is Boolean)
               {
                  this[_loc3_] = true;
               }
               else
               {
                  this[_loc3_] = param1.attributes()[_loc2_];
               }
            }
         }
         if(this.vis)
         {
            this.visClass = Res.getClass(this.vis);
         }
      }
      
      public static function init() : *
      {
         var _loc1_:XML = null;
         var _loc2_:Emitter = null;
         arr = new Array();
         for each(_loc1_ in AllData.d.part)
         {
            _loc2_ = new Emitter(_loc1_);
            arr[_loc2_.id] = _loc2_;
         }
      }
      
      public static function emit(param1:String, param2:Location, param3:Number, param4:Number, param5:Object = null) : *
      {
         var _loc6_:Emitter = arr[param1];
         if(_loc6_)
         {
            _loc6_.cast(param2,param3,param4,param5);
         }
         else
         {
            trace("Нет частицы " + param1);
         }
      }
      
      public function cast(param1:Location, param2:Number, param3:Number, param4:Object = null) : Part
      {
         var _loc6_:Part = null;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:* = undefined;
         var _loc13_:* = undefined;
         if(param1 == null || !param1.active)
         {
            return null;
         }
         if(kol2 > World.w.maxParts && this.imp == 0)
         {
            return null;
         }
         var _loc5_:int = 1;
         if(Boolean(param4) && Boolean(param4.kol))
         {
            _loc5_ = int(param4.kol);
         }
         if(_loc5_ > 50)
         {
            _loc5_ = 50;
         }
         this.frame = this.dframe = 0;
         var _loc7_:* = 1;
         while(_loc7_ <= _loc5_)
         {
            if(this.maxkol > 0 && kols[this.maxkol] >= 12)
            {
               return _loc6_;
            }
            _loc6_ = new Part();
            _loc6_.loc = param1;
            _loc6_.sloy = this.sloy;
            _loc6_.X = param2;
            _loc6_.Y = param3;
            if(this.rx)
            {
               _loc6_.X += (Math.random() - 0.5) * this.rx;
            }
            if(this.ry)
            {
               _loc6_.Y += (Math.random() - 0.5) * this.ry;
            }
            if(this.maxkol > 0)
            {
               _loc6_.maxkol = this.maxkol;
               ++kols[this.maxkol];
            }
            _loc6_.vClass = this.visClass;
            if(this.minv + this.rv > 0)
            {
               _loc8_ = Math.random() * Math.PI * 2;
               _loc9_ = Math.random() * this.rv + this.minv;
               _loc6_.dx = Math.sin(_loc8_) * _loc9_;
               _loc6_.dy = Math.cos(_loc8_) * _loc9_;
            }
            if(this.rdx)
            {
               _loc6_.dx += (Math.random() - 0.5) * this.rdx;
            }
            if(this.rdy)
            {
               _loc6_.dy += (Math.random() - 0.5) * this.rdy;
            }
            _loc6_.dx += this.dx;
            _loc6_.dy += this.dy;
            if(this.rdr)
            {
               _loc6_.dr = (Math.random() - 0.5) * this.rdr;
            }
            if(this.rot)
            {
               _loc6_.r = Math.random() * 360;
            }
            if(param4)
            {
               if(param4.rx)
               {
                  _loc6_.X += (Math.random() - 0.5) * param4.rx;
               }
               if(param4.ry)
               {
                  _loc6_.Y += (Math.random() - 0.5) * param4.ry;
               }
               if(param4.dx)
               {
                  _loc6_.dx += param4.dx;
               }
               if(param4.dy)
               {
                  _loc6_.dy += param4.dy;
               }
               if(param4.dr)
               {
                  _loc6_.dr += param4.dr;
               }
               if(param4.md != null)
               {
                  _loc6_.dx *= param4.md;
                  _loc6_.dy *= param4.md;
               }
               if(param4.frame)
               {
                  this.frame = param4.frame;
               }
               if(param4.dframe)
               {
                  this.dframe = param4.dframe;
               }
               if(param4.otklad)
               {
                  this.otklad = param4.otklad;
               }
            }
            _loc6_.ddy = World.ddy * this.grav;
            _loc6_.brake = this.brake;
            if(this.rgrav)
            {
               _loc6_.ddy += World.ddy * this.rgrav * Math.random();
            }
            _loc6_.liv = _loc6_.mliv = Math.floor(Math.random() * this.rliv) + this.minliv;
            _loc6_.isAlph = this.alph;
            _loc6_.isPreAlph = this.prealph;
            _loc6_.isAnim = this.anim;
            _loc6_.isMove = _loc6_.dx != 0 || _loc6_.dy != 0 || _loc6_.ddy != 0;
            _loc6_.water = this.water;
            if(this.blitx)
            {
               _loc6_.blitX = this.blitx;
            }
            if(this.blity)
            {
               _loc6_.blitY = this.blity;
            }
            if(this.blitd)
            {
               _loc6_.blitDelta = this.blitd;
            }
            if(this.blitf > 0)
            {
               _loc6_.blitMFrame = this.blitf;
               _loc6_.blitFrame = Math.floor(Math.random() * this.blitf);
            }
            if(this.otklad > 0)
            {
               _loc6_.otklad = Math.floor(Math.random() * this.otklad + 1);
            }
            if(this.vis)
            {
               _loc6_.initVis(this.frame + (this.dframe == 0 ? 0 : Math.floor(Math.random() * this.dframe + 1)));
            }
            if(this.blit)
            {
               _loc6_.initBlit(this.blit);
            }
            if(_loc6_.vis)
            {
               if(Boolean(param4) && Boolean(param4.alpha))
               {
                  _loc6_.vis.alpha = param4.alpha;
               }
               if(Boolean(param4) && Boolean(param4.scale))
               {
                  _loc6_.vis.scaleX = _loc6_.vis.scaleY = param4.scale;
               }
               if(Boolean(param4) && Boolean(param4.rotation))
               {
                  _loc6_.vis.rotation = param4.rotation;
               }
               _loc6_.vis.blendMode = this.blend;
               if(this.scale != 1)
               {
                  _loc6_.vis.scaleX = _loc6_.vis.scaleY = this.scale;
               }
               if(this.rsc != 0)
               {
                  _loc6_.vis.scaleX = _loc6_.vis.scaleY = this.scale - this.rsc + Math.random() * this.rsc;
               }
               if(this.ctrans)
               {
                  _loc6_.vis.transform.colorTransform = param1.cTransform;
               }
               if(Boolean(this.filter) && Boolean(Emitter.fils[this.filter]))
               {
                  _loc6_.vis.filters = Emitter.fils[this.filter];
               }
               if(Boolean(param4 && param4.celx != null) && Boolean(param4.cely != null) && Boolean(_loc6_.vis.len))
               {
                  _loc10_ = param4.celx - _loc6_.X;
                  _loc11_ = param4.cely - _loc6_.Y;
                  _loc12_ = Math.sqrt(_loc10_ * _loc10_ + _loc11_ * _loc11_);
                  _loc13_ = Math.atan2(_loc11_,_loc10_) * 180 / Math.PI;
                  _loc6_.vis.len.scaleX = _loc12_ / _loc6_.vis.len.width;
                  _loc6_.vis.len.rotation = _loc13_;
                  if(_loc6_.vis.fl)
                  {
                     _loc6_.vis.fl.x = _loc10_;
                     _loc6_.vis.fl.y = _loc11_;
                  }
               }
               if(Boolean(param4) && Boolean(param4.mirr))
               {
                  _loc6_.vis.scaleX = -_loc6_.vis.scaleX;
               }
               param1.addObj(_loc6_);
               if(this.prealph)
               {
                  _loc6_.vis.alpha = 0;
               }
               if(this.id == "numb" && Boolean(param4.txt))
               {
                  _loc6_.vis.numb.text = param4.txt;
               }
               if((this.id == "replic" || this.id == "replic2") && Boolean(param4.txt))
               {
                  _loc6_.vis.text.text.text = param4.txt;
               }
               if((this.id == "gui" || this.id == "take") && Boolean(param4.txt))
               {
                  _loc6_.vis.text.text.styleSheet = World.w.gui.style;
                  _loc6_.vis.text.text.htmlText = param4.txt;
               }
               if(this.camscale)
               {
                  _loc6_.vis.scaleX = _loc6_.vis.scaleY = 1 / World.w.cam.scaleV;
                  if(Boolean(param4) && Boolean(param4.scale))
                  {
                     _loc6_.vis.scaleX *= param4.scale;
                     _loc6_.vis.scaleY *= param4.scale;
                  }
               }
            }
            _loc7_++;
         }
         return _loc6_;
      }
   }
}

