package fe.weapon
{
   import fe.World;
   import fe.loc.Location;
   import fe.loc.Tile;
   import flash.display.Graphics;
   
   public class Trasser
   {
      
      public var loc:Location;
      
      public var X:Number;
      
      public var Y:Number;
      
      public var dx:Number;
      
      public var dy:Number;
      
      public var begx:Number;
      
      public var begy:Number;
      
      public var begdx:Number;
      
      public var begdy:Number;
      
      public var ddx:Number = 0;
      
      public var ddy:Number = 0;
      
      public var is_skok:Boolean = false;
      
      public var vse:Boolean = false;
      
      public var stay:Boolean = false;
      
      public var liv:int = 100;
      
      public var sled:Array;
      
      public var explRadius:Number = 0;
      
      internal var brake:* = 2;
      
      internal var skok:Number = 0.5;
      
      internal var tormoz:Number = 0.7;
      
      public function Trasser()
      {
         super();
      }
      
      public function trass(param1:Graphics) : *
      {
         var _loc3_:* = undefined;
         var _loc4_:* = undefined;
         this.sled = new Array();
         this.X = this.begx;
         this.Y = this.begy;
         this.dx = this.begdx;
         this.dy = this.begdy;
         this.vse = this.stay = false;
         param1.clear();
         param1.lineStyle(5,65433,0.5);
         param1.moveTo(this.X,this.Y);
         var _loc2_:* = 0;
         while(_loc2_ < this.liv)
         {
            this.dy += this.ddy;
            this.dx += this.ddx;
            if(this.stay)
            {
               if(this.dx > 1)
               {
                  this.dx -= this.brake;
               }
               else if(this.dx < -1)
               {
                  this.dx += this.brake;
               }
               else
               {
                  this.dx = 0;
               }
            }
            if(Math.abs(this.dx) < World.maxdelta && Math.abs(this.dy) < World.maxdelta)
            {
               this.run();
            }
            else
            {
               _loc3_ = Math.floor(Math.max(Math.abs(this.dx),Math.abs(this.dy)) / World.maxdelta) + 1;
               _loc4_ = 0;
               while(_loc4_ < _loc3_ && !this.vse)
               {
                  this.run(_loc3_);
                  _loc4_++;
               }
            }
            param1.lineTo(this.X,this.Y);
            this.sled.push({
               "x":this.X,
               "y":this.Y
            });
            if(this.vse)
            {
               break;
            }
            _loc2_++;
         }
      }
      
      public function run(param1:int = 1) : *
      {
         var _loc2_:Tile = null;
         if(this.vse)
         {
            return;
         }
         this.X += this.dx / param1;
         if(this.X < 0 || this.X >= this.loc.spaceX * Tile.tileX)
         {
            this.vse = true;
            return;
         }
         if(this.dx < 0)
         {
            _loc2_ = this.loc.getAbsTile(this.X,this.Y);
            if(_loc2_.phis == 1 && this.X <= _loc2_.phX2 && this.X >= _loc2_.phX1 && this.Y >= _loc2_.phY1 && this.Y <= _loc2_.phY2)
            {
               if(!this.is_skok)
               {
                  this.vse = true;
               }
               else
               {
                  this.X = _loc2_.phX2 + 1;
                  this.dx = Math.abs(this.dx * this.skok);
               }
            }
         }
         if(this.dx > 0)
         {
            _loc2_ = this.loc.getAbsTile(this.X,this.Y);
            if(_loc2_.phis == 1 && this.X >= _loc2_.phX1 && this.X <= _loc2_.phX2 && this.Y >= _loc2_.phY1 && this.Y <= _loc2_.phY2)
            {
               if(!this.is_skok)
               {
                  this.vse = true;
               }
               else
               {
                  this.X = _loc2_.phX1 - 1;
                  this.dx = -Math.abs(this.dx * this.skok);
               }
            }
         }
         if(this.vse)
         {
            this.Y += this.dy / param1;
            return;
         }
         if(this.dy < 0)
         {
            this.Y += this.dy / param1;
            _loc2_ = this.loc.getAbsTile(this.X,this.Y);
            if(_loc2_.phis == 1 && this.Y <= _loc2_.phY2 && this.Y >= _loc2_.phY1 && this.X >= _loc2_.phX1 && this.X <= _loc2_.phX2)
            {
               if(!this.is_skok)
               {
                  this.vse = true;
               }
               else
               {
                  this.Y = _loc2_.phY2 + 1;
                  this.dy = Math.abs(this.dy * this.skok);
               }
            }
         }
         var _loc3_:Number = 0;
         if(this.dy > 0)
         {
            this.Y += this.dy / param1;
            if(this.Y >= this.loc.spaceY * Tile.tileY)
            {
               this.vse = true;
               return;
            }
            _loc2_ = this.loc.getAbsTile(this.X,this.Y);
            if(_loc2_.phis == 1 && this.Y >= _loc2_.phY1 && this.Y <= _loc2_.phY2 && this.X >= _loc2_.phX1 && this.X <= _loc2_.phX2)
            {
               this.Y = _loc2_.phY1 - 1;
               if(!this.is_skok)
               {
                  this.vse = true;
               }
               else if(this.dy > 2)
               {
                  this.dy = -Math.abs(this.dy * this.skok);
                  this.dx *= this.tormoz;
               }
               else
               {
                  this.dy = 0;
                  this.stay = true;
               }
            }
         }
      }
   }
}

