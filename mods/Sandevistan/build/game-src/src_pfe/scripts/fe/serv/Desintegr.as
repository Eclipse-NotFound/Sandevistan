package fe.serv
{
   import fe.Obj;
   import fe.Snd;
   import fe.graph.Emitter;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class Desintegr
   {
      
      public var owner:Obj;
      
      internal var burnBmp:BitmapData;
      
      internal var burnBm:Bitmap;
      
      internal var burnN:int = 0;
      
      internal var burnTip:int = 0;
      
      internal var burnPart:String;
      
      internal var burnGlowColor:uint;
      
      internal var burnCt:ColorTransform;
      
      internal var burnRnd:int;
      
      internal var burnKolPix:int;
      
      internal var burnTime1:int = 10;
      
      internal var burnTime2:int = 30;
      
      public var vse:Boolean = false;
      
      public function Desintegr(param1:Obj, param2:int)
      {
         var _loc4_:Rectangle = null;
         this.burnRnd = Math.random() * int.MAX_VALUE;
         super();
         this.owner = param1;
         this.burnTip = param2;
         this.burnBmp = new BitmapData(this.owner.vis.width,this.owner.vis.height,true,0);
         var _loc3_:Matrix = new Matrix();
         _loc4_ = this.owner.vis.getBounds(this.owner.vis);
         _loc3_.tx = -_loc4_.left;
         _loc3_.ty = -_loc4_.top;
         this.burnBmp.draw(this.owner.vis,_loc3_);
         this.owner.vis = new MovieClip();
         this.burnBm = new Bitmap(this.burnBmp);
         this.owner.vis.addChild(this.burnBm);
         this.burnBm.x = _loc4_.left;
         this.burnBm.y = _loc4_.top;
         if(this.burnTip == 1)
         {
            this.burnCt = new ColorTransform(1,1,1,1,255 / this.burnTime1,100 / this.burnTime1,0,0);
            this.burnPart = "burn";
            this.burnGlowColor = 16755200;
            Snd.ps("desintegr_f",this.owner.X,this.owner.Y);
         }
         else if(this.burnTip == 2)
         {
            this.burnCt = new ColorTransform(1,1,1,1,0,255 / this.burnTime1,100 / this.burnTime1,0);
            this.burnPart = "plakap";
            this.burnGlowColor = 65280;
            Snd.ps("liquid_f",this.owner.X,this.owner.Y);
         }
         else if(this.burnTip == 3)
         {
            this.burnCt = new ColorTransform(1,1,1,1,155 / this.burnTime1,155 / this.burnTime1,255 / this.burnTime1,0);
            this.burnPart = "burn";
            this.burnGlowColor = 4474111;
            Snd.ps("desintegr_f",this.owner.X,this.owner.Y);
         }
         else if(this.burnTip == 4)
         {
            this.burnCt = new ColorTransform(1,1,1,1,100 / this.burnTime1,100 / this.burnTime1,255 / this.burnTime1,0);
            this.burnPart = "krupa";
            this.burnGlowColor = 255;
            Snd.ps("freezing_f",this.owner.X,this.owner.Y);
         }
         else if(this.burnTip == 5)
         {
            this.burnCt = new ColorTransform(1,0.85,0.85,1,0,0,0,0);
            this.burnPart = "blood";
            this.burnGlowColor = 16711680;
         }
         else if(this.burnTip == 6)
         {
            this.burnCt = new ColorTransform(0.9,1,0.85,1,0,0,0,0);
            this.burnPart = "gblood";
            this.burnGlowColor = 6736947;
         }
         else if(this.burnTip == 7)
         {
            this.burnCt = new ColorTransform(1,0.85,0.88,1,0,0,0,0);
            this.burnPart = "pblood";
            this.burnGlowColor = 16738047;
         }
         this.burnKolPix = this.burnBmp.height * this.burnBmp.width;
         this.burnN = 1;
      }
      
      public function step() : *
      {
         if(this.burnN > 0 && this.burnN <= this.burnTime1)
         {
            this.burnBmp.colorTransform(this.burnBmp.rect,this.burnCt);
            this.burnBm.filters = [new GlowFilter(this.burnGlowColor,this.burnN / this.burnTime1,3,3,2,3)];
         }
         else if(this.burnN > this.burnTime1 && this.burnN <= this.burnTime2 + this.burnTime1)
         {
            this.burnBmp.pixelDissolve(this.burnBmp,this.burnBmp.rect,new Point(0,0),this.burnRnd,this.burnKolPix * (this.burnN - this.burnTime1) / this.burnTime2,16711680);
            if(this.owner.massa >= 0.25 || Math.random() < this.owner.massa * 4)
            {
               Emitter.emit(this.burnPart,this.owner.loc,this.owner.X,this.owner.Y - this.owner.scY / 2,{
                  "rx":this.owner.scX * 0.75,
                  "rx":this.owner.scY * 0.5
               });
            }
         }
         else if(this.burnN >= this.burnTime2 + this.burnTime1)
         {
            this.vse = true;
         }
         ++this.burnN;
      }
   }
}

