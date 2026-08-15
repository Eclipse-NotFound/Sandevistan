package fe.loc
{
   import fe.*;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   
   public class LandLoader
   {
      
      public var id:String;
      
      public var roomsFile:String;
      
      internal var loader_rooms:URLLoader;
      
      internal var request:URLRequest;
      
      public var test:Boolean = false;
      
      public var loaded:Boolean = false;
      
      public var errLoad:Boolean = false;
      
      public var allroom:XML;
      
      public function LandLoader(param1:String)
      {
         var roomsURL:* = undefined;
         var nid:String = param1;
         super();
         this.id = nid;
         this.roomsFile = GameData.d.land.(@id == id).@file;
         this.test = GameData.d.land.(@id == id).@test > 0;
         if(World.w.roomsLoad)
         {
            this.loader_rooms = new URLLoader();
            roomsURL = World.w.landPath + this.roomsFile + ".xml";
            if(World.w.playerMode == "PlugIn")
            {
               roomsURL += "?u=" + Math.random().toFixed(5);
            }
            this.request = new URLRequest(roomsURL);
            try
            {
               this.loader_rooms.load(this.request);
            }
            catch(err:*)
            {
               errLoad = true;
               trace("no load " + roomsFile);
               World.w.load_log += "Load error " + roomsFile + "\n";
            }
            this.loader_rooms.addEventListener(Event.COMPLETE,this.onCompleteLoadRooms);
            this.loader_rooms.addEventListener(IOErrorEvent.IO_ERROR,this.ioErrorHandler);
         }
         else
         {
            this.allroom = World.w.rooms.rooms[this.roomsFile];
            this.loaded = true;
            World.w.load_log += "Land " + this.roomsFile + " loaded\n";
            if(!this.test)
            {
               World.w.roomsLoadOk();
            }
         }
      }
      
      internal function onCompleteLoadRooms(param1:Event) : void
      {
         this.loaded = true;
         World.w.load_log += "Land " + this.roomsFile + " loaded\n";
         this.allroom = new XML(this.loader_rooms.data);
         if(!this.test)
         {
            World.w.roomsLoadOk();
         }
      }
      
      private function ioErrorHandler(param1:IOErrorEvent) : void
      {
         World.w.load_log += "IOerror " + this.roomsFile + "\n";
      }
   }
}

