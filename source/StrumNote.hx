package;

import flixel.FlxSprite;

class StrumNote extends FlxSprite
{
	public var baseX:Float;
	public var baseY:Float;
	public var playerStrum:Bool;

	public function new(x:Float, y:Float, type:String, strumID:Int, playerStrum:Bool)
	{
		super(x, y);
		baseY = y;

		ID = strumID;

		// get the frames and stuff
		switch (type)
		{
			default:
				frames = Paths.getSparrowAtlas('notes/NOTE_assets');
		}
		// actually load in the animation
		switch (type)
		{
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

		antialiasing = true;

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
