package;

import flixel.system.FlxSound;
import Controls.Device;
import Controls.Control;
import flixel.math.FlxRandom;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.FlxObject;
#if (desktop && !hl) import Discord.DiscordClient; #end

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var curSelected:Int = 0;

	var bg:FlxSprite = new FlxSprite();

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;
	private var curChar:String = "unknown";

	private var InMainFreeplayState:Bool = false;

	private var CurrentSongIcon:FlxSprite;

	private var Catagories:Array<String> = ['base'];
	var translatedCatagory:Array<String> = [LanguageManager.getTextString('freeplay_base')];

	var weekList:Array<String> = [];

	private var CurrentPack:Int = 0;
	private var NameAlpha:Alphabet;

	var loadingPack:Bool = false;

	var songColors:Array<FlxColor> = [];

	private var camFollow:FlxObject;

	private var iconArray:Array<HealthIcon> = [];

	var titles:Array<Alphabet> = [];
	var icons:Array<FlxSprite> = [];

	var canInteract:Bool = true;

	var characterSelectText:FlxText;
	var showCharText:Bool = true;

	var charList:Array<String> = [];

	override function create()
	{
		#if (desktop && !hl) DiscordClient.changePresence("In the Freeplay Menu", null); #end

		openfl.system.System.gc();

		showCharText = FlxG.save.data.wasInCharSelect;

		bg.loadGraphic(Paths.image('backgrounds/menu'));
		bg.color = 0xFF4965FF;
		bg.scrollFactor.set();
		add(bg);

		for (i in 0...Catagories.length)
		{
			Highscore.load();

			var CurrentSongIcon:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('packs/' + (Catagories[i].toLowerCase()), "preload"));
			CurrentSongIcon.centerOffsets(false);
			CurrentSongIcon.x = (1000 * i + 1) + (512 - CurrentSongIcon.width);
			CurrentSongIcon.y = (FlxG.height / 2) - 256;
			CurrentSongIcon.antialiasing = true;

			var NameAlpha:Alphabet = new Alphabet(40, (FlxG.height / 2) - 282, translatedCatagory[i], true, false);
			NameAlpha.x = CurrentSongIcon.x;

			add(CurrentSongIcon);
			icons.push(CurrentSongIcon);
			add(NameAlpha);
			titles.push(NameAlpha);
		}

		weekList = CoolUtil.coolTextFile(Paths.file('data/weekList.txt', TEXT, 'preload'));
		charList = CoolUtil.coolTextFile(Paths.file('data/characterList.txt', TEXT, 'preload'));

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollow.setPosition(icons[CurrentPack].x + 256, icons[CurrentPack].y + 256);

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		FlxG.camera.focusOn(camFollow.getPosition());

		super.create();
	}

	public static function createSongArrayFromTxt(name:String, whatTo:String):Array<String>
	{
		var tempWeek:Array<String> = CoolUtil.coolTextFile(Paths.file('data/weeks/' + name + '.txt', TEXT, 'preload'));
		var returned:Array<String> = [];

		if (whatTo.toLowerCase() == 'songs')
		{
			for (i in 0...tempWeek.length)
			{
				var currentValue = tempWeek[i].trim().split(':');
				returned.push(currentValue[0]);
			}
		}

		if (whatTo.toLowerCase() == 'char')
		{
			for (i in 0...tempWeek.length)
			{
				var currentValue = tempWeek[i].trim().split(':');
				returned.push(currentValue[1]);
			}
		}

		return returned;
	}

	public function getColorCode(char:String):String
	{
		var returnedString:String = '';
		for (i in 0...charList.length)
		{
			var currentValue = charList[i].trim().split(':');
			if (currentValue[0] != char)
				continue;
			else
				returnedString = currentValue[2]; // this is the color code one
		}
		if (returnedString == '')
			return char;
		else
			return returnedString;
	}

	public function LoadProperPack()
	{
		switch (Catagories[CurrentPack].toLowerCase())
		{
			case 'base':
				for (i in 0...weekList.length)
				{
					var mainCharacter = createSongArrayFromTxt(weekList[i], 'char');
					addWeek(createSongArrayFromTxt(weekList[i], 'songs'), i, createSongArrayFromTxt(weekList[i], 'char'));
					songColors.push(FlxColor.fromString(getColorCode(mainCharacter[0])));
				}
		}
	}

	var scoreBG:FlxSprite;

	public function GoToActualFreeplay()
	{
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.itemType = 'Classic';
			songText.targetY = i;
			songText.scrollFactor.set();
			songText.alpha = 0;
			songText.y += 1000;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;
			icon.scrollFactor.set();

			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, LEFT);
		scoreText.antialiasing = true;
		scoreText.y = -225;
		scoreText.scrollFactor.set();

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		scoreBG.scrollFactor.set();
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 15, 0, "", 24);
		diffText.setFormat(Paths.font("vcr.ttf"), 24, FlxColor.WHITE, LEFT);
		diffText.antialiasing = true;
		diffText.scrollFactor.set();

		if (showCharText)
		{
			characterSelectText = new FlxText(FlxG.width, FlxG.height, 0, LanguageManager.getTextString("freeplay_skipChar"), 18);
			characterSelectText.setFormat("VCR OSD Mono", 18, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			characterSelectText.borderSize = 1.5;
			characterSelectText.antialiasing = true;
			characterSelectText.scrollFactor.set();
			characterSelectText.alpha = 0;
			characterSelectText.x -= characterSelectText.textField.textWidth;
			characterSelectText.y -= characterSelectText.textField.textHeight;
			add(characterSelectText);

			FlxTween.tween(characterSelectText, {alpha: 1}, 0.5, {ease: FlxEase.expoInOut});
		}

		add(diffText);
		add(scoreText);

		FlxTween.tween(scoreBG, {y: 0}, 0.5, {ease: FlxEase.expoInOut});
		FlxTween.tween(scoreText, {y: -5}, 0.5, {ease: FlxEase.expoInOut});
		FlxTween.tween(diffText, {y: 30}, 0.5, {ease: FlxEase.expoInOut});

		for (song in 0...grpSongs.length)
		{
			grpSongs.members[song].unlockY = true;

			FlxTween.tween(grpSongs.members[song], {y: song, alpha: song == curSelected ? 1 : 0.6}, 0.5, {
				ease: FlxEase.expoInOut,
				onComplete: function(twn:FlxTween)
				{
					grpSongs.members[song].unlockY = false;

					canInteract = true;
				}
			});
		}

		changeSelection();
	}

	inline public function addSong(songName:String, weekNum:Int, songCharacter:String)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter));
	}

	public function UpdatePackSelection(change:Int)
	{
		CurrentPack += change;
		if (CurrentPack == -1)
			CurrentPack = Catagories.length - 1;

		if (CurrentPack == Catagories.length)
			CurrentPack = 0;

		camFollow.x = icons[CurrentPack].x + 256;
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;

		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);

			if (songCharacters.length != 1)
				num++;
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		// Selector Menu Functions
		if (!InMainFreeplayState)
		{
			scoreBG = null;
			scoreText = null;
			diffText = null;
			characterSelectText = null;

			if (controls.LEFT_P && canInteract)
			{
				UpdatePackSelection(-1);
			}
			if (controls.RIGHT_P && canInteract)
			{
				UpdatePackSelection(1);
			}
			if (controls.ACCEPT && !loadingPack && canInteract)
			{
				FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);

				canInteract = false;

				new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
				{
					loadingPack = true;
					LoadProperPack();

					for (item in icons)
					{
						FlxTween.tween(item, {alpha: 0, y: item.y - 200}, 0.2, {ease: FlxEase.cubeInOut});
					}
					for (item in titles)
					{
						FlxTween.tween(item, {alpha: 0, y: item.y - 200}, 0.2, {ease: FlxEase.cubeInOut});
					}

					new FlxTimer().start(0.2, function(Dumbshit:FlxTimer)
					{
						for (item in icons)
						{
							item.visible = false;
						}
						for (item in titles)
						{
							item.visible = false;
						}

						GoToActualFreeplay();
						InMainFreeplayState = true;
						loadingPack = false;
					});
				});
			}
			if (controls.BACK && canInteract)
			{
				FlxG.switchState(new MainMenuState());
			}

			return;
		}
		// Freeplay Functions
		else
		{
			var upP = controls.UP_P;
			var downP = controls.DOWN_P;
			var accepted = controls.ACCEPT;

			if (upP && canInteract)
				changeSelection(-1);
			if (downP && canInteract)
				changeSelection(1);

			if (controls.BACK && canInteract)
			{
				loadingPack = true;
				canInteract = false;

				for (i in grpSongs)
				{
					i.unlockY = true;

					FlxTween.tween(i, {y: 5000, alpha: 0}, 0.3, {
						onComplete: function(twn:FlxTween)
						{
							i.unlockY = false;

							for (item in icons)
							{
								item.visible = true;
								FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut});
							}
							for (item in titles)
							{
								item.visible = true;
								FlxTween.tween(item, {alpha: 1, y: item.y + 200}, 0.2, {ease: FlxEase.cubeInOut});
							}

							if (scoreBG != null)
							{
								FlxTween.tween(scoreBG, {y: scoreBG.y - 100}, 0.5, {
									ease: FlxEase.expoInOut,
									onComplete: function(spr:FlxTween)
									{
										scoreBG = null;
									}
								});
							}

							if (scoreText != null)
							{
								FlxTween.tween(scoreText, {y: scoreText.y - 100}, 0.5, {
									ease: FlxEase.expoInOut,
									onComplete: function(spr:FlxTween)
									{
										scoreText = null;
									}
								});
							}

							if (diffText != null)
							{
								FlxTween.tween(diffText, {y: diffText.y - 100}, 0.5, {
									ease: FlxEase.expoInOut,
									onComplete: function(spr:FlxTween)
									{
										diffText = null;
									}
								});
							}
							if (showCharText)
							{
								if (characterSelectText != null)
								{
									FlxTween.tween(characterSelectText, {alpha: 0}, 0.5, {
										ease: FlxEase.expoInOut,
										onComplete: function(spr:FlxTween)
										{
											characterSelectText = null;
										}
									});
								}
							}

							InMainFreeplayState = false;
							loadingPack = false;

							for (i in grpSongs)
								remove(i);
							for (i in iconArray)
								remove(i);

							// MAKE SURE TO RESET EVERYTHIN!
							songs = [];
							grpSongs.members = [];
							iconArray = [];
							curSelected = 0;
							canInteract = true;
						}
					});
				}
			}
			if (accepted && canInteract)
			{
				switch (songs[curSelected].songName)
				{
					default:
						FlxG.sound.music.fadeOut(1, 0);
						PlayState.SONG = Song.loadFromJson(songs[curSelected].songName.toLowerCase());
						PlayState.isStoryMode = false;

						PlayState.characteroverride = "none";
						PlayState.formoverride = "none";
						PlayState.curmult = [1, 1, 1, 1];

						PlayState.storyWeek = songs[curSelected].week;

						if ((FlxG.keys.pressed.CONTROL))
						{
							LoadingState.loadAndSwitchState(new PlayState());
						}
						else
						{
							if (!FlxG.save.data.wasInCharSelect)
							{
								FlxG.save.data.wasInCharSelect = true;
								FlxG.save.flush();
							}
							LoadingState.loadAndSwitchState(new CharacterSelectState());
						}
				}
			}
		}

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		bg.color = FlxColor.interpolate(bg.color, songColors[songs[curSelected].week], CoolUtil.camLerpShit(0.045));

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		if (scoreText != null)
			scoreText.text = LanguageManager.getTextString('freeplay_personalBest') + lerpScore;
		positionHighscore();
	}

	function positionHighscore()
	{
		scoreText.x = FlxG.width - scoreText.width - 6;
		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;

		if (curSelected >= songs.length)
			curSelected = 0;

		curChar = Highscore.getChar(songs[curSelected].songName);

		if (diffText != null)
			diffText.text = curChar.toUpperCase();

		intendedScore = Highscore.getScore(songs[curSelected].songName);

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
			iconArray[i].alpha = 0.6;

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";

	public function new(song:String, week:Int, songCharacter:String)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
	}
}
