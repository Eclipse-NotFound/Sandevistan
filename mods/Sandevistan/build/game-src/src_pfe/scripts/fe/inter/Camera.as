package fe.inter
{
   import fe.Snd;
   import fe.World;
   import fe.loc.Location;
   import fe.unit.Unit;
   import flash.display.DisplayObject;
   
   public class Camera
   {
      
      public var w:World;
      
      public var moved:Boolean;
      
      public var screenX:int = 1280;
      
      public var screenY:int = 800;
      
      public var X:int = 200;
      
      public var Y:int = 200;
      
      public var vx:int;
      
      public var vy:int;
      
      public var ovy:int;
      
      public var maxsx:int = 2000;
      
      public var maxsy:int = 2000;
      
      public var maxvx:int = 2000;
      
      public var maxvy:int = 2000;
      
      public var celX:int;
      
      public var celY:int;
      
      public var camRun:Boolean = false;
      
      public var otryv:Number = 0;
      
      public var quakeX:Number = 0;
      
      public var quakeY:Number = 0;
      
      public var isZoom:int = 0;
      
      public var scaleV:* = 1;
      
      public var scaleS:* = 1;
      
      public var dblack:Number = 0;
      
      public var showOn:Boolean = false;
      
      public var showX:Number = -1;
      
      public var showY:Number = 0;
      
      public function Camera(param1:World)
      {
         super();
         this.w = param1;
      }
      
      public function setLoc(param1:Location) : *
      {
         if(param1 == null)
         {
            return;
         }
         this.screenX = this.w.swfStage.stageWidth;
         this.screenY = this.w.swfStage.stageHeight;
         this.maxsx = param1.limX;
         this.maxsy = param1.limY;
         this.maxvx = this.maxsx - this.screenX;
         this.maxvy = this.maxsy - this.screenY;
         this.quakeX = this.quakeY = 0;
         if(param1.limX - 40 <= this.screenX && param1.limY - 40 <= this.screenY)
         {
            this.moved = false;
            this.vx = -this.maxvx / 2;
            this.vy = -this.maxvy / 2;
            this.w.visual.x = this.w.sats.vis.x = this.vx;
            this.w.visual.y = this.w.sats.vis.y = this.vy;
         }
         else
         {
            this.moved = true;
         }
         this.setZoom();
      }
      
      public function setKoord(param1:DisplayObject, param2:Number, param3:Number) : *
      {
         param1.x = param2 * this.scaleV + this.vx;
         param1.y = param3 * this.scaleV + this.vy;
      }
      
      public function setZoom(param1:int = -1000) : *
      {
         if(param1 == 1000)
         {
            ++this.isZoom;
            if(this.isZoom > 2)
            {
               this.isZoom = 0;
            }
            World.w.gui.infoText("zoom" + this.isZoom);
         }
         else if(param1 >= 0)
         {
            this.isZoom = param1;
         }
         if(this.isZoom == 1)
         {
            this.scaleV = Math.max(this.screenX / this.maxsx,this.screenY / this.maxsy);
         }
         else if(this.isZoom == 2)
         {
            this.scaleV = Math.min(this.screenX / this.maxsx,this.screenY / this.maxsy);
         }
         else
         {
            this.scaleV = 1;
         }
         this.scaleS = Math.min(this.screenX / 1920,this.screenY / 1000);
         if(this.scaleV > 0.98)
         {
            this.scaleV = 1;
         }
         this.maxvx = this.maxsx * this.scaleV - this.screenX;
         this.maxvy = this.maxsy * this.scaleV - this.screenY;
         this.w.visual.scaleX = this.w.sats.vis.scaleX = this.w.visual.scaleY = this.w.sats.vis.scaleY = this.scaleV;
         this.w.vscene.scaleX = this.w.vscene.scaleY = this.scaleS;
         if(this.screenY > this.maxsy * this.scaleV)
         {
            World.w.grafon.ramT.scaleY = -(this.screenY - this.maxsy * this.scaleV) / 100 / this.scaleV - 0.5;
            World.w.grafon.ramB.scaleY = (this.screenY - this.maxsy * this.scaleV + 5) / 100 / this.scaleV + 0.5;
         }
         else
         {
            World.w.grafon.ramT.scaleY = -0.5 / this.scaleV;
            World.w.grafon.ramB.scaleY = 0.6 / this.scaleV;
         }
         if(this.screenX > this.maxsx * this.scaleV)
         {
            World.w.grafon.ramL.scaleX = -(this.screenX - this.maxsx * this.scaleV) / 100 / this.scaleV - 0.5;
            World.w.grafon.ramR.scaleX = (this.screenX - this.maxsx * this.scaleV + 5) / 100 / this.scaleV + 0.5;
         }
         else
         {
            World.w.grafon.ramL.scaleX = -0.5 / this.scaleV;
            World.w.grafon.ramR.scaleX = 0.5 / this.scaleV;
         }
      }
      
      public function calc(param1:Unit) : *
      {
         if(this.w.ctr.keyZoom)
         {
            if(Boolean(World.w.loc) && World.w.loc.sky)
            {
               this.setZoom(2);
            }
            else
            {
               this.setZoom(1000);
            }
            this.w.ctr.keyZoom = false;
         }
         if(this.moved)
         {
            if((this.w.ctr.keyLook || this.showOn) && this.otryv < 1)
            {
               if(this.showOn)
               {
                  this.otryv += 0.2;
               }
               else
               {
                  this.otryv += 0.05;
               }
            }
            if(!this.w.ctr.keyLook && !this.showOn && this.otryv > 0)
            {
               this.otryv -= 0.2;
               if(this.otryv < 0)
               {
                  this.otryv = 0;
               }
            }
            if(this.w.ctr.keyLook)
            {
               this.showX = -1;
            }
            if(!this.camRun)
            {
               if(this.otryv > 0)
               {
                  if(this.showX >= 0)
                  {
                     this.X = param1.X * this.scaleV + this.otryv * (this.showX - this.screenX / 2) * 1.3;
                     this.Y = param1.Y * this.scaleV + this.otryv * (this.showY - this.screenY / 2) * 1.3;
                  }
                  else
                  {
                     this.X = param1.X * this.scaleV + this.otryv * (this.celX - this.screenX / 2);
                     this.Y = param1.Y * this.scaleV + this.otryv * (this.celY - this.screenY / 2);
                  }
               }
               else
               {
                  this.X = param1.X * this.scaleV;
                  if(this.ovy - param1.Y * this.scaleV > 5 && this.ovy - param1.Y * this.scaleV < 50)
                  {
                     this.Y = this.ovy - (this.ovy - param1.Y * this.scaleV) / 4;
                  }
                  else
                  {
                     this.Y = param1.Y * this.scaleV;
                  }
               }
            }
            this.ovy = this.Y;
            if(this.maxvx < 0)
            {
               this.vx = -this.maxvx / 2;
            }
            else
            {
               this.vx = -this.X + this.screenX / 2;
               if(this.vx > 0)
               {
                  this.vx = 0;
               }
               if(this.vx < -this.maxvx)
               {
                  this.vx = -this.maxvx;
               }
            }
            if(this.maxvy < 0)
            {
               this.vy = -this.maxvy / 2;
            }
            else
            {
               this.vy = -this.Y + this.screenY / 2 + 100;
               if(this.vy > 0)
               {
                  this.vy = 0;
               }
               if(this.vy < -this.maxvy)
               {
                  this.vy = -this.maxvy;
               }
            }
         }
         if(this.quakeX != 0)
         {
            if(Math.random() > 0.2)
            {
               this.quakeX *= -(Math.random() * 0.3 + 0.5);
            }
            if(this.quakeX < 1 && this.quakeX > -1)
            {
               this.quakeX = 0;
            }
         }
         if(this.quakeY != 0)
         {
            if(Math.random() > 0.2)
            {
               this.quakeY *= -(Math.random() * 0.3 + 0.5);
            }
            if(this.quakeY < 1 && this.quakeY > -1)
            {
               this.quakeY = 0;
            }
         }
         this.w.visual.x = this.w.sats.vis.x = this.vx + this.quakeX;
         this.w.visual.y = this.w.sats.vis.y = this.vy + this.quakeY;
         Snd.centrX = this.X;
         Snd.centrY = this.Y;
         this.w.celX = (this.celX - this.vx) / this.scaleV;
         this.w.celY = (this.celY - this.vy) / this.scaleV;
         if(this.dblack > 0)
         {
            this.w.vblack.visible = true;
            this.w.vblack.alpha += this.dblack / 100;
            if(this.w.vblack.alpha >= 1)
            {
               this.dblack = 0;
            }
         }
         if(this.dblack < 0)
         {
            this.w.vblack.alpha += this.dblack / 100;
            if(this.w.vblack.alpha <= 0)
            {
               this.dblack = 0;
               this.w.vblack.visible = false;
            }
         }
      }
   }
}

