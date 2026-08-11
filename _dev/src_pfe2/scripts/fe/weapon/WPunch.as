package fe.weapon
{
   import fe.Snd;
   import fe.World;
   import fe.unit.Unit;
   
   public class WPunch extends Weapon
   {
      
      public var zadok:Boolean = false;
      
      public function WPunch(param1:Unit, param2:String, param3:int = 0)
      {
         super(param1,param2,param3);
         vBullet = visualPunch;
      }
      
      override public function actions() : *
      {
         var _loc1_:Number = NaN;
         var _loc2_:Number = NaN;
         var _loc3_:int = 0;
         owner.setPunchWeaponPos(this);
         if(t_attack > 0)
         {
            --t_attack;
         }
         if(t_attack == rapid - 5)
         {
            if(owner.player)
            {
               _loc1_ = owner.celX - X;
               _loc2_ = owner.celY - Y;
               _loc3_ = _loc2_ > 0 ? 1 : -1;
               if(Math.abs(_loc2_) > Math.abs(_loc1_))
               {
                  _loc2_ = Math.abs(_loc1_) * _loc3_;
               }
               rot = Math.atan2(_loc2_,_loc1_);
            }
            shoot();
            if(owner.player)
            {
               b.damage *= World.w.pers.punchDamMult;
            }
            b.liv = 5;
            if(this.zadok && (rot < Math.PI / 2 && rot > -Math.PI / 2 && owner.storona < 0 || (rot > Math.PI / 2 || rot < -Math.PI / 2) && owner.storona > 0))
            {
               b.otbros = otbros * 1.5;
               b.damage = damage * 2 * damMult;
               if(owner.player)
               {
                  b.damage *= World.w.pers.punchDamMult;
                  b.destroy = World.w.pers.kickDestroy;
               }
               Snd.ps("m_big",X,Y,0,Math.random() * 0.2 + 0.1);
            }
            else
            {
               Snd.ps("m_med",X,Y,0,Math.random() * 0.2 + 0.1);
            }
            b.probiv = 1;
            b.retDam = true;
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

