package fe.serv
{
   import fe.*;
   import fe.loc.Location;
   import fe.loc.Loot;
   
   public class LootGen
   {
      
      private static var rndArr:Array;
      
      public static var arr:Array;
      
      private static var loc:Location;
      
      private static var nx:Number;
      
      private static var ny:Number;
      
      private static var is_loot:int = 0;
      
      private static var lootBroken:Boolean = false;
      
      public function LootGen()
      {
         super();
      }
      
      public static function init() : *
      {
         var weap:* = undefined;
         var item:* = undefined;
         var a:Array = null;
         arr = new Array();
         var n:Array = new Array();
         n["weapon"] = 0;
         arr["weapon"] = new Array();
         arr["magic"] = new Array();
         arr["uniq"] = new Array();
         arr["pers"] = new Array();
         for each(weap in AllData.d.weapon.(@tip > 0 && @tip < 4))
         {
            if(weap.com.length() != 0)
            {
               arr["weapon"].push({
                  "id":weap.@id,
                  "st":weap.com.@stage,
                  "chance":weap.com.@chance,
                  "worth":weap.com.@worth,
                  "lvl":weap.@lvl,
                  "r":n["weapon"] = n["weapon"] + Number(weap.com.@chance)
               });
               if(weap.com.@uniq.length())
               {
                  arr["uniq"].push({
                     "id":weap.@id + "^1",
                     "st":weap.com.@stage,
                     "chance":weap.com.@uniq,
                     "worth":weap.com.@worth,
                     "lvl":weap.@lvl,
                     "r":n["uniq"] = n["uniq"] + Number(weap.com.@uniq)
                  });
               }
            }
         }
         for each(weap in AllData.d.weapon.(@tip == 5))
         {
            arr["magic"].push({
               "id":weap.@id,
               "st":0,
               "chance":0,
               "worth":0,
               "lvl":0,
               "r":0
            });
         }
         for each(item in AllData.d.item)
         {
            if(item.@tip.length())
            {
               if(arr[item.@tip] == null)
               {
                  arr[item.@tip] = new Array();
                  n[item.@tip] = 0;
               }
               arr[item.@tip].push({
                  "id":item.@id,
                  "st":item.@stage,
                  "chance":(item.@chance.length() ? item.@chance : 1),
                  "lvl":item.@lvl,
                  "r":n[item.@tip] = n[item.@tip] + Number(item.@chance.length() ? item.@chance : 1)
               });
               if(item.@tip == "art" || item.@tip == "impl" || Boolean(item.sk.length()))
               {
                  arr["pers"].push(item.@id);
               }
            }
            if(item.@tip2.length())
            {
               if(arr[item.@tip2] == null)
               {
                  arr[item.@tip2] = new Array();
                  n[item.@tip2] = 0;
               }
               arr[item.@tip2].push({
                  "id":item.@id,
                  "st":item.@stage,
                  "chance":(item.@chance2.length() ? item.@chance2 : item.@chance),
                  "lvl":item.@lvl,
                  "r":n[item.@tip2] = n[item.@tip2] + Number(item.@chance2.length() ? item.@chance2 : item.@chance)
               });
            }
         }
         a = new Array();
      }
      
      public static function getRandom(param1:String, param2:Number = -100, param3:int = -100) : String
      {
         var _loc4_:Array = null;
         var _loc5_:Array = null;
         var _loc8_:* = undefined;
         var _loc6_:Number = 0;
         _loc4_ = arr[param1];
         if(_loc4_ == null)
         {
            return null;
         }
         var _loc7_:int = 0;
         if(World.w.land)
         {
            _loc7_ = World.w.land.gameStage;
         }
         if(param1 != Item.L_BOOK && (param2 > 0 || param3 > 0 || _loc7_ > 0))
         {
            _loc5_ = new Array();
            for each(_loc8_ in _loc4_)
            {
               if((_loc7_ <= 0 || _loc8_.st == null || _loc8_.st <= _loc7_) && (param2 == -100 || _loc8_.lvl == null || _loc8_.lvl <= param2) && (param3 == -100 || _loc8_.worth == null || param3 == _loc8_.worth))
               {
                  _loc5_.push({
                     "id":_loc8_.id,
                     "r":_loc6_ = _loc6_ + Number(_loc8_.chance)
                  });
               }
            }
         }
         else
         {
            _loc5_ = _loc4_;
         }
         if(_loc5_.length == 0)
         {
            return null;
         }
         if(_loc5_.length == 1)
         {
            return _loc5_[0].id;
         }
         _loc6_ = Math.random() * _loc5_[_loc5_.length - 1].r;
         for each(_loc8_ in _loc5_)
         {
            if(_loc8_.r > _loc6_)
            {
               return _loc8_.id;
            }
         }
         return null;
      }
      
      private static function newLoot(param1:Number, param2:String, param3:String = null, param4:int = -1, param5:int = 0, param6:Interact = null) : Boolean
      {
         var _loc9_:String = null;
         var _loc10_:int = 0;
         var _loc11_:Number = NaN;
         if(param1 < 1 && Math.random() > param1)
         {
            return false;
         }
         var _loc7_:Number = 1;
         if(lootBroken)
         {
            _loc7_ = 0.4;
         }
         if(param2 == Item.L_WEAPON)
         {
            if(int(param3) > 0)
            {
               param3 = getRandom(param2,Math.max(1,loc.weaponLevel + (Math.random() * 2 - 1)),int(param3));
               if(param3 == null)
               {
                  _loc7_ *= 0.5;
               }
            }
            if(param3 == null)
            {
               param3 = getRandom(param2,Math.max(1,loc.weaponLevel + (Math.random() * 2 - 1)));
               if(param3 == null)
               {
                  _loc7_ *= 0.5;
               }
            }
            if(param3 == null)
            {
               param3 = getRandom(param2);
            }
         }
         if(param3 == null || param3 == "")
         {
            if(param2 == Item.L_EXPL || param2 == Item.L_UNIQ)
            {
               param3 = getRandom(param2,Math.max(1,loc.weaponLevel + (Math.random() * 2 - 1)));
            }
            else
            {
               param3 = getRandom(param2,Math.max(1,loc.locDifLevel / 2 + (Math.random() * 2 - 1)));
            }
            if(param3 == null)
            {
               param3 = getRandom(param2);
            }
         }
         if(param3 == null)
         {
            trace("Ошибка при генерации лута тип:",param2);
            return false;
         }
         if(param4 == -1 && param2 == Item.L_UNIQ)
         {
            param4 = 1;
         }
         var _loc8_:Item = new Item(param2,param3,param4);
         if(param2 == "eda")
         {
            _loc8_.tip = "food";
         }
         if(param2 == "co")
         {
            _loc8_.tip = "scheme";
            _loc9_ = param3.substr(2);
            _loc8_.nazv = Res.pipText("recipe") + " «" + Res.txt("i",_loc9_) + "»";
         }
         _loc8_.multHP = _loc7_;
         _loc8_.imp = param5;
         _loc8_.cont = param6;
         if(_loc8_.id == "money")
         {
            _loc8_.kol *= World.w.pers.capsMult * World.w.pers.difCapsMult;
         }
         if(_loc8_.id == "bit")
         {
            _loc8_.kol *= World.w.pers.bitsMult * World.w.pers.difCapsMult;
         }
         if(lootBroken && (_loc8_.id == "money" || _loc8_.id == "bit"))
         {
            _loc8_.kol *= 0.5;
         }
         if(lootBroken && (_loc8_.tip == Item.L_AMMO || _loc8_.tip == Item.L_EXPL) && Math.random() < 0.5)
         {
            return false;
         }
         if(param5 == 0 && Boolean(_loc8_.xml.@limit.length()))
         {
            _loc10_ = World.w.game.getLimit(_loc8_.xml.@limit);
            _loc11_ = World.w.land.lootLimit;
            if(_loc8_.xml.@mlim.length())
            {
               _loc11_ *= _loc8_.xml.@mlim;
            }
            if(Boolean(_loc8_.xml.@maxlim.length()) && _loc10_ >= _loc8_.xml.@maxlim)
            {
               if(!World.w.testLoot)
               {
                  trace("Достигнут максимум:",param3,_loc10_);
               }
               return false;
            }
            if(_loc10_ >= _loc11_)
            {
               if(!World.w.testLoot)
               {
                  trace("Превышен лимит:",param3,_loc10_,_loc11_);
               }
               return false;
            }
            World.w.game.addLimit(_loc8_.xml.@limit,1);
         }
         if(World.w.testLoot)
         {
            World.w.invent.take(_loc8_);
         }
         else
         {
            new Loot(loc,_loc8_,nx,ny,true);
         }
         ++is_loot;
         return true;
      }
      
      public static function lootId(param1:Location, param2:Number, param3:Number, param4:String, param5:int = -1, param6:int = 0, param7:Interact = null, param8:Boolean = false) : *
      {
         if(param1 == null)
         {
            return false;
         }
         lootBroken = param8;
         loc = param1;
         nx = param2;
         ny = param3;
         newLoot(1,"",param4,param5,param6,param7);
      }
      
      public static function lootCont(param1:Location, param2:Number, param3:Number, param4:String, param5:Boolean = false, param6:Number = 0) : Boolean
      {
         var _loc9_:* = undefined;
         var _loc10_:Array = null;
         if(param1 == null)
         {
            return false;
         }
         lootBroken = param5;
         loc = param1;
         nx = param2;
         ny = param3;
         is_loot = 0;
         var _loc7_:Number = Math.min(loc.locDifLevel,20);
         var _loc8_:int = 1;
         if(param4 == "ammo")
         {
            newLoot(0.7,Item.L_AMMO);
            newLoot(0.25,Item.L_AMMO);
            newLoot(0.15,Item.L_AMMO);
            if(World.w.pers.freel)
            {
               newLoot(0.7,Item.L_AMMO);
            }
         }
         else if(param4 == "metal")
         {
            if(!newLoot(0.5,Item.L_ITEM,"money",Math.random() * 30 * (_loc7_ * 0.15 + 1) + 5))
            {
               newLoot(1,Item.L_AMMO);
            }
         }
         else if(param4 == "bomb")
         {
            _loc8_ = 3;
            _loc9_ = 0;
            while(_loc9_ < _loc8_)
            {
               newLoot(1,Item.L_EXPL,"dinamit");
               _loc9_++;
            }
         }
         else if(param4 == "expl")
         {
            _loc8_ = Math.floor(Math.random() * 4 - 1);
            _loc9_ = 0;
            while(_loc9_ <= _loc8_)
            {
               newLoot(1,Item.L_EXPL);
               _loc9_++;
            }
            newLoot(0.5,Item.L_COMPE);
            if(World.w.pers.freel)
            {
               newLoot(0.5,Item.L_EXPL);
            }
         }
         else if(param4 == "bigexpl")
         {
            _loc8_ = Math.floor(Math.random() * 4 + 2);
            _loc9_ = 0;
            while(_loc9_ <= _loc8_)
            {
               newLoot(1,Item.L_EXPL);
               _loc9_++;
            }
            if(World.w.pers.freel)
            {
               newLoot(0.5,Item.L_EXPL);
            }
            newLoot(0.5,Item.L_COMPE);
         }
         else if(param4 == "wbattle")
         {
            if(!newLoot(0.04,Item.L_UNIQ))
            {
               if(Math.random() < Math.min(_loc7_ / 5,0.7))
               {
                  newLoot(1,Item.L_WEAPON,"4",1);
               }
               else
               {
                  newLoot(1,Item.L_WEAPON,"3",1);
               }
            }
            newLoot(0.8,Item.L_AMMO);
            if(World.w.pers.freel)
            {
               newLoot(0.5,Item.L_AMMO);
            }
            newLoot(0.1,Item.L_ITEM,"stealth");
            if(World.w.pers.barahlo)
            {
               newLoot(0.1,Item.L_COMPA,"intel_comp");
            }
         }
         else if(param4 == "case")
         {
            newLoot(0.9,Item.L_ITEM,"money",Math.random() * 20 * (_loc7_ * 0.11 + 1) + 5);
         }
         else if(param4 == "wbig")
         {
            if(!newLoot(0.08,Item.L_UNIQ))
            {
               if(Math.random() < 0.5)
               {
                  newLoot(1,Item.L_WEAPON,"5",1);
               }
               else
               {
                  newLoot(1,Item.L_WEAPON,"4",1);
               }
            }
            newLoot(0.5,Item.L_EXPL,"",Math.floor(Math.random() * 4));
            newLoot(0.5,Item.L_AMMO,"",Math.floor(Math.random() * 4));
            if(World.w.pers.freel)
            {
               newLoot(0.5,Item.L_AMMO);
            }
            if(World.w.pers.barahlo)
            {
               newLoot(0.5,Item.L_COMPA,"intel_comp");
            }
         }
         else if(param4 == "robocell")
         {
            newLoot(1,Item.L_COMPM);
         }
         else if(param4 == "instr")
         {
            newLoot(0.1,Item.L_ITEM,"pin",Math.floor(Math.random() * 5 + 1));
            if(!newLoot(0.35,Item.L_WEAPON,"2",1))
            {
               newLoot(0.5,Item.L_ITEM,"rep");
            }
            newLoot(0.85,Item.L_COMPA);
            newLoot(0.7,Item.L_COMPW);
            newLoot(0.1,Item.L_COMPE);
            newLoot(0.5,Item.L_COMPM);
            newLoot(0.5,Item.L_PAINT);
            if(World.w.pers.barahlo)
            {
               newLoot(0.85,Item.L_COMPA);
               newLoot(0.7,Item.L_COMPW);
               newLoot(0.1,Item.L_COMPE);
               newLoot(0.1,Item.L_COMPE);
               newLoot(0.5,Item.L_COMPA);
            }
         }
         else if(param4 == "instr2")
         {
            newLoot(0.1,Item.L_ITEM,"pin",Math.floor(Math.random() * 5 + 1));
            if(!newLoot(0.35,Item.L_WEAPON,"2",1))
            {
               newLoot(0.5,Item.L_ITEM,"rep");
            }
            newLoot(0.75,Item.L_COMPA);
            newLoot(0.4,Item.L_COMPW);
            newLoot(0.5,Item.L_COMPM);
            newLoot(0.2,Item.L_PAINT);
            if(World.w.pers.barahlo)
            {
               newLoot(0.75,Item.L_COMPA);
               newLoot(0.4,Item.L_COMPW);
               newLoot(0.1,Item.L_COMPE);
               newLoot(0.5,Item.L_COMPA);
            }
         }
         else if(param4 == "trash")
         {
            if(loc.land.act.biom == 0)
            {
               newLoot(0.25,Item.L_FOOD,"radcookie");
            }
            if(Math.random() < 0.25)
            {
               if(Math.random() < 0.6)
               {
                  loc.createUnit("tarakan",nx,ny,true);
               }
               else
               {
                  loc.createUnit("rat",nx,ny,true);
               }
            }
            else
            {
               _loc8_ = Math.floor(Math.random() * 2);
               if(World.w.pers.barahlo)
               {
                  _loc8_ += 2;
               }
               _loc9_ = 0;
               while(_loc9_ <= _loc8_)
               {
                  newLoot(1,Item.L_STUFF);
                  _loc9_++;
               }
               newLoot(0.4,Item.L_ITEM,"money",Math.random() * 10 * (_loc7_ * 0.1 + 1) + 5);
            }
         }
         else if(param4 == "fridge")
         {
            newLoot(0.5,Item.L_FOOD,"sparklecola");
            newLoot(0.5,Item.L_FOOD,"sars");
            newLoot(0.1,Item.L_FOOD,"radcola");
            if(Math.random() < 0.2)
            {
               if(Math.random() < 0.4)
               {
                  loc.createUnit("tarakan",nx,ny,true);
               }
               else if(Math.random() < 0.5)
               {
                  loc.createUnit("rat",nx,ny,true);
               }
               else
               {
                  loc.createUnit("bloat",nx,ny,true);
               }
            }
            else
            {
               _loc8_ = Math.floor(Math.random() * 2);
               _loc9_ = 0;
               while(_loc9_ <= _loc8_)
               {
                  newLoot(1,Item.L_FOOD);
                  _loc9_++;
               }
               newLoot(0.3,Item.L_COMPP,"herbs",Math.floor(Math.random() * 6 + 1));
            }
         }
         else if(param4 == "food")
         {
            if(loc.land.act.biom == 0)
            {
               newLoot(0.25,Item.L_FOOD,"radcookie");
            }
            if(Math.random() < 0.25)
            {
               if(Math.random() < 0.6)
               {
                  loc.createUnit("tarakan",nx,ny,true);
               }
               else
               {
                  loc.createUnit("rat",nx,ny,true);
               }
            }
            else
            {
               newLoot(0.8,Item.L_FOOD);
               newLoot(0.5,Item.L_STUFF);
               newLoot(0.2,Item.L_COMPP,"herbs",Math.floor(Math.random() * 6 + 1));
               newLoot(0.05,"co");
            }
         }
         else if(param4 == "med")
         {
            newLoot(0.05,Item.L_ITEM,"pin",Math.floor(Math.random() * 2 + 1));
            _loc8_ = Math.floor(Math.random() * 3 - 1);
            _loc9_ = 0;
            while(_loc9_ <= _loc8_)
            {
               newLoot(1,Item.L_MED);
               _loc9_++;
            }
            newLoot(0.25,Item.L_HIM);
            newLoot(0.03,Item.L_MED,"firstaid");
            newLoot(0.05,Item.L_POT,"potHP");
            newLoot(0.25,Item.L_ITEM,"gel");
         }
         else if(param4 == "med2")
         {
            newLoot(0.75,Item.L_POT,"potHP");
            _loc8_ = Math.floor(Math.random() * 3);
            _loc9_ = 0;
            while(_loc9_ <= _loc8_)
            {
               newLoot(1,Item.L_MED);
               _loc9_++;
            }
            newLoot(1,Item.L_HIM);
            newLoot(0.5,Item.L_MED,"firstaid");
            newLoot(0.5,Item.L_MED,"doctor");
            newLoot(0.5,Item.L_MED,"surgeon");
            newLoot(0.8,Item.L_ITEM,"gel");
         }
         else if(param4 == "table")
         {
            newLoot(0.1,Item.L_ITEM,"pin",Math.floor(Math.random() * 3 + 1));
            if(!newLoot(0.08,Item.L_BOOK))
            {
               newLoot(0.5,Item.L_ITEM,"money",Math.random() * 50 + 5 + 3 * _loc7_);
            }
            newLoot(0.1,Item.L_FOOD);
            newLoot(0.13,Item.L_WEAPON,"3");
            newLoot(0.3,Item.L_AMMO);
            newLoot(0.1,Item.L_ITEM,"dart");
            newLoot(0.1,Item.L_ITEM,"app");
            newLoot(0.04,Item.L_SCHEME);
            newLoot(0.25,Item.L_FOOD);
            newLoot(0.08,"co");
            newLoot(0.1,Item.L_MED,"potm1");
         }
         else if(param4 == "filecab")
         {
            newLoot(0.1,Item.L_ITEM,"pin",Math.floor(Math.random() * 3 + 1));
            newLoot(0.5,Item.L_ITEM,"money",Math.random() * 20);
            newLoot(0.1,Item.L_ITEM,"app");
            newLoot(0.02,Item.L_SCHEME);
            newLoot(0.08,"co");
         }
         else if(param4 == "cup")
         {
            newLoot(0.06,Item.L_ITEM,"pin",Math.floor(Math.random() * 3 + 1));
            newLoot(0.3,Item.L_ITEM,"money",Math.random() * 20);
            newLoot(0.25,Item.L_COMPA);
            newLoot(0.75,Item.L_STUFF);
            newLoot(0.2,Item.L_COMPA,"kombu_comp");
            newLoot(0.2,Item.L_COMPA,"antirad_comp");
            newLoot(0.2,Item.L_COMPA,"antihim_comp");
         }
         else if(param4 == "bloat")
         {
            loc.createUnit("bloat",nx,ny,true);
         }
         else if(param4 == "book")
         {
            if(!newLoot(0.3,Item.L_BOOK))
            {
               newLoot(1,Item.L_ITEM,"lbook");
            }
            newLoot(0.1,Item.L_ITEM,"gem" + Math.floor(Math.random() * 3 + 1));
            newLoot(0.25,Item.L_SCHEME);
            newLoot(0.3,"co");
            if(param1.itemsTip == "bibl")
            {
               newLoot(0.5,Item.L_ITEM,"book_cm");
            }
         }
         else if(param4 == "term" || param4 == "info")
         {
            if(param1.land.act.id == "minst")
            {
               newLoot(1,Item.L_ITEM,"datast");
            }
            else if(!newLoot(0.25,Item.L_ITEM,"disc"))
            {
               newLoot(1,Item.L_ITEM,"data");
            }
            newLoot(0.5,Item.L_COMPM);
         }
         else if(param4 == "cryo")
         {
            _loc8_ = Math.floor(Math.random() * 3);
            _loc9_ = 0;
            while(_loc9_ <= _loc8_)
            {
               newLoot(1,Item.L_ITEM,"pcryo");
               _loc9_++;
            }
            newLoot(0.5,Item.L_ITEM,"gel");
         }
         else if(param4 == "chest")
         {
            newLoot(0.1,Item.L_ITEM,"pin",Math.floor(Math.random() * 5 + 1));
            newLoot(0.2,Item.L_WEAPON,"3",2);
            newLoot(0.2,Item.L_ITEM,"bit",Math.random() * 50 + 7 * _loc7_ + 2);
            newLoot(0.3,Item.L_ITEM,"gem" + Math.floor(Math.random() * 3 + 1));
            newLoot(0.25,Item.L_COMPA);
            newLoot(0.03,Item.L_BOOK);
            newLoot(0.5,Item.L_AMMO);
            newLoot(0.03,Item.L_SCHEME);
            if(is_loot > 5)
            {
               replic("full");
            }
            if(is_loot < 2)
            {
               replic("empty");
            }
         }
         else if(param4 == "safe")
         {
            if(World.w.land.rnd && param1.prob == null && Math.random() < 0.05)
            {
               _loc9_ = 0;
               while(_loc9_ < 4)
               {
                  loc.createUnit("bloat",nx,ny,true);
                  _loc9_++;
               }
            }
            else
            {
               newLoot(param6 / 100,Item.L_UNIQ);
               newLoot(0.1 + param6 / 100,Item.L_ITEM,"sphera");
               newLoot(0.2 + param6 / 200,Item.L_ITEM,"stealth");
               newLoot(0.25 + param6 / 100,Item.L_ITEM,"gem" + Math.floor(Math.random() * 3 + 1));
               newLoot(0.2,Item.L_MED);
               newLoot(0.25,Item.L_ITEM,"retr");
               newLoot(0.1,Item.L_ITEM,"runa");
               newLoot(0.1,Item.L_ITEM,"reboot");
               newLoot(0.2 + param6 / 100,Item.L_BOOK);
               newLoot(0.1 + param6 / 100,Item.L_COMPP);
               newLoot(1,Item.L_ITEM,"bit",Math.random() * (param6 + 10) * 8 + 2 + 4 * _loc7_);
               newLoot(0.1 + param6 / 300,Item.L_SCHEME);
               newLoot(0.25,Item.L_POT,"potMP");
               newLoot(0.1,Item.L_POT,"potHP");
               if(!newLoot(0.4,Item.L_MED,"potm2"))
               {
                  newLoot(0.3,Item.L_MED,"potm3");
               }
               if(is_loot == 0)
               {
                  newLoot(1,Item.L_ITEM,"gem" + Math.floor(Math.random() * 3 + 1));
               }
               if(is_loot > 6)
               {
                  replic("full");
               }
               if(is_loot < 2)
               {
                  replic("empty");
               }
            }
         }
         else if(param4 == "specweap")
         {
            _loc8_ = Math.floor(Math.random() * 4);
            _loc10_ = new Array();
            if(World.w.invent.weapons["lsword"] == null || World.w.invent.weapons["lsword"].variant == 0)
            {
               _loc10_.push("lsword^1");
            }
            if(World.w.invent.weapons["antidrak"] == null || World.w.invent.weapons["antidrak"].variant == 0)
            {
               _loc10_.push("antidrak^1");
            }
            if(World.w.invent.weapons["quick"] == null || World.w.invent.weapons["quick"].variant == 0)
            {
               _loc10_.push("quick^1");
            }
            if(World.w.invent.weapons["mlau"] == null || World.w.invent.weapons["mlau"].variant == 0)
            {
               _loc10_.push("mlau^1");
            }
            if(_loc10_.length)
            {
               newLoot(1,Item.L_WEAPON,_loc10_[Math.floor(Math.random() * _loc10_.length)]);
            }
            else
            {
               newLoot(1,Item.L_UNIQ);
            }
         }
         else if(param4 == "specalc")
         {
            newLoot(1,Item.L_SPEC,"alc7");
            newLoot(1,Item.L_ITEM,"gem" + Math.floor(Math.random() * 3 + 1));
         }
         else if(param4 == "speclp")
         {
            newLoot(1,Item.L_SPEC,"lp_item");
            newLoot(1,Item.L_ITEM,"gem" + Math.floor(Math.random() * 3 + 1));
         }
         return is_loot > 0;
      }
      
      public static function lootDrop(param1:Location, param2:Number, param3:Number, param4:String, param5:int = 0) : Boolean
      {
         if(param1 == null)
         {
            return false;
         }
         lootBroken = false;
         loc = param1;
         nx = param2;
         ny = param3;
         is_loot = 0;
         if(param4 == "scorp")
         {
            newLoot(1,Item.L_COMPA,"chitin_comp");
            newLoot(0.25,Item.L_COMPP,"gland");
            newLoot(0.1,Item.L_FOOD,"meat");
         }
         else if(param4 == "slime")
         {
            newLoot(0.75,Item.L_ITEM,"acidslime");
         }
         else if(param4 == "pinkslime")
         {
            newLoot(0.75,Item.L_ITEM,"pinkslime");
         }
         else if(param4 == "raider")
         {
            newLoot(0.25,"eda");
            newLoot(0.25,Item.L_AMMO);
            newLoot(0.12,Item.L_EXPL);
         }
         else if(param4 == "alicorn1" || param4 == "alicorn2" || param4 == "alicorn3")
         {
            newLoot(1,Item.L_COMPP,"mdust");
            newLoot(0.1,Item.L_POT,"potMP");
            if(!newLoot(0.3,Item.L_MED,"potm1"))
            {
               newLoot(0.2,Item.L_MED,"potm2");
            }
         }
         else if(param4 == "ranger1" || param4 == "ranger2" || param4 == "ranger3")
         {
            newLoot(1,Item.L_ITEM,"frag",Math.floor(Math.random() * 3 + 1));
            newLoot(0.5,Item.L_ITEM,"scrap",Math.floor(Math.random() * 3 + 1));
            newLoot(1,Item.L_COMPA,"power_comp");
            newLoot(0.25,Item.L_AMMO);
         }
         else if(param4 == "encl2" || param4 == "encl3" || param4 == "encl4")
         {
            newLoot(0.5,Item.L_ITEM,"frag",Math.floor(Math.random() * 3 + 1));
            if(!newLoot(0.3,Item.L_AMMO,"batt"))
            {
               newLoot(0.5,Item.L_AMMO,"crystal");
            }
            newLoot(0.3,Item.L_COMPA,"power_comp");
         }
         else if(param4 == "hellhound1")
         {
            if(param5 > 0)
            {
               newLoot(1,Item.L_COMPW,"kogt");
            }
         }
         else if(param4 == "zombie")
         {
            newLoot(0.35,Item.L_COMPP,"ghoulblood");
            newLoot(0.15,Item.L_COMPP,"radslime");
            newLoot(0.5,Item.L_COMPA,"skin_comp");
         }
         else if(param4 == "zombie4")
         {
            newLoot(0.8,Item.L_COMPP,"ghoulblood");
            newLoot(1,Item.L_COMPP,"radslime");
         }
         else if(param4 == "zombie5")
         {
            newLoot(1,Item.L_COMPP,"ghoulblood");
            newLoot(0.3,Item.L_COMPP,"metal_comp");
         }
         else if(param4 == "zombie6")
         {
            newLoot(1,Item.L_COMPP,"ghoulblood");
            newLoot(0.3,Item.L_COMPA,"battle_comp");
            newLoot(0.8,Item.L_COMPP,"acidslime");
         }
         else if(param4 == "zombie7")
         {
            newLoot(0.6,Item.L_COMPP,"ghoulblood");
            newLoot(0.2,Item.L_COMPP,"pinkslime");
            if(param5 > 0)
            {
               newLoot(0.6,Item.L_COMPM,"darkfrag");
            }
         }
         else if(param4 == "zombie8")
         {
            newLoot(0.6,Item.L_COMPP,"ghoulblood");
            newLoot(1,Item.L_COMPP,"pinkslime");
            if(param5 > 0)
            {
               newLoot(0.8,Item.L_COMPM,"darkfrag");
            }
         }
         else if(param4 == "zombie9")
         {
            newLoot(0.6,Item.L_COMPP,"ghoulblood");
            newLoot(1,Item.L_COMPP,"whorn");
            if(param5 > 0)
            {
               newLoot(1,Item.L_COMPM,"darkfrag");
            }
         }
         else if(param4 == "bloodwing")
         {
            newLoot(0.2,Item.L_COMPP,"wingmembrane");
            newLoot(0.16,Item.L_COMPP,"vampfang");
            newLoot(0.25,Item.L_FOOD,"meat");
         }
         else if(param4 == "bloodwing2")
         {
            newLoot(0.3,Item.L_COMPP,"wingmembrane");
            newLoot(0.2,Item.L_COMPP,"vampfang");
            newLoot(0.4,Item.L_COMPP,"pinkslime");
         }
         else if(param4 == "bloat0")
         {
            newLoot(0.2,Item.L_COMPP,"bloatwing");
            newLoot(0.1,Item.L_COMPP,"bloateye");
         }
         else if(param4 == "bloat1")
         {
            newLoot(0.2,Item.L_COMPP,"bloatwing");
            newLoot(0.1,Item.L_COMPP,"bloateye");
            newLoot(0.2,Item.L_COMPP,"acidslime");
         }
         else if(param4 == "bloat2")
         {
            newLoot(0.2,Item.L_COMPP,"bloatwing");
            newLoot(0.1,Item.L_COMPP,"bloateye");
            newLoot(0.1,Item.L_COMPP,"gland");
         }
         else if(param4 == "bloat3")
         {
            newLoot(0.3,Item.L_COMPP,"bloatwing");
            newLoot(0.2,Item.L_COMPP,"bloateye");
            newLoot(0.1,Item.L_COMPP,"molefat");
         }
         else if(param4 == "bloat4")
         {
            newLoot(0.4,Item.L_COMPP,"bloatwing");
            newLoot(0.3,Item.L_COMPP,"bloateye");
         }
         else if(param4 == "rat")
         {
            newLoot(0.35,Item.L_COMPP,"ratliver");
            newLoot(0.25,Item.L_COMPP,"rattail");
            newLoot(0.1,Item.L_FOOD,"meat");
         }
         else if(param4 == "molerat")
         {
            newLoot(0.5,Item.L_COMPP,"ratliver");
            newLoot(1,Item.L_COMPP,"molefat");
            newLoot(0.25,Item.L_FOOD,"meat");
         }
         else if(param4 == "fish1")
         {
            newLoot(0.5,Item.L_COMPP,"fishfat");
         }
         else if(param4 == "fish2")
         {
            newLoot(1,Item.L_COMPP,"fishfat");
         }
         else if(param4 == "ant1")
         {
            newLoot(0.15,Item.L_COMPA,"chitin_comp");
            newLoot(0.1,Item.L_FOOD,"meat");
         }
         else if(param4 == "ant2")
         {
            newLoot(0.3,Item.L_COMPA,"chitin_comp");
            newLoot(0.1,Item.L_FOOD,"meat");
         }
         else if(param4 == "ant3")
         {
            newLoot(0.2,Item.L_COMPA,"chitin_comp");
            newLoot(1,Item.L_COMPP,"firegland");
            newLoot(0.1,Item.L_FOOD,"meat");
         }
         else if(param4 == "necros")
         {
            newLoot(0.5,Item.L_ITEM,"dsoul");
         }
         else if(param4 == "ebloat")
         {
            newLoot(1,Item.L_COMPP,"essence");
         }
         else if(param4 == "turret")
         {
            newLoot(0.5,Item.L_ITEM,"scrap");
            newLoot(0.35,Item.L_COMPW,"frag");
            if(!newLoot(0.2,Item.L_AMMO,"batt"))
            {
               newLoot(0.2,Item.L_AMMO,"energ");
            }
         }
         else if(param4 == "turret1")
         {
            newLoot(0.5,Item.L_ITEM,"scrap");
            newLoot(0.5,Item.L_ITEM,"scrap");
            newLoot(0.85,Item.L_COMPW,"frag");
            newLoot(0.52,Item.L_COMPA,"magus_comp");
            if(!newLoot(0.4,Item.L_AMMO,"batt"))
            {
               newLoot(0.8,Item.L_AMMO,"energ");
            }
         }
         else if(param4 == "robobrain")
         {
            newLoot(0.25,Item.L_ITEM,"scrap");
            newLoot(0.15,Item.L_COMPW,"frag");
            newLoot(0.5,Item.L_COMPM);
            newLoot(0.5,Item.L_AMMO,"batt");
            newLoot(0.4,Item.L_COMPA,"metal_comp");
            if(param5 > 0)
            {
               newLoot(1,Item.L_COMPM,"impgen");
            }
         }
         else if(param4 == "protect")
         {
            newLoot(0.3,Item.L_ITEM,"scrap");
            newLoot(0.25,Item.L_COMPW,"frag");
            newLoot(0.6,Item.L_COMPM);
            newLoot(0.9,Item.L_AMMO,"batt");
            newLoot(0.4,Item.L_COMPA,"metal_comp");
            if(param5 > 0)
            {
               newLoot(1,Item.L_COMPM,"uscan");
            }
         }
         else if(param4 == "gutsy")
         {
            newLoot(0.45,Item.L_ITEM,"scrap");
            newLoot(0.5,Item.L_COMPW,"frag");
            newLoot(0.7,Item.L_COMPM);
            newLoot(0.85,Item.L_COMPA,"battle_comp");
            if(!newLoot(0.4,Item.L_AMMO,"fuel"))
            {
               newLoot(0.75,Item.L_AMMO,"energ");
            }
            if(param5 > 0)
            {
               newLoot(1,Item.L_COMPM,"tlaser");
            }
         }
         else if(param4 == "eqd")
         {
            newLoot(0.45,Item.L_ITEM,"scrap");
            newLoot(0.5,Item.L_COMPW,"frag");
            newLoot(0.8,Item.L_COMPM);
            newLoot(0.85,Item.L_COMPA,"magus_comp");
            newLoot(1,Item.L_AMMO,"energ");
            newLoot(0.5,Item.L_ITEM,"data");
            if(param5 > 0)
            {
               newLoot(1,Item.L_COMPM,"pcrystal");
            }
         }
         else if(param4 == "sentinel")
         {
            newLoot(0.85,Item.L_ITEM,"scrap");
            newLoot(0.5,Item.L_COMPW,"frag");
            newLoot(1,Item.L_COMPM);
            if(!newLoot(0.4,Item.L_AMMO,"p5"))
            {
               newLoot(1,Item.L_AMMO,"crystal");
            }
            newLoot(0.85,Item.L_AMMO,"rocket");
            newLoot(0.5,Item.L_COMPW);
            newLoot(1,Item.L_COMPM,"motiv");
         }
         else if(param4 == "vortex" || param4 == "spritebot" || param4 == "roller")
         {
            newLoot(0.2,Item.L_ITEM,"scrap");
         }
         return is_loot > 0;
      }
      
      public static function replic(param1:String) : *
      {
         if(isrnd())
         {
            World.w.gg.replic(param1);
         }
      }
      
      protected static function isrnd(param1:Number = 0.5) : Boolean
      {
         return Math.random() < param1;
      }
   }
}

