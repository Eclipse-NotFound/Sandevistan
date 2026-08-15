package fe.unit
{
   import fe.loc.Location;
   
   public class Coord
   {
      
      public var tip:String;
      
      public var loc:Location;
      
      public var t1:int;
      
      public var t2:int;
      
      public var tr:int;
      
      public var liv1:Boolean = false;
      
      public var liv2:Boolean = false;
      
      public var liv3:Boolean = false;
      
      internal var kolAll:int = 6;
      
      internal var kolClosed:int = 3;
      
      public var opened:Array = [];
      
      public function Coord(param1:Location, param2:String = null)
      {
         super();
         this.loc = param1;
         this.tip = param2;
         this.tr = 1;
         this.t1 = 100;
         this.t2 = 150;
         this.rndOpened();
      }
      
      internal function rndOpened() : *
      {
         var _loc1_:* = 1;
         while(_loc1_ <= this.kolAll)
         {
            this.opened[_loc1_] = true;
            _loc1_++;
         }
         _loc1_ = 1;
         while(_loc1_ <= this.kolClosed)
         {
            this.opened[Math.floor(Math.random() * this.kolAll + 1)] = false;
            _loc1_++;
         }
      }
      
      public function step() : *
      {
         var _loc1_:* = undefined;
         --this.t1;
         if(this.t1 <= 0)
         {
            this.t1 = Math.floor(Math.random() * 60 + 150);
            _loc1_ = 1;
            while(_loc1_ <= 3)
            {
               ++this.tr;
               if(this.tr > 3)
               {
                  this.tr = 1;
               }
               if(this["liv" + this.tr])
               {
                  break;
               }
               _loc1_++;
            }
         }
         --this.t2;
         if(this.t2 == 75)
         {
            _loc1_ = 1;
            while(_loc1_ <= this.kolAll)
            {
               this.loc.allAct(null,this.opened[_loc1_] ? "red" : "green","a" + _loc1_);
               _loc1_++;
            }
         }
         if(this.t2 == 0)
         {
            _loc1_ = 1;
            while(_loc1_ <= this.kolAll)
            {
               this.loc.allAct(null,this.opened[_loc1_] ? "open" : "close","a" + _loc1_);
               _loc1_++;
            }
            this.t2 = 300;
            this.rndOpened();
         }
      }
   }
}

