package fe.weapon
{
   import fe.Snd;
   import fe.World;
   import fe.loc.Tile;
   import fe.unit.Unit;
   
   public class WKick extends Weapon
   {
      
      public var kick:Boolean = true;
      
      public function WKick(param1:Unit, param2:String, param3:int = 0)
      {
         super(param1,param2,param3);
         vBullet = visualPunch;
         b = new Bullet(param1,X - dlina / 2 * storona,Y - dlina,null,false);
         b.weap = this;
         dopCh = 0;
         dopEffect = "stun";
         setBullet(b);
      }
      
      override public function actions() : *
      {
         var _loc1_:Boolean = false;
         var _loc2_:Tile = null;
         var _loc3_:Tile = null;
         var _loc4_:* = undefined;
         X = owner.X;
         Y = owner.Y;
         storona = owner.storona;
         if(t_attack > 0)
         {
            --t_attack;
         }
         if(t_attack == rapid - 8)
         {
            b.retDam = true;
            b.off = false;
            b.tilehit = false;
            b.loc = owner.loc;
            b.knocky = -0.1;
            b.knockx = storona;
            b.parr = null;
            b.dist = 0;
            b.damage = damage * World.w.pers.punchDamMult;
            b.otbros = otbros * World.w.pers.punchDamMult;
            b.destroy = destroy;
            b.probiv = 1;
            _loc1_ = false;
            if(World.w.pers.punchDamMult > 1)
            {
               dopCh = World.w.pers.punchDamMult - 1;
               dopDamage = 30;
            }
            if(this.kick)
            {
               storona = -owner.storona;
               _loc2_ = owner.loc.getAbsTile(X + storona * 60,Y - 30);
               _loc3_ = owner.loc.getAbsTile(X + storona * 60,Y - 50);
               if(Boolean(_loc2_) && Boolean(_loc3_) && _loc3_.thre < _loc2_.thre)
               {
                  _loc1_ = true;
               }
               b.knockx = storona;
               b.damage *= 2;
               b.otbros *= 1.5;
               b.destroy = World.w.pers.kickDestroy;
               dopDamage = 60;
               if(_loc1_)
               {
                  b.bindMove(X + storona * 70,Y - 50,X + storona * 20,Y - 50);
                  b.bindMove(X + storona * 70,Y - 30,X + storona * 20,Y - 30);
               }
               else
               {
                  b.bindMove(X + storona * 70,Y - 30,X + storona * 20,Y - 30);
                  b.bindMove(X + storona * 70,Y - 50,X + storona * 20,Y - 50);
               }
               Snd.ps("m_big",X,Y,0,Math.random() * 0.2 + 0.1);
            }
            else
            {
               _loc2_ = owner.loc.getAbsTile(X + storona * 60,Y - 30);
               _loc3_ = owner.loc.getAbsTile(X + storona * 60,Y - 50);
               if(Boolean(_loc2_) && Boolean(_loc3_) && _loc3_.thre < _loc2_.thre)
               {
                  _loc1_ = true;
               }
               if(_loc1_)
               {
                  b.bindMove(X + storona * 60,Y - 50,X + storona * 20,Y - 50);
               }
               b.bindMove(X + storona * 60,Y - 30,X + storona * 20,Y - 30);
               _loc4_ = 1;
               while(_loc4_ <= 5)
               {
                  if(_loc4_ != 3 && !(_loc1_ && _loc4_ == 5))
                  {
                     b.bindMove(X + storona * 60,Y - _loc4_ * 10,X + storona * 20,Y - _loc4_ * 10);
                  }
                  _loc4_++;
               }
               Snd.ps("m_med",X,Y,0,Math.random() * 0.2 + 0.1);
            }
         }
      }
      
      override public function attack(param1:Boolean = false) : Boolean
      {
         if(t_attack <= 0)
         {
            t_attack = rapid;
         }
         return true;
      }
      
      override public function animate() : *
      {
      }
   }
}

