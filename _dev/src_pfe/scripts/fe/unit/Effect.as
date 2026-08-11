package fe.unit
{
   import fe.*;
   import fe.graph.Emitter;
   import flash.geom.ColorTransform;
   
   public class Effect
   {
      
      public var owner:Unit;
      
      public var id:String;
      
      public var tip:int = 0;
      
      public var forever:Boolean = false;
      
      public var t:int = 1;
      
      public var lvl:int = 1;
      
      public var lvl1:int = 0;
      
      public var lvl2:int = 0;
      
      public var lvl3:int = 0;
      
      public var val:Number;
      
      public var player:Boolean = false;
      
      public var params:Boolean = false;
      
      public var add:Boolean = false;
      
      public var se:Boolean = true;
      
      public var him:int = 0;
      
      public var ad:Boolean = false;
      
      public var post:String;
      
      internal var postBad:Boolean = false;
      
      internal var del:Array;
      
      public var vse:Boolean = false;
      
      public function Effect(param1:String, param2:Unit = null, param3:Number = 0)
      {
         super();
         if(param2 == null)
         {
            this.owner = World.w.gg;
         }
         else
         {
            this.owner = param2;
         }
         this.player = this.owner.player;
         this.id = param1;
         this.val = param3;
         this.getXmlParam();
      }
      
      internal function getXmlParam() : *
      {
         var node:* = undefined;
         var ndel:* = undefined;
         this.t = 1;
         this.post = null;
         this.postBad = false;
         this.del = new Array();
         this.him = 0;
         this.lvl = 1;
         this.forever = false;
         node = AllData.d.eff.(@id == id);
         if(node.length())
         {
            this.tip = node.@tip;
            this.t = node.@t * 30;
            if(World.w.testEff)
            {
               this.t = node.@t * 3;
            }
            if(this.val == 0)
            {
               this.val = node.@val;
            }
            if(node.sk.length())
            {
               this.params = true;
            }
            if(node.@post.length())
            {
               this.post = node.@post;
            }
            if(node.@postbad.length())
            {
               this.post = node.@postbad;
               this.postBad = true;
            }
            if(node.@him.length())
            {
               this.him = node.@him;
            }
            if(node.@lvl1.length())
            {
               this.lvl1 = node.@lvl1;
            }
            if(node.@lvl2.length())
            {
               this.lvl2 = node.@lvl2;
            }
            if(node.@lvl3.length())
            {
               this.lvl3 = node.@lvl3;
            }
            if(node.@add.length())
            {
               this.add = true;
            }
            if(node.del.length())
            {
               for each(ndel in node.del)
               {
                  this.del.push(ndel.@id);
               }
            }
         }
         if(this.t == 0)
         {
            this.t = 30;
            this.forever = true;
         }
      }
      
      public function setEff() : *
      {
         var _loc1_:* = undefined;
         var _loc2_:Effect = null;
         if(this.del.length)
         {
            for each(_loc1_ in this.del)
            {
               for each(_loc2_ in this.owner.effects)
               {
                  if(_loc2_.id == _loc1_)
                  {
                     _loc2_.unsetEff(false,false,false);
                     break;
                  }
               }
            }
         }
         if(this.params)
         {
            if(this.player)
            {
               (this.owner as UnitPlayer).pers.setParameters();
            }
            else
            {
               this.owner.setEffParams();
            }
         }
         if(this.id == "potion_fly" || this.id == "potion_shadow")
         {
            this.owner.newPart("black",15);
         }
         if(this.id == "potion_shadow")
         {
            if(this.player)
            {
               (this.owner as UnitPlayer).uncallPet(true);
               (this.owner as UnitPlayer).changeWeapon("not");
            }
         }
         if(this.id == "potion_rat")
         {
            if(this.player)
            {
               (this.owner as UnitPlayer).ratOn();
            }
         }
         if(this.id == "potion_infra")
         {
            World.w.grafon.warShadow();
         }
         if(this.id == "reanim" && this.player)
         {
            (this.owner as UnitPlayer).noReanim = true;
         }
         if(this.id == "stupor" && this.player)
         {
            (this.owner as UnitPlayer).stam = 0;
         }
         if(this.id == "fetter" && this.player)
         {
            (this.owner as UnitPlayer).fetX = this.owner.X;
            (this.owner as UnitPlayer).fetY = this.owner.Y;
         }
         if(this.id == "stealth" || this.id == "stealth_armor")
         {
            (this.owner as UnitPlayer).f_stealth = true;
            (this.owner as UnitPlayer).setFilters();
         }
         if(this.id == "bloodinv" && this.player)
         {
            (this.owner as UnitPlayer).f_inv = true;
            (this.owner as UnitPlayer).setFilters();
            this.owner.newPart("blood",30);
         }
         if(this.id == "curse")
         {
            World.w.game.triggers["curse"] = 1;
         }
         this.visEff();
      }
      
      public function checkT() : *
      {
         var _loc1_:* = undefined;
         if(this.lvl1 > 0)
         {
            _loc1_ = this.lvl;
            this.lvl = 1;
            if(this.t / 30 > this.lvl1)
            {
               this.lvl = 2;
            }
            if(this.t / 30 > this.lvl2)
            {
               this.lvl = 3;
            }
            if(this.t / 30 > this.lvl3)
            {
               this.lvl = 4;
            }
            if(_loc1_ != this.lvl && this.params)
            {
               if(this.player)
               {
                  (this.owner as UnitPlayer).pers.setParameters();
               }
               else
               {
                  this.owner.setEffParams();
               }
            }
         }
      }
      
      public function visEff() : *
      {
         var _loc1_:ColorTransform = null;
         if(this.id == "potion_shadow" && this.player)
         {
            (this.owner as UnitPlayer).f_shad = true;
            (this.owner as UnitPlayer).setFilters();
         }
         if(this.id == "inhibitor")
         {
            if(this.owner.vis.inh)
            {
               this.owner.vis.inh.visible = true;
               this.owner.vis.inh.gotoAndPlay(1);
            }
         }
         if(this.id == "freezing")
         {
            _loc1_ = new ColorTransform(0.7,0.7,1,1,100,100,130);
            if(this.owner.cTransform)
            {
               _loc1_.concat(this.owner.cTransform);
            }
            this.owner.vis.transform.colorTransform = _loc1_;
         }
      }
      
      public function unsetEff(param1:Boolean = true, param2:Boolean = true, param3:Boolean = true) : *
      {
         var _loc4_:Boolean = false;
         var _loc5_:* = undefined;
         if(this.id == "potion_rat")
         {
            if(!(this.owner as UnitPlayer).ratOff())
            {
               if(this.t < 20)
               {
                  this.t = 29;
               }
               return;
            }
            if((this.owner as UnitPlayer).retPet != "")
            {
               (this.owner as UnitPlayer).callPet((this.owner as UnitPlayer).retPet,true);
            }
         }
         this.vse = true;
         if(this.player && param2 && this.se)
         {
            if(this.tip == 3)
            {
               World.w.gui.infoText("endFoodEffect",Res.txt("e",this.id));
            }
            else
            {
               World.w.gui.infoText("endEffect",Res.txt("e",this.id));
            }
         }
         if(Boolean(this.post) && param1)
         {
            this.id = this.post;
            _loc4_ = this.postBad;
            this.getXmlParam();
            if(_loc4_)
            {
               _loc5_ = World.w.pers.addictions[this.id];
               if(_loc5_ >= World.w.pers.ad1)
               {
                  this.forever = true;
                  this.ad = true;
               }
               if(_loc5_ >= World.w.pers.ad2)
               {
                  this.lvl = 2;
               }
               if(_loc5_ >= World.w.pers.ad3)
               {
                  this.lvl = 3;
               }
            }
            this.vse = false;
         }
         if(this.params && param3)
         {
            if(this.player)
            {
               (this.owner as UnitPlayer).pers.setParameters();
            }
            else
            {
               this.owner.setEffParams();
            }
         }
         if(this.id == "stealth" || this.id == "stealth_armor")
         {
            (this.owner as UnitPlayer).f_stealth = false;
            (this.owner as UnitPlayer).setFilters();
         }
         if(this.id == "potion_fly")
         {
            this.owner.isFly = false;
            this.owner.newPart("black",15);
         }
         if(this.id == "potion_shadow" && this.player)
         {
            (this.owner as UnitPlayer).f_shad = false;
            (this.owner as UnitPlayer).f_stealth = false;
            (this.owner as UnitPlayer).setFilters();
            if((this.owner as UnitPlayer).retPet != "")
            {
               (this.owner as UnitPlayer).callPet((this.owner as UnitPlayer).retPet,true);
            }
         }
         if(this.id == "potion_infra")
         {
            World.w.grafon.warShadow();
         }
         if(this.id == "reanim" && this.player)
         {
            (this.owner as UnitPlayer).noReanim = false;
         }
         if(this.id == "inhibitor")
         {
            if(this.owner.vis.inh)
            {
               this.owner.vis.inh.visible = false;
            }
         }
         if(this.id == "freezing")
         {
            if(this.owner.cTransform)
            {
               this.owner.vis.transform.colorTransform = this.owner.cTransform;
            }
            else
            {
               this.owner.vis.transform.colorTransform = new ColorTransform();
            }
         }
         if(this.id == "sacrifice" && this.player)
         {
            (this.owner as UnitPlayer).noReanim = false;
         }
         if(this.id == "bloodinv" && this.player)
         {
            (this.owner as UnitPlayer).f_inv = false;
            (this.owner as UnitPlayer).setFilters();
         }
      }
      
      public function secEffect() : *
      {
         var _loc1_:Unit = null;
         this.checkT();
         if(this.id == "burning")
         {
            if(this.owner.isPlav)
            {
               this.t = 1;
            }
            else
            {
               this.owner.damage(this.val,Unit.D_FIRE,null,true);
               this.owner.shok = 33;
            }
         }
         if(this.id == "pinkcloud")
         {
            this.owner.damage(this.val,Unit.D_PINK,null,true);
         }
         if(this.id == "blindness" && this.player)
         {
            if(this.owner.sost < 4)
            {
               Emitter.emit("blind",this.owner.loc,this.owner.X - 300 + Math.random() * 600,this.owner.Y - 200 + Math.random() * 400);
            }
         }
         if(this.id == "chemburn")
         {
            this.owner.damage(this.val,Unit.D_ACID,null,true);
         }
         if(this.id == "drunk" && this.lvl > 3)
         {
            this.owner.damage(this.val,Unit.D_POISON,null,true);
            Emitter.emit("poison",this.owner.loc,this.owner.X + this.owner.storona * 20,this.owner.Y - 40);
         }
         if(this.id == "namok")
         {
            if(!this.owner.isPlav && this.owner.sost < 4)
            {
               Emitter.emit("kap",this.owner.loc,this.owner.X,this.owner.Y - this.owner.scY * 0.25,{"md":0.1});
            }
         }
         if(this.id == "hydra" && this.owner.sost == 1)
         {
            this.owner.heal(this.val);
            if(this.owner.player)
            {
               this.owner.heal(this.val / 2,3,false);
               (this.owner as UnitPlayer).pers.heal(this.val,4);
               (this.owner as UnitPlayer).pers.heal(this.val,5);
            }
         }
         if(this.id == "inhibitor")
         {
            for each(_loc1_ in this.owner.loc.units)
            {
               if(this.owner.isMeet(_loc1_) && _loc1_.fraction != this.owner.fraction && _loc1_.rasst2 < this.val * this.val)
               {
                  _loc1_.slow = 40;
               }
            }
         }
         if(this.id == "fetter")
         {
            Emitter.emit("slow",this.owner.loc,(this.owner as UnitPlayer).fetX,(this.owner as UnitPlayer).fetY);
         }
      }
      
      public function stepEffect() : *
      {
         if(this.id == "burning")
         {
            if(this.owner.sost < 4)
            {
               Emitter.emit("flame",this.owner.loc,this.owner.X,this.owner.Y - this.owner.scY / 2);
            }
         }
         if(this.id == "sacrifice" && this.t == 5)
         {
            this.owner.damage(this.owner.maxhp * 0.5,Unit.D_INSIDE);
            this.owner.newPart("blood",50);
         }
      }
      
      public function step() : *
      {
         if(this.t % 30 == 0)
         {
            this.secEffect();
         }
         this.stepEffect();
         --this.t;
         if(this.t <= 0)
         {
            if(this.forever)
            {
               this.t = 30;
            }
            else
            {
               this.unsetEff();
            }
         }
      }
   }
}

