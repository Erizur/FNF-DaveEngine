package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;

using StringTools;

class BGSprite extends FlxSprite
{
	public var spriteName:String;

	public function new(spriteName:String, posX:Float, posY:Float, path:String = '', animations:Array<Animation>, ?scrollX:Float = 1, ?scrollY:Float = 1,
			?antialiasing:Bool = true, ?active:Bool = false)
	{
		super(posX, posY);

		this.spriteName = spriteName;
		var hasAnimations:Bool = animations != null;

		if (path != '')
		{
			if (hasAnimations)
			{
				frames = Paths.getSparrowAtlas(path);
				for (i in 0...animations.length)
				{
					var curAnim = animations[i];
					if (curAnim != null)
					{
						if (curAnim.indices != null)
						{
							animation.addByIndices(curAnim.name, curAnim.prefixName, curAnim.indices, "", curAnim.frames, curAnim.looped, curAnim.flip[0],
								curAnim.flip[1]);
						}
						else
						{
							animation.addByPrefix(curAnim.name, curAnim.prefixName, curAnim.frames, curAnim.looped, curAnim.flip[0], curAnim.flip[1]);
						}
					}
				}
			}
			else
			{
				loadGraphic(path);
			}
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
}
