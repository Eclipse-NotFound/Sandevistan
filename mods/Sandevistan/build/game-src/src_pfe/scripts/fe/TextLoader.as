package fe
{
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.ProgressEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class TextLoader
   {
      
      public var id:String;
      
      public var n:int = 0;
      
      internal var def:Boolean = false;
      
      public var textFile:String;
      
      internal var loader_text:URLLoader;
      
      internal var request:URLRequest;
      
      public var progressLoad:Number = 0;
      
      public var loaded:Boolean = false;
      
      public var errLoad:Boolean = false;
      
      public var d:XML;
      
      public function TextLoader(param1:String, param2:Boolean = false)
      {
         super();
         this.def = param2;
         this.textFile = param1;
         if(World.w.playerMode == "PlugIn")
         {
            this.textFile += "?u=" + Math.random().toFixed(5);
         }
         this.loader_text = new URLLoader();
         this.request = new URLRequest(this.textFile);
         this.loader_text.load(this.request);
         this.loader_text.addEventListener(Event.COMPLETE,this.onCompleteLoadText);
         this.loader_text.addEventListener(IOErrorEvent.IO_ERROR,this.onErrorLoadText);
         this.loader_text.addEventListener(ProgressEvent.PROGRESS,this.funProgress);
      }
      
      internal function onCompleteLoadText(param1:Event) : void
      {
         var event:Event = param1;
         this.loaded = true;
         World.w.load_log += "Text " + this.textFile + " loaded\n";
         try
         {
            this.d = new XML(this.loader_text.data);
            if(this.def)
            {
               Res.e = this.d;
            }
            this.loaded = true;
         }
         catch(err:*)
         {
            World.w.load_log += "Text file error " + textFile + "\n";
            errLoad = true;
         }
         World.w.textsLoadOk();
         this.loader_text.removeEventListener(Event.COMPLETE,this.onCompleteLoadText);
         this.loader_text.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorLoadText);
      }
      
      private function onErrorLoadText(param1:IOErrorEvent) : void
      {
         this.errLoad = true;
         World.w.load_log += "File not found " + this.textFile + "\n";
         World.w.textsLoadOk();
         this.loader_text.removeEventListener(Event.COMPLETE,this.onCompleteLoadText);
         this.loader_text.removeEventListener(IOErrorEvent.IO_ERROR,this.onErrorLoadText);
         this.loader_text.removeEventListener(ProgressEvent.PROGRESS,this.funProgress);
      }
      
      internal function funProgress(param1:ProgressEvent) : void
      {
         this.progressLoad = param1.bytesLoaded / param1.bytesTotal;
         World.w.textProgressLoad = this.progressLoad;
      }
   }
}

