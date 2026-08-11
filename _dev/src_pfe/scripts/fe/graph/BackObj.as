package fe.graph
{
   import fe.*;
   import fe.loc.Location;
   import flash.display.MovieClip;
   import flash.utils.*;
   
   public class BackObj
   {
      
      public var id:String;
      
      public var X:Number;
      
      public var Y:Number;
      
      public var scX:Number = 1;
      
      public var scY:Number = 1;
      
      public var vis:MovieClip;
      
      public var erase:MovieClip;
      
      public var light:MovieClip;
      
      public var frame:int = 1;
      
      public var frameOn:int = 0;
      
      public var frameOff:int = 0;
      
      public var blend:String = "normal";
      
      public var alpha:Number = 1;
      
      public var sloy:int = 0;
      
      public var er:Boolean = false;
      
      public function BackObj(param1:Location, param2:String, param3:Number, param4:Number, param5:XML = null)
      {
         var node:XML = null;
         var wid:* = undefined;
         var nloc:Location = param1;
         var nid:String = param2;
         var nx:Number = param3;
         var ny:Number = param4;
         var xml:XML = param5;
         super();
         this.id = nid;
         this.X = nx;
         this.Y = ny;
         node = AllData.d.back.(@id == id)[0];
         wid = node.@x2 * World.tileX;
         if(Boolean(xml) && Boolean(xml.@w.length()))
         {
            wid = xml.@w * World.tileX;
         }
         if(wid <= 0)
         {
            wid = World.tileX;
         }
         if(Boolean(nloc) && nloc.mirror)
         {
            if(node.@mirr == "2" && Math.random() < 0.5)
            {
               this.X = nloc.limX - this.X;
               this.scX = -1;
            }
            else if(node.@mirr == "1")
            {
               this.X = nloc.limX - this.X;
               this.scX = -1;
            }
            else
            {
               this.X = nloc.limX - this.X - wid;
            }
         }
         else if(node.@mirr == "2" && Math.random() < 0.5)
         {
            this.X = nx + wid;
            this.scX = -1;
         }
         this.vis = World.w.grafon.getObj("back_" + (node.@tid.length() ? node.@tid : this.id) + "_t",Grafon.numbBack);
         this.erase = World.w.grafon.getObj("back_" + (node.@tid.length() ? node.@tid : this.id) + "_e",Grafon.numbBack);
         this.light = World.w.grafon.getObj("back_" + (node.@tid.length() ? node.@tid : this.id) + "_l",Grafon.numbBack);
         if(node.@fr.length())
         {
            this.frame = node.@fr;
         }
         else if(nloc.lightOn > 0 && Boolean(node.@lon.length()))
         {
            this.frame = node.@lon;
         }
         else if(nloc.lightOn < 0 && Boolean(node.@loff.length()))
         {
            this.frame = node.@loff;
         }
         else if(this.vis)
         {
            this.frame = Math.floor(Math.random() * this.vis.totalFrames + 1);
         }
         else
         {
            this.frame = 1;
         }
         if(node.@s.length())
         {
            this.sloy = node.@s;
         }
         if(node.@blend.length())
         {
            this.blend = node.@blend;
         }
         if(node.@alpha.length())
         {
            this.alpha = node.@alpha;
         }
         if(node.@er.length())
         {
            this.er = true;
         }
         if(xml)
         {
            if(xml.@w.length())
            {
               this.scX = xml.@w;
            }
            if(xml.@h.length())
            {
               this.scY = xml.@h;
            }
            if(xml.@a.length())
            {
               this.alpha = xml.@a;
            }
            if(xml.@fr.length())
            {
               this.frame = xml.@fr;
            }
            if(Boolean(xml.@lon.length()) && Boolean(xml.@lon > 1) && Boolean(node.@lon.length()))
            {
               this.frame = node.@lon;
            }
            if(Boolean(xml.@lon.length()) && Boolean(xml.@lon < 1) && Boolean(node.@loff.length()))
            {
               this.frame = node.@loff;
            }
         }
         if(this.frame > 0)
         {
            if(this.vis)
            {
               this.vis.gotoAndStop(this.frame);
            }
            if(this.erase)
            {
               this.erase.gotoAndStop(this.frame);
            }
            if(this.light)
            {
               this.light.gotoAndStop(this.frame);
            }
         }
         if(node.@loff.length())
         {
            this.frameOff = node.@loff;
         }
         if(node.@lon.length())
         {
            this.frameOn = node.@lon;
         }
      }
      
      public function onoff(param1:int) : *
      {
         if(param1 > 0 && Boolean(this.frameOn))
         {
            this.frame = this.frameOn;
         }
         if(param1 < 0 && Boolean(this.frameOff))
         {
            this.frame = this.frameOff;
         }
         if(this.frame > 0)
         {
            if(this.vis)
            {
               this.vis.gotoAndStop(this.frame);
            }
            if(this.erase)
            {
               this.erase.gotoAndStop(this.frame);
            }
            if(this.light)
            {
               this.light.gotoAndStop(this.frame);
            }
         }
      }
   }
}

