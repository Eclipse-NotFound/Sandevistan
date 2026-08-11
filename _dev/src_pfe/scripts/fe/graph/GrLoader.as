package fe.graph
{
   import flash.display.Loader;
   import flash.events.Event;
   import flash.events.ProgressEvent;
   import flash.net.URLRequest;
   
   public class GrLoader
   {
      
      public static var kol:int = 0;
      
      public static var kolIsLoad:int = 0;
      
      public var id:int;
      
      public var loader:Loader;
      
      public var progressLoad:Number = 0;
      
      public var isLoad:Boolean = false;
      
      public var res:*;
      
      internal var gr:Grafon;
      
      public function GrLoader(param1:int, param2:String, param3:Grafon)
      {
         super();
         ++kol;
         this.gr = param3;
         this.id = param1;
         this.loader = new Loader();
         var _loc4_:URLRequest = new URLRequest(param2);
         this.loader.load(_loc4_);
         this.loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.funLoaded);
         this.loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS,this.funProgress);
      }
      
      internal function funLoaded(param1:Event) : void
      {
         this.res = param1.target.content;
         this.isLoad = true;
         this.progressLoad = 1;
         ++kolIsLoad;
         this.gr.checkLoaded(this.id);
         this.loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.funLoaded);
         this.loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS,this.funProgress);
      }
      
      internal function funProgress(param1:ProgressEvent) : void
      {
         this.progressLoad = param1.bytesLoaded / param1.bytesTotal;
         this.gr.allProgress();
      }
   }
}

