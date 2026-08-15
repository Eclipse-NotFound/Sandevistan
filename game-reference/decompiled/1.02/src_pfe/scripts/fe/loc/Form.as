package fe.loc
{
   import fe.*;
   
   public class Form
   {
      
      public static var fForms:Array;
      
      public static var oForms:Array;
      
      public var id:String;
      
      public var idMirror:String;
      
      public var tip:int = 0;
      
      public var front:String;
      
      public var back:String;
      
      public var vid:int;
      
      public var rear:Boolean = false;
      
      public var mat:int = 0;
      
      public var hp:int = 0;
      
      public var thre:int = 0;
      
      public var indestruct:Boolean = false;
      
      public var phis:int = 0;
      
      public var shelf:Boolean = false;
      
      public var diagon:int = 0;
      
      public var stair:int = 0;
      
      public var lurk:int = 0;
      
      public function Form(param1:XML = null)
      {
         super();
         if(param1 != null)
         {
            this.id = param1.@id;
            if(param1.@m.length())
            {
               this.idMirror = param1.@m;
            }
            this.tip = param1.@ed;
            if(param1.@vid > 0)
            {
               this.vid = param1.@vid;
            }
            else
            {
               this.front = param1.@id;
            }
            if(param1.@back.length())
            {
               this.back = param1.@back;
            }
            if(param1.@mat.length())
            {
               this.mat = param1.@mat;
            }
            if(param1.@rear.length())
            {
               this.rear = true;
            }
            if(param1.@lurk.length())
            {
               this.lurk = param1.@lurk;
            }
            if(param1.@hp > 0)
            {
               this.hp = param1.@hp;
            }
            if(param1.@thre > 0)
            {
               this.thre = param1.@thre;
            }
            if(param1.@indestruct > 0)
            {
               this.indestruct = true;
            }
            if(param1.@phis.length())
            {
               this.phis = param1.@phis;
            }
            if(param1.@shelf.length())
            {
               this.shelf = true;
            }
            if(param1.@diagon.length())
            {
               this.diagon = param1.@diagon;
            }
            if(param1.@stair.length())
            {
               this.stair = param1.@stair;
            }
         }
      }
      
      public static function setForms() : *
      {
         var _loc1_:* = undefined;
         fForms = new Array();
         oForms = new Array();
         for each(_loc1_ in AllData.d.mat)
         {
            if(_loc1_.@ed == 1)
            {
               fForms[_loc1_.@id] = new Form(_loc1_);
            }
            else
            {
               oForms[_loc1_.@id] = new Form(_loc1_);
            }
         }
      }
   }
}

