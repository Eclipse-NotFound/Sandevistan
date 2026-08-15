package fe
{
   import flash.display.MovieClip;
   import flash.utils.*;
   
   public class Res
   {
      
      public static var d:XML;
      
      public static var e:XML;
      
      public static var clob:Array = new Array();
      
      internal static var rainbowcol:Array = ["red","or","yel","green","blu","purp"];
      
      clob["u"] = "unit";
      clob["w"] = "weapon";
      clob["a"] = "armor";
      clob["o"] = "obj";
      clob["i"] = "item";
      clob["e"] = "eff";
      clob["f"] = "info";
      clob["p"] = "pip";
      clob["k"] = "key";
      clob["g"] = "gui";
      clob["m"] = "map";
      clob[0] = "n";
      clob[1] = "info";
      clob[2] = "mess";
      clob[3] = "help";
      
      public function Res()
      {
         super();
      }
      
      public static function istxt(param1:String, param2:String) : Boolean
      {
         var xl:* = undefined;
         var tip:String = param1;
         var id:String = param2;
         xl = d[clob[tip]].(@id == id);
         if(xl.length() == 0)
         {
            xl = e[clob[tip]].(@id == id);
            if(xl.length() == 0)
            {
               return false;
            }
         }
         return true;
      }
      
      public static function txt(param1:String, param2:String, param3:int = 0, param4:Boolean = false) : String
      {
         var s:String = null;
         var xl:* = undefined;
         var spl:Array = null;
         var tip:String = param1;
         var id:String = param2;
         var razd:int = param3;
         var dop:Boolean = param4;
         if(id == "")
         {
            return "";
         }
         try
         {
            xl = d[clob[tip]].(@id == id);
            s = xl[clob[razd]][0];
         }
         catch(err:*)
         {
         }
         if(s == null)
         {
            try
            {
               xl = e[clob[tip]].(@id == id);
               s = xl[clob[razd]][0];
            }
            catch(err:*)
            {
            }
         }
         if(s == null)
         {
            if(tip == "o")
            {
               return "";
            }
            if(razd == 0)
            {
               return "*" + clob[tip] + "_" + id;
            }
            return "";
         }
         xl = xl[0];
         if(xl.@m == "1")
         {
            spl = s.split("|");
            if(spl.length >= 2)
            {
               s = spl[World.w.matFilter ? 1 : 0];
            }
         }
         if(razd >= 1 || dop)
         {
            if(xl.@s1.length())
            {
               s = addKeys(s,xl);
            }
            try
            {
               if(xl[clob[razd]][0].@s1.length())
               {
                  s = addKeys(s,xl[clob[razd]][0]);
               }
            }
            catch(err:*)
            {
            }
            s = s.replace(/\[br\]/g,"<br>");
            s = s.replace(/\[/g,"<span class=\'yel\'>");
            s = s.replace(/\]/g,"</span>");
         }
         if(dop)
         {
            s = s.replace(/[\b\r\t]/g,"");
         }
         if(tip == "f" || tip == "e" && razd == 2 || Boolean(razd >= 1) && Boolean(xl.@st.length()))
         {
            s = "<span class = \'r" + xl.@st + "\'>" + s + "</span>";
         }
         return s;
      }
      
      public static function guiText(param1:String) : String
      {
         return txt("g",param1);
      }
      
      public static function pipText(param1:String) : String
      {
         return txt("p",param1);
      }
      
      public static function messText(param1:String, param2:int = 0, param3:Boolean = true) : String
      {
         var xml:* = undefined;
         var tip:int = 0;
         var node:* = undefined;
         var s1:String = null;
         var sar:Array = null;
         var i:* = undefined;
         var pers:* = undefined;
         var id:String = param1;
         var v:int = param2;
         var imp:Boolean = param3;
         var s:String = "";
         try
         {
            xml = d.txt.(@id == id);
            if(xml.length() == 0)
            {
               xml = e.txt.(@id == id);
            }
            if(xml.length() == 0)
            {
               return "";
            }
            if(!imp && xml.@imp <= 0)
            {
               return "";
            }
            tip = int(xml.@imp);
            if(v == 1)
            {
               s = xml.info[0];
            }
            else if(xml.n[0].r.length())
            {
               for each(node in xml.n[0].r)
               {
                  s1 = node.toString();
                  if(node.@m.length())
                  {
                     sar = s1.split("|");
                     if(sar)
                     {
                        if(World.w.matFilter && sar.length > 1)
                        {
                           s1 = sar[1];
                        }
                        else
                        {
                           s1 = sar[0];
                        }
                     }
                  }
                  if(node.@s1.length())
                  {
                     i = 1;
                     while(i <= 5)
                     {
                        if(node.attribute("s" + i).length())
                        {
                           s1 = s1.replace("@" + i,"<span class=\'yel\'>" + World.w.ctr.retKey(node.attribute("s" + i)) + "</span>");
                        }
                        i++;
                     }
                  }
                  s1 = s1.replace(/[\b\r\t]/g,"");
                  if(tip == 1)
                  {
                     if(node.@p.length() == 0)
                     {
                        s += "<span class=\'dark\'>" + s1 + "</span>" + "<br>";
                     }
                     else
                     {
                        pers = node.@p;
                        if(pers.substr(0,2) == "lp")
                        {
                           s += "<span class=\'light\'>" + " - " + s1 + "</span>" + "<br>";
                        }
                        else
                        {
                           s += " - " + s1 + "<br>";
                        }
                     }
                  }
                  else
                  {
                     s += s1 + "<br>";
                  }
               }
            }
            else
            {
               s = xml.n[0];
            }
            s = lpName(s);
            s = s.replace(/\[br\]/g,"<br>");
            if(xml.@s1.length())
            {
               i = 1;
               while(i <= 5)
               {
                  if(xml.attribute("s" + i).length())
                  {
                     s = s.replace("@" + i,"<span class=\'r2\'>" + World.w.ctr.retKey(xml.attribute("s" + i)) + "</span>");
                  }
                  i++;
               }
            }
         }
         catch(err:*)
         {
            return "err: " + id;
         }
         return s == null ? "" : s;
      }
      
      public static function advText(param1:int) : String
      {
         var _loc2_:* = d.advice[0];
         var _loc3_:String = _loc2_.a[param1];
         return _loc3_ == null ? "" : _loc3_;
      }
      
      public static function repText(param1:String, param2:String, param3:Boolean = true) : String
      {
         var xl:XMLList = null;
         var n:* = undefined;
         var num:int = 0;
         var s:String = null;
         var n1:* = undefined;
         var n2:* = undefined;
         var ss:String = null;
         var id:String = param1;
         var act:String = param2;
         var msex:Boolean = param3;
         xl = d.replic[0].rep.(@id == id && @act == act);
         if(xl.length() == 0)
         {
            return "";
         }
         xl = xl[0].r;
         n = xl.length();
         if(n == 0)
         {
            return "";
         }
         num = Math.floor(Math.random() * n);
         if(World.w.matFilter && Boolean(xl[num].@m.length()))
         {
            return "";
         }
         s = xl[num];
         n1 = s.indexOf("#");
         if(n1 >= 0)
         {
            n2 = s.lastIndexOf("#");
            ss = s.substring(n1 + 1,n2);
            s = s.substring(0,n1) + ss.split("|")[msex ? 0 : 1] + s.substring(n2 + 1);
         }
         s = s.replace("@lp",World.w.pers.persName);
         return s;
      }
      
      public static function namesArr(param1:String) : Array
      {
         var arr:Array;
         var n:* = undefined;
         var id:String = param1;
         var xl:XMLList = d.names;
         if(xl.length() == 0)
         {
            return null;
         }
         xl = xl[0].name.(@id == id);
         if(xl.length() == 0)
         {
            return null;
         }
         xl = xl[0].r;
         arr = new Array();
         for each(n in xl)
         {
            arr.push(n.toString());
         }
         return arr;
      }
      
      public static function lpName(param1:String) : String
      {
         return param1.replace(/@lp/g,World.w.pers.persName);
      }
      
      public static function getDate(param1:Number) : String
      {
         var _loc2_:Date = new Date(param1);
         return _loc2_.fullYear + "." + (_loc2_.month >= 9 ? "" : "0") + (_loc2_.month + 1) + "." + (_loc2_.date >= 10 ? "" : "0") + _loc2_.date + "  " + _loc2_.hours + ":" + (_loc2_.minutes >= 10 ? "" : "0") + _loc2_.minutes;
      }
      
      public static function numb(param1:Number) : String
      {
         var _loc2_:int = Math.round(param1 * 10);
         if(_loc2_ % 10 == 0)
         {
            return (_loc2_ / 10).toString();
         }
         if(param1 < 0)
         {
            return Math.ceil(_loc2_ / 10) + "." + Math.abs(_loc2_ % 10);
         }
         return Math.floor(_loc2_ / 10) + "." + _loc2_ % 10;
      }
      
      public static function addKeys(param1:String, param2:XML) : String
      {
         if(param1 == null)
         {
            return "";
         }
         var _loc3_:* = 1;
         while(_loc3_ <= 5)
         {
            if(param2.attribute("s" + _loc3_).length())
            {
               param1 = param1.replace("@" + _loc3_,"<span class=\'imp\'>" + World.w.ctr.retKey(param2.attribute("s" + _loc3_)) + "</span>");
            }
            _loc3_++;
         }
         return param1;
      }
      
      public static function formatText(param1:String) : String
      {
         return param1.replace(/\r\n/g,"<br>");
      }
      
      public static function gameTime(param1:Number) : String
      {
         var _loc2_:int = Math.round(param1 / 1000);
         var _loc3_:int = Math.floor(_loc2_ / 3600);
         var _loc4_:int = Math.floor((_loc2_ - _loc3_ * 3600) / 60);
         var _loc5_:int = _loc2_ % 60;
         return _loc3_.toString() + ":" + (_loc4_ < 10 ? "0" : "") + _loc4_ + ":" + (_loc5_ < 10 ? "0" : "") + _loc5_;
      }
      
      public static function rainbow(param1:String) : String
      {
         var _loc2_:* = 0;
         var _loc3_:String = "";
         var _loc4_:* = 0;
         while(_loc4_ < param1.length)
         {
            _loc3_ += "<span class=\'" + rainbowcol[_loc2_] + "\'>" + param1.charAt(_loc4_) + "</span>";
            _loc2_++;
            if(_loc2_ >= 6)
            {
               _loc2_ = 0;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      public static function getVis(param1:String, param2:Class = null) : MovieClip
      {
         var r:Class = null;
         var id:String = param1;
         var def:Class = param2;
         try
         {
            r = getDefinitionByName(id) as Class;
         }
         catch(err:ReferenceError)
         {
            r = def;
         }
         if(r)
         {
            return new r();
         }
         return null;
      }
      
      public static function getClass(param1:String, param2:String = null, param3:Class = null) : Class
      {
         var r:Class = null;
         var id1:String = param1;
         var id2:String = param2;
         var def:Class = param3;
         try
         {
            r = getDefinitionByName(id1) as Class;
         }
         catch(err:ReferenceError)
         {
            if(id2 == null)
            {
               r = def;
            }
            else
            {
               try
               {
                  r = getDefinitionByName(id2) as Class;
               }
               catch(err:ReferenceError)
               {
                  r = def;
               }
            }
         }
         return r;
      }
   }
}

