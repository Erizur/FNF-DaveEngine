package;

import flixel.FlxSprite;

class StrumNote extends FlxSprite
{
	public var baseX:Float;
	public var baseY:Float;
	public var playerStrum:Bool;
	public var pressingKey5:Bool;
   public function new(x:Float, y:Float, type:String, strumID:Int, playerStrum:Bool)
   {
      super(x, y);
	  baseY = y;
	  pressingKey5 = false;

	  ID = strumID;

      //get the frames and stuff
      switch (type)
      {
         case '3D':
            frames = Paths.getSparrowAtlas('notes/NOTE_assets_3D');
         case 'top10awesome':
            frames = Paths.getSparrowAtlas('notes/OMGtop10awesomehi');
         case 'gh':
            frames = Paths.getSparrowAtlas('notes/NOTEGH_assets');
         default:
            frames = Paths.getSparrowAtlas('notes/NOTE_assets');
      }
      //actually load in the animation
      switch (type)
      {
         case 'gh':
				animation.addByPrefix('green', 'A Strum');
				animation.addByPrefix('red', 'B Strum');
				animation.addByPrefix('yellow', 'C Strum');
            animation.addByPrefix('blue', 'D Strum');
            animation.addByPrefix('orange', 'E Strum');
            
				switch (Math.abs(strumID))
				{
					case 0:
						animation.addByPrefix('static', 'A Strum');
						animation.addByPrefix('pressed', 'A Press', 24, false);
						animation.addByPrefix('confirm', 'A Confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'B Strum');
						animation.addByPrefix('pressed', 'B Press', 24, false);
						animation.addByPrefix('confirm', 'B Confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'C Strum');
						animation.addByPrefix('pressed', 'C Press', 24, false);
						animation.addByPrefix('confirm', 'C Confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'D Strum');
						animation.addByPrefix('pressed', 'D Press', 24, false);
						animation.addByPrefix('confirm', 'D Confirm', 24, false);
					case 4:
						animation.addByPrefix('static', 'E Strum');
						animation.addByPrefix('pressed', 'E Press', 24, false);
						animation.addByPrefix('confirm', 'E Confirm', 24, false);
				}
			default:
				animation.addByPrefix('green', 'arrowUP');
				animation.addByPrefix('blue', 'arrowDOWN');
				animation.addByPrefix('purple', 'arrowLEFT');
				animation.addByPrefix('red', 'arrowRIGHT');
				switch (Math.abs(strumID))
				{
					case 0:
						animation.addByPrefix('static', 'arrowLEFT');
						animation.addByPrefix('pressed', 'left press', 24, false);
						animation.addByPrefix('confirm', 'left confirm', 24, false);
					case 1:
						animation.addByPrefix('static', 'arrowDOWN');
						animation.addByPrefix('pressed', 'down press', 24, false);
						animation.addByPrefix('confirm', 'down confirm', 24, false);
					case 2:
						animation.addByPrefix('static', 'arrowUP');
						animation.addByPrefix('pressed', 'up press', 24, false);
						animation.addByPrefix('confirm', 'up confirm', 24, false);
					case 3:
						animation.addByPrefix('static', 'arrowRIGHT');
						animation.addByPrefix('pressed', 'right press', 24, false);
						animation.addByPrefix('confirm', 'right confirm', 24, false);
				}
      }
      animation.play('static');

      antialiasing = type != '3D';

      setGraphicSize(Std.int(width * 0.7));
      updateHitbox();
	  
      scrollFactor.set();

		this.playerStrum = playerStrum;
   	}
	public function resetX()
	{
		x = baseX;
	}
	public function resetY()
	{
		y = baseY;
	}
	public function centerStrum()
	{
		x = baseX + 320 * (playerStrum ? -1 : 1) + 78 / 4;
	}
}