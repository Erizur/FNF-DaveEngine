package;

import sys.FileSystem;
import flixel.FlxSprite;
import flixel.math.FlxMath;

using StringTools;

class HealthIcon extends FlxSprite
{
	public var sprTracker:FlxSprite;

	public var noAaChars:Array<String> = [];

	var char:String;
	var state:String;

	public var isPlayer:Bool;

	var characterList:Array<String> = [];

	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		characterList = CoolUtil.coolTextFile(Paths.file('data/characterList.txt', TEXT, 'preload'));

		super();
		this.isPlayer = isPlayer;
		changeIcon(char);
		scrollFactor.set();
	}

	public function changeIcon(char:String)
	{
		var characterToFind:String = char;
		var theChar:String = '';

		for (i in 0...characterList.length)
		{
			var currentValue = characterList[i].trim().split(':');
			if (currentValue[0] != characterToFind)
			{
				continue;
			}
			else
			{
				theChar = currentValue[1];
			}
		}

		if (this.char != char)
		{
			if (char != "none")
			{
				var reqIcon:String = Paths.image('ui/iconGrid/' + theChar, 'preload');
				if (FileSystem.exists(reqIcon))
				{
					loadGraphic(reqIcon, true, 150, 150);
				}
				else
				{
					loadGraphic(Paths.image('ui/iconGrid/face', 'preload'), true, 150, 150);
				}
			}
			else
			{
				loadGraphic(Paths.image('ui/iconGrid/face', 'preload'), true, 150, 150);
			}

			if (char != "none")
			{
				antialiasing = !noAaChars.contains(char);
				animation.add(char, [0, 1], 0, false, isPlayer);
				animation.play(char);
			}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		offset.set(Std.int(FlxMath.bound(width - 150, 0)), Std.int(FlxMath.bound(height - 150, 0)));

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 10, sprTracker.y - 30);
	}

	public function changeState(charState:String)
	{
		switch (charState)
		{
			case 'normal':
				animation.curAnim.curFrame = 0;
			case 'losing':
				animation.curAnim.curFrame = 1;
		}
		state = charState;
	}

	public function getState()
	{
		return state;
	}

	public function getChar():String
	{
		return char;
	}
}
