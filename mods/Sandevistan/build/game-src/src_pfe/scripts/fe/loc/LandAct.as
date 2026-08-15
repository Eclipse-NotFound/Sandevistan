package fe.loc
{
   import fe.*;
   
   public class LandAct
   {
      
      public var id:String;
      
      public var tip:String = "";
      
      public var land:Land;
      
      public var loaded:Boolean = false;
      
      public var xmlland:XML;
      
      public var allroom:XML;
      
      public var begLocX:int = 0;
      
      public var begLocY:int = 0;
      
      public var mLocX:int = 1;
      
      public var mLocY:int = 1;
      
      public var dif:Number = 0;
      
      public var biom:int = 0;
      
      public var conf:int = 0;
      
      public var gameStage:int = 0;
      
      public var lootLimit:Number = 0;
      
      public var list:int = 0;
      
      public var rnd:Boolean = false;
      
      public var autoLevel:Boolean = false;
      
      public var test:Boolean = false;
      
      public var fin:int = -1;
      
      public var prob:int = 0;
      
      public var exitProb:String;
      
      public var loadScr:int = -1;
      
      public var kolAllProb:int = 0;
      
      public var kolClosedProb:int = 0;
      
      public var xp:int = 100;
      
      public var rad:Number = 0;
      
      public var wrad:Number = 1;
      
      public var wdam:Number = 0;
      
      public var wtipdam:int = 7;
      
      public var tipWater:int = 0;
      
      public var color:String;
      
      public var sndMusic:String;
      
      public var postMusic:Boolean = false;
      
      public var fon:String;
      
      public var backwall:String;
      
      public var border:String = "A";
      
      public var visMult:Number = 1;
      
      public var opacWater:Number = 0;
      
      public var darkness:int = 0;
      
      public var artFire:String;
      
      public var lastCpCode:String;
      
      public var upStage:Boolean = false;
      
      public var landStage:int = 0;
      
      public var access:Boolean = false;
      
      public var visited:Boolean = false;
      
      public var passed:Boolean = false;
      
      public function LandAct(param1:XML)
      {
         super();
         this.xmlland = param1;
         this.id = param1.@id;
         if(param1.@tip.length())
         {
            this.tip = param1.@tip;
         }
         if(param1.@dif.length())
         {
            this.dif = param1.@dif;
         }
         if(param1.@biom.length())
         {
            this.biom = param1.@biom;
         }
         if(param1.@conf.length())
         {
            this.conf = param1.@conf;
         }
         if(param1.@stage.length())
         {
            this.gameStage = param1.@stage;
         }
         if(param1.@limit.length())
         {
            this.lootLimit = param1.@limit;
         }
         if(param1.@rnd.length())
         {
            this.rnd = true;
         }
         if(param1.@test.length())
         {
            this.test = true;
         }
         if(param1.@fin.length())
         {
            this.fin = param1.@fin;
         }
         if(param1.@autolevel.length())
         {
            this.autoLevel = true;
         }
         if(param1.@prob.length())
         {
            this.prob = param1.@prob;
         }
         if(param1.@list.length())
         {
            this.list = param1.@list;
         }
         if(param1.@locx.length())
         {
            this.begLocX = param1.@locx;
         }
         if(param1.@locy.length())
         {
            this.begLocY = param1.@locy;
         }
         if(param1.@mx.length())
         {
            this.mLocX = param1.@mx;
         }
         if(param1.@my.length())
         {
            this.mLocY = param1.@my;
         }
         if(param1.@acc.length())
         {
            this.access = true;
         }
         if(param1.@exit.length())
         {
            this.exitProb = param1.@exit;
         }
         if(param1.@loadscr.length())
         {
            this.loadScr = param1.@loadscr;
         }
         if(param1.options.length())
         {
            if(param1.options.@xp.length())
            {
               this.xp = param1.options.@xp;
            }
            if(param1.options.@color.length())
            {
               this.color = param1.options.@color;
            }
            if(param1.options.@backwall.length())
            {
               this.backwall = param1.options.@backwall;
            }
            if(param1.options.@border.length())
            {
               this.border = param1.options.@border;
            }
            if(param1.options.@fon.length())
            {
               this.fon = param1.options.@fon;
            }
            if(param1.options.@music.length())
            {
               this.sndMusic = param1.options.@music;
            }
            if(param1.options.@postmusic.length())
            {
               this.postMusic = true;
            }
            if(param1.options.@rad.length())
            {
               this.rad = param1.options.@rad;
            }
            if(param1.options.@wrad.length())
            {
               this.wrad = param1.options.@wrad;
            }
            if(param1.options.@wtip.length())
            {
               this.tipWater = param1.options.@wtip;
            }
            if(param1.options.@wopac.length())
            {
               this.opacWater = param1.options.@wopac;
            }
            if(param1.options.@wdam.length())
            {
               this.wdam = param1.options.@wdam;
            }
            if(param1.options.@wtipdam.length())
            {
               this.wtipdam = param1.options.@wtipdam;
            }
            if(param1.options.@vis.length())
            {
               this.visMult = param1.options.@vis;
            }
            if(param1.options.@darkness.length())
            {
               this.darkness = param1.options.@darkness;
            }
            if(param1.options.@art.length())
            {
               this.artFire = param1.options.@art;
            }
         }
      }
      
      public function calcProbs() : *
      {
         var _loc1_:* = undefined;
         this.kolAllProb = 0;
         this.kolClosedProb = 0;
         for each(_loc1_ in this.xmlland.prob)
         {
            ++this.kolAllProb;
            if(World.w.game.triggers["prob_" + _loc1_.@id] != null)
            {
               ++this.kolClosedProb;
            }
         }
      }
      
      public function save() : Object
      {
         var _loc1_:Object = new Object();
         _loc1_.cp = this.lastCpCode;
         _loc1_.st = this.landStage;
         _loc1_.access = this.access;
         _loc1_.visited = this.visited;
         _loc1_.passed = this.passed;
         return _loc1_;
      }
      
      public function load(param1:Object) : *
      {
         if(param1.cp != null)
         {
            this.lastCpCode = param1.cp;
         }
         if(param1.st != null)
         {
            this.landStage = param1.st;
         }
         if(param1.access != null && !this.access)
         {
            this.access = param1.access;
         }
         if(param1.visited != null)
         {
            this.visited = param1.visited;
         }
         if(param1.passed != null)
         {
            this.passed = param1.passed;
         }
         return param1;
      }
   }
}

