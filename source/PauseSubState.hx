package;

import flixel.group.FlxGroup;
import haxe.Json;
import haxe.Http;
import flixel.math.FlxRandom;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.addons.display.FlxBackdrop;
import lime.app.Application;

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;
	var bg:FlxBackdrop;

	var menuItems:Array<PauseOption> = [
		new PauseOption('Resume'),
		new PauseOption('Restart Song'),
		new PauseOption('Change Character'),
		new PauseOption('No Miss Mode'),
		new PauseOption('Exit to menu')
	];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;
	var expungedSelectWaitTime:Float = 0;
	var timeElapsed:Float = 0;
	var patienceTime:Float = 0;

	public var funnyTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

	public function new(x:Float, y:Float)
	{
		super();
		
		funnyTexts = new FlxTypedGroup<FlxText>();
		add(funnyTexts);

		for(item in menuItems)
		{
			if(item.optionName == 'Change Character')
			{
				if(PlayState.isStoryMode == true)
				{
					menuItems.remove(item);
				}
				else
				{
					continue;
				}
			}
			else
			{
				continue;
			}
		}

		switch (PlayState.SONG.song.toLowerCase())
		{
			default:
				pauseMusic = new FlxSound().loadEmbedded(Paths.music('breakfast'), true, true);
		}
		
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var backBg:FlxSprite = new FlxSprite();
		backBg.makeGraphic(FlxG.width + 1, FlxG.height + 1, FlxColor.BLACK);
		backBg.alpha = 0;
		backBg.scrollFactor.set();
		add(backBg);

		bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
		bg.alpha = 0;
		bg.antialiasing = true;
		bg.scrollFactor.set();
		add(bg);

		var levelInfo:FlxText = new FlxText(20, 15, 0, "", 32);
		levelInfo.text += PlayState.SONG.song;
		levelInfo.scrollFactor.set();
		levelInfo.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		levelInfo.antialiasing = true;
		levelInfo.borderSize = 2.5;
		levelInfo.updateHitbox();
		add(levelInfo);

		var levelDifficulty:FlxText = new FlxText(20, 15 + 32, 0, "", 32);
		levelDifficulty.text += CoolUtil.difficultyString();
		levelDifficulty.scrollFactor.set();
		levelDifficulty.setFormat(Paths.font('vcr.ttf'), 32, FlxColor.WHITE, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		levelDifficulty.antialiasing = true;
		levelDifficulty.borderSize = 2.5;
		levelDifficulty.updateHitbox();

		levelDifficulty.alpha = 0;
		levelInfo.alpha = 0;

		levelInfo.x = FlxG.width - (levelInfo.width + 20);
		levelDifficulty.x = FlxG.width - (levelDifficulty.width + 20);

		FlxTween.tween(backBg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(bg, {alpha: 0.6}, 0.4, {ease: FlxEase.quartInOut});
		FlxTween.tween(levelInfo, {alpha: 1, y: 20}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.3});
		FlxTween.tween(levelDifficulty, {alpha: 1, y: levelDifficulty.y + 5}, 0.4, {ease: FlxEase.quartInOut, startDelay: 0.5});
		if (FreeplayState.skipSelect.contains(PlayState.SONG.song.toLowerCase()))
		{
			menuItems.remove(PauseOption.getOption(menuItems, 'Change Character'));
		}

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, LanguageManager.getTextString('pause_${menuItems[i].optionName}'), true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float)
	{
		var scrollSpeed:Float = 50;
      	bg.x -= scrollSpeed * elapsed;
      	bg.y -= scrollSpeed * elapsed;

		timeElapsed += elapsed;
		if (pauseMusic.volume < 0.75)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			if (expungedSelectWaitTime <= 2)
			{
				expungedSelectWaitTime = 2;
			}
			changeSelection(-1);
		}
		if (downP)
		{
			if (expungedSelectWaitTime <= 2)
			{
				expungedSelectWaitTime = 2;
			}
			changeSelection(1);
		}

		if (accepted)
		{
			selectOption();
		}
	}
	function selectOption()
	{
		var daSelected:String = menuItems[curSelected].optionName;

		switch (daSelected)
		{
			case "Resume":
				close();
			case "Restart Song":
				FlxG.sound.music.volume = 0;
				PlayState.instance.vocals.volume = 0;

				PlayState.instance.shakeCam = false;
				PlayState.instance.camZooming = false;
				FlxG.mouse.visible = false;
				FlxG.resetState();
			case "Change Character":
					funnyTexts.clear();
					PlayState.characteroverride = 'none';
					PlayState.formoverride = 'none';

					Application.current.window.title = Main.applicationName;

					PlayState.instance.shakeCam = false;
					PlayState.instance.camZooming = false;
					FlxG.mouse.visible = false;
					FlxG.switchState(new CharacterSelectState());	
			case "No Miss Mode":
				PlayState.instance.noMiss = !PlayState.instance.noMiss;
			case "Exit to menu":
				funnyTexts.clear();
				PlayState.characteroverride = 'none';
				PlayState.formoverride = 'none';

				Application.current.window.title = Main.applicationName;

				PlayState.instance.shakeCam = false;
				PlayState.instance.camZooming = false;
				FlxG.mouse.visible = false;
				FlxG.switchState(new MainMenuState());
		}
	}
	override function close()
	{
		funnyTexts.clear();

		super.close();
	}

	override function destroy()
	{
		pauseMusic.destroy();

		super.destroy();
	}
	function changeSelection(change:Int = 0):Void
	{
		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
class PauseOption
{
	public var optionName:String;

	public function new(optionName:String)
	{
		this.optionName = optionName;
	}
	
	public static function getOption(list:Array<PauseOption>, optionName:String):PauseOption
	{
		for (option in list)
		{
			if (option.optionName == optionName)
			{
				return option;
			}
		}
		return null;
	}
}