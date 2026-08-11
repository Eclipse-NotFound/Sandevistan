package fe.graph
{
   import fe.*;
   import fe.loc.*;
   import fl.motion.Color;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.BitmapDataChannel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.filters.BlurFilter;
   import flash.filters.ColorMatrixFilter;
   import flash.filters.DropShadowFilter;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Mouse;
   import flash.ui.MouseCursorData;
   import flash.utils.*;
   
   public class Grafon
   {
      
      public static var spriteLists:Array = new Array();
      
      public static var texUrl:Array = ["texture.swf","texture1.swf","sprite.swf","sprite1.swf"];
      
      public static const numbMat:* = 0;
      
      public static const numbFon:* = 0;
      
      public static const numbBack:* = 1;
      
      public static const numbObj:* = 1;
      
      public static const numbSprite:* = 2;
      
      public var loc:Location;
      
      public var visual:Sprite;
      
      public var visBack:Sprite;
      
      public var visBack2:Sprite;
      
      public var visObjs:Array;
      
      internal const kolObjs:* = 6;
      
      public var visVoda:Sprite;
      
      public var visFront:Sprite;
      
      public var visLight:Sprite;
      
      public var visSats:Sprite;
      
      public var visFon:MovieClip;
      
      internal var resX:int;
      
      internal var resY:int;
      
      internal var kusokX:int = 48;
      
      internal var kusokY:int = 25;
      
      public var frontBmp:BitmapData;
      
      internal var frontBitmap:Bitmap;
      
      internal var vodaBmp:BitmapData;
      
      internal var vodaBitmap:Bitmap;
      
      internal var backBmp:BitmapData;
      
      internal var backBitmap:Bitmap;
      
      internal var backBmp2:BitmapData;
      
      internal var backBitmap2:Bitmap;
      
      public var lightBmp:BitmapData;
      
      internal var lightBitmap:Bitmap;
      
      public var satsBmp:BitmapData;
      
      internal var satsBitmap:Bitmap;
      
      internal var shadBmp:BitmapData;
      
      internal var colorBmp:BitmapData;
      
      internal var dsFilter:DropShadowFilter;
      
      internal var infraTransform:ColorTransform;
      
      internal var defTransform:ColorTransform;
      
      public var pa:MovieClip;
      
      public var pb:MovieClip;
      
      public var brTrans:ColorTransform;
      
      public var brColor:Color;
      
      internal var brData:BitmapData;
      
      internal var brPoint:Point;
      
      internal var brRect:Rectangle;
      
      internal var pm:Matrix;
      
      internal var voda:*;
      
      internal var m:Matrix;
      
      public var ramT:MovieClip;
      
      public var ramB:MovieClip;
      
      public var ramL:MovieClip;
      
      public var ramR:MovieClip;
      
      internal var arrFront:Array;
      
      internal var arrBack:Array;
      
      internal var rectX:int = 1920;
      
      internal var rectY:int = 1000;
      
      internal var allRect:Rectangle;
      
      internal var lightX:int = 49;
      
      internal var lightY:int = 28;
      
      internal var lightRect:Rectangle;
      
      public var resIsLoad:Boolean = false;
      
      public var progressLoad:Number = 0;
      
      public var grLoaders:Array;
      
      internal var nn:int = 0;
      
      public function Grafon(param1:Sprite)
      {
         var _loc2_:* = undefined;
         var _loc3_:String = null;
         this.dsFilter = new DropShadowFilter(7,90,0,0.75,16,16,1,3,false,false,true);
         this.infraTransform = new ColorTransform(1,1,1,1,100);
         this.defTransform = new ColorTransform();
         this.pa = new paintaero();
         this.pb = new paintbrush();
         this.brTrans = new ColorTransform();
         this.brColor = new Color();
         this.brData = new BitmapData(100,100,false,0);
         this.brPoint = new Point(0,0);
         this.brRect = new Rectangle(0,0,50,50);
         this.pm = new Matrix();
         this.voda = new tileVoda();
         this.allRect = new Rectangle(0,0,this.rectX,this.rectY);
         this.lightRect = new Rectangle(0,0,this.lightX,this.lightY);
         super();
         this.visual = param1;
         this.visBack = new Sprite();
         this.visBack2 = new Sprite();
         this.visVoda = new Sprite();
         this.visVoda.alpha = 0.6;
         this.visFront = new Sprite();
         this.visLight = new Sprite();
         this.visSats = new Sprite();
         this.visSats.visible = false;
         this.visSats.filters = [new BlurFilter(3,3,1)];
         this.visObjs = new Array();
         _loc2_ = 0;
         while(_loc2_ < this.kolObjs)
         {
            this.visObjs.push(new Sprite());
            _loc2_++;
         }
         this.visual.addChild(this.visBack);
         this.visual.addChild(this.visBack2);
         this.visual.addChild(this.visObjs[0]);
         this.visual.addChild(this.visObjs[1]);
         this.visual.addChild(this.visObjs[2]);
         this.visual.addChild(this.visFront);
         this.visual.addChild(this.visObjs[3]);
         this.visual.addChild(this.visVoda);
         this.visual.addChild(this.visLight);
         this.visual.addChild(this.visObjs[4]);
         this.visual.addChild(this.visSats);
         this.visual.addChild(this.visObjs[5]);
         this.visLight.x = -Tile.tileX / 2;
         this.visLight.y = -Tile.tileY / 2 - Tile.tileY;
         this.visLight.scaleX = Tile.tileX;
         this.visLight.scaleY = Tile.tileY;
         this.frontBmp = new BitmapData(this.rectX,this.rectY,true,0);
         this.frontBitmap = new Bitmap(this.frontBmp);
         this.visFront.addChild(this.frontBitmap);
         this.backBmp = new BitmapData(this.rectX,this.rectY,true,0);
         this.backBitmap = new Bitmap(this.backBmp);
         this.visBack.addChild(this.backBitmap);
         this.backBmp2 = new BitmapData(this.rectX,this.rectY,true,0);
         this.backBitmap2 = new Bitmap(this.backBmp2);
         this.visBack2.addChild(this.backBitmap2);
         this.vodaBmp = new BitmapData(this.rectX,this.rectY,true,0);
         this.vodaBitmap = new Bitmap(this.vodaBmp);
         this.visVoda.addChild(this.vodaBitmap);
         this.satsBmp = new BitmapData(this.rectX,this.rectY,true,0);
         this.satsBitmap = new Bitmap(this.satsBmp,"auto",true);
         this.visSats.addChild(this.satsBitmap);
         this.colorBmp = new BitmapData(this.rectX,this.rectY,true,0);
         this.shadBmp = new BitmapData(this.rectX,this.rectY,true,0);
         this.lightBmp = new BitmapData(this.lightX,this.lightY,true,4278190080);
         this.lightBitmap = new Bitmap(this.lightBmp,"auto",true);
         this.visLight.addChild(this.lightBitmap);
         this.ramT = new visBlack();
         this.ramB = new visBlack();
         this.ramR = new visBlack();
         this.ramL = new visBlack();
         this.ramT.cacheAsBitmap = this.ramB.cacheAsBitmap = this.ramR.cacheAsBitmap = this.ramL.cacheAsBitmap = true;
         this.visual.addChild(this.ramT);
         this.visual.addChild(this.ramB);
         this.visual.addChild(this.ramR);
         this.visual.addChild(this.ramL);
         this.grLoaders = new Array();
         for(_loc2_ in texUrl)
         {
            _loc3_ = texUrl[_loc2_];
            if(World.w.playerMode == "PlugIn")
            {
               _loc3_ += "?u=" + World.w.fileVersion;
            }
            this.grLoaders[_loc2_] = new GrLoader(_loc2_,_loc3_,this);
         }
         this.createCursors();
      }
      
      public function checkLoaded(param1:int) : *
      {
         var _loc2_:XML = null;
         if(param1 == 0)
         {
            this.arrFront = new Array();
            this.arrBack = new Array();
            for each(_loc2_ in AllData.d.mat)
            {
               if(_loc2_.@vid.length() == 0)
               {
                  if(_loc2_.@ed == "2")
                  {
                     this.arrBack[_loc2_.@id] = new Material(_loc2_);
                  }
                  else
                  {
                     this.arrFront[_loc2_.@id] = new Material(_loc2_);
                  }
               }
            }
         }
         this.resIsLoad = GrLoader.kolIsLoad >= GrLoader.kol;
      }
      
      public function allProgress() : *
      {
         var _loc1_:* = undefined;
         this.progressLoad = 0;
         for(_loc1_ in this.grLoaders)
         {
            this.progressLoad += this.grLoaders[_loc1_].progressLoad;
         }
         this.progressLoad /= GrLoader.kol;
      }
      
      internal function createCursors() : *
      {
         this.createCursor(visCurArrow,"arrow");
         this.createCursor(visCurTarget,"target",13,13);
         this.createCursor(visCurTarget1,"combat",13,13);
         this.createCursor(visCurTarget2,"action",13,13);
      }
      
      internal function createCursor(param1:Class, param2:String, param3:int = 0, param4:int = 0) : *
      {
         var _loc5_:Vector.<BitmapData> = null;
         var _loc6_:MouseCursorData = null;
         _loc5_ = new Vector.<BitmapData>();
         _loc5_.push(new param1());
         _loc6_ = new MouseCursorData();
         _loc6_.data = _loc5_;
         _loc6_.hotSpot = new Point(param3,param4);
         Mouse.registerCursor(param2,_loc6_);
      }
      
      public function getObj(param1:String, param2:int = 0) : *
      {
         return this.grLoaders[param2].res.getObj(param1);
      }
      
      public function drawFon(param1:MovieClip, param2:String) : *
      {
         if(param2 == "" || param2 == null)
         {
            param2 = "fonDefault";
         }
         if(Boolean(this.visFon) && param1.contains(this.visFon))
         {
            param1.removeChild(this.visFon);
         }
         this.visFon = this.getObj(param2);
         if(this.visFon)
         {
            param1.addChild(this.visFon);
         }
      }
      
      public function setFonSize(param1:Number, param2:Number) : *
      {
         var _loc3_:* = undefined;
         if(this.visFon)
         {
            if(param1 > this.rectX && param2 > this.rectY)
            {
               this.visFon.x = this.visual.x;
               this.visFon.y = this.visual.y;
               this.visFon.width = this.rectX;
               this.visFon.height = this.rectY;
            }
            else
            {
               _loc3_ = this.visFon.width / this.visFon.height;
               this.visFon.x = this.visFon.y = 0;
               if(param1 >= param2 * _loc3_)
               {
                  this.visFon.width = param1;
                  this.visFon.height = param1 / _loc3_;
               }
               else
               {
                  this.visFon.height = param2;
                  this.visFon.width = param2 * _loc3_;
               }
            }
         }
      }
      
      public function warShadow() : *
      {
         if(World.w.pers.infravis)
         {
            this.visLight.transform.colorTransform = this.infraTransform;
            this.visLight.blendMode = "multiply";
         }
         else
         {
            this.visLight.transform.colorTransform = this.defTransform;
            this.visLight.blendMode = "normal";
         }
      }
      
      public function drawLoc(param1:Location) : *
      {
         var transpFon:Boolean = false;
         var darkness:int = 0;
         var tile:MovieClip = null;
         var t:Tile = null;
         var front:Sprite = null;
         var back:Sprite = null;
         var back2:Sprite = null;
         var voda:Sprite = null;
         var mat:Material = null;
         var gret:int = 0;
         var i:* = undefined;
         var e:* = undefined;
         var darkness2:* = undefined;
         var ct:ColorTransform = null;
         var j:* = undefined;
         var bo:BackObj = null;
         var nloc:Location = param1;
         try
         {
            World.w.gr_stage = 1;
            this.loc = nloc;
            this.loc.grafon = this;
            this.resX = this.loc.spaceX * Tile.tileX;
            this.resY = this.loc.spaceY * Tile.tileY;
            transpFon = nloc.transpFon;
            if(nloc.backwall == "sky")
            {
               transpFon = true;
            }
            World.w.gr_stage = 2;
            this.ramT.x = this.ramB.x = -50;
            this.ramR.y = this.ramL.y = 0;
            this.ramT.y = 0;
            this.ramL.x = 0;
            this.ramB.y = this.loc.limY - 1;
            this.ramR.x = this.loc.limX - 1;
            this.ramT.scaleX = this.ramB.scaleX = this.loc.limX / 100 + 1;
            this.ramT.scaleY = this.ramB.scaleY = 2;
            this.ramR.scaleY = this.ramL.scaleY = this.loc.limY / 100;
            this.ramR.scaleX = this.ramL.scaleX = 2;
            World.w.gr_stage = 3;
            this.frontBmp.lock();
            this.backBmp.lock();
            this.backBmp2.lock();
            this.vodaBmp.lock();
            this.frontBmp.fillRect(this.allRect,0);
            this.backBmp.fillRect(this.allRect,0);
            this.backBmp2.fillRect(this.allRect,0);
            this.vodaBmp.fillRect(this.allRect,0);
            this.satsBmp.fillRect(this.allRect,0);
            this.lightBmp.fillRect(this.lightRect,4278190080);
            this.setLight();
            this.visLight.visible = this.loc.black && World.w.black;
            this.warShadow();
            darkness = 170 + this.loc.darkness;
            if(darkness > 255)
            {
               darkness = 255;
            }
            if(darkness < 0)
            {
               darkness = 0;
            }
            this.colorBmp.fillRect(this.allRect,darkness * 16777216);
            this.shadBmp.fillRect(this.allRect,4294967295);
            World.w.gr_stage = 4;
            this.m = new Matrix();
            front = new Sprite();
            back = new Sprite();
            back2 = new Sprite();
            voda = new Sprite();
            for each(mat in this.arrFront)
            {
               mat.used = false;
            }
            for each(mat in this.arrBack)
            {
               mat.used = false;
            }
            gret = 0;
            World.w.gr_stage = 5;
            i = 0;
            while(i < this.loc.spaceX)
            {
               j = 0;
               while(j < this.loc.spaceY)
               {
                  t = this.loc.getTile(i,j);
                  this.loc.tileKontur(i,j,t);
                  if(this.arrFront[t.front])
                  {
                     this.arrFront[t.front].used = true;
                  }
                  if(this.arrBack[t.back])
                  {
                     this.arrBack[t.back].used = true;
                  }
                  if(t.vid > 0)
                  {
                     tile = new tileFront();
                     tile.gotoAndStop(t.vid);
                     if(t.vRear)
                     {
                        back2.addChild(tile);
                     }
                     else
                     {
                        front.addChild(tile);
                     }
                     tile.x = i * Tile.tileX;
                     tile.y = j * Tile.tileY;
                  }
                  if(t.vid2 > 0)
                  {
                     tile = new tileFront();
                     tile.gotoAndStop(t.vid2);
                     if(t.v2Rear)
                     {
                        back2.addChild(tile);
                     }
                     else
                     {
                        front.addChild(tile);
                     }
                     tile.x = i * Tile.tileX;
                     tile.y = j * Tile.tileY;
                  }
                  if(t.water)
                  {
                     tile = new tileVoda();
                     tile.gotoAndStop(this.loc.tipWater + 1);
                     if(this.loc.getTile(i,j - 1).water == 0 && this.loc.getTile(i,j - 1).phis == 0)
                     {
                        tile.voda.gotoAndStop(2);
                     }
                     tile.x = i * Tile.tileX;
                     tile.y = j * Tile.tileY;
                     voda.addChild(tile);
                  }
                  j++;
               }
               i++;
            }
            World.w.gr_stage = 6;
            this.vodaBmp.draw(voda,new Matrix(),null,null,null,false);
            this.frontBmp.draw(front,new Matrix(),null,null,null,false);
            World.w.gr_stage = 7;
            this.drawBackWall(nloc.backwall,nloc.backform);
            World.w.gr_stage = 8;
            for each(mat in this.arrFront)
            {
               try
               {
                  this.drawKusok(mat,true);
               }
               catch(err:*)
               {
                  World.w.showError(err,"Ошибка рисования слоя " + mat.id);
               }
            }
            World.w.gr_stage = 9;
            for(e in this.arrBack)
            {
               try
               {
                  this.drawKusok(this.arrBack[e],false);
               }
               catch(err:*)
               {
                  World.w.showError(err,"Ошибка рисования слоя " + arrBack[e].id);
               }
            }
            World.w.gr_stage = 10;
            this.satsBmp.copyChannel(this.backBmp,this.backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
            darkness2 = 1 - (255 - darkness) / 150;
            ct = new ColorTransform();
            World.w.gr_stage = 11;
            j = -2;
            while(j <= 3)
            {
               if(j == -1)
               {
                  this.backBmp.copyChannel(this.satsBmp,this.backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
               }
               for each(bo in this.loc.backobjs)
               {
                  if(bo.sloy == j && !bo.er || j == -2 && bo.er)
                  {
                     this.m = new Matrix();
                     this.m.scale(bo.scX,bo.scY);
                     this.m.tx = bo.X;
                     this.m.ty = bo.Y;
                     ct.alphaMultiplier = bo.alpha;
                     if(bo.vis)
                     {
                        if(j <= 0)
                        {
                           ct.redMultiplier = ct.greenMultiplier = ct.blueMultiplier = 1;
                           this.backBmp.draw(bo.vis,this.m,ct,bo.blend,null,true);
                        }
                        else
                        {
                           if(bo.light)
                           {
                              if(darkness2 >= 0.43)
                              {
                                 ct.redMultiplier = ct.greenMultiplier = ct.blueMultiplier = 1;
                              }
                              else
                              {
                                 ct.redMultiplier = ct.greenMultiplier = ct.blueMultiplier = 0.55 + darkness2;
                              }
                           }
                           else
                           {
                              ct.redMultiplier = ct.greenMultiplier = ct.blueMultiplier = darkness2;
                           }
                           this.backBmp2.draw(bo.vis,this.m,ct,bo.blend,null,true);
                           if(bo.light)
                           {
                              ct.redMultiplier = ct.greenMultiplier = ct.blueMultiplier = 1;
                           }
                           else
                           {
                              ct.redMultiplier = ct.greenMultiplier = ct.blueMultiplier = darkness2;
                           }
                        }
                     }
                     if(bo.erase)
                     {
                        this.satsBmp.draw(bo.erase,this.m,null,"erase",null,true);
                     }
                     if(bo.light)
                     {
                        this.colorBmp.draw(bo.light,this.m,ct,"normal",null,true);
                     }
                  }
               }
               j++;
            }
            World.w.gr_stage = 12;
            this.m = new Matrix();
            if(nloc.cTransform)
            {
               this.frontBmp.colorTransform(this.frontBmp.rect,nloc.cTransform);
               this.vodaBmp.colorTransform(this.vodaBmp.rect,nloc.cTransform);
            }
            this.shadBmp.applyFilter(this.frontBmp,this.frontBmp.rect,new Point(0,0),this.dsFilter);
            World.w.gr_stage = 13;
            if(nloc.cTransform)
            {
               this.backBmp.colorTransform(this.backBmp.rect,nloc.cTransform);
               ct = new ColorTransform();
               darkness2 = 1 + (170 - darkness) / 33;
               ct.concat(nloc.cTransform);
               if(darkness2 > 1)
               {
                  ct.redMultiplier *= darkness2;
                  ct.greenMultiplier *= darkness2;
                  ct.blueMultiplier *= darkness2;
               }
               this.backBmp2.colorTransform(this.backBmp2.rect,ct);
            }
            World.w.gr_stage = 14;
            this.backBmp2.draw(back,new Matrix(),nloc.cTransform,null,null,false);
            World.w.gr_stage = 15;
            if(transpFon)
            {
               this.satsBmp.copyChannel(this.backBmp,this.backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
            }
            this.backBmp.draw(this.colorBmp,null,null,"hardlight");
            this.backBmp.draw(this.shadBmp);
            if(transpFon)
            {
               this.backBmp.copyChannel(this.satsBmp,this.backBmp.rect,new Point(0,0),BitmapDataChannel.ALPHA,BitmapDataChannel.ALPHA);
            }
            World.w.gr_stage = 16;
            if(this.loc.gas > 0)
            {
               this.m = new Matrix();
               this.m.ty = 520;
               this.backBmp2.draw(this.getObj("back_pink_t",numbBack),this.m,new ColorTransform(1,1,1,0.3));
            }
            World.w.gr_stage = 17;
            for each(mat in this.arrFront)
            {
               this.drawKusok(mat,false,true);
            }
            this.backBmp2.draw(back2,new Matrix(),nloc.cTransform,null,null,false);
            World.w.gr_stage = 18;
            this.frontBmp.unlock();
            this.backBmp.unlock();
            this.backBmp2.unlock();
            this.vodaBmp.unlock();
            if(Boolean(nloc.cTransform) && Boolean(nloc.cTransformFon))
            {
               this.visFon.transform.colorTransform = nloc.cTransformFon;
            }
            else if(this.visFon.transform.colorTransform != this.defTransform)
            {
               this.visFon.transform.colorTransform = this.defTransform;
            }
         }
         catch(err:*)
         {
            World.w.showError(err);
         }
         World.w.gr_stage = 19;
         this.drawAllObjs();
         World.w.gr_stage = 0;
      }
      
      public function setLight() : *
      {
         var _loc2_:* = undefined;
         this.lightBmp.lock();
         var _loc1_:* = 1;
         while(_loc1_ < this.loc.spaceX)
         {
            _loc2_ = 1;
            while(_loc2_ < this.loc.spaceY)
            {
               this.lightBmp.setPixel32(_loc1_,_loc2_ + 1,Math.floor((1 - this.loc.space[_loc1_][_loc2_].visi) * 255) * 16777216);
               _loc2_++;
            }
            _loc1_++;
         }
         this.lightBmp.unlock();
      }
      
      public function drawAllObjs() : *
      {
         var _loc3_:* = undefined;
         var _loc1_:* = 0;
         while(_loc1_ < this.kolObjs)
         {
            _loc3_ = this.visual.getChildIndex(this.visObjs[_loc1_]);
            this.visual.removeChild(this.visObjs[_loc1_]);
            this.visObjs[_loc1_] = new Sprite();
            this.visual.addChildAt(this.visObjs[_loc1_],_loc3_);
            _loc1_++;
         }
         var _loc2_:Pt = this.loc.firstObj;
         while(_loc2_)
         {
            _loc2_.addVisual();
            _loc2_ = _loc2_.nobj;
         }
         this.loc.gg.addVisual();
         for(_loc1_ in this.loc.signposts)
         {
            this.visObjs[3].addChild(this.loc.signposts[_loc1_]);
         }
      }
      
      public function drawBackWall(param1:String, param2:int = 0) : *
      {
         if(param1 == "sky")
         {
            return;
         }
         this.m = new Matrix();
         var _loc3_:BitmapData = this.getObj(param1);
         if(_loc3_ == null)
         {
            _loc3_ = this.getObj("tBackWall");
         }
         var _loc4_:Sprite = new Sprite();
         _loc4_.graphics.beginBitmapFill(_loc3_);
         if(param2 == 0)
         {
            _loc4_.graphics.drawRect(0,0,this.kusokX * Tile.tileX,this.kusokY * Tile.tileY);
         }
         else if(param2 == 1)
         {
            _loc4_.graphics.drawRect(0,0,11 * Tile.tileX - 10,this.kusokY * Tile.tileY);
            _loc4_.graphics.drawRect(37 * Tile.tileX + 10,0,this.kusokX * Tile.tileX,this.kusokY * Tile.tileY);
         }
         else if(param2 == 2)
         {
            _loc4_.graphics.drawRect(0,16 * Tile.tileY + 10,this.kusokX * Tile.tileX,this.kusokY * Tile.tileY);
         }
         else if(param2 == 3)
         {
            _loc4_.graphics.drawRect(0,24 * Tile.tileY + 10,this.kusokX * Tile.tileX,this.kusokY * Tile.tileY);
         }
         this.backBmp.draw(_loc4_,this.m,null,null,null,false);
      }
      
      internal function setMCT(param1:MovieClip, param2:Tile, param3:Boolean) : *
      {
         if(param1.c1)
         {
            if(param3)
            {
               param1.c1.gotoAndStop(param2.kont1 + 1);
               param1.c2.gotoAndStop(param2.kont2 + 1);
               param1.c3.gotoAndStop(param2.kont3 + 1);
               param1.c4.gotoAndStop(param2.kont4 + 1);
            }
            else
            {
               param1.c1.gotoAndStop(param2.pont1 + 1);
               param1.c2.gotoAndStop(param2.pont2 + 1);
               param1.c3.gotoAndStop(param2.pont3 + 1);
               param1.c4.gotoAndStop(param2.pont4 + 1);
            }
         }
      }
      
      public function drawKusok(param1:Material, param2:Boolean, param3:Boolean = false) : *
      {
         var _loc4_:Tile = null;
         var _loc5_:MovieClip = null;
         var _loc15_:* = undefined;
         if(!param1.used)
         {
            return;
         }
         if(param1.rear == param2)
         {
            return;
         }
         var _loc6_:Sprite = new Sprite();
         var _loc7_:Sprite = new Sprite();
         var _loc8_:Sprite = new Sprite();
         var _loc9_:Sprite = new Sprite();
         var _loc10_:Sprite = new Sprite();
         var _loc11_:Sprite = new Sprite();
         var _loc12_:Sprite = new Sprite();
         if(param1.texture == null)
         {
            _loc7_.graphics.beginFill(6710886);
         }
         else if(this.loc.homeStable && param1.alttexture != null)
         {
            _loc7_.graphics.beginBitmapFill(param1.alttexture);
         }
         else
         {
            _loc7_.graphics.beginBitmapFill(param1.texture);
         }
         _loc7_.graphics.drawRect(0,0,this.kusokX * Tile.tileX,this.kusokY * Tile.tileY);
         _loc6_.addChild(_loc7_);
         _loc6_.addChild(_loc8_);
         if(param1.border)
         {
            _loc9_.graphics.beginBitmapFill(param1.border);
            _loc9_.graphics.drawRect(0,0,this.kusokX * Tile.tileX,this.kusokY * Tile.tileY);
            _loc6_.addChild(_loc9_);
            _loc6_.addChild(_loc10_);
         }
         if(param1.floor)
         {
            _loc11_.graphics.beginBitmapFill(param1.floor);
            _loc11_.graphics.drawRect(0,0,this.kusokX * Tile.tileX,this.kusokY * Tile.tileY);
            _loc6_.addChild(_loc11_);
            _loc6_.addChild(_loc12_);
         }
         var _loc13_:Boolean = false;
         var _loc14_:* = 0;
         while(_loc14_ < this.loc.spaceX)
         {
            _loc15_ = 0;
            while(_loc15_ < this.loc.spaceY)
            {
               _loc4_ = this.loc.getTile(_loc14_,_loc15_);
               if(_loc4_.front == param1.id && (param2 || param3) || _loc4_.back == param1.id && !param2)
               {
                  _loc13_ = true;
                  _loc5_ = new param1.textureMask();
                  this.setMCT(_loc5_,_loc4_,param2);
                  _loc5_.x = (_loc14_ + 0.5) * Tile.tileX;
                  _loc5_.y = (_loc15_ + 0.5) * Tile.tileY;
                  _loc8_.addChild(_loc5_);
                  if(Boolean(_loc4_.zForm) && param2)
                  {
                     _loc5_.scaleY = (_loc4_.phY2 - _loc4_.phY1) / Tile.tileY;
                     _loc5_.y = (_loc4_.phY2 + _loc4_.phY1) / 2;
                  }
                  if(param1.borderMask)
                  {
                     _loc5_ = new param1.borderMask();
                     this.setMCT(_loc5_,_loc4_,param2);
                     _loc5_.x = (_loc14_ + 0.5) * Tile.tileX;
                     _loc5_.y = (_loc15_ + 0.5) * Tile.tileY;
                     _loc10_.addChild(_loc5_);
                     if(Boolean(_loc4_.zForm) && param2)
                     {
                        _loc5_.scaleY = (_loc4_.phY2 - _loc4_.phY1) / Tile.tileY;
                        _loc5_.y = (_loc4_.phY2 + _loc4_.phY1) / 2;
                     }
                  }
                  if(param1.floorMask)
                  {
                     _loc5_ = new param1.floorMask();
                     if(_loc5_.c1)
                     {
                        _loc5_.c1.gotoAndStop(_loc4_.kont1 + 1);
                        _loc5_.c2.gotoAndStop(_loc4_.kont2 + 1);
                     }
                     _loc12_.addChild(_loc5_);
                     _loc5_.x = (_loc14_ + 0.5) * Tile.tileX;
                     _loc5_.y = (_loc15_ + 0.5 + _loc4_.zForm / 4) * Tile.tileY;
                  }
               }
               _loc15_++;
            }
            _loc14_++;
         }
         if(!_loc13_)
         {
            return;
         }
         this.m.tx = 0;
         this.m.ty = 0;
         _loc7_.cacheAsBitmap = _loc8_.cacheAsBitmap = _loc9_.cacheAsBitmap = _loc10_.cacheAsBitmap = _loc11_.cacheAsBitmap = _loc12_.cacheAsBitmap = true;
         _loc7_.mask = _loc8_;
         _loc9_.mask = _loc10_;
         _loc11_.mask = _loc12_;
         if(param1.F)
         {
            _loc6_.filters = param1.F;
         }
         if(param2)
         {
            this.frontBmp.draw(_loc6_,this.m,null,null,null,false);
         }
         else if(param3)
         {
            this.backBmp2.draw(_loc6_,this.m,this.loc.cTransform,null,null,false);
         }
         else
         {
            this.backBmp.draw(_loc6_,this.m,null,null,null,false);
         }
      }
      
      public function getSpriteList(param1:String, param2:int = 0) : BitmapData
      {
         if(spriteLists[param1] == null)
         {
            if(param2 > 0)
            {
               spriteLists[param1] = this.getObj(param1,numbSprite + param2);
            }
            else
            {
               spriteLists[param1] = this.getObj(param1,numbSprite);
               if(spriteLists[param1] == null)
               {
                  spriteLists[param1] = this.getObj(param1,numbSprite + 1);
               }
            }
         }
         if(spriteLists[param1] == null)
         {
            trace("нет спрайтов",param1);
         }
         return spriteLists[param1];
      }
      
      public function drawSats() : *
      {
         this.satsBmp.fillRect(this.satsBmp.rect,0);
         this.satsBmp.draw(this.visual,new Matrix());
      }
      
      public function onSats(param1:Boolean) : *
      {
         this.visSats.visible = param1;
         this.visObjs[2].visible = !param1;
      }
      
      public function drawWater(param1:Tile, param2:Boolean = true) : *
      {
         this.m = new Matrix();
         this.m.tx = param1.X * Tile.tileX;
         this.m.ty = param1.Y * Tile.tileY;
         this.voda.gotoAndStop(this.loc.tipWater + 1);
         if(this.loc.getTile(param1.X,param1.Y - 1).water == 0 && this.loc.getTile(param1.X,param1.Y - 1).phis == 0)
         {
            this.voda.voda.gotoAndStop(2);
         }
         else
         {
            this.voda.voda.gotoAndStop(1);
         }
         this.vodaBmp.draw(this.voda,this.m,this.loc.cTransform,param1.water > 0 ? "normal" : "erase",null,false);
         if(param2)
         {
            this.drawWater(this.loc.getTile(param1.X,param1.Y + 1),false);
         }
      }
      
      public function tileDie(param1:Tile, param2:int) : *
      {
         var _loc3_:Class = block_dyr;
         var _loc4_:Class = block_tre;
         var _loc5_:* = (param1.X + 0.5) * Tile.tileX;
         var _loc6_:* = (param1.Y + 0.5) * Tile.tileY;
         if(param1.fake)
         {
            Emitter.emit("fake",this.loc,_loc5_,_loc6_);
            _loc4_ = block_bur;
         }
         else if(param1.mat == 7)
         {
            Emitter.emit("fake",this.loc,_loc5_,_loc6_);
            Emitter.emit("pole",this.loc,_loc5_,_loc6_,{
               "kol":10,
               "rx":Tile.tileX,
               "ry":Tile.tileY
            });
            _loc3_ = TileMask;
            _loc4_ = null;
         }
         else if(param2 < 10)
         {
            if(param1.mat == 1)
            {
               Emitter.emit("metal",this.loc,_loc5_,_loc6_,{
                  "kol":6,
                  "rx":Tile.tileX,
                  "ry":Tile.tileY
               });
            }
            else if(param1.mat == 2)
            {
               Emitter.emit("kusok",this.loc,_loc5_,_loc6_,{
                  "kol":6,
                  "rx":Tile.tileX,
                  "ry":Tile.tileY
               });
            }
            else if(param1.mat == 3)
            {
               Emitter.emit("schep",this.loc,_loc5_,_loc6_,{
                  "kol":6,
                  "rx":Tile.tileX,
                  "ry":Tile.tileY
               });
            }
            else if(param1.mat == 4)
            {
               Emitter.emit("kusokB",this.loc,_loc5_,_loc6_,{
                  "kol":6,
                  "rx":Tile.tileX,
                  "ry":Tile.tileY
               });
            }
            else if(param1.mat == 5)
            {
               Emitter.emit("steklo",this.loc,_loc5_,_loc6_,{
                  "kol":6,
                  "rx":Tile.tileX,
                  "ry":Tile.tileY
               });
            }
            else if(param1.mat == 6)
            {
               Emitter.emit("kusokD",this.loc,_loc5_,_loc6_,{
                  "kol":6,
                  "rx":Tile.tileX,
                  "ry":Tile.tileY
               });
            }
         }
         else if(param2 >= 15)
         {
            Emitter.emit("plav",this.loc,_loc5_,_loc6_);
            _loc3_ = block_plav;
            _loc4_ = block_pla;
         }
         else if(param2 >= 11 && param2 <= 13)
         {
            Emitter.emit("bur",this.loc,_loc5_,_loc6_);
            _loc4_ = block_bur;
         }
         this.decal(_loc3_,_loc4_,_loc5_,_loc6_,1,0,"hardlight");
      }
      
      public function dyrka(param1:int, param2:int, param3:int, param4:int, param5:Boolean = false, param6:Number = 1) : *
      {
         var _loc7_:Class = null;
         var _loc8_:Class = null;
         var _loc9_:String = "normal";
         var _loc10_:Boolean = false;
         var _loc11_:* = Math.random() * 0.5 + 0.5;
         var _loc12_:* = Math.random() * 360;
         if(param3 == 0 || param4 == 0)
         {
            return;
         }
         if(param4 == 1)
         {
            if(param3 >= 1 && param3 <= 6)
            {
               _loc8_ = bullet_metal;
            }
            else if(param3 == 9)
            {
               if(!param5 && Math.random() * 0.5 < param6)
               {
                  _loc8_ = metal_tre;
               }
               _loc10_ = true;
            }
         }
         else if(param4 == 2 || param4 == 4 || param4 == 6)
         {
            if(param3 >= 1 && param3 <= 3)
            {
               if(param3 > 1 && Math.random() > 0.5)
               {
                  _loc7_ = bullet_dyr;
               }
               _loc8_ = bullet_tre;
               if(param3 == 2)
               {
                  _loc11_ += 0.5;
               }
               if(param3 == 3)
               {
                  _loc11_ += 1;
               }
            }
            else if(param3 >= 4 && param3 <= 6)
            {
               if(!param5)
               {
                  _loc8_ = punch_tre;
               }
               if(param3 == 5)
               {
                  _loc11_ += 0.5;
               }
               if(param3 == 6)
               {
                  _loc11_ += 1;
               }
            }
            else if(param3 == 9)
            {
               if(!param5 && Math.random() * 0.5 < param6)
               {
                  _loc8_ = expl_tre;
               }
               _loc10_ = true;
            }
            if(param3 < 10 && !param5)
            {
               if(param4 == 2)
               {
                  Emitter.emit("kusoch",this.loc,param1,param2,{"kol":3});
               }
               else
               {
                  Emitter.emit("kusochB",this.loc,param1,param2,{"kol":3});
               }
            }
         }
         else if(param4 == 3)
         {
            if(param3 >= 1 && param3 <= 3)
            {
               _loc7_ = bullet_dyr;
               _loc8_ = bullet_wood;
               _loc12_ = 0;
               if(param3 == 2)
               {
                  _loc11_ += 0.5;
               }
               if(param3 == 3)
               {
                  _loc11_ += 1;
               }
            }
            else if(param3 >= 4 && param3 <= 6)
            {
               if(!param5)
               {
                  _loc8_ = punch_tre;
               }
               if(param3 == 5)
               {
                  _loc11_ += 0.5;
               }
               if(param3 == 6)
               {
                  _loc11_ += 1;
               }
            }
            else if(param3 == 9)
            {
               if(!param5 && Math.random() * 0.5 < param6)
               {
                  _loc8_ = expl_tre;
               }
               _loc10_ = true;
            }
            if(param3 < 10 && !param5)
            {
               Emitter.emit("schepoch",this.loc,param1,param2,{"kol":3});
            }
         }
         else if(param4 == 7)
         {
            Emitter.emit("pole",this.loc,param1,param2,{"kol":5});
         }
         if(param3 == 11)
         {
            if(Math.random() < 0.1)
            {
               _loc8_ = fire_soft;
            }
         }
         else if(param3 == 12 || param3 == 13)
         {
            if(param5 && Math.random() * 0.2 > param6)
            {
               _loc8_ = fire_soft;
            }
            else
            {
               _loc8_ = laser_tre;
            }
            if(param3 == 13)
            {
               _loc11_ *= 0.6;
            }
            _loc9_ = "hardlight";
         }
         else if(param3 == 15)
         {
            if(param5)
            {
               _loc8_ = plasma_soft;
            }
            else
            {
               _loc7_ = plasma_dyr;
               _loc8_ = plasma_tre;
            }
            _loc9_ = "hardlight";
         }
         else if(param3 == 16)
         {
            if(param5)
            {
               _loc8_ = fire_soft;
            }
            else
            {
               _loc7_ = plasma_dyr;
               _loc8_ = bluplasma_tre;
            }
            _loc9_ = "hardlight";
         }
         else if(param3 == 17)
         {
            if(param5)
            {
               _loc8_ = fire_soft;
            }
            else
            {
               _loc7_ = plasma_dyr;
               _loc8_ = pinkplasma_tre;
            }
            _loc9_ = "hardlight";
         }
         else if(param3 == 18)
         {
            _loc8_ = cryo_soft;
            _loc9_ = "hardlight";
         }
         else if(param3 == 19)
         {
            if(!param5 && Math.random() * 0.5 < param6)
            {
               _loc8_ = plaexpl_tre;
            }
            _loc10_ = true;
         }
         this.decal(_loc7_,_loc8_,param1,param2,_loc11_,_loc12_,_loc9_);
      }
      
      public function decal(param1:Class, param2:Class, param3:Number, param4:Number, param5:Number = 1, param6:Number = 0, param7:String = "normal") : *
      {
         var _loc8_:MovieClip = null;
         var _loc9_:MovieClip = null;
         var _loc10_:* = undefined;
         var _loc11_:* = undefined;
         var _loc12_:BitmapData = null;
         var _loc13_:* = undefined;
         var _loc14_:* = undefined;
         var _loc15_:Rectangle = null;
         var _loc16_:Point = null;
         this.m = new Matrix();
         if(param5 != 1)
         {
            this.m.scale(param5,param5);
         }
         if(param6 != 0)
         {
            this.m.rotate(param6);
         }
         this.m.tx = param3;
         this.m.ty = param4;
         if(param1)
         {
            _loc8_ = new param1();
            if(_loc8_.totalFrames > 1)
            {
               _loc8_.gotoAndStop(Math.floor(Math.random() * _loc8_.totalFrames + 1));
            }
            this.frontBmp.draw(_loc8_,this.m,null,"erase",null,true);
         }
         if(param2)
         {
            _loc9_ = new param2();
            if(_loc9_.totalFrames > 1)
            {
               _loc9_.gotoAndStop(Math.floor(Math.random() * _loc9_.totalFrames + 1));
            }
            _loc9_.scaleX = _loc9_.scaleY = param5;
            _loc9_.rotation = param6;
            _loc10_ = Math.round(_loc9_.width / 2 + 2) * 2;
            _loc11_ = Math.round(_loc9_.height / 2 + 2) * 2;
            _loc12_ = new BitmapData(_loc10_,_loc11_,false,0);
            _loc13_ = 0;
            _loc14_ = 0;
            if(param3 - _loc10_ / 2 < 0)
            {
               _loc13_ = -(param3 - _loc10_ / 2);
            }
            if(param4 - _loc11_ / 2 < 0)
            {
               _loc14_ = -(param4 - _loc11_ / 2);
            }
            _loc15_ = new Rectangle(param3 - _loc10_ / 2 + _loc13_,param4 - _loc11_ / 2 + _loc14_,param3 + _loc10_ / 2 + _loc13_,param4 + _loc11_ / 2 + _loc14_);
            _loc16_ = new Point(0,0);
            _loc12_.copyChannel(this.frontBmp,_loc15_,_loc16_,BitmapDataChannel.ALPHA,BitmapDataChannel.GREEN);
            this.frontBmp.draw(_loc9_,this.m,param7 == "normal" ? World.w.loc.cTransform : null,param7,null,true);
            _loc15_ = new Rectangle(0,0,_loc10_,_loc11_);
            _loc16_ = new Point(param3 - _loc10_ / 2 + _loc13_,param4 - _loc11_ / 2 + _loc14_);
            this.frontBmp.copyChannel(_loc12_,_loc15_,_loc16_,BitmapDataChannel.GREEN,BitmapDataChannel.ALPHA);
         }
      }
      
      public function gwall(param1:int, param2:int) : *
      {
         var _loc3_:Matrix = new Matrix();
         _loc3_.tx = param1 * Tile.tileX;
         _loc3_.ty = param2 * Tile.tileY;
         var _loc4_:MovieClip = new tileGwall();
         this.frontBmp.draw(_loc4_,_loc3_);
      }
      
      public function paint(param1:int, param2:int, param3:int, param4:int, param5:Boolean = false) : *
      {
         var _loc6_:MovieClip = null;
         var _loc11_:int = 0;
         var _loc12_:int = 0;
         var _loc13_:int = 0;
         var _loc14_:int = 0;
         if(param5)
         {
            _loc6_ = this.pa;
         }
         else
         {
            _loc6_ = this.pb;
         }
         var _loc7_:Number = Math.sqrt((param3 - param1) * (param3 - param1) + (param4 - param2) * (param4 - param2));
         var _loc8_:int = Math.ceil(_loc7_ / 3);
         var _loc9_:Number = (param3 - param1) / _loc8_;
         var _loc10_:Number = (param4 - param2) / _loc8_;
         if(param1 < param3)
         {
            _loc11_ = param1 - 25;
            _loc12_ = param3 + 25;
         }
         else
         {
            _loc11_ = param3 - 25;
            _loc12_ = param1 + 25;
         }
         if(param2 < param4)
         {
            _loc13_ = param2 - 25;
            _loc14_ = param4 + 25;
         }
         else
         {
            _loc13_ = param4 - 25;
            _loc14_ = param2 + 25;
         }
         this.brPoint.x = 0;
         this.brPoint.y = 0;
         this.brRect.left = _loc11_;
         this.brRect.right = _loc12_;
         this.brRect.top = _loc13_;
         this.brRect.bottom = _loc14_;
         this.brData.copyChannel(this.backBmp,this.brRect,this.brPoint,BitmapDataChannel.ALPHA,BitmapDataChannel.GREEN);
         var _loc15_:* = 1;
         while(_loc15_ <= _loc8_)
         {
            this.pm.tx = param1 + _loc9_ * _loc15_;
            this.pm.ty = param2 + _loc10_ * _loc15_;
            this.backBmp.draw(_loc6_,this.pm,this.brTrans,"normal",null,false);
            _loc15_++;
         }
         this.brPoint.x = _loc11_;
         this.brPoint.y = _loc13_;
         this.brRect.left = 0;
         this.brRect.right = _loc12_ - _loc11_;
         this.brRect.top = 0;
         this.brRect.bottom = _loc14_ - _loc13_;
         this.backBmp.copyChannel(this.brData,this.brRect,this.brPoint,BitmapDataChannel.GREEN,BitmapDataChannel.ALPHA);
      }
      
      public function specEffect(param1:Number = 0) : *
      {
         if(param1 == 0)
         {
            this.visual.filters = [];
            this.visFon.filters = [];
         }
         else if(param1 == 1)
         {
            this.visual.filters = [new ColorMatrixFilter([2,-0.9,-0.1,0,0,-0.4,1.5,-0.1,0,0,-0.4,-0.9,2,0,0,0,0,0,1,0])];
         }
         else if(param1 == 2)
         {
            this.visual.filters = [new ColorMatrixFilter([-0.574,1.43,0.144,0,0,0.426,0.43,0.144,0,0,0.426,1.43,-0.856,0,0,0,0,0,1,0])];
         }
         else if(param1 == 3)
         {
            this.visual.filters = [new ColorMatrixFilter([0,1,0,0,0,1,0,0,0,0,0,0,-0.2,0,100,0,0,0,1,0])];
         }
         else if(param1 == 4)
         {
            this.visual.filters = [new ColorMatrixFilter([0,-0.5,-0.5,0,255,-0.5,0,-0.5,0,255,-0.5,-0.5,0,0,255,0,0,0,1,0])];
         }
         else if(param1 == 5)
         {
            this.visual.filters = [new ColorMatrixFilter([3.4,6.7,0.9,0,-635,3.4,6.75,0.9,0,-635,3.4,6.7,0.9,0,-635,0,0,0,1,0])];
         }
         else if(param1 == 6)
         {
            this.visual.filters = [new ColorMatrixFilter([0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0.33,0.33,0.33,0,0,0,0,0,1,0])];
         }
         else if(param1 > 100)
         {
            this.visual.filters = [new BlurFilter(param1 - 100,param1 - 100)];
            this.visFon.filters = [new BlurFilter(param1 - 100,param1 - 100)];
         }
      }
   }
}

