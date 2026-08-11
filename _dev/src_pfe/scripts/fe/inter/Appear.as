package fe.inter
{
   import fe.*;
   import fl.controls.ColorPicker;
   import fl.events.ColorPickerEvent;
   import fl.events.SliderEvent;
   import fl.motion.Color;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   
   public class Appear
   {
      
      public static var trFur:ColorTransform = new ColorTransform(0.8,0.8,0.8);
      
      public static var trHair:ColorTransform = new ColorTransform(163 / 255,86 / 255,11 / 255);
      
      public static var trHair1:ColorTransform = new ColorTransform(1,1,1);
      
      public static var trEye:ColorTransform = new ColorTransform(0,0.9,0);
      
      public static var trMagic:ColorTransform = new ColorTransform(0,1,0);
      
      public static var trBlack:ColorTransform = new ColorTransform(0,0,0,0.2,0,255,100);
      
      public static var visHair1:Boolean = false;
      
      public static var fEye:int = 1;
      
      public static var maxEye:int = 6;
      
      public static var fHair:int = 1;
      
      public static var maxHair:int = 5;
      
      public static var ggArmorId:String = "";
      
      public static var hideMane:int = 0;
      
      public static var transp:Boolean = false;
      
      public var vis:MovieClip;
      
      internal var col:Color;
      
      public var funOk:Function;
      
      public var funCancel:Function;
      
      public var cFur:uint = 10724259;
      
      public var cHair:uint = 8734217;
      
      public var cHair1:uint = 16777215;
      
      public var cEye:uint = 1504067;
      
      public var cMagic:uint = 65280;
      
      internal var tFur:uint;
      
      internal var tHair:uint;
      
      internal var tHair1:uint;
      
      internal var tEye:uint;
      
      internal var tMagic:uint;
      
      internal var clist:Array;
      
      internal var tek:String = "Fur";
      
      internal var temp:Object;
      
      internal var def:Object;
      
      public var loadObj:Object;
      
      public var saved:Object;
      
      public function Appear()
      {
         var _loc1_:* = undefined;
         this.col = new Color();
         this.clist = ["Fur","Hair","Hair1","Eye","Magic"];
         super();
         this.vis = new dialVid();
         for each(_loc1_ in this.clist)
         {
            this["t" + _loc1_] = this["c" + _loc1_];
         }
         this.def = this.save();
         this.setColors();
         this.setTransforms();
         this.setColor("Fur",this.cFur);
      }
      
      public function setLang() : *
      {
         this.vis.butOk.text.text = "OK";
         this.vis.butCancel.text.text = Res.guiText("cancel");
         this.vis.butDef.text.text = Res.pipText("default");
         this.vis.title.text = Res.guiText("butvid");
         this.vis.tFur.text = Res.guiText("vidfur");
         this.vis.tHair.text = Res.guiText("vidhair");
         this.vis.tHair1.text = Res.guiText("vidhair1");
         this.vis.tEye.text = Res.guiText("videye");
         this.vis.tMagic.text = Res.guiText("vidmagic");
      }
      
      public function attach(param1:MovieClip, param2:Function, param3:Function) : *
      {
         param1.addChild(this.vis);
         this.vis.fon.visible = true;
         this.temp = this.save();
         this.funcOn();
         this.funOk = param2;
         this.funCancel = param3;
         this.setColors();
         this.vis.pers.gotoAndStop(2);
         this.vis.pers.gotoAndStop(1);
      }
      
      public function detach() : *
      {
         if(this.vis.parent)
         {
            this.vis.parent.removeChild(this.vis);
         }
         this.funcOff();
         this.funOk = null;
         this.funCancel = null;
         if(this.saved != null)
         {
            this.load(this.saved);
            this.saved = null;
         }
      }
      
      public function funcOn() : *
      {
         var _loc1_:* = undefined;
         this.vis.butOk.addEventListener(MouseEvent.CLICK,this.buttonOk);
         this.vis.butCancel.addEventListener(MouseEvent.CLICK,this.buttonCancel);
         this.vis.butDef.addEventListener(MouseEvent.CLICK,this.buttonDef);
         for each(_loc1_ in this.clist)
         {
            this.vis["color" + _loc1_].addEventListener(ColorPickerEvent.CHANGE,this.changeHandler);
            this.vis["color" + _loc1_].addEventListener(Event.OPEN,this.openHandler);
         }
         this.vis.slRed.addEventListener(SliderEvent.THUMB_DRAG,this.chColor);
         this.vis.slGreen.addEventListener(SliderEvent.THUMB_DRAG,this.chColor);
         this.vis.slBlue.addEventListener(SliderEvent.THUMB_DRAG,this.chColor);
         this.vis.checkHair1.addEventListener(ColorPickerEvent.CHANGE,this.changeHair1);
         this.vis.b1Eye.addEventListener(MouseEvent.CLICK,this.chBut);
         this.vis.b2Eye.addEventListener(MouseEvent.CLICK,this.chBut);
         this.vis.b1Hair.addEventListener(MouseEvent.CLICK,this.chBut);
         this.vis.b2Hair.addEventListener(MouseEvent.CLICK,this.chBut);
      }
      
      public function funcOff() : *
      {
         var _loc1_:* = undefined;
         if(!this.vis.butOk.hasEventListener(MouseEvent.CLICK))
         {
            return;
         }
         this.vis.butOk.removeEventListener(MouseEvent.CLICK,this.buttonOk);
         this.vis.butCancel.removeEventListener(MouseEvent.CLICK,this.buttonCancel);
         this.vis.butDef.removeEventListener(MouseEvent.CLICK,this.buttonDef);
         for each(_loc1_ in this.clist)
         {
            this.vis["color" + _loc1_].removeEventListener(ColorPickerEvent.CHANGE,this.changeHandler);
            this.vis["color" + _loc1_].removeEventListener(Event.OPEN,this.openHandler);
         }
         this.vis.slRed.removeEventListener(SliderEvent.THUMB_DRAG,this.chColor);
         this.vis.slGreen.removeEventListener(SliderEvent.THUMB_DRAG,this.chColor);
         this.vis.slBlue.removeEventListener(SliderEvent.THUMB_DRAG,this.chColor);
         this.vis.checkHair1.removeEventListener(ColorPickerEvent.CHANGE,this.changeHair1);
         this.vis.b1Eye.removeEventListener(MouseEvent.CLICK,this.chBut);
         this.vis.b2Eye.removeEventListener(MouseEvent.CLICK,this.chBut);
         this.vis.b1Hair.removeEventListener(MouseEvent.CLICK,this.chBut);
         this.vis.b2Hair.removeEventListener(MouseEvent.CLICK,this.chBut);
      }
      
      public function buttonOk(param1:MouseEvent) : *
      {
         if(Boolean(this.funOk))
         {
            this.funOk();
         }
         World.w.saveConfig();
      }
      
      public function buttonCancel(param1:MouseEvent) : *
      {
         this.load(this.temp);
         this.setTransforms();
         this.setColors();
         this.vis.pers.gotoAndStop(2);
         this.vis.pers.gotoAndStop(1);
         if(Boolean(this.funCancel))
         {
            this.funCancel();
         }
      }
      
      public function buttonDef(param1:MouseEvent) : *
      {
         this.load(this.def);
         this.setTransforms();
         this.setColors();
         this.vis.pers.gotoAndStop(2);
         this.vis.pers.gotoAndStop(1);
      }
      
      internal function setColors() : *
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this.clist)
         {
            this.vis["color" + _loc1_].selectedColor = this["c" + _loc1_];
         }
         this.vis.checkHair1.selected = visHair1;
      }
      
      public function setTransforms() : *
      {
         var _loc1_:* = undefined;
         for each(_loc1_ in this.clist)
         {
            this.colorToTransform(this["c" + _loc1_],Appear["tr" + _loc1_]);
         }
      }
      
      public function save() : Object
      {
         var _loc2_:* = undefined;
         if(this.saved != null)
         {
            this.load(this.saved);
         }
         var _loc1_:Object = new Object();
         for each(_loc2_ in this.clist)
         {
            _loc1_["c" + _loc2_] = this["c" + _loc2_];
         }
         _loc1_.visHair1 = visHair1;
         _loc1_.fEye = fEye;
         _loc1_.fHair = fHair;
         return _loc1_;
      }
      
      public function saveOst() : *
      {
         if(this.saved == null)
         {
            this.saved = this.save();
         }
      }
      
      public function load(param1:Object) : *
      {
         var _loc2_:* = undefined;
         if(param1 == null)
         {
            for each(_loc2_ in this.clist)
            {
               this["c" + _loc2_] = this["t" + _loc2_];
            }
            visHair1 = false;
            fEye = 1;
            fHair = 1;
         }
         else
         {
            for each(_loc2_ in this.clist)
            {
               this["c" + _loc2_] = param1["c" + _loc2_];
            }
            visHair1 = param1.visHair1;
            fEye = param1.fEye;
            fHair = param1.fHair;
         }
         this.setTransforms();
      }
      
      internal function colorToTransform(param1:uint, param2:ColorTransform) : *
      {
         var _loc3_:int = 290;
         var _loc4_:Number = (290 - 255) / 255;
         this.col.tintMultiplier = 1;
         this.col.tintColor = param1;
         param2.redMultiplier = this.col.redOffset / _loc3_ + _loc4_;
         param2.greenMultiplier = this.col.greenOffset / _loc3_ + _loc4_;
         param2.blueMultiplier = this.col.blueOffset / _loc3_ + _loc4_;
         this.vis.slRed.value = this.col.redOffset;
         this.vis.slGreen.value = this.col.greenOffset;
         this.vis.slBlue.value = this.col.blueOffset;
         this.setRGB();
      }
      
      internal function setRGB() : *
      {
         this.vis.nRed.text = "R:" + this.col.redOffset;
         this.vis.nGreen.text = "G:" + this.col.greenOffset;
         this.vis.nBlue.text = "B:" + this.col.blueOffset;
      }
      
      internal function chColor(param1:SliderEvent) : void
      {
         this.col.redOffset = this.vis.slRed.value;
         this.col.greenOffset = this.vis.slGreen.value;
         this.col.blueOffset = this.vis.slBlue.value;
         this.setRGB();
         this.setColor(this.tek,this.col.color);
      }
      
      internal function changeHandler(param1:ColorPickerEvent) : void
      {
         var _loc3_:ColorTransform = null;
         var _loc2_:ColorPicker = param1.currentTarget as ColorPicker;
         var _loc4_:* = _loc2_.name.substr(5);
         this.tek = _loc4_;
         this.setColor(_loc4_,_loc2_.selectedColor);
      }
      
      internal function openHandler(param1:Event) : void
      {
         var _loc2_:ColorPicker = param1.currentTarget as ColorPicker;
         var _loc3_:* = _loc2_.name.substr(5);
         this.tek = _loc3_;
         this.setColor(_loc3_,_loc2_.selectedColor);
      }
      
      internal function changeHair1(param1:Event) : void
      {
         visHair1 = this.vis.checkHair1.selected;
         this.vis.pers.gotoAndStop(2);
         this.vis.pers.gotoAndStop(1);
      }
      
      public function chBut(param1:MouseEvent) : *
      {
         var _loc2_:String = (param1.currentTarget as DisplayObject).name;
         if(_loc2_ == "b1Eye")
         {
            --fEye;
            if(fEye <= 0)
            {
               fEye = maxEye;
            }
         }
         if(_loc2_ == "b2Eye")
         {
            ++fEye;
            if(fEye > maxEye)
            {
               fEye = 1;
            }
         }
         if(_loc2_ == "b1Hair")
         {
            --fHair;
            if(fHair <= 0)
            {
               fHair = maxHair;
            }
         }
         if(_loc2_ == "b2Hair")
         {
            ++fHair;
            if(fHair > maxHair)
            {
               fHair = 1;
            }
         }
         this.vis.pers.gotoAndStop(2);
         this.vis.pers.gotoAndStop(1);
      }
      
      internal function setColor(param1:String, param2:uint) : *
      {
         this["c" + param1] = param2;
         this.colorToTransform(this["c" + param1],Appear["tr" + param1]);
         this.vis["color" + param1].selectedColor = param2;
         this.vis.pers.gotoAndStop(2);
         this.vis.pers.gotoAndStop(1);
      }
   }
}

