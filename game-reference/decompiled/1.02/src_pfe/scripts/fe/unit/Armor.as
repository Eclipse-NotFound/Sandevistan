package fe.unit
{
   import fe.*;
   
   public class Armor
   {
      
      public var id:String;
      
      public var nazv:String;
      
      public var owner:Unit;
      
      public var tip:int = 1;
      
      public var clo:int = 0;
      
      public var active:Boolean = false;
      
      public var xml:XML;
      
      public var lvl:int = 0;
      
      public var maxlvl:int = 0;
      
      public var armor:Number = 0;
      
      public var marmor:Number = 0;
      
      public var armor_qual:Number = 0;
      
      public var resist:Array;
      
      public var dexter:Number = 0;
      
      public var sneak:Number = 0;
      
      public var radVul:Number = 1;
      
      public var h2oMult:Number = 1;
      
      public var meleeMult:Number = 1;
      
      public var gunsMult:Number = 1;
      
      public var magicMult:Number = 1;
      
      public var crit:Number = 0;
      
      public var tre:Number = 0;
      
      public var ableFly:int = 0;
      
      public var showObsInd:Boolean = false;
      
      public var abil:String;
      
      public var mana:Number = 0;
      
      public var maxmana:Number = 0;
      
      public var dmana_act:Number = 0;
      
      public var dmana_use:Number = 0;
      
      public var dmana_res:Number = 0;
      
      public var abilActive:Boolean = false;
      
      public var und:Boolean = false;
      
      public var norep:Boolean = false;
      
      public var hp:int = 100;
      
      public var maxhp:int = 100;
      
      public var idComp:String;
      
      public var kolComp:int = 1;
      
      public var price:int = 0;
      
      public var sort:int = 0;
      
      public var hideMane:int = 0;
      
      public function Armor(param1:String, param2:int = 0)
      {
         var i:*;
         var nid:String = param1;
         var nlvl:int = param2;
         super();
         this.id = nid;
         this.lvl = nlvl;
         this.xml = AllData.d.armor.(@id == id)[0];
         if(this.xml.@tip.length())
         {
            this.tip = this.xml.@tip;
         }
         if(this.xml.@clo.length())
         {
            this.clo = this.xml.@clo;
         }
         if(this.xml.@hp.length())
         {
            this.hp = this.maxhp = this.xml.@hp;
         }
         if(this.xml.@lvl.length())
         {
            this.maxlvl = this.xml.@lvl;
         }
         if(this.xml.@und.length())
         {
            this.und = true;
         }
         if(this.xml.@norep.length())
         {
            this.norep = true;
         }
         if(this.xml.@h2o.length())
         {
            this.h2oMult = this.xml.@h2o;
         }
         if(this.xml.@tre.length())
         {
            this.tre = this.xml.@tre;
         }
         if(this.xml.@melee.length())
         {
            this.meleeMult = this.xml.@melee;
         }
         if(this.xml.@guns.length())
         {
            this.gunsMult = this.xml.@guns;
         }
         if(this.xml.@magic.length())
         {
            this.magicMult = this.xml.@magic;
         }
         if(this.xml.@crit.length())
         {
            this.crit = this.xml.@crit;
         }
         if(this.xml.@comp.length())
         {
            this.idComp = this.xml.@comp;
         }
         else
         {
            this.idComp = this.id + "_comp";
         }
         if(this.xml.@kolcomp.length())
         {
            this.kolComp = this.xml.@kolcomp;
         }
         this.price = this.xml.@price;
         if(this.xml.@sort.length())
         {
            this.sort = this.xml.@sort;
         }
         if(this.xml.@abil.length())
         {
            this.abil = this.xml.@abil;
         }
         if(this.xml.@fly.length())
         {
            this.ableFly = 1;
         }
         if(this.xml.@hide.length())
         {
            this.hideMane = this.xml.@hide;
         }
         this.resist = new Array();
         i = 0;
         while(i < Unit.kolVulners)
         {
            this.resist[i] = 0;
            i++;
         }
         if(this.tip == 1)
         {
            this.resist[Unit.D_PINK] = -0.5;
         }
         if(this.lvl >= 0)
         {
            this.getXmlParam(this.xml.upd[this.lvl]);
         }
         else
         {
            this.getXmlParam(this.xml.upd[0]);
         }
      }
      
      public function getXmlParam(param1:XML) : *
      {
         if(param1.@armor.length())
         {
            this.armor = param1.@armor;
         }
         if(param1.@marmor.length())
         {
            this.marmor = param1.@marmor;
         }
         if(param1.@qual.length())
         {
            this.armor_qual = param1.@qual;
         }
         if(param1.@bul.length())
         {
            this.resist[Unit.D_BUL] = param1.@bul;
         }
         if(param1.@phis.length())
         {
            this.resist[Unit.D_PHIS] = param1.@phis;
         }
         if(param1.@blade.length())
         {
            this.resist[Unit.D_BLADE] = param1.@blade;
         }
         if(param1.@expl.length())
         {
            this.resist[Unit.D_EXPL] = param1.@expl;
         }
         if(param1.@fang.length())
         {
            this.resist[Unit.D_FANG] = param1.@fang;
         }
         if(param1.@fire.length())
         {
            this.resist[Unit.D_FIRE] = param1.@fire;
         }
         if(param1.@cryo.length())
         {
            this.resist[Unit.D_CRIO] = param1.@cryo;
         }
         if(param1.@laser.length())
         {
            this.resist[Unit.D_LASER] = param1.@laser;
         }
         if(param1.@plasma.length())
         {
            this.resist[Unit.D_PLASMA] = param1.@plasma;
         }
         if(param1.@spark.length())
         {
            this.resist[Unit.D_SPARK] = param1.@spark;
         }
         if(param1.@acid.length())
         {
            this.resist[Unit.D_ACID] = param1.@acid;
         }
         if(param1.@necro.length())
         {
            this.resist[Unit.D_NECRO] = param1.@necro;
         }
         if(param1.@venom.length())
         {
            this.resist[Unit.D_VENOM] = param1.@venom;
         }
         if(param1.@radx.length())
         {
            this.radVul = 1 - Number(param1.@radx);
         }
         if(param1.@dexter.length())
         {
            this.dexter = param1.@dexter;
         }
         if(param1.@sneak.length())
         {
            this.sneak = param1.@sneak;
            this.showObsInd = true;
         }
         if(param1.@mana.length())
         {
            this.maxmana = param1.@mana;
         }
         if(param1.@act.length())
         {
            this.dmana_act = param1.@act;
         }
         if(param1.@used.length())
         {
            this.dmana_use = param1.@used;
         }
         if(param1.@res.length())
         {
            this.dmana_res = param1.@res;
         }
         this.nazv = Res.txt("a",this.id);
         if(this.lvl > 0)
         {
            this.nazv += " - " + this.lvl;
         }
      }
      
      public function setArmor() : *
      {
         var _loc1_:Number = NaN;
         if(Boolean(this.owner) && this.active)
         {
            _loc1_ = 1;
            if(this.hp < this.maxhp / 2)
            {
               _loc1_ = 0.5 + this.hp / this.maxhp;
            }
            this.owner.armor = this.armor * _loc1_;
            this.owner.marmor = this.marmor * _loc1_;
            this.owner.armor_qual = this.armor_qual * _loc1_;
         }
      }
      
      public function damage(param1:Number, param2:int) : *
      {
         if(this.und)
         {
            return;
         }
         if(param2 != Unit.D_VENOM && param2 != Unit.D_EMP && param2 != Unit.D_POISON && param2 != Unit.D_BLEED && param2 != Unit.D_INSIDE)
         {
            param1 *= 1 - this.resist[param2];
            if(param2 == Unit.D_ACID)
            {
               param1 *= 2;
            }
            if(param2 == Unit.D_PINK)
            {
               param1 *= 3;
            }
            this.hp -= param1;
            if(this.hp < 0)
            {
               this.hp = 0;
               World.w.gg.changeArmor("off");
            }
         }
         this.setArmor();
      }
      
      public function repair(param1:int) : *
      {
         this.hp += param1;
         if(this.hp > this.maxhp)
         {
            this.hp = this.maxhp;
         }
         this.setArmor();
      }
      
      public function needComp() : int
      {
         if(this.xml.upd[this.lvl + 1])
         {
            return this.xml.upd[this.lvl + 1].@kol;
         }
         return 0;
      }
      
      public function upgrade() : *
      {
         if(this.lvl >= this.maxlvl)
         {
            return;
         }
         ++this.lvl;
         var _loc1_:* = 0;
         while(_loc1_ < Unit.kolVulners)
         {
            this.resist[_loc1_] = 0;
            _loc1_++;
         }
         this.getXmlParam(this.xml.upd[this.lvl]);
      }
   }
}

