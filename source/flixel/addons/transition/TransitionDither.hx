package flixel.addons.transition;

import openfl.display.Bitmap;
import Shaders.DitherEffect;
import flixel.util.FlxColor;
import openfl.display.BitmapData;
import flixel.graphics.FlxGraphic;

class TransitionDither extends TransitionEffect
{
   var ditherShader:DitherEffect = new DitherEffect();
   public function new(data:TransitionData)
   {
      //ain't doing anything on this until there's an actual dither shader that works lol
      super(data);

      var bitmap:BitmapData = new BitmapData(FlxG.width * 2, FlxG.width * 2, false, FlxColor.BLACK);
      var graphic = FlxGraphic.fromBitmapData(bitmap);
      var ugh:FlxSprite = new FlxSprite().loadGraphic(graphic);
      ugh.screenCenter();
      //ugh.shader = ditherShader.shader;
      add(ugh);
   }
}