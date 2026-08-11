package fe.weapon
{
   import fe.*;
   import fe.loc.Tile;
   import fe.unit.Unit;
   import fe.unit.UnitPlayer;
   
   public class WPaint extends Weapon
   {
      
      internal var del:Object = {
         "x":0,
         "y":0
      };
      
      internal var celX:Number;
      
      internal var celY:Number;
      
      internal var pX:Number = -1;
      
      internal var pY:Number = -1;
      
      public var color:int = 1;
      
      public var paintId:String = "p_black";
      
      public var paintNazv:String = "";
      
      public function WPaint(param1:Unit, param2:String, param3:int = 0)
      {
         super(param1,param2,param3);
         vWeapon = visualpaint;
         vis = new vWeapon();
      }
      
      public function lineCel() : int
      {
         var _loc8_:Tile = null;
         var _loc1_:* = 0;
         var _loc2_:Number = owner.X;
         var _loc3_:Number = owner.Y - owner.scY * 0.75;
         var _loc4_:Number = this.celX - _loc2_;
         var _loc5_:Number = this.celY - _loc3_;
         var _loc6_:* = Math.floor(Math.max(Math.abs(_loc4_),Math.abs(_loc5_)) / World.maxdelta) + 1;
         var _loc7_:* = 1;
         while(_loc7_ < _loc6_)
         {
            this.celX = _loc2_ + _loc4_ * _loc7_ / _loc6_;
            this.celY = _loc3_ + _loc5_ * _loc7_ / _loc6_;
            _loc8_ = World.w.loc.getAbsTile(Math.floor(this.celX),Math.floor(this.celY));
            if(_loc8_.phis == 1 && this.celX >= _loc8_.phX1 && this.celX <= _loc8_.phX2 && this.celY >= _loc8_.phY1 && this.celY <= _loc8_.phY2)
            {
               return 0;
            }
            _loc7_++;
         }
         return 1;
      }
      
      override public function actions() : *
      {
         var _loc2_:* = undefined;
         var _loc3_:* = undefined;
         var _loc1_:* = 40 * owner.storona;
         if(owner.player)
         {
            this.celX = owner.celX;
            this.celY = owner.celY;
            storona = owner.storona;
            this.del.x = this.celX - (owner.X + _loc1_);
            this.del.y = this.celY - owner.weaponY;
            norma(this.del,600);
            _loc1_ = (owner as UnitPlayer).pers.meleeS * owner.storona;
            _loc2_ = this.celX - X;
            _loc3_ = this.celY - Y;
            ready = _loc2_ * _loc2_ + _loc3_ * _loc3_ < 100;
            this.del.x = (owner.X + _loc1_ + this.del.x - X) / 2;
            this.del.y = (owner.weaponY + this.del.y - Y) / 2;
            if(owner.player)
            {
               norma(this.del,20);
            }
            this.pX = X;
            this.pY = Y;
            X += this.del.x;
            Y += this.del.y;
         }
      }
      
      override public function attack(param1:Boolean = false) : Boolean
      {
         World.w.grafon.paint(this.pX,this.pY,X,Y,World.w.ctr.keyRun);
         return true;
      }
      
      public function setPaint(param1:String, param2:uint, param3:String) : *
      {
         this.paintId = param1;
         this.paintNazv = Res.txt("i",this.paintId);
         World.w.grafon.brTrans.color = param2;
      }
      
      override public function animate() : *
      {
         if(vis)
         {
            vis.y = Y;
            vis.x = X;
            vis.scaleX = storona;
         }
      }
   }
}

