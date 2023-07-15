package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

using StringTools;

class BGSprite extends FlxSprite
{
	public var spriteName:String;

	public var anims:Animation = null;

	public function new(spriteName:String, posX:Float, posY:Float, path:String = '', animations:Animation = null, ?scrollX:Float = 1, ?scrollY:Float = 1,
			?antialiasing:Bool = true, ?active:Bool = false)
	{
		super(posX, posY);

		this.spriteName = spriteName;
		var hasAnimations:Bool = animations != null;

		if (hasAnimations)
			anims = Reflect.copy(animations);

		if (path != '')
		{
			if (hasAnimations)
			{
				frames = Paths.getSparrowAtlas(path);
				var curAnim = anims;
				var animName:String = curAnim.name;
				var animPrefix:String = curAnim.prefixName;
				var animFrames:Int = curAnim.frames;
				var animLooped:Bool = curAnim.looped;
				var animFlipped:Array<Bool> = Reflect.field(curAnim, 'flip') != null ? curAnim.flip : [false, false];
				var animIndices:Array<Int> = curAnim.indices;

				if (curAnim != null)
				{
					if (animIndices != null && animIndices.length > 0)
					{
						animation.addByIndices(animName, animPrefix, animIndices, "", animFrames, animLooped, animFlipped[0], animFlipped[1]);
					}
					else
						animation.addByPrefix(animName, animPrefix, animFrames, animLooped, animFlipped[0], animFlipped[1]);
				}
			}
			else
				loadGraphic(path);
		}
		this.antialiasing = antialiasing;
		scrollFactor.set(scrollX, scrollY);
		this.active = active;
	}

	public static function getBGSprite(spriteGroup:FlxTypedGroup<BGSprite>, spriteName:String):BGSprite
	{
		for (bgSprite in spriteGroup.members)
		{
			if (bgSprite.spriteName == spriteName)
			{
				return bgSprite;
			}
		}
		return null;
	}

	public function dance():Void
	{
		if (anims != null)
			animation.play(anims.name);
	}
}
