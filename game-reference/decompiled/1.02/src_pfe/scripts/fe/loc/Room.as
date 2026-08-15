package fe.loc
{
   public class Room
   {
      
      public static var nornd:Array = ["beg0","back","roof","pass","passroof","roofpass","vert","surf"];
      
      public var xml:XML;
      
      public var id:String;
      
      public var tip:String;
      
      public var rx:int = 0;
      
      public var ry:int = 0;
      
      public var rz:int = 0;
      
      public var lvl:int = 0;
      
      public var back:String;
      
      public var kol:* = 2;
      
      public var rnd:Boolean = true;
      
      public function Room(param1:XML)
      {
         var _loc2_:* = undefined;
         super();
         this.xml = param1;
         this.id = this.xml.@name;
         if(this.xml.@x.length())
         {
            this.rx = this.xml.@x;
         }
         if(this.xml.@y.length())
         {
            this.ry = this.xml.@y;
         }
         if(this.xml.@z.length())
         {
            this.rz = this.xml.@z;
         }
         if(this.xml.options.length())
         {
            if(this.xml.options.@tip.length())
            {
               this.tip = this.xml.options.@tip;
            }
            if(this.xml.options.@level.length())
            {
               this.lvl = this.xml.options.@level;
            }
            if(this.xml.options.@back.length())
            {
               this.back = this.xml.options.@back;
            }
            if(this.tip == "uniq")
            {
               this.kol = 1;
            }
            if(this.xml.options.@uniq.length())
            {
               this.kol = 1;
            }
            for each(_loc2_ in nornd)
            {
               if(this.tip == _loc2_)
               {
                  this.rnd = false;
                  break;
               }
            }
            if(this.xml.options.@nornd.length())
            {
               this.rnd = false;
            }
            if(this.xml.options.@test.length())
            {
               this.kol = 4;
               this.lvl = 0;
            }
         }
      }
   }
}

