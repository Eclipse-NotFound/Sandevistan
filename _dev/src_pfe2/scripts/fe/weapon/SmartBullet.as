package fe.weapon
{
   import fe.*;
   import fe.unit.Unit;
   
   public class SmartBullet extends Bullet
   {
      
      internal static var p:Object = {
         "x":0,
         "y":0
      };
      
      public var manevr:Number = 3;
      
      public var maxVel:* = 150;
      
      public var cel:Unit;
      
      public function SmartBullet(param1:Unit, param2:Number, param3:Number, param4:Class = null, param5:Boolean = true)
      {
         super(param1,param2,param3,param4);
         vRot = true;
      }
      
      public function setCel(param1:Unit, param2:Number = 3) : *
      {
         this.cel = param1;
         this.manevr = param2;
      }
      
      override public function step() : *
      {
         if(Boolean(!babah) && Boolean(this.cel) && this.manevr > 0)
         {
            p.x = this.cel.X - X;
            p.y = (this.cel.Y1 + this.cel.Y2) / 2 - Y;
            norma(p,this.manevr);
            p.x += dx;
            p.y += dy;
            if(vel < this.maxVel)
            {
               vel += accel;
            }
            norma(p,vel);
            dx = p.x;
            dy = p.y;
         }
         super.step();
         rot = Math.atan2(dy,dx);
         if(vis)
         {
            vis.rotation = rot * 180 / Math.PI;
         }
      }
   }
}

