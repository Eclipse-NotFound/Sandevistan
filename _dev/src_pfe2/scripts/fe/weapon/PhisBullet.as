package fe.weapon
{
   import fe.*;
   import fe.graph.Emitter;
   import fe.loc.Box;
   import fe.loc.Tile;
   import fe.unit.Unit;
   import fe.unit.UnitPlayer;
   
   public class PhisBullet extends Bullet
   {
      
      internal var brake:* = 2;
      
      internal var dr:Number = 0;
      
      internal var lip:Boolean = false;
      
      internal var prilip:Boolean = false;
      
      internal var bumc:Boolean = false;
      
      internal var skok:Number = 0.5;
      
      internal var tormoz:Number = 0.7;
      
      internal var isSensor:Boolean = false;
      
      public var sndHit:String = "";
      
      public function PhisBullet(param1:Unit, param2:Number, param3:Number, param4:Class = null)
      {
         super(param1,param2,param3,param4);
         ddy = World.ddy;
         massa = 0.1;
         warn = 1;
         levitPoss = true;
         inWater = 0;
         scX = scY = 30;
         if(vis)
         {
            vis.visible = true;
         }
      }
      
      override public function step() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:* = undefined;
         if(levit)
         {
            dy *= 0.8;
            dx *= 0.8;
         }
         else
         {
            dy += ddy;
         }
         if(stay)
         {
            if(dx > 1)
            {
               dx -= this.brake;
            }
            else if(dx < -1)
            {
               dx += this.brake;
            }
            else
            {
               dx = 0;
            }
            this.dr = dx;
         }
         if(inWater)
         {
            dy *= 0.8;
            dx *= 0.8;
         }
         if(!babah && !this.prilip)
         {
            if(Math.abs(dx) < World.maxdelta && Math.abs(dy) < World.maxdelta)
            {
               this.run();
            }
            else
            {
               _loc1_ = Math.floor(Math.max(Math.abs(dx),Math.abs(dy)) / World.maxdelta) + 1;
               _loc2_ = 0;
               while(_loc2_ < _loc1_ && !babah)
               {
                  this.run(_loc1_);
                  _loc2_++;
               }
            }
         }
         this.checkWater();
         if(vis)
         {
            vis.rotation += this.dr;
            vis.x = X;
            vis.y = Y;
         }
         if(this.isSensor || loc.sky)
         {
            this.sensor();
         }
         if(expl_t > 0)
         {
            --expl_t;
         }
         else
         {
            --liv;
         }
         if(liv == 3)
         {
            if((World.w.gg as UnitPlayer).teleObj == this)
            {
               (World.w.gg as UnitPlayer).dropTeleObj();
            }
            explosion();
            liv = 1;
         }
         if(expl_t > 0 && expl_t % explPeriod == 1)
         {
            explRun();
         }
         if(liv <= 0)
         {
            onCursor = 0;
            vse = true;
         }
         if(explRadius > 0)
         {
            loc.warning = 10;
         }
         if(vse)
         {
            loc.remObj(this);
            loc.remGrenade(this);
         }
         onCursor = liv > 5 && X - scX / 2 < World.w.celX && X + scX / 2 > World.w.celX && Y - scY / 2 < World.w.celY && Y + scY / 2 > World.w.celY ? 3 : 0;
      }
      
      private function sensor() : Boolean
      {
         var _loc1_:Unit = null;
         for each(_loc1_ in loc.units)
         {
            if(!_loc1_.disabled && _loc1_.fraction != owner.fraction && X >= _loc1_.X1 && X <= _loc1_.X2 && Y >= _loc1_.Y1 && Y <= _loc1_.Y2 && _loc1_.sost < 3)
            {
               explosion();
               onCursor = 0;
               vse = true;
               return true;
            }
         }
         return false;
      }
      
      public function checkWater() : int
      {
         var _loc1_:* = inWater;
         inWater = 0;
         try
         {
            if((loc.space[Math.floor(X / Tile.tileX)][Math.floor(Y / Tile.tileY)] as Tile).water > 0)
            {
               inWater = 1;
            }
         }
         catch(err:*)
         {
         }
         if(_loc1_ != inWater && dy > 5)
         {
            Emitter.emit("kap",loc,X,Y,{
               "dy":-Math.abs(dy) * (Math.random() * 0.3 + 0.3),
               "kol":5
            });
            Snd.ps("fall_item_water",X,Y,0,dy / 10);
         }
         return inWater;
      }
      
      override public function popadalo(param1:int = 0) : *
      {
         if(param1 < 0)
         {
            return;
         }
         dx = dy = 0;
         if(explRadius)
         {
            explosion();
            if(vis)
            {
               vis.visible = false;
            }
         }
         if(liv > 1)
         {
            liv = 1;
         }
         babah = true;
      }
      
      override public function run(param1:int = 1) : *
      {
         var _loc2_:Tile = null;
         var _loc3_:Number = NaN;
         X += dx / param1;
         if(this.lip)
         {
            if(Boolean(loc.celObj && loc.celObj is Box && (loc.celObj as Box).explcrack && owner && owner.player && X >= loc.celObj.X1 && X <= loc.celObj.X2) && Boolean(Y >= loc.celObj.Y1) && Y <= loc.celObj.Y2)
            {
               targetObj = loc.celObj;
               this.prilip = true;
               return;
            }
         }
         if(loc.sky)
         {
            Y += dy / param1;
            if(X < 0 || X >= loc.limX || Y < 0 || Y >= loc.limY)
            {
               vse = true;
               return;
            }
         }
         else
         {
            if(X < 0 || X >= loc.spaceX * Tile.tileX)
            {
               vse = true;
               return;
            }
            if(dx < 0)
            {
               _loc2_ = loc.getAbsTile(X,Y);
               if(_loc2_.phis == 1 && X <= _loc2_.phX2 && X >= _loc2_.phX1 && Y >= _loc2_.phY1 && Y <= _loc2_.phY2)
               {
                  if(this.sndHit != "")
                  {
                     Snd.ps(this.sndHit,X,Y,0,Math.abs(dx / 10));
                  }
                  if(this.bumc)
                  {
                     this.popadalo();
                  }
                  X = _loc2_.phX2 + 1;
                  dx = Math.abs(dx * this.skok);
                  if(this.lip)
                  {
                     this.prilip = true;
                  }
               }
            }
            if(dx > 0)
            {
               _loc2_ = loc.getAbsTile(X,Y);
               if(_loc2_.phis == 1 && X >= _loc2_.phX1 && X <= _loc2_.phX2 && Y >= _loc2_.phY1 && Y <= _loc2_.phY2)
               {
                  if(this.sndHit != "")
                  {
                     Snd.ps(this.sndHit,X,Y,0,Math.abs(dx / 10));
                  }
                  if(this.bumc)
                  {
                     this.popadalo();
                  }
                  X = _loc2_.phX1 - 1;
                  dx = -Math.abs(dx * this.skok);
                  if(this.lip)
                  {
                     this.prilip = true;
                  }
               }
            }
            if(dy < 0)
            {
               stay = false;
               Y += dy / param1;
               _loc2_ = loc.getAbsTile(X,Y);
               if(_loc2_.phis == 1 && Y <= _loc2_.phY2 && Y >= _loc2_.phY1 && X >= _loc2_.phX1 && X <= _loc2_.phX2)
               {
                  if(this.sndHit != "")
                  {
                     Snd.ps(this.sndHit,X,Y,0,Math.abs(dy / 10));
                  }
                  if(this.bumc)
                  {
                     this.popadalo();
                  }
                  Y = _loc2_.phY2 + 1;
                  dy = Math.abs(dy * this.skok);
                  if(this.lip)
                  {
                     this.prilip = true;
                  }
               }
            }
            _loc3_ = 0;
            if(dy > 0)
            {
               stay = false;
               Y += dy / param1;
               if(Y >= loc.spaceY * Tile.tileY)
               {
                  vse = true;
                  return;
               }
               _loc2_ = loc.getAbsTile(X,Y);
               if(_loc2_.phis == 1 && Y >= _loc2_.phY1 && Y <= _loc2_.phY2 && X >= _loc2_.phX1 && X <= _loc2_.phX2)
               {
                  if(this.bumc)
                  {
                     if(this.sndHit != "")
                     {
                        Snd.ps(this.sndHit,X,Y,0,Math.abs(dy / 10));
                     }
                     this.popadalo();
                  }
                  Y = _loc2_.phY1 - 1;
                  if(this.lip)
                  {
                     this.prilip = true;
                  }
                  if(dy > 2)
                  {
                     dy = -Math.abs(dy * this.skok);
                     dx *= this.tormoz;
                     if(this.sndHit != "")
                     {
                        Snd.ps(this.sndHit,X,Y,0,Math.abs(dy / 10));
                     }
                  }
                  else
                  {
                     dy = 0;
                     stay = true;
                  }
               }
            }
         }
      }
   }
}

