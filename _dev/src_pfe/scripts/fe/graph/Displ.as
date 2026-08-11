package fe.graph
{
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.MovieClip;
   import flash.filters.DisplacementMapFilter;
   import flash.filters.DisplacementMapFilterMode;
   import flash.geom.Matrix;
   import flash.geom.Point;
   
   public class Displ
   {
      
      internal var mm:MovieClip;
      
      internal var gr:MovieClip;
      
      internal var displFilter1:DisplacementMapFilter;
      
      internal var displFilter2:DisplacementMapFilter;
      
      internal var displBmpd:BitmapData;
      
      internal var displStamp:MovieClip;
      
      internal var displPoint:Point;
      
      internal var displMatrix:Matrix;
      
      internal var displX:Number = 10;
      
      internal var displY:Number = 15;
      
      internal var disp_t:int = 0;
      
      internal var wavKol:int = 10;
      
      internal var wavArr:Array;
      
      internal var disX:* = 200;
      
      internal var disY:* = 250;
      
      internal var spd:Number = 1;
      
      internal var t_anim:int = 0;
      
      internal var t_klip:int = 60;
      
      internal var t_groza:int = 120;
      
      internal var p_x:Number;
      
      internal var p_y:Number;
      
      public function Displ(param1:MovieClip, param2:MovieClip = null)
      {
         var _loc4_:MovieClip = null;
         this.displPoint = new Point(0,0);
         this.displMatrix = new Matrix();
         this.wavArr = new Array();
         super();
         this.mm = param1;
         this.gr = param2;
         this.displBmpd = new BitmapData(240,300,false,8355711);
         this.displStamp = new displVolna();
         this.displMatrix.tx = this.mm.target.x - this.mm.displ1.x;
         this.displMatrix.ty = this.mm.target.y - this.mm.displ1.y;
         this.displFilter1 = new DisplacementMapFilter(this.displBmpd,this.displPoint,BitmapDataChannel.RED,BitmapDataChannel.RED,this.displX,this.displY,DisplacementMapFilterMode.COLOR);
         this.displFilter2 = new DisplacementMapFilter(this.displBmpd,this.displPoint,BitmapDataChannel.RED,BitmapDataChannel.RED,0,5,DisplacementMapFilterMode.COLOR);
         var _loc3_:int = 0;
         while(_loc3_ < this.wavKol)
         {
            _loc4_ = new visWav();
            _loc4_.x = Math.random() * this.disX * 2 - this.disX;
            _loc4_.y = Math.random() * this.disY * 2 - this.disY;
            _loc4_.scaleX = Math.random() + 2;
            _loc4_.scaleY = 3;
            this.displStamp.addChild(_loc4_);
            this.wavArr[_loc3_] = _loc4_;
            _loc3_++;
         }
         _loc4_ = new visSerost();
         this.displStamp.addChild(_loc4_);
         this.p_x = this.mm.pistol.x;
         this.p_y = this.mm.pistol.y;
         if(this.gr)
         {
            this.gr.tuchi.cacheAsBitmap = this.gr.maska.cacheAsBitmap = true;
            this.gr.tuchi.blendMode = "screen";
            this.gr.tuchi.mask = this.gr.maska;
         }
      }
      
      public function anim() : *
      {
         var _loc2_:MovieClip = null;
         ++this.t_anim;
         --this.t_klip;
         if(this.t_klip <= 0)
         {
            this.mm.eye.play();
            this.t_klip = Math.floor(Math.random() * 110 + 60);
         }
         var _loc1_:int = 0;
         while(_loc1_ < this.wavKol)
         {
            _loc2_ = this.wavArr[_loc1_];
            _loc2_.x -= this.spd + _loc1_ / 2;
            _loc2_.y += (this.spd + _loc1_ / 2) * 0.3;
            if(_loc2_.x < -this.disX * 2)
            {
               _loc2_.x = this.disX;
               _loc2_.scaleX = Math.random() + 2;
               _loc2_.scaleY = 3;
               _loc2_.alpha = Math.random() * 0.5 + 0.5;
            }
            if(_loc2_.y > this.disY)
            {
               _loc2_.y = -this.disY;
            }
            _loc1_++;
         }
         this.displBmpd.draw(this.displStamp,this.displMatrix);
         this.mm.displ1.filters = [this.displFilter1];
         this.mm.displ2.filters = [this.displFilter2];
         this.mm.pistol.x = this.p_x + Math.sin(this.t_anim / 100) * 2;
         this.mm.pistol.y = this.p_y - (Math.cos(this.t_anim / 100) - 1) * 8;
         this.mm.pistol.magic.krug.rotation = this.t_anim;
         this.mm.pistol.magic2.krug.rotation = 90 + this.t_anim * 0.67;
         this.mm.horn.magic.krug.rotation = 90 + this.t_anim * 0.67;
         if(this.gr)
         {
            --this.t_groza;
            if(this.t_groza == 0)
            {
               this.gr.x = Math.random() * 1800;
               this.gr.y = Math.random() * 350;
               this.gr.scaleX = this.gr.scaleY = 1 - this.gr.y / 800;
               this.gr.moln.moln.rotation = Math.random() * 360;
               this.gr.moln.moln.gotoAndStop(Math.floor(Math.random() * this.gr.moln.moln.totalFrames + 1));
               this.gr.alpha = 1;
               this.gr.visible = true;
               this.gr.tuchi.x = -200 - Math.random() * 400;
               this.gr.tuchi.y = -200 - Math.random() * 300;
            }
            else if(this.t_groza < 0)
            {
               this.gr.alpha = Math.min(1,Math.random() * 0.5 + this.t_groza / 12 + 0.7);
               if(this.t_groza < -6 && Math.random() < 0.1)
               {
                  this.t_groza = -100;
               }
            }
            if(this.t_groza < -30)
            {
               this.t_groza = Math.floor(Math.random() * 200 + 100);
               this.gr.visible = false;
            }
         }
      }
   }
}

