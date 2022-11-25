package;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var songChars:Map<String, String> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var songChars:Map<String, String> = new Map<String, String>();
	#end

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, ?char:String = "bf"):Void
	{
		var daSong:String = formatSong(song);

		if (songScores.exists(daSong))
		{
			if (songScores.get(daSong) < score)
			{
				setScore(daSong, score, char);
			}
		}
		else
		{
			setScore(daSong, score, char);
		}
	}

	public static function saveWeekScore(week:Int = 1, score:Int = 0, ?diff:Int = 0, ?char:String = "bf"):Void
	{
		var daWeek:String = formatSong('week' + week);

		if (songScores.exists(daWeek))
		{
			if (songScores.get(daWeek) < score)
			{
				setScore(daWeek, score, char);
			}
		}
		else
		{
			setScore(daWeek, score, char);
		}
	}

	public static function setScore(song:String, score:Int, char:String):Void
	{
		songScores.set(song, score);
		songChars.set(song, char);
		FlxG.save.data.songScores = songScores;
		FlxG.save.data.songNames = songChars;
		FlxG.save.flush();
	}

	static function setChar(song:String, char:String):Void
	{
		songChars.set(song, char);
		FlxG.save.data.songNames = songChars;
		FlxG.save.flush();
	}

	public static function formatSong(song:String):String
	{
		var daSong:String = song;

		return daSong;
	}

	public static function getScore(song:String):Int
	{
		if (!songScores.exists(formatSong(song)))
		{
			setScore(formatSong(song), 0, "bf");
		}
		return songScores.get(formatSong(song));
	}

	public static function getChar(song:String):String
	{
		if (songChars == null)
			return "ERROR";
		if (!songChars.exists(formatSong(song)))
		{
			setChar(formatSong(song), "bf");
			return "bf";
		}
		return songChars.get(formatSong(song));
	}

	public static function getWeekScore(week:Int):Int
	{
		if (!songScores.exists(formatSong('week' + week)))
		{
			setScore(formatSong('week' + week), 0, "bf");
		}
		return songScores.get(formatSong('week' + week));
	}

	public static function getWeekChar(week:Int, diff:Int):String
	{
		if (!songScores.exists(formatSong('week' + week)))
		{
			setChar(formatSong('week' + week), "bf");
			return "bf";
		}
		return songChars.get(formatSong('week' + week));
	}

	public static function load():Void
	{
		if (FlxG.save.data.songScores != null)
		{
			songScores = FlxG.save.data.songScores;
		}
		if (FlxG.save.data.songNames != null)
		{
			songChars = FlxG.save.data.songNames;
		}
	}
}
