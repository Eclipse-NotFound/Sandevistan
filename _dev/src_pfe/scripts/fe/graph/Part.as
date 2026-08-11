package fe.graph
{
   import fe.*;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Part extends Pt
   {
      
      public var vClass:Class;
      
      public var isMove:Boolean = false;
      
      public var isAnim:int = 0;
      
      public var isAlph:Boolean = false;
      
      public var isPreAlph:Boolean = false;
      
      public var dr:Number = 0;
      
      public var r:Number = 0;
      
      public var ddy:Number = 0;
      
      public var liv:int = 20;
      
      public var mliv:int = 20;
      
      public var brake:Number = 1;
      
      public var otklad:int = 0;
      
      public var blitData:BitmapData;
      
      internal var blitX:int = 120;
      
      internal var blitY:int = 120;
      
      internal var blitRect:Rectangle;
      
      internal var blitPoint:Point;
      
      internal var visData:BitmapData;
      
      internal var visBmp:Bitmap;
      
      internal var blitFrame:Number = 0;
      
      internal var blitDelta:Number = 1;
      
      internal var blitMFrame:int = -1;
      
      public var water:int = 0;
      
      public var maxkol:int = 0;
      
      public function Part()
      {
         super();
      }
      
      override public function setNull(param1:Boolean = false) : *
      {
         if(this.visData)
         {
            this.visData.dispose();
         }
         loc.remObj(this);
         if(this.maxkol > 0)
         {
            --Emitter.kols[this.maxkol];
         }
         delete global[this];
      }
      
      public function initBlit(param1:String) : *
      {
         var _loc2_:int = 0;
         this.blitData = World.w.grafon.getSpriteList(param1,1);
         this.blitRect = new Rectangle(0,0,this.blitX,this.blitY);
         this.blitPoint = new Point(0,0);
         vis = new MovieClip();
         this.visData = new BitmapData(this.blitX,this.blitY,true,0);
         this.visBmp = new Bitmap(this.visData);
         vis.addChild(this.visBmp);
         this.visBmp.x = -this.blitX / 2;
         this.visBmp.y = -this.blitY / 2;
         vis.x = X;
         vis.y = Y;
         vis.rotation = this.r;
         if(this.isAnim == 0)
         {
            _loc2_ = Math.floor(Math.random() * this.blitData.width / this.blitX);
            this.blit(_loc2_);
         }
      }
      
      public function blit(param1:int) : *
      {
         this.blitRect.x = param1 * this.blitX;
         this.blitRect.y = 0;
         this.visData.copyPixels(this.blitData,this.blitRect,this.blitPoint);
      }
      
      public function initVis(param1:int = 0) : *
      {
         if(this.vClass)
         {
            vis = new this.vClass();
            if(param1 == 0)
            {
               vis.gotoAndStop(Math.floor(Math.random() * vis.totalFrames + 1));
            }
            else
            {
               vis.gotoAndStop(param1);
            }
            if(this.isAnim == 0)
            {
               vis.cacheAsBitmap = true;
            }
            else if(this.isAnim == 2)
            {
               vis.gotoAndPlay(Math.floor(Math.random() * vis.totalFrames) + 1);
            }
            else
            {
               vis.gotoAndPlay(param1 + 1);
            }
            vis.x = X;
            vis.y = Y;
            vis.rotation = this.r;
            return;
         }
      }
      
      override public function step() : *
      {
         var _loc1_:* = undefined;
         if(this.otklad > 0)
         {
            vis.visible = false;
            vis.stop();
            --this.otklad;
            return;
         }
         if(vis.visible == false)
         {
            vis.visible = true;
            if(this.isAnim > 0)
            {
               vis.play();
            }
         }
         if(this.isMove)
         {
            X += dx;
            Y += dy;
            dy += this.ddy;
            this.r += this.dr;
            vis.x = X;
            vis.y = Y;
            vis.rotation = this.r;
            dx *= this.brake;
            dy *= this.brake;
         }
         if(this.isAlph && this.liv < 9)
         {
            vis.alpha = this.liv / 10;
         }
         else if(this.isPreAlph && this.mliv - this.liv < 9)
         {
            vis.alpha = (this.mliv - this.liv) / 10;
         }
         else if(this.isAlph || this.isPreAlph)
         {
            vis.alpha = 1;
         }
         if(Boolean(this.isAnim) && Boolean(this.blitData) && this.blitFrame * this.blitX < this.blitData.width)
         {
            this.blit(Math.floor(this.blitFrame));
            this.blitFrame += this.blitDelta;
            if(this.blitMFrame > 0 && this.blitFrame >= this.blitMFrame)
            {
               this.blitFrame = 0;
            }
         }
         if(this.water > 0)
         {
            _loc1_ = loc.getAbsTile(X,Y).water;
            if(this.water == 2 && _loc1_ == 0 || this.water == 1 && _loc1_ > 0)
            {
               this.liv = 1;
            }
         }
         --this.liv;
         if(this.liv <= 0)
         {
            this.setNull();
         }
         ++Emitter.kol1;
      }
   }
}

