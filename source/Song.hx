package;

import Section.SwagSection;
import haxe.Json;
import haxe.format.JsonParser;
import lime.utils.Assets;

typedef SwagSong =
{
	var song:String;
	var notes:Array<SwagSection>;
	var bpm:Float;
	var needsVoices:Bool;
	var speed:Float;

	var player1:String;
	var player2:String;
	var gf:String;
	var stage:String;
}

class Song
{
	public var song:String;
	public var notes:Array<SwagSection>;
	public var bpm:Int;
	public var needsVoices:Bool = true;
	public var speed:Float = 1;

	public var player1:String = 'bf';
	public var player2:String = 'dad';
	public var gf:String;
	public var stage:String;

	public function new(song, notes, bpm)
	{
		this.song = song;
		this.notes = notes;
		this.bpm = bpm;
	}

	public static function loadFromJson(jsonInput:String):SwagSong
	{
		var rawJson = "";
		rawJson = Assets.getText(Paths.chart(jsonInput.toLowerCase())).trim();

		if (rawJson == null)
			throw 'Failed to locate chart JSON in $jsonInput'; // better error when it can't find the JSON

		if (rawJson != null){
			while (!rawJson.endsWith("}"))
				rawJson = rawJson.substr(0, rawJson.length - 1);
		}
		return parseJSONshit(rawJson);
	}

	inline public static function parseJSONshit(rawJson:String):SwagSong
		return cast Json.parse(rawJson).song;
}
