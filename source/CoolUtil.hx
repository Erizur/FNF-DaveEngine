package;

import flixel.group.FlxGroup;
import flixel.FlxG;
import openfl.utils.AssetCache;
import flixel.math.FlxRandom;
import flixel.math.FlxMath;
import lime.utils.Assets;

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

	public static function difficultyString():String
	{
		switch (PlayState.storyWeek)
		{
			default:
				return difficultyArray[PlayState.storyDifficulty];

		}
	}

	public static function coolTextFile(path:String):Array<String>
	{
		var daList:Array<String> = Assets.getText(path).trim().split('\n');

		for (i in 0...daList.length)
		{
			daList[i] = daList[i].trim();
		}
		return daList;
	}
	
	public static function coolStringFile(path:String):Array<String>
		{
			var daList:Array<String> = path.trim().split('\n');
	
			for (i in 0...daList.length)
			{
				daList[i] = daList[i].trim();
			}
	
			return daList;
		}

	public static function numberArray(max:Int, ?min = 0):Array<Int>
	{
		var dumbArray:Array<Int> = [];
		for (i in min...max)
		{
			dumbArray.push(i);
		}
		return dumbArray;
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

	public static function cacheImage(image:String)
	{
		Assets.cache.image.set(image, lime.graphics.Image.fromFile(image));
	}
	public static function isArrayEqualTo(array1:Array<Dynamic>, array2:Array<Dynamic>)
	{
		if (array1.length != array2.length)
		{
			return false;
		}
		else
		{
			for (i in 0...array2.length)
			{
				if (array1[i] != array2[i])
				{
					return false;
				}
			}
		}
		return true;
	}
}
