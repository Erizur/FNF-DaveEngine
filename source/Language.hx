package;

import flixel.util.FlxColor;

class Language
{
   public var langaugeName:String;
   public var pathName:String;
   public var langaugeColor:FlxColor;

   public function new(langaugeName:String, pathName:String, langaugeColor:FlxColor)
   {
      this.langaugeName = langaugeName;
      this.pathName = pathName;
      this.langaugeColor = langaugeColor;
   }
}