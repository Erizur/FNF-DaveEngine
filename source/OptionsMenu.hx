package;

import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
#if (desktop && !hl)
import Discord.DiscordClient;
#end

class OptionsMenu extends MusicBeatState
{
	var curSelected:Int = 0;

	var controlsStrings:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;
	var versionShit:FlxText;

	var languages:Array<Language> = new Array<Language>();
	var curLanguage:String = LanguageManager.save.data.language;

	var oldY:Float = 0;

	override function create()
	{
		#if (desktop && !hl)
		DiscordClient.changePresence("In the Options Menu", null);
		#end
		var menuBG:FlxSprite = new FlxSprite();

		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.antialiasing = true;
		menuBG.loadGraphic(Paths.image('backgrounds/menu'));
		add(menuBG);

		languages = LanguageManager.getLanguages();

		controlsStrings = CoolUtil.coolStringFile(LanguageManager.getTextString('option_change_keybinds')
			+ "\n"
			+ (FlxG.save.data.newInput ? LanguageManager.getTextString('option_ghostTapping_on') : LanguageManager.getTextString('option_ghostTapping_off'))
			+ "\n"
			+ (FlxG.save.data.downscroll ? LanguageManager.getTextString('option_downscroll') : LanguageManager.getTextString('option_upscroll'))
			+ "\n"
			+ (FlxG.save.data.songPosition ? LanguageManager.getTextString('option_songPosition_on') : LanguageManager.getTextString('option_songPosition_off'))
			+ "\n"
			+ (FlxG.save.data.eyesores ? LanguageManager.getTextString('option_eyesores_enabled') : LanguageManager.getTextString('option_eyesores_disabled'))
			+ "\n"
			+ (FlxG.save.data.donoteclick ? LanguageManager.getTextString('option_hitsound_on') : LanguageManager.getTextString('option_hitsound_off'))
			+ "\n"
			+ (FlxG.save.data.botplay ? LanguageManager.getTextString('option_enable_botplay') : LanguageManager.getTextString('option_disable_botplay'))
			+ "\n"
			+ (FlxG.save.data.noteCamera ? LanguageManager.getTextString('option_noteCamera_on') : LanguageManager.getTextString('option_noteCamera_off'))
			+ "\n"
			+ LanguageManager.getTextString('option_change_langauge')
			+ "\n"
			+ (FlxG.save.data.disableFps ? LanguageManager.getTextString('option_enable_fps') : LanguageManager.getTextString('option_disable_fps'))
			+ "\n"
			+
			(CompatTool.save.data.compatMode ? LanguageManager.getTextString('option_disable_compat') : LanguageManager.getTextString('option_enable_compat')));

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		for (i in 0...controlsStrings.length)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * i) + 30, controlsStrings[i], true, false);
			controlLabel.screenCenter(X);
			controlLabel.itemType = 'Vertical';
			controlLabel.isMenuItem = true;
			controlLabel.targetY = i;
			grpControls.add(controlLabel);

			oldY = controlLabel.targetY;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		versionShit = new FlxText(5, FlxG.height - 18, 0, "Offset (Left, Right): " + FlxG.save.data.offset, 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (controls.BACK)
		{
			FlxG.save.flush();
			CompatTool.save.flush();
			FlxG.switchState(new MainMenuState());
		}
		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

		if (controls.RIGHT_R)
		{
			FlxG.save.data.offset++;
			versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
		}

		if (controls.LEFT_R)
		{
			FlxG.save.data.offset--;
			versionShit.text = "Offset (Left, Right): " + FlxG.save.data.offset;
		}
		if (controls.ACCEPT)
		{
			grpControls.remove(grpControls.members[curSelected]);
			switch (curSelected)
			{
				case 0:
					new FlxTimer().start(0.01, function(timer:FlxTimer)
					{
						FlxG.switchState(new ChangeKeybinds());
					});
					updateGroupControls(LanguageManager.getTextString('option_change_keybinds'), 0, 'Vertical');
				case 1:
					FlxG.save.data.newInput = !FlxG.save.data.newInput;
					updateGroupControls((FlxG.save.data.newInput ? LanguageManager.getTextString('option_ghostTapping_on') : LanguageManager.getTextString('option_ghostTapping_off')),
						1, 'Vertical');
				case 2:
					FlxG.save.data.downscroll = !FlxG.save.data.downscroll;
					updateGroupControls((FlxG.save.data.downscroll ? LanguageManager.getTextString('option_downscroll') : LanguageManager.getTextString('option_upscroll')),
						2, 'Vertical');
				case 3:
					FlxG.save.data.songPosition = !FlxG.save.data.songPosition;
					updateGroupControls((FlxG.save.data.songPosition ? LanguageManager.getTextString('option_songPosition_on') : LanguageManager.getTextString('option_songPosition_off')),
						3, 'Vertical');
				case 4:
					FlxG.save.data.eyesores = !FlxG.save.data.eyesores;
					updateGroupControls((FlxG.save.data.eyesores ? LanguageManager.getTextString('option_eyesores_enabled') : LanguageManager.getTextString('option_eyesores_disabled')),
						4, 'Vertical');
				case 5:
					FlxG.save.data.donoteclick = !FlxG.save.data.donoteclick;
					updateGroupControls((FlxG.save.data.donoteclick ? LanguageManager.getTextString('option_hitsound_on') : LanguageManager.getTextString('option_hitsound_off')),
						5, 'Vertical');
				case 6:
					FlxG.save.data.noteCamera = !FlxG.save.data.noteCamera;
					updateGroupControls((FlxG.save.data.noteCamera ? LanguageManager.getTextString('option_noteCamera_on') : LanguageManager.getTextString('option_noteCamera_off')),
						6, 'Vertical');
				case 7:
					updateGroupControls(LanguageManager.getTextString('option_change_langauge'), 7, 'Vertical');
					FlxG.switchState(new ChangeLanguageState());
				case 8:
					FlxG.save.data.disableFps = !FlxG.save.data.disableFps;
					Main.fps.visible = !FlxG.save.data.disableFps;
					updateGroupControls(FlxG.save.data.disableFps ? LanguageManager.getTextString('option_enable_fps') : LanguageManager.getTextString('option_disable_fps'),
						8, 'Vertical');
				case 9:
					CompatTool.save.data.compatMode = !CompatTool.save.data.compatMode;
					updateGroupControls(CompatTool.save.data.compatMode ? LanguageManager.getTextString('option_disable_compat') : LanguageManager.getTextString('option_enable_compat'),
						10, 'Vertical');
				case 10:
					FlxG.save.data.botplay = !FlxG.save.data.botplay;
					updateGroupControls((FlxG.save.data.botplay ? LanguageManager.getTextString('option_enable_botplay') : LanguageManager.getTextString('option_disable_botplay')),
						12, 'Vertical');
					trace(FlxG.save.data.botplay);
			}
		}
	}

	override function beatHit()
	{
		super.beatHit();
		FlxTween.tween(FlxG.camera, {zoom: 1.05}, 0.3, {ease: FlxEase.quadOut, type: BACKWARD});
	}

	function updateGroupControls(controlText:String, yIndex:Int, controlTextItemType:String)
	{
		var ctrl:Alphabet = new Alphabet(0, (70 * curSelected) + 30, controlText, true, false);
		ctrl.screenCenter(X);
		ctrl.isMenuItem = true;
		ctrl.targetY = curSelected - yIndex;
		ctrl.itemType = controlTextItemType;
		grpControls.add(ctrl);
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
	}
}
