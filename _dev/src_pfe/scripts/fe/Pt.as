package fe
{
   import fe.loc.Location;
   import flash.display.MovieClip;
   
   public class Pt
   {
      
      public var loc:Location;
      
      public var nobj:Pt;
      
      public var pobj:Pt;
      
      public var in_chain:Boolean = false;
      
      public var stay:Boolean = false;
      
      public var X:Number;
      
      public var Y:Number;
      
      public var sloy:int = 0;
      
      public var dx:Number = 0;
      
      public var dy:Number = 0;
      
      public var vis:MovieClip;
      
      public function Pt()
      {
         super();
      }
      
      public function addVisual() : *
      {
         if(Boolean(this.vis) && Boolean(this.loc) && this.loc.active)
         {
            World.w.grafon.visObjs[this.sloy].addChild(this.vis);
         }
      }
      
      public function remVisual() : *
      {
         if(Boolean(this.vis) && Boolean(this.vis.parent))
         {
            this.vis.parent.removeChild(this.vis);
         }
      }
      
      public function setNull(param1:Boolean = false) : *
      {
      }
      
      public function err() : String
      {
         if(this.loc)
         {
            this.loc.remObj(this);
         }
         return null;
      }
      
      public function step() : *
      {
      }
   }
}

