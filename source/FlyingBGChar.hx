package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.math.FlxRandom;

class FlyingBGChar extends BGSprite
{
   public var direction:String;
   public var angleChangeAmount:Float;
   public var posOffset:Float = 800;

   public var leftPosCheck:Float;
   public var rightPosCheck:Float;
   public var randomSpeed:Float = 1;
   
   public function new(spriteName:String, path:String)
   {
      super(spriteName, 0, 0, path, null, 1, 1, true, false);

      init();
   }

   public function switchDirection()
   {
      angleChangeAmount = new FlxRandom().float(100, 200);
	  
      y = (FlxG.height / 2) - height / 2;

      direction = direction == 'left' ? 'right' : direction == 'right' ? 'left' : '';
   }
   public function init()
   {
      angleChangeAmount = new FlxRandom().float(100, 200);
	  randomSpeed = new FlxRandom().float(1, 5);
      
      var dirs = ['left', 'right'];
      direction = new FlxRandom().getObject(dirs);

      leftPosCheck = (-width * (1 / PlayState.instance.getCamZoom())) - posOffset;
      rightPosCheck = (FlxG.width * (1 / PlayState.instance.getCamZoom())) + width + posOffset;
      switch (direction)
      {
         case 'left':
            x = rightPosCheck;
         case 'right':
            x = leftPosCheck;
      }
      screenCenter(Y);
   }
}