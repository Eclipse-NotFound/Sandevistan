package {
 import flash.display.*;
 import flash.events.*;
 import flash.filesystem.*;
 import flash.system.ApplicationDomain;
 import flash.desktop.NativeApplication;
 import flash.text.TextField;
 import flash.utils.ByteArray;
 public class SandyMenuProbe extends Sprite {
  public function SandyMenuProbe() {}
  private static var instance:SandyMenuProbe;
  private var main:Object, w:Object, phase:int=0, ticks:int=0, checks:int=0, failures:int=0;
  public static function init(m:Object):void { instance=new SandyMenuProbe(); instance.main=m; m.stage.addEventListener(Event.ENTER_FRAME,instance.tick); }
  private function log(s:String):void { var f:FileStream=new FileStream(); f.open(File.applicationStorageDirectory.resolvePath("sandy_modlog.txt"),FileMode.APPEND); f.writeUTFBytes("[MENU-TEST] "+s+"\n"); f.close(); }
  private function check(s:String,b:Boolean):void {checks++; if(!b) failures++; log(s+" "+(b?"PASS":"FAIL"));}
  private function flat(c:DisplayObjectContainer,a:Array):void {for(var i:int=0;i<c.numChildren;i++){var d:DisplayObject=c.getChildAt(i);a.push(d);if(d is DisplayObjectContainer)flat(d as DisplayObjectContainer,a);}}
  private function guide(hover:Boolean):void {
   var all:Array=[];flat(main as DisplayObjectContainer,all);
   var tf:TextField=null;
   for each(var d:DisplayObject in all) if(d is TextField && TextField(d).text.indexOf("音乐文件配置")>=0 && d.visible) tf=d as TextField;
   check((hover?"hover":"page")+"-guide-visible",tf!=null);
   if(tf!=null){check((hover?"hover":"page")+"-guide-fits",tf.textHeight<=tf.height-4 && tf.maxScrollV==1);log("guide height="+tf.textHeight+"/"+tf.height+" lines="+tf.numLines);}
    var target:DisplayObject = tf.parent as DisplayObject;
   var bmp:BitmapData=new BitmapData(860,640,false,0);bmp.draw(target);
   var file:FileStream=new FileStream();file.open(File.applicationStorageDirectory.resolvePath(hover?"music-guide-hover.png":"music-guide-page.png"),FileMode.WRITE);var png:ByteArray=new ByteArray();bmp.encode(bmp.rect,new PNGEncoderOptions(),png);file.writeBytes(png);file.close();bmp.dispose();
  }
  private function tick(e:Event):void {
   try {
    if(w==null){var W:Class=ApplicationDomain.currentDomain.getDefinition("fe.World") as Class;w=W["w"];if(w==null)return;}
    var carrier:Object=main.getChildByName("ModSettingsCarrier");
    var api:Object=carrier!=null?carrier["modAPI"]:null;
    if(phase==0 && w.mm.loaded && w.landData!=null && api!=null){w.mm.mainMenuOff();w.newGame(-1,"MENU-GUIDE",{dif:2,propusk:true});phase=1;ticks=0;}
    else if(phase==1 && w.gg!=null && w.allStat==1 && ++ticks>45){
     var all:Array=[];flat(main as DisplayObjectContainer,all);var mark:Boolean=false;
     for each(var d:DisplayObject in all) if(d is TextField && /Sandevistan.*已加载/i.test(TextField(d).text))mark=true;
     check("boot-mark-removed",!mark);
     check("missing-music-file",!File.applicationDirectory.resolvePath("mods/Sandevistan/release/sandy_theme.mp3").exists);
     w.pip.onoff(5);phase=2;ticks=0;
    }else if(phase==2 && ++ticks>15){check("select-sandevistan",api.selectPage("sandevistan"));phase=3;ticks=0;}
    else if(phase==3 && ++ticks>15){guide(false);all=[];flat(main as DisplayObjectContainer,all);var row:DisplayObject=null;
     for(var ni:int=0;ni<all.length;ni++){var node:DisplayObject=all[ni] as DisplayObject;if(node!=null && node.name=="SettingsItem:musicon")row=node;}
     check("music-toggle-present",row!=null);if(row!=null)row.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER,true));phase=4;ticks=0;
    }else if(phase==4 && ++ticks>5){guide(true);check("no-error-dialog",w.verror==null || !w.verror.visible);log("SUMMARY "+(failures==0?"PASS":"FAIL")+" checks="+checks+" failures="+failures);phase=5;main.stage.removeEventListener(Event.ENTER_FRAME,tick);}
   }catch(err:*){log("ERROR "+err+" "+err.getStackTrace());log("SUMMARY FAIL exception");phase=5;main.stage.removeEventListener(Event.ENTER_FRAME,tick);}
  }
 }
}