package;

import flixel.util.FlxAxes;
import flixel.system.FlxSound;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.text.FlxTypeText;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.text.FlxText;

typedef SubtitleProperties = {
	var ?x:Float;
   var ?y:Float;
   var ?subtitleSize:Int;
   var ?typeSpeed:Float;
   var ?screenCenter:FlxAxes;
}

class Subtitle extends FlxTypeText
{
   public var manager:SubtitleManager;
   public function new(text:String, ?typeSpeed, showTime:Float, properties:SubtitleProperties)
   {
      properties = init(properties);

      super(properties.x, properties.y, FlxG.width, text, 36);
      sounds = null;
	  
      setFormat("Comic Sans MS Bold", properties.subtitleSize, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      antialiasing = true;
      borderSize = 2;

      screenCenter(properties.screenCenter);

      start(properties.typeSpeed, false, false, [], function()
      {
         new FlxTimer().start(showTime, function(timer:FlxTimer)
         {
            FlxTween.tween(this, {alpha: 0}, 0.5, {onComplete: function(tween:FlxTween)
            {
               manager.onSubtitleComplete(this);
            }});
         });
      });
   }
   function init(properties:SubtitleProperties):SubtitleProperties
	{
      if (properties == null) properties = {};

      if (properties.x == null) properties.x = FlxG.width / 2;
      if (properties.y == null) properties.y = (FlxG.height / 2) + 100;
      if (properties.subtitleSize == null) properties.subtitleSize = 36;
      if (properties.typeSpeed == null) properties.typeSpeed = 0.02;
      if (properties.screenCenter == null) properties.screenCenter = FlxAxes.XY;

      return properties;
   }
}