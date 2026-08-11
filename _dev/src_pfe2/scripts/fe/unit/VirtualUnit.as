package fe.unit
{
   import fe.Obj;
   import fe.loc.Box;
   import fe.weapon.Bullet;
   
   public class VirtualUnit extends Unit
   {
      
      public var owner:Obj;
      
      internal var nTipDam:int = -1;
      
      public function VirtualUnit(param1:String = null, param2:Number = 100, param3:XML = null, param4:Object = null)
      {
         super();
         activateTrap = 0;
         dexter = 0;
         mat = 1;
         showNumbs = false;
         isSats = false;
         doop = true;
         levitPoss = false;
         if(param1 != null)
         {
            this.nTipDam = int(param1);
         }
      }
      
      override public function damage(param1:Number, param2:int, param3:Bullet = null, param4:Boolean = false) : Number
      {
         if(this.nTipDam >= 0 && this.nTipDam != param2)
         {
            return 0;
         }
         this.owner.command("dam");
         return 1;
      }
      
      override public function udarBullet(param1:Bullet, param2:int = 0) : int
      {
         if(this.nTipDam >= 0 && this.nTipDam != param1.tipDamage)
         {
            return 0;
         }
         this.owner.command("dam");
         return 1;
      }
      
      override public function udarUnit(param1:Unit, param2:Number = 1) : Boolean
      {
         return false;
      }
      
      override public function udarBox(param1:Box) : int
      {
         return 0;
      }
      
      override public function die(param1:int = 0) : *
      {
         exterminate();
      }
   }
}

