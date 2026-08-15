package fe.serv
{
   import fe.*;
   import fe.unit.Invent;
   
   public class Item
   {
      
      public static const L_ITEM:* = "item";
      
      public static const L_ARMOR:* = "armor";
      
      public static const L_WEAPON:* = "weapon";
      
      public static const L_UNIQ:* = "uniq";
      
      public static const L_SPELL:* = "spell";
      
      public static const L_AMMO:* = "a";
      
      public static const L_EXPL:* = "e";
      
      public static const L_MED:* = "med";
      
      public static const L_BOOK:* = "book";
      
      public static const L_HIM:* = "him";
      
      public static const L_POT:* = "pot";
      
      public static const L_FOOD:* = "food";
      
      public static const L_SCHEME:* = "scheme";
      
      public static const L_PAINT:* = "paint";
      
      public static const L_COMPA:* = "compa";
      
      public static const L_COMPW:* = "compw";
      
      public static const L_COMPE:* = "compe";
      
      public static const L_COMPM:* = "compm";
      
      public static const L_COMPP:* = "compp";
      
      public static const L_SPEC:* = "spec";
      
      public static const L_INSTR:* = "instr";
      
      public static const L_STUFF:* = "stuff";
      
      public static const L_ART:* = "art";
      
      public static const L_IMPL:* = "impl";
      
      public static const L_KEY:* = "key";
      
      public static var itemTip:Array = ["weapon","spell","a","e","med","book","him","scheme","compa","compw","compe","compm","compp","paint","art","impl","key"];
      
      public var tip:String;
      
      public var wtip:String = "";
      
      public var base:String = "";
      
      public var id:String;
      
      public var nazv:String;
      
      public var mess:String;
      
      public var fc:int = -1;
      
      public var invis:Boolean = false;
      
      public var xml:XML;
      
      public var kol:int = 0;
      
      public var vault:int = 0;
      
      public var invCat:int = 3;
      
      public var sost:Number = 1;
      
      public var multHP:Number = 1;
      
      public var variant:int = 0;
      
      public var mass:Number = 0;
      
      public var imp:int = 0;
      
      public var cont:Interact;
      
      public var nov:int = 0;
      
      public var dat:Number = 0;
      
      public var bou:int = 0;
      
      public var shpun:int = 0;
      
      public var lvl:int = 0;
      
      public var barter:int = 0;
      
      public var trig:String;
      
      public var price:Number = 0;
      
      public var pmult:Number = 1;
      
      public var noref:Boolean = false;
      
      public var nocheap:Boolean = false;
      
      public var hardinv:Boolean = false;
      
      public function Item(param1:String, param2:String, param3:int = -1, param4:int = 0, param5:XML = null)
      {
         var l:XMLList = null;
         var wid:String = null;
         var ntip:String = param1;
         var nid:String = param2;
         var nkol:int = param3;
         var nvar:int = param4;
         var nxml:XML = param5;
         super();
         this.variant = nvar;
         if(nid != null && nid.charAt(nid.length - 2) == "^")
         {
            this.variant = int(nid.charAt(nid.length - 1));
            this.id = nid.substr(0,nid.length - 2);
         }
         else
         {
            this.id = nid;
         }
         this.tip = ntip;
         this.kol = nkol;
         if(this.tip == "" || this.tip == null)
         {
            this.itemTip();
         }
         if(this.tip == L_UNIQ)
         {
            this.tip = L_WEAPON;
         }
         if(nxml == null)
         {
            if(this.tip == L_ARMOR)
            {
               l = AllData.d.armor.(@id == id);
            }
            else if(this.tip == L_WEAPON)
            {
               l = AllData.d.weapon.(@id == id);
            }
            else
            {
               l = AllData.d.item.(@id == id);
            }
            if(l.length())
            {
               this.xml = l[0];
               this.wtip = this.xml.@tip;
            }
         }
         else
         {
            this.xml = nxml;
            this.wtip = this.xml.@tip;
         }
         if(this.tip == L_ARMOR || this.tip == L_WEAPON)
         {
            this.kol = 1;
            if(Boolean(this.tip == L_ARMOR) && Boolean(this.xml) && this.xml.@tip == "3")
            {
               this.sost = 1;
            }
            else
            {
               if(nkol == 0)
               {
                  this.sost = 0.05 + Math.random() * 0.15;
               }
               if(nkol == 1)
               {
                  this.sost = 0.6 + Math.random() * 0.25;
               }
            }
         }
         if(this.kol < 0 && Boolean(this.xml))
         {
            if(this.xml.@kol.length())
            {
               this.kol = this.xml.@kol;
            }
            else
            {
               this.kol = 1;
            }
         }
         if(this.tip == L_WEAPON || this.tip == L_EXPL)
         {
            if(this.variant == 0)
            {
               this.nazv = Res.txt("w",this.id);
            }
            else if(Res.istxt("w",this.id + "^" + this.variant))
            {
               this.nazv = Res.txt("w",this.id + "^" + this.variant);
            }
            else
            {
               this.nazv = Res.txt("w",this.id) + " - II";
            }
            if(this.tip == L_EXPL)
            {
               this.wtip = "w5";
            }
            else
            {
               this.wtip = "w" + l.@skill;
            }
         }
         else if(this.tip == L_ARMOR)
         {
            this.nazv = Res.txt("a",this.id);
            if(Boolean(this.xml) && Boolean(this.xml.@tip.length()))
            {
               this.wtip = "armor" + this.xml.@tip;
            }
            else
            {
               this.wtip = "armor1";
            }
         }
         else if(Boolean(this.xml) && Boolean(this.xml.@base.length()))
         {
            this.base = this.xml.@base;
            this.nazv = Res.txt("i",this.base);
            if(this.xml.@mod.length())
            {
               this.nazv += " (" + Res.pipText("am_" + this.xml.@mod) + ")";
            }
         }
         else
         {
            this.nazv = Res.txt("i",this.id);
         }
         if(Boolean(this.tip == L_ITEM) && Boolean(this.xml) && Boolean(this.xml.@tip.length()))
         {
            this.tip = this.xml.@tip;
         }
         if(this.tip == L_SCHEME && !Res.istxt("i",this.id))
         {
            wid = this.id.substr(2);
            if(this.xml.@work == "work")
            {
               this.nazv = Res.pipText("scheme1") + " «" + Res.txt("i",wid) + "»";
            }
            else
            {
               this.nazv = Res.pipText("recipe") + " «" + Res.txt("i",wid) + "»";
            }
         }
         if(this.tip == L_AMMO || this.tip == L_EXPL)
         {
            this.invCat = 2;
         }
         if(Boolean(this.xml && this.xml.@us > 0 && this.tip != L_FOOD) && Boolean(this.tip != "eda") && this.tip != L_BOOK)
         {
            this.invCat = 1;
         }
         if(this.tip == L_WEAPON && Boolean(this.xml))
         {
            if(this.xml.@tip != 4)
            {
               this.mass = 1;
            }
            if(Boolean(this.xml.phis.length()) && Boolean(this.xml.phis.@m.length()))
            {
               this.mass = this.xml.phis.@m;
            }
         }
         if(this.xml)
         {
            if(this.xml.@invcat.length())
            {
               this.invCat = this.xml.@invcat;
            }
            if(this.xml.@invis.length())
            {
               this.invis = true;
            }
            if(this.xml.@fc.length())
            {
               this.fc = this.xml.@fc;
            }
            if(this.xml.@mess.length())
            {
               this.mess = this.xml.@mess;
            }
            if(this.xml.@m.length())
            {
               this.mass = this.xml.@m;
            }
         }
      }
      
      public function itemTip() : *
      {
         var l:XMLList = null;
         l = AllData.d.item.(@id == id);
         if(l.length())
         {
            this.xml = l[0];
            if(this.xml.@tip.length())
            {
               this.tip = this.xml.@tip;
            }
            else
            {
               this.tip = L_ITEM;
            }
         }
         else
         {
            l = AllData.d.weapon.(@id == id);
            if(l.length())
            {
               this.xml = l[0];
               this.tip = L_WEAPON;
            }
            else
            {
               l = AllData.d.armor.(@id == id);
               if(l.length())
               {
                  this.xml = l[0];
                  this.tip = L_ARMOR;
               }
            }
         }
      }
      
      public function getPrice() : *
      {
         if(this.xml)
         {
            if(Boolean(this.xml.com.length()) && Boolean(this.xml.com.@price.length()))
            {
               this.price = this.xml.com[0].@price * this.sost * this.multHP * this.pmult;
               if(this.variant > 0)
               {
                  if(this.xml.com[1])
                  {
                     this.price = this.xml.com[1].@price * this.sost * this.multHP * this.pmult;
                  }
                  else
                  {
                     this.price *= 3;
                  }
               }
            }
            else
            {
               this.price = this.xml.@price * this.sost * this.multHP * this.pmult;
            }
         }
      }
      
      public function getMultPrice() : Number
      {
         if(Boolean(this.xml) && Boolean(this.xml.@price > 0) && this.xml.@sell > 0)
         {
            return Number(this.xml.@sell) / Number(this.xml.@price);
         }
         return 0.1;
      }
      
      public function checkAuto(param1:Boolean = false) : Boolean
      {
         var _loc3_:* = undefined;
         var _loc2_:Invent = World.w.invent;
         if(this.tip == L_WEAPON)
         {
            _loc3_ = _loc2_.weapons[this.id];
            if(_loc3_ != null && (World.w.vsWeaponRep || param1))
            {
               if(_loc3_.hp <= _loc3_.maxhp && (_loc3_.respect == 0 || _loc3_.respect == 2 || !World.w.hardInv))
               {
                  return true;
               }
               if(param1 && World.w.hardInv)
               {
                  this.shpun = 2;
               }
               return false;
            }
            if(_loc3_ == null && World.w.vsWeaponNew)
            {
               if(World.w.hardInv)
               {
                  if(this.mass == 0)
                  {
                     return true;
                  }
                  if(this.xml.@tip <= 3)
                  {
                     if(_loc2_.massW <= World.w.pers.maxmW - this.mass)
                     {
                        return true;
                     }
                     if(param1)
                     {
                        World.w.gui.infoText("fullWeap");
                     }
                     return false;
                  }
                  if(this.xml.@tip == 5)
                  {
                     if(_loc2_.massM <= World.w.pers.maxmM - this.mass)
                     {
                        return true;
                     }
                     if(param1)
                     {
                        World.w.gui.infoText("fullMagic");
                     }
                     return false;
                  }
                  return false;
               }
               return true;
            }
            return false;
         }
         if(this.tip == L_SPELL)
         {
            if(_loc2_.massM >= World.w.pers.maxmM)
            {
               World.w.gui.infoText("fullMagic");
            }
            return true;
         }
         if(this.tip == L_ARMOR)
         {
            return true;
         }
         if(this.mass == 0)
         {
            return true;
         }
         if(World.w.hardInv)
         {
            if(_loc2_.mass[this.invCat] + this.mass * this.kol > World.w.pers["maxm" + this.invCat])
            {
               return false;
            }
         }
         if(World.w.vsAmmoAll && this.tip == L_AMMO)
         {
            return true;
         }
         if(Boolean(World.w.vsAmmoTek) && Boolean(this.xml) && this.tip == L_AMMO)
         {
            for each(_loc3_ in _loc2_.weapons)
            {
               if(_loc3_.tip <= 3 && (_loc3_.respect == 0 || _loc3_.respect == 2) && _loc3_.ammoBase != "" && (_loc3_.ammoBase == this.xml.@id || _loc3_.ammoBase == this.xml.@base))
               {
                  return true;
               }
            }
         }
         if(World.w.vsExplAll && this.tip == L_EXPL)
         {
            return true;
         }
         if(World.w.vsMedAll && (this.tip == L_MED || this.tip == L_POT))
         {
            return true;
         }
         if(World.w.vsHimAll && this.tip == L_HIM)
         {
            return true;
         }
         if(World.w.vsEqipAll && this.tip == "equip")
         {
            return true;
         }
         if(World.w.vsStuffAll && this.invCat == 3)
         {
            return true;
         }
         if(World.w.vsVal && this.tip == "valuables")
         {
            return true;
         }
         if(World.w.vsBook && (this.tip == "book" || this.tip == "sphera"))
         {
            return true;
         }
         if(World.w.vsFood && (this.tip == "food" || this.tip == "eda"))
         {
            return true;
         }
         if(World.w.vsComp && (this.tip == "stuff" || this.tip == "compa" || this.tip == "compw" || this.tip == "compe" || this.tip == "compm"))
         {
            return true;
         }
         if(World.w.vsIngr && this.tip == "compp")
         {
            return true;
         }
         return false;
      }
      
      public function save() : Object
      {
         return {
            "tip":this.tip,
            "id":this.id,
            "kol":this.kol,
            "sost":this.sost,
            "barter":this.barter,
            "lvl":this.lvl,
            "trig":this.trig,
            "variant":this.variant
         };
      }
      
      public function trade() : *
      {
         this.kol -= this.bou;
         this.bou = 0;
      }
   }
}

