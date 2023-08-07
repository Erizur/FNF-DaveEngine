package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import Subtitle.SubtitleProperties;

class SubtitleManager extends FlxTypedGroup<Subtitle>
{
   public function addSubtitle(text:String, ?typeSpeed:Float, showTime:Float, ?properties:SubtitleProperties)
   {
		var subtitle = new Subtitle(text, typeSpeed, showTime, properties);
		subtitle.x = (FlxG.width - subtitle.width) / 2;
		subtitle.y = ((FlxG.height - subtitle.height) / 2) - 200;
		subtitle.manager = this;
		add(subtitle);
		   }
	public function onSubtitleComplete(subtitle:Subtitle)
	{
		remove(subtitle);
	}
}