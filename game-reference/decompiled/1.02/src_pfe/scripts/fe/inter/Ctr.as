package fe.inter
{
   import fe.Res;
   import fe.World;
   import flash.display.StageDisplayState;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.ui.Keyboard;
   
   public class Ctr
   {
      
      public var keyXML:XML = <keys>
			<key id='keyLeft' def={Keyboard.A}/>
			<key id='keyRight' def={Keyboard.D}/>
			<key id='keyBeUp' def={Keyboard.W}/>
			<key id='keySit' def={Keyboard.S}/>
			<key id='keyJump' def={Keyboard.SPACE}/>
			<key id='keyRun' def={Keyboard.SHIFT}/>
			<key id='keyDash'/>
			
			<key id='keyAttack' def='lmb'/>
			<key id='keyPunch' def={Keyboard.F}/>
			<key id='keyReload' def={Keyboard.R}/>
			<key id='keyGrenad' def={Keyboard.G}/>
			<key id='keyMagic' def={Keyboard.T}/>
			<key id='keyDef' def={Keyboard.C}/>
			<key id='keyPet' def={Keyboard.U}/>
			<key id='keyAction' def={Keyboard.E}/>
			<key id='keyCrack' def={Keyboard.Y}/>
			<key id='keyTele' def={Keyboard.Q} alt='rmb'/>
			<key id='keyPip' def={Keyboard.TAB}/>
			<key id='keyArmor' def={Keyboard.N}/>
			<key id='keySats' def={Keyboard.V} alt='mmb'/>

			<key id='keyInvent' def={Keyboard.I}/>
			<key id='keyStatus' def={Keyboard.O}/>
			<key id='keySkills' def={Keyboard.K}/>
			<key id='keyMed' def={Keyboard
      .L}/>
			<key id='keyMap' def={Keyboard.M}/>
			<key id='keyQuest' def={Keyboard.J}/>
			<key id='keyItem' def={Keyboard.P}/>
			<key id='keyPot' def={Keyboard.H}/>
			<key id='keyMana' def={Keyboard.B}/>
			<key id='keyItemNext' def={Keyboard.RIGHTBRACKET}/>
			<key id='keyItemPrev' def={Keyboard.LEFTBRACKET}/>
			<key id='keyScrDown' def='scrd'/>
			<key id='keyScrUp' def='scru'/>
			<key id='keyWeapon1' def={Keyboard.NUMBER_1}/>
			<key id='keyWeapon2' def={Keyboard.NUMBER_2}/>
			<key id='keyWeapon3' def={Keyboard.NUMBER_3}/>
			<key id='keyWeapon4' def={Keyboard.NUMBER_4}/>
			<key id='keyWeapon5' def={Keyboard.NUMBER_5}/>
			<key id='keyWeapon6' def={Keyboard.NUMBER_6}/>
			<key id='keyWeapon7' def={Keyboard.NUMBER_7}/>
			<key id='keyWeapon8' def={Keyboard.NUMBER_8}/>
			<key id='keyWeapon9' def={Keyboard.NUMBER_9}/>
			<key id='keyWeapon10' def={Keyboard.NUMBER_0}/>
			<key id='keyWeapon11' def={Keyboard.MINUS}/>
			<key id='keyWeapon12' def={Keyboard.EQUAL}/>
			<key id='keySpell1' def={Keyboard
      .Z}/>
			<key id='keySpell2' def={Keyboard.X}/>
			<key id='keySpell3'/>
			<key id='keySpell4'/>
			
			<key id='keyLook' def={Keyboard.SEMICOLON}/>
			<key id='keyZoom' def={Keyboard.QUOTE}/>
			<key id='keyFull' def={Keyboard.ENTER}/>
		</keys>;
      
      internal var keyDowns:Vector.<Boolean>;
      
      internal var keyNames:Vector.<String>;
      
      internal var mbNames:Array;
      
      internal var keys:Array;
      
      internal var keyObj:Array;
      
      internal var keyIds:Array;
      
      public var keyLeft:Boolean = false;
      
      public var keyRight:Boolean = false;
      
      public var keyDubLeft:Boolean = false;
      
      public var keyDubRight:Boolean = false;
      
      public var keyJump:Boolean = false;
      
      public var keySit:Boolean = false;
      
      public var keyDubSit:Boolean = false;
      
      public var keyBeUp:Boolean = false;
      
      public var keyRun:Boolean = false;
      
      public var keyAttack:Boolean = false;
      
      public var keyPunch:Boolean = false;
      
      public var keyReload:Boolean = false;
      
      public var keyGrenad:Boolean = false;
      
      public var keyMagic:Boolean = false;
      
      public var keyDef:Boolean = false;
      
      public var keyPet:Boolean = false;
      
      public var keyAction:Boolean = false;
      
      public var keyCrack:Boolean = false;
      
      public var keyTele:Boolean = false;
      
      public var keyPip:Boolean = false;
      
      public var keySats:Boolean = false;
      
      public var keyFly:Boolean = false;
      
      public var keyLook:Boolean = false;
      
      public var keyZoom:Boolean = false;
      
      public var keyFull:Boolean = false;
      
      public var keyItem:Boolean = false;
      
      public var keyPot:Boolean = false;
      
      public var keyMana:Boolean = false;
      
      public var keyItemPrev:Boolean = false;
      
      public var keyItemNext:Boolean = false;
      
      public var keyInvent:Boolean = false;
      
      public var keyStatus:Boolean = false;
      
      public var keySkills:Boolean = false;
      
      public var keyMed:Boolean = false;
      
      public var keyMap:Boolean = false;
      
      public var keyQuest:Boolean = false;
      
      public var keyWeapon1:Boolean = false;
      
      public var keyWeapon2:Boolean = false;
      
      public var keyWeapon3:Boolean = false;
      
      public var keyWeapon4:Boolean = false;
      
      public var keyWeapon5:Boolean = false;
      
      public var keyWeapon6:Boolean = false;
      
      public var keyWeapon7:Boolean = false;
      
      public var keyWeapon8:Boolean = false;
      
      public var keyWeapon9:Boolean = false;
      
      public var keyWeapon10:Boolean = false;
      
      public var keyWeapon11:Boolean = false;
      
      public var keyWeapon12:Boolean = false;
      
      public var keyScrDown:Boolean = false;
      
      public var keyScrUp:Boolean = false;
      
      public var rbmDbl:Boolean = false;
      
      public var keyDash:Boolean = false;
      
      public var keyArmor:Boolean = false;
      
      public var keySpell1:Boolean = false;
      
      public var keySpell2:Boolean = false;
      
      public var keySpell3:Boolean = false;
      
      public var keySpell4:Boolean = false;
      
      public var keyTest1:Boolean = false;
      
      public var keyTest2:Boolean = false;
      
      public var keyboardMode:int = 0;
      
      internal const dubleT:* = 5;
      
      private var kR_t:int = 10;
      
      private var kL_t:int = 10;
      
      private var kD_t:int = 10;
      
      private var scr_t:int = 0;
      
      public var active:Boolean = true;
      
      internal var KeyboardA:* = 65;
      
      internal var KeyboardZ:* = 90;
      
      internal var KeyboardW:* = 87;
      
      internal var KeyboardQ:* = 81;
      
      public var setkeyOn:Boolean = false;
      
      public var setkeyRequest:* = null;
      
      internal var setkeyFun:Function;
      
      public var keyPressed:Boolean = false;
      
      public var keyPressed2:Boolean = false;
      
      public function Ctr(param1:* = null)
      {
         super();
         this.keyNames = new Vector.<String>(256);
         this.keyDowns = new Vector.<Boolean>(256);
         this.mbNames = new Array();
         var _loc2_:* = Keyboard.A;
         while(_loc2_ <= Keyboard.Z)
         {
            this.keyNames[_loc2_] = String.fromCharCode(65 + _loc2_ - Keyboard.A);
            _loc2_++;
         }
         _loc2_ = Keyboard.NUMBER_0;
         while(_loc2_ <= Keyboard.NUMBER_9)
         {
            this.keyNames[_loc2_] = (_loc2_ - Keyboard.NUMBER_0).toString();
            _loc2_++;
         }
         _loc2_ = Keyboard.NUMPAD_0;
         while(_loc2_ <= Keyboard.NUMPAD_9)
         {
            this.keyNames[_loc2_] = "Numpad " + (_loc2_ - Keyboard.NUMPAD_0);
            _loc2_++;
         }
         _loc2_ = Keyboard.F1;
         while(_loc2_ <= Keyboard.F12)
         {
            this.keyNames[_loc2_] = "F" + (_loc2_ - Keyboard.F1 + 1);
            _loc2_++;
         }
         this.keyNames[Keyboard.UP] = "up";
         this.keyNames[Keyboard.DOWN] = "down";
         this.keyNames[Keyboard.LEFT] = "left";
         this.keyNames[Keyboard.RIGHT] = "right";
         this.keyNames[Keyboard.SPACE] = "Spacebar";
         this.keyNames[Keyboard.END] = "End";
         this.keyNames[Keyboard.INSERT] = "Insert";
         this.keyNames[Keyboard.HOME] = "Home";
         this.keyNames[Keyboard.DELETE] = "Delete";
         this.keyNames[Keyboard.PAGE_DOWN] = "Page Down";
         this.keyNames[Keyboard.PAGE_UP] = "Page Up";
         this.keyNames[Keyboard.ENTER] = "Enter";
         this.keyNames[Keyboard.ESCAPE] = "Esc";
         this.keyNames[Keyboard.BACKSPACE] = "Backspace";
         this.keyNames[Keyboard.CAPS_LOCK] = "Caps Lock";
         this.keyNames[Keyboard.CONTROL] = "Ctrl";
         this.keyNames[Keyboard.SHIFT] = "Shift";
         this.keyNames[Keyboard.ALTERNATE] = "Alt";
         this.keyNames[Keyboard.TAB] = "Tab";
         this.keyNames[Keyboard.COMMA] = ",";
         this.keyNames[Keyboard.MINUS] = "-";
         this.keyNames[Keyboard.EQUAL] = "=";
         this.keyNames[Keyboard.SLASH] = "/";
         this.keyNames[Keyboard.QUOTE] = "\'";
         this.keyNames[Keyboard.SEMICOLON] = ";";
         this.keyNames[Keyboard.PERIOD] = ".";
         this.keyNames[Keyboard.BACKQUOTE] = "`";
         this.keyNames[Keyboard.BACKSLASH] = "\\";
         this.keyNames[Keyboard.LEFTBRACKET] = "{";
         this.keyNames[Keyboard.RIGHTBRACKET] = "}";
         this.keyNames[Keyboard.NUMPAD_ADD] = "Numpad +";
         this.keyNames[Keyboard.NUMPAD_DECIMAL] = "Numpad .";
         this.keyNames[Keyboard.NUMPAD_DIVIDE] = "Numpad /";
         this.keyNames[Keyboard.NUMPAD_MULTIPLY] = "Numpad *";
         this.keyNames[Keyboard.NUMPAD_SUBTRACT] = "Numpad -";
         this.keyNames[Keyboard.NUMPAD_ENTER] = "Numpad Enter";
         this.mbNames["lmb"] = Res.txt("k","lmb");
         this.mbNames["rmb"] = Res.txt("k","rmb");
         this.mbNames["mmb"] = Res.txt("k","mmb");
         this.mbNames["scrd"] = Res.txt("k","scrd");
         this.mbNames["scru"] = Res.txt("k","scru");
         this.gotoDef();
         if(param1)
         {
            this.load(param1);
         }
         this.updateKeys();
         World.w.swfStage.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN,this.onMiddleMouseDown1);
         World.w.swfStage.addEventListener(MouseEvent.MIDDLE_MOUSE_UP,this.onMiddleMouseUp1);
         World.w.swfStage.addEventListener(MouseEvent.RIGHT_MOUSE_DOWN,this.onRightMouseDown1);
         World.w.swfStage.addEventListener(MouseEvent.RIGHT_MOUSE_UP,this.onRightMouseUp1);
         World.w.swfStage.addEventListener(MouseEvent.RIGHT_CLICK,this.onRightMouse);
         World.w.swfStage.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown1);
         World.w.swfStage.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp1);
         World.w.swfStage.addEventListener(MouseEvent.MOUSE_MOVE,this.onMouseMove1);
         World.w.swfStage.addEventListener(MouseEvent.MOUSE_WHEEL,this.onMouseWheel1);
         World.w.swfStage.addEventListener(KeyboardEvent.KEY_DOWN,this.onKeyboardDownEvent);
         World.w.swfStage.addEventListener(KeyboardEvent.KEY_UP,this.onKeyboardUpEvent);
      }
      
      public function clearAll() : *
      {
         this.keyLeft = this.keyRight = this.keyJump = this.keyAttack = this.keySit = this.keyBeUp = this.keyPunch = this.keyDash = this.keyAttack = this.keyPot = this.keyMana = this.keyGrenad = this.keyMagic = this.keyDef = this.keyPet = this.keyReload = this.keyTele = this.keyScrDown = this.keyScrUp = this.keyArmor = false;
         this.keyInvent = this.keyStatus = this.keySkills = this.keyMed = this.keyMap = this.keyQuest = false;
      }
      
      public function setKeyboard() : *
      {
         if(this.keyboardMode == 0)
         {
            this.KeyboardA = Keyboard.A;
            this.KeyboardZ = Keyboard.Z;
            this.KeyboardW = Keyboard.W;
            this.KeyboardQ = Keyboard.Q;
         }
         if(this.keyboardMode == 1)
         {
            this.KeyboardA = Keyboard.Q;
            this.KeyboardZ = Keyboard.W;
            this.KeyboardW = Keyboard.Z;
            this.KeyboardQ = Keyboard.A;
         }
      }
      
      public function step() : *
      {
         if(this.kR_t < 100)
         {
            ++this.kR_t;
         }
         if(this.kL_t < 100)
         {
            ++this.kL_t;
         }
         if(this.kD_t < 100)
         {
            ++this.kD_t;
         }
         if(this.scr_t > 0)
         {
            --this.scr_t;
            if(this.scr_t == 0)
            {
               if(this.keys["scrd"])
               {
                  this[this.keys["scrd"].id] = false;
               }
               if(this.keys["scru"])
               {
                  this[this.keys["scru"].id] = false;
               }
            }
         }
      }
      
      public function updateKeys() : *
      {
         var _loc1_:* = undefined;
         this.keys = new Array();
         for each(_loc1_ in this.keyObj)
         {
            if(_loc1_.a1)
            {
               this.keys[_loc1_.a1] = _loc1_;
            }
            if(_loc1_.a2)
            {
               this.keys[_loc1_.a2] = _loc1_;
            }
         }
      }
      
      public function gotoDef() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Object = null;
         this.keyObj = new Array();
         this.keyIds = new Array();
         for(_loc1_ in this.keyXML.key)
         {
            _loc2_ = {"id":this.keyXML.key[_loc1_].@id};
            if(this.keyXML.key[_loc1_].@def.length())
            {
               _loc2_.a1 = this.keyXML.key[_loc1_].@def.toString();
            }
            if(this.keyXML.key[_loc1_].@alt.length())
            {
               _loc2_.a2 = this.keyXML.key[_loc1_].@alt.toString();
            }
            this.keyObj.push(_loc2_);
            this.keyIds[this.keyXML.key[_loc1_].@id] = _loc2_;
         }
      }
      
      public function save() : *
      {
         var _loc2_:* = undefined;
         var _loc1_:Array = new Array();
         for(_loc2_ in this.keyIds)
         {
            _loc1_[_loc2_] = {
               "a1":this.keyIds[_loc2_].a1,
               "a2":this.keyIds[_loc2_].a2
            };
         }
         return _loc1_;
      }
      
      public function load(param1:*) : *
      {
         var _loc2_:* = undefined;
         for(_loc2_ in param1)
         {
            if(this.keyIds[_loc2_])
            {
               this.checkKey(param1[_loc2_].a1);
               this.checkKey(param1[_loc2_].a2);
               if(this.keyIds[_loc2_].a1 != Keyboard.TAB)
               {
                  this.keyIds[_loc2_].a1 = param1[_loc2_].a1;
               }
               this.keyIds[_loc2_].a2 = param1[_loc2_].a2;
            }
         }
      }
      
      public function checkKey(param1:String) : *
      {
         var _loc2_:* = undefined;
         if(param1 == null)
         {
            return;
         }
         for(_loc2_ in this.keyIds)
         {
            if(this.keyIds[_loc2_])
            {
               if(this.keyIds[_loc2_].a1 == param1)
               {
                  this.keyIds[_loc2_].a1 = null;
               }
               if(this.keyIds[_loc2_].a2 == param1)
               {
                  this.keyIds[_loc2_].a2 = null;
               }
            }
         }
      }
      
      public function retKey(param1:*) : String
      {
         if(this.keyIds[param1] == null)
         {
            return "?";
         }
         var _loc2_:* = this.keyIds[param1].a1;
         if(_loc2_ == null)
         {
            _loc2_ = this.keyIds[param1].a2;
         }
         if(_loc2_ == null)
         {
            return "???";
         }
         if(_loc2_ > 0 && _loc2_ < 256)
         {
            return "[" + this.keyNames[_loc2_] + "]";
         }
         return "[" + this.mbNames[_loc2_] + "]";
      }
      
      public function permissKey(param1:uint) : Boolean
      {
         if(param1 == Keyboard.CONTROL || param1 == Keyboard.ESCAPE || param1 == Keyboard.TAB || param1 == Keyboard.CAPS_LOCK || param1 == Keyboard.DELETE || param1 == Keyboard.END || param1 == Keyboard.HOME || param1 == Keyboard.INSERT)
         {
            return false;
         }
         return true;
      }
      
      public function requestKey(param1:Function = null) : *
      {
         this.setkeyOn = true;
         this.setkeyRequest = null;
         this.setkeyFun = param1;
      }
      
      internal function requestOk(param1:*) : *
      {
         this.setkeyOn = false;
         this.setkeyRequest = param1;
         if(Boolean(this.setkeyFun))
         {
            this.setkeyFun();
         }
      }
      
      public function onMouseMove1(param1:MouseEvent) : void
      {
         World.w.cam.celX = param1.stageX;
         World.w.cam.celY = param1.stageY;
         if(World.w.gui)
         {
            if(param1.stageY < 100 && param1.stageX > World.w.swfStage.stageWidth - 400)
            {
               World.w.gui.infoAlpha = 0.2;
            }
            else
            {
               World.w.gui.infoAlpha = 1;
            }
            World.w.gui.showDop = World.w.showFavs && param1.stageY > World.w.swfStage.stageHeight - 15;
         }
      }
      
      public function onMouseDown1(param1:MouseEvent) : void
      {
         if(World.w.onConsol)
         {
            return;
         }
         if(World.w.clickReq == 1)
         {
            World.w.clickReq = 2;
            return;
         }
         this.keyPressed = true;
         if(this.setkeyOn)
         {
            this.requestOk("lmb");
            param1.stopPropagation();
            return;
         }
         if(!this.active)
         {
            this.active = true;
         }
         else if(this.keys["lmb"])
         {
            this[this.keys["lmb"].id] = true;
         }
      }
      
      public function onMouseUp1(param1:MouseEvent) : void
      {
         if(this.keys["lmb"])
         {
            this[this.keys["lmb"].id] = false;
         }
      }
      
      private function onRightMouse(param1:MouseEvent) : void
      {
      }
      
      public function onRightMouseDown1(param1:MouseEvent) : void
      {
         if(World.w.onConsol)
         {
            return;
         }
         this.keyPressed = true;
         this.keyPressed2 = true;
         if(this.setkeyOn)
         {
            this.requestOk("rmb");
            return;
         }
         if(this.keys["rmb"])
         {
            this[this.keys["rmb"].id] = true;
         }
      }
      
      public function onRightMouseUp1(param1:MouseEvent) : void
      {
         if(this.keys["rmb"])
         {
            this[this.keys["rmb"].id] = false;
         }
      }
      
      public function onMiddleMouseDown1(param1:MouseEvent) : void
      {
         if(World.w.onConsol)
         {
            return;
         }
         if(this.setkeyOn)
         {
            this.requestOk("mmb");
            return;
         }
         if(this.keys["mmb"])
         {
            this[this.keys["mmb"].id] = true;
         }
      }
      
      public function onMiddleMouseUp1(param1:MouseEvent) : void
      {
         if(this.keys["mmb"])
         {
            this[this.keys["mmb"].id] = false;
         }
      }
      
      public function onMouseWheel1(param1:MouseEvent) : void
      {
         if(World.w.onConsol)
         {
            return;
         }
         if(this.setkeyOn)
         {
            if(param1.delta < 0)
            {
               this.requestOk("scrd");
            }
            if(param1.delta > 0)
            {
               this.requestOk("scru");
            }
            return;
         }
         try
         {
            if(World.w.gui.inform.visible && Boolean(World.w.gui.inform.scText.visible))
            {
               World.w.gui.inform.txt.scrollV -= param1.delta;
               param1.stopPropagation();
               return;
            }
         }
         catch(err:*)
         {
         }
         if(param1.delta < 0 && Boolean(this.keys["scrd"]))
         {
            this[this.keys["scrd"].id] = true;
         }
         if(param1.delta > 0 && Boolean(this.keys["scru"]))
         {
            this[this.keys["scru"].id] = true;
         }
         this.scr_t = 3;
         param1.stopPropagation();
      }
      
      public function onKeyboardDownEvent(param1:KeyboardEvent) : void
      {
         var _loc2_:* = undefined;
         if(this.setkeyOn)
         {
            if(this.permissKey(param1.keyCode))
            {
               this.requestOk(param1.keyCode);
            }
            else if(param1.keyCode == Keyboard.DELETE)
            {
               this.requestOk(null);
            }
            else if(param1.keyCode == Keyboard.TAB || param1.keyCode == Keyboard.ESCAPE)
            {
               this.requestOk(-1);
            }
            return;
         }
         if(!World.w.onConsol)
         {
            if(param1.keyCode < 256 && !this.keyDowns[param1.keyCode])
            {
               if(this.keys[param1.keyCode])
               {
                  this[this.keys[param1.keyCode].id] = true;
                  if(this.keys[param1.keyCode].id == "keyLeft" && this.kL_t < this.dubleT)
                  {
                     this.keyDubLeft = true;
                  }
                  if(this.keys[param1.keyCode].id == "keyRight" && this.kR_t < this.dubleT)
                  {
                     this.keyDubRight = true;
                  }
                  if(this.keys[param1.keyCode].id == "keySit" && this.kD_t < this.dubleT)
                  {
                     this.keyDubSit = true;
                  }
               }
            }
            if(param1.keyCode < 256)
            {
               this.keyDowns[param1.keyCode] = true;
            }
            if(Boolean(World.w.pip) && World.w.pip.reqKey)
            {
               _loc2_ = 1;
               while(_loc2_ <= 12)
               {
                  if(this["keyWeapon" + _loc2_])
                  {
                     this["keyWeapon" + _loc2_] = false;
                     World.w.pip.assignKey(_loc2_ + (this.keyRun ? 12 : 0));
                  }
                  _loc2_++;
               }
               _loc2_ = 1;
               while(_loc2_ <= 4)
               {
                  if(this["keySpell" + _loc2_])
                  {
                     this["keySpell" + _loc2_] = false;
                     World.w.pip.assignKey(24 + _loc2_);
                  }
                  _loc2_++;
               }
               if(this.keyGrenad)
               {
                  this.keyGrenad = false;
                  World.w.pip.assignKey(29);
               }
               if(this.keyMagic)
               {
                  this.keyMagic = false;
                  World.w.pip.assignKey(30);
               }
            }
         }
         if(param1.keyCode == Keyboard.END)
         {
            World.w.consolOnOff();
         }
         if(World.w.chitOn && param1.keyCode == Keyboard.HOME)
         {
            this.keyTest1 = true;
         }
         if(param1.keyCode == Keyboard.DELETE && World.w.testMode)
         {
            World.w.onPause = !World.w.onPause;
         }
         if(param1.keyCode == Keyboard.INSERT)
         {
            World.w.redrawLoc();
         }
         if(param1.keyCode == Keyboard.BACKQUOTE)
         {
            this.keyFly = true;
         }
         if(World.w.chitOn)
         {
            if(param1.keyCode == Keyboard.INSERT)
            {
               this.keyTest2 = true;
            }
         }
         if(this.keyFull)
         {
            if(!World.w.onConsol)
            {
               World.w.swfStage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            }
            this.keyFull = false;
         }
      }
      
      public function onKeyboardUpEvent(param1:KeyboardEvent) : void
      {
         if(param1.keyCode < 256)
         {
            this.keyDowns[param1.keyCode] = false;
         }
         if(this.keys[param1.keyCode])
         {
            this[this.keys[param1.keyCode].id] = false;
            if(this.keys[param1.keyCode].id == "keyLeft")
            {
               this.kL_t = 0;
            }
            if(this.keys[param1.keyCode].id == "keyRight")
            {
               this.kR_t = 0;
            }
            if(this.keys[param1.keyCode].id == "keySit")
            {
               this.kD_t = 0;
            }
         }
      }
   }
}

