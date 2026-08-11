package fe.serv
{
   import fe.*;
   
   public class Vendor
   {
      
      public var id:String;
      
      public var buys:Array;
      
      public var buys2:Array;
      
      public var kolBou:Number = 0;
      
      public var kolSell:Number = 0;
      
      public var money:int = 0;
      
      public var xml:XML;
      
      public var multPrice:Number = 1;
      
      public function Vendor(param1:int = 0, param2:XML = null, param3:Array = null, param4:String = "vendor")
      {
         var _loc5_:Item = null;
         var _loc6_:* = undefined;
         var _loc7_:Object = null;
         var _loc8_:XML = null;
         var _loc9_:String = null;
         super();
         this.buys = new Array();
         this.buys2 = new Array();
         this.xml = param2;
         if(param2)
         {
            if(param2.@id == "random")
            {
               if(param3)
               {
                  for each(_loc7_ in param3)
                  {
                     _loc5_ = new Item(null,_loc7_.id,_loc7_.kol,_loc7_.variant);
                     this.buys.push(_loc5_);
                  }
               }
               else
               {
                  this.setRndBuys(100,"random");
               }
            }
            else
            {
               for each(_loc8_ in this.xml.buy)
               {
                  _loc5_ = new Item(null,_loc8_.@id,_loc8_.@n);
                  if(_loc8_.@barter.length())
                  {
                     _loc5_.barter = _loc8_.@barter;
                  }
                  if(_loc8_.@lvl.length())
                  {
                     _loc5_.lvl = _loc8_.@lvl;
                  }
                  if(_loc8_.@trigger.length())
                  {
                     _loc5_.trig = _loc8_.@trigger;
                  }
                  if(_loc8_.@noref.length())
                  {
                     _loc5_.noref = true;
                  }
                  if(_loc8_.@nocheap.length())
                  {
                     _loc5_.nocheap = true;
                  }
                  if(_loc8_.@hardinv.length())
                  {
                     _loc5_.hardinv = true;
                  }
                  if(_loc8_.@pmult.length())
                  {
                     _loc5_.pmult = _loc8_.@pmult;
                  }
                  if(param3)
                  {
                     for each(_loc7_ in param3)
                     {
                        if(_loc7_.variant == _loc5_.variant && _loc7_.id == _loc5_.id)
                        {
                           _loc5_.kol = _loc7_.kol;
                           _loc5_.sost = _loc7_.sost;
                           break;
                        }
                     }
                  }
                  this.buys.push(_loc5_);
               }
            }
         }
         else
         {
            this.setRndBuys(param1,param4);
         }
         if(this.xml)
         {
            this.id = this.xml.@id;
         }
         for(_loc6_ in this.buys)
         {
            _loc9_ = this.buys[_loc6_].id;
            if(this.buys[_loc6_].variant > 0)
            {
               _loc9_ += "^" + this.buys[_loc6_].variant;
            }
            this.buys2[_loc9_] = this.buys[_loc6_];
         }
         this.money = Math.round(Math.random() * 450 + 50);
         if(Math.random() < 0.2)
         {
            this.money *= 2;
         }
      }
      
      public function setRndBuys(param1:int = 0, param2:String = "vendor") : *
      {
         var _loc3_:int = 0;
         var _loc5_:Item = null;
         var _loc6_:String = null;
         var _loc8_:String = null;
         var _loc9_:int = 0;
         if(Math.random() < 0.7)
         {
            this.multPrice = Math.floor(Math.random() * 6 + 8) / 10;
         }
         if(param2 == "random")
         {
            _loc3_ = 30;
         }
         else if(param2 == "doctor")
         {
            _loc3_ = 5 + 3 * World.w.pers.barterLvl;
         }
         else
         {
            _loc3_ = 10 + 6 * World.w.pers.barterLvl;
         }
         _loc3_ = Math.round(_loc3_ * (0.5 + Math.random() * 0.7));
         var _loc4_:int = _loc3_ * (0.1 + Math.random() * 0.3);
         var _loc7_:* = 0;
         while(_loc7_ < _loc3_)
         {
            if(_loc7_ < _loc4_ && param2 != "doctor")
            {
               _loc6_ = LootGen.getRandom(Item.L_WEAPON,1 + param1 / 4);
               _loc5_ = new Item(Item.L_WEAPON,_loc6_,1);
               if(this.buys2[_loc6_] == null)
               {
                  if(Math.random() < 0.2)
                  {
                     _loc5_.barter = Math.floor(Math.random() * param1 / 4 + 1);
                     if(_loc5_.barter > 5)
                     {
                        _loc5_.barter = 5;
                     }
                  }
                  this.buys.push(_loc5_);
                  this.buys2[_loc6_] = _loc5_;
               }
            }
            else
            {
               _loc9_ = Math.floor(Math.random() * 110);
               if(param2 == "doctor")
               {
                  if(_loc9_ < 70)
                  {
                     _loc8_ = Item.L_MED;
                  }
                  else
                  {
                     _loc8_ = Item.L_HIM;
                  }
               }
               else if(_loc9_ < 5)
               {
                  _loc8_ = Item.L_UNIQ;
               }
               else if(_loc9_ < 10)
               {
                  _loc8_ = Item.L_SCHEME;
               }
               else if(_loc9_ < 25)
               {
                  _loc8_ = Item.L_MED;
               }
               else if(_loc9_ < 35)
               {
                  _loc8_ = Item.L_HIM;
               }
               else if(_loc9_ < 55)
               {
                  _loc8_ = Item.L_EXPL;
               }
               else if(_loc9_ < 60)
               {
                  _loc8_ = Item.L_COMPA;
               }
               else if(_loc9_ < 65)
               {
                  _loc8_ = Item.L_COMPW;
               }
               else if(_loc9_ < 70)
               {
                  _loc8_ = Item.L_COMPE;
               }
               else if(_loc9_ < 75)
               {
                  _loc8_ = Item.L_COMPM;
               }
               else
               {
                  _loc8_ = Item.L_AMMO;
               }
               _loc6_ = LootGen.getRandom(_loc8_,param1);
               if(_loc6_ != null)
               {
                  _loc5_ = new Item(_loc8_,_loc6_);
                  if(this.buys2[_loc6_] == null)
                  {
                     if(Math.random() < 0.3)
                     {
                        _loc5_.lvl = Math.floor(Math.random() * param1 + 1);
                        if(_loc5_.lvl > 5)
                        {
                           _loc5_.lvl = 5;
                        }
                     }
                     if(_loc8_ == Item.L_AMMO)
                     {
                        _loc5_.kol = Math.round(_loc5_.kol * (3 + Math.random() * 12));
                     }
                     else if(_loc8_ != Item.L_UNIQ && _loc8_ != Item.L_SCHEME)
                     {
                        _loc5_.kol = Math.round(_loc5_.kol * (1 + Math.random() * 4));
                     }
                     this.buys.push(_loc5_);
                     this.buys2[_loc6_] = _loc5_;
                  }
                  else if(_loc8_ != Item.L_UNIQ && _loc8_ != Item.L_SCHEME)
                  {
                     this.buys2[_loc6_].kol += _loc5_.kol;
                  }
               }
            }
            _loc7_++;
         }
      }
      
      public function reset() : *
      {
         var _loc1_:* = undefined;
         this.kolBou = 0;
         for(_loc1_ in this.buys)
         {
            this.buys[_loc1_].bou = 0;
         }
      }
      
      public function refill() : *
      {
         var item:Item = null;
         var i:* = undefined;
         var uid:String = null;
         var buy:* = undefined;
         var lim:* = undefined;
         if(this.xml == null)
         {
            return;
         }
         if(this.id == "random")
         {
            this.buys = new Array();
            this.buys2 = new Array();
            this.setRndBuys(100,"random");
            for(i in this.buys)
            {
               uid = this.buys[i].id;
               if(this.buys[i].variant > 0)
               {
                  uid += "^" + this.buys[i].variant;
               }
               this.buys2[uid] = this.buys[i];
            }
            return;
         }
         for each(item in this.buys)
         {
            if(!(item.noref || item.tip == Item.L_ARMOR || item.tip == Item.L_WEAPON || item.tip == Item.L_SCHEME || item.tip == Item.L_UNIQ || item.tip == Item.L_IMPL))
            {
               buy = this.xml.buy.(@id == item.id);
               if(!(buy.length() == 0 || buy.@n.length() == 0))
               {
                  lim = Math.ceil(buy.@n * World.w.pers.limitBuys);
                  if(item.kol < lim)
                  {
                     item.kol = Math.min(lim,item.kol + Math.ceil(0.25 * lim));
                  }
               }
            }
         }
      }
      
      public function save() : *
      {
         var _loc2_:Item = null;
         if(this.id == null)
         {
            return null;
         }
         var _loc1_:Array = new Array();
         for each(_loc2_ in this.buys)
         {
            _loc1_.push(_loc2_.save());
         }
         return _loc1_;
      }
   }
}

