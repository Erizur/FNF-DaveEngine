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
				var curAnim = animations;
				if (curAnim != null)
				{
					if (curAnim.indices != null)
					{
						animation.addByIndices(curAnim.name, curAnim.prefixName, curAnim.indices, "", curAnim.frames, curAnim.looped, curAnim.flip[0],
							curAnim.flip[1]);
					}
					else
						animation.addByPrefix(curAnim.name, curAnim.prefixName, curAnim.frames, curAnim.looped, curAnim.flip[0], curAnim.flip[1]);
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
