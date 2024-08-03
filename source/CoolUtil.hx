package;

import flixel.FlxG;
import lime.utils.Assets;
import flixel.util.FlxSave;

using StringTools;

class CoolUtil
{
	public static var difficultyArray:Array<String> = new Array<String>();

	public static function init()
	{
		difficultyArray = new Array<String>();
		difficultyArray.push(LanguageManager.getTextString('play_easy'));
		difficultyArray.push(LanguageManager.getTextString('play_normal'));
		difficultyArray.push(LanguageManager.getTextString('play_hard'));
	}

	inline public static function difficultyString():String
	{
		return switch (PlayState.storyWeek)
		{
			default:
				difficultyArray[PlayState.storyDifficulty];
		}
	}

	inline public static function coolTextFile(path:String):Array<String>
	{
		return [
			for (i in Assets.getText(path).trim().split('\n'))
				i.trim()
		];
	}

	inline public static function coolStringFile(path:String):Array<String>
	{
		return [
			for (i in path.trim().split('\n'))
				i.trim()
		];
	}

	inline public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		return [
			for (i in min...max)
				i
		];
	}

	public static function formatString(string:String, separator:String):String
	{
		var split:Array<String> = string.split(separator);
		var formattedString:String = '';
		for (i in 0...split.length)
		{
			var piece:String = split[i];
			var allSplit = piece.split('');
			var firstLetterUpperCased = allSplit[0].toUpperCase();
			var substring = piece.substr(1, piece.length - 1);
			var newPiece = firstLetterUpperCased + substring;
			if (i != split.length - 1)
			{
				newPiece += " ";
			}
			formattedString += newPiece;
		}
		return formattedString;
	}

	public static function getMinAndMax(value1:Float, value2:Float):Array<Float>
	{
		var minAndMaxs = new Array<Float>();

		var min = Math.min(value1, value2);
		var max = Math.max(value1, value2);

		minAndMaxs.push(min);
		minAndMaxs.push(max);

		return minAndMaxs;
	}

	inline public static function cacheImage(image:String)
	{
		Assets.cache.image.set(image, lime.graphics.Image.fromFile(image));
	}

	public static function isArrayEqualTo(array1:Array<Dynamic>, array2:Array<Dynamic>)
	{
		if (array1.length != array2.length)
			return false;
		else
		{
			for (i in 0...array2.length)
			{
				if (array1[i] != array2[i])
					return false;
			}
		}
		return true;
	}

	/**
		Lerps camera, but accountsfor framerate shit?
		Right now it's simply for use to change the followLerp variable of a camera during update
		TODO LATER MAYBE:
			Actually make and modify the scroll and lerp shit in it's own function
			instead of solely relying on changing the lerp on the fly
	 */
	public static function camLerpShit(lerp:Float):Float
	{
		return lerp * (FlxG.elapsed / (1 / 60));
	}

	/** Quick Function to Fix Save Files for Flixel 5
		if you are making a mod, you are gonna wanna change "MemeHoovy" to something else
		so Base Dave Engine saves won't conflict with yours
		@BeastlyGabi
	**/
	public static function getSavePath(folder:String = 'MemeHoovy'):String
	{
		@:privateAccess
		return #if (flixel < "5.0.0") folder #else FlxG.stage.application.meta.get('company')
			+ '/'
			+ FlxSave.validate(FlxG.stage.application.meta.get('file')) #end;
	}

	public static function showPopUp(message:String, title:String):Void
	{
		#if (!ios || !iphonesim)
		try
		{
			trace('$title - $message');
			lime.app.Application.current.window.alert(message, title);
		}
		catch (e:Dynamic)
			trace('$title - $message');
		#else
		trace('$title - $message');
		#end
	}
}
