package;

import Controls.KeyboardScheme;
import flixel.input.actions.FlxActionInput;
import flixel.addons.display.FlxShaderMaskCamera;
import flixel.input.actions.FlxActionInputDigital.FlxActionInputDigitalMouseWheel;
import haxe.macro.Context;
import haxe.Json;
import flixel.effects.FlxFlicker;
import flixel.input.keyboard.FlxKeyList;
import flixel.FlxObject;
import flixel.group.FlxGroup;
import flixel.FlxCamera;
import flixel.input.actions.FlxAction.FlxActionDigital;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.math.FlxMath;
import StringTools;

/*
ello again!! another reminder to not use my coding without my permission/without checking in with me :))
-vs dave dev T5mpler
*/
class ChangeKeybinds extends MusicBeatState
{
	var bg:FlxSprite = new FlxSprite();

	var camFollow:FlxObject;

	var selectableItems:Array<FlxText> = new Array<FlxText>();
	var curItemSelected:Int = 0;
	var curItem:FlxText;

	public static var uiControls:Array<ControlUI> = 
	[
		new ControlUI('Left', 'left'),
		new ControlUI('Down', 'down'),
		new ControlUI('Up', 'up'),
		new ControlUI('Right', 'right'),
		new ControlUI('Reset', 'reset'),
		new ControlUI('Key5', 'key5'),
	];

	var currentUIControl:ControlUI;

	var textGroups:Array<TextGroup> = new Array<TextGroup>();
	var curTextGroup:TextGroup;
	var controlGroups:Array<TextGroup> = new Array<TextGroup>();
	var controlTexts:Array<FlxText> = new Array<FlxText>();

	var curKeybindSelected:Int = 0;
	var currentKeybind:FlxText;

	var keybindPresets:Array<String> = ['Arrow Keys', 'WASD', 'DFJK', 'ASKL', 'ZX,.'];
	var choosePreset:FlxText;
	var preset:FlxText;
	var presetLeft:FlxText;
	var presetRight:FlxText;
	var curSelectedPreset:Int = 0;
	var curPreset:String;

	var state:KeybindState = KeybindState.SelectControl;

	public override function create()
	{
		bg.color = 0xFFea71fd;
		bg.loadGraphic(MainMenuState.randomizeBG());
		bg.scrollFactor.set();
		add(bg);
		
		var tutorial:FlxText = new FlxText(0, 50, FlxG.width / 2, LanguageManager.getTextString('keybind_tutorial'), 32);
		tutorial.screenCenter(X);
		tutorial.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		tutorial.borderSize = 2;
		tutorial.antialiasing = true;
		add(tutorial);

		createPresetUI();

		for (i in 0...uiControls.length)
		{
			var uiControl:ControlUI = uiControls[i];
			addControlText(uiControl, i);
		}
		curTextGroup = textGroups[curItemSelected];

		camFollow = new FlxObject(FlxG.width / 2, selectableItems[curItemSelected].y);
		FlxG.camera.follow(camFollow, 0.05);
		
		changeSelection();

		super.create();
	}

	override function update(elapsed:Float)
	{
		var left = controls.LEFT_P;
		var down = controls.DOWN_P;
		var up = controls.UP_P;
		var right = controls.RIGHT_P;
		var back = controls.BACK;
		var accept = controls.ACCEPT;

		switch (state)
		{
			case SelectControl:
				if (up && !controls.RIGHT && !controls.LEFT)
				{
					changeSelection(-1);
				}
				if (down && !controls.RIGHT && !controls.LEFT)
				{
					changeSelection(1);
				}
				if (accept)
				{
					switch (curTextGroup.groupName)
					{
						case 'presetGroup':
							changePreset();
						case 'controlGroup':
							state = KeybindState.SelectKeybind;
							FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
							changeKeybindSelection();
					}
				}
				if (curTextGroup.groupName == 'presetGroup')
				{
					if (controls.RIGHT)
					{
						updateText(presetRight, true);
					}
					if (controls.RIGHT_R)
					{
						updateText(presetRight, false);
					}
					if (controls.LEFT)
					{
						updateText(presetLeft, true);
					}
					if (controls.LEFT_R)
					{
						updateText(presetLeft, false);
					}
					if (left)
					{
						changePresetSelection(-1);
					}
					if (right)
					{
						changePresetSelection(1);
					}
				}
			case SelectKeybind:
				if (left)
				{
					changeKeybindSelection(-1);
				}
				if (right)
				{
					changeKeybindSelection(1);
				}
				if (accept)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

					state = KeybindState.ChangeKeybind;
				}
			case ChangeKeybind:
				var oldKeybindText = currentKeybind.text;
				currentKeybind.text = "_";

				var keyID = FlxG.keys.firstJustPressed();

				var keyBlacklist:Array<FlxKey> = [FlxKey.ENTER, FlxKey.SPACE, FlxKey.BACKSPACE, FlxKey.ESCAPE];
				if (keyID > -1)
				{
					if (keyBlacklist.contains(keyID))
					{
						FlxG.camera.shake(0.05, 0.1);
						FlxG.sound.play(Paths.sound('missnote'), 0.9);
					}
					else
					{
						var controlKeybinds = KeybindPrefs.keybinds.get(currentUIControl.controlName);

						var keyJustPressed = cast(keyID, FlxKey);
						
						var otherKeybind = curKeybindSelected == 1 ? 0 : 1;
						var otherKeybindText = curTextGroup.texts.members[otherKeybind];
						if (controlKeybinds[otherKeybind] == keyJustPressed)
						{
							FlxG.camera.shake(0.05, 0.1);
							FlxG.sound.play(Paths.sound('missnote'), 0.9);

							updateText(currentKeybind, false);
							updateText(otherKeybindText, false);

							currentKeybind.text = oldKeybindText;
		
							state = KeybindState.SelectControl;
							return;
						}
						else
						{
							controlKeybinds[curKeybindSelected] = keyJustPressed;
						}
						
						KeybindPrefs.keybinds.set(currentUIControl.controlName, controlKeybinds);
						PlayerSettings.player1.controls.setKeyboardScheme(Custom);
	
						FlxG.sound.play(Paths.sound('confirmMenu'));
	
						currentKeybind.text = keyJustPressed.toString();
						
						updateText(currentKeybind, false);
						updateText(otherKeybindText, false);
	
						state = KeybindState.SelectControl;
					}
				}
		}
		if (back)
		{
			switch (state)
			{
				case SelectControl:
					KeybindPrefs.saveControls();
					FlxG.switchState(new OptionsMenu());
				case SelectKeybind:
					updateText(currentKeybind, false);
					state = SelectControl;
				case KeybindState.ChangeKeybind:
			}
		}
	}
	function addControlText(uiControl:ControlUI, order:Int)
	{
		var uiControlKeybinds = KeybindPrefs.keybinds.get(uiControl.controlName);

		var keybindTexts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();

		var control:FlxText = new FlxText((FlxG.width / 2) - 200, (preset.y + 125) + (order * 100), 0, uiControl.uiName + ":", 32);
		control.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		control.borderSize = 2;
		control.antialiasing = true;
		add(control);

		controlTexts.push(control);
		selectableItems.push(control);

		for (j in 0...uiControlKeybinds.length)
		{
			var inputKeybind = uiControlKeybinds[j];
			var keybind:FlxText = new FlxText(control.x, control.y, 0, inputKeybind.toString(), 32);
			switch (j)
			{
				case 0:
					keybind.x = (FlxG.width / 2) + (j * 50);
				default:
					keybind.x = (FlxG.width / 2) + (j * 50) + keybindTexts.members[j - 1].width;
			}
			keybind.y = control.y;
			keybind.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
			keybind.borderSize = 2;
			keybind.antialiasing = true;
			add(keybind);

			keybindTexts.add(keybind);
		}
		var controlGroup = new TextGroup('controlGroup', keybindTexts);
		controlGroups.push(controlGroup);
		textGroups.push(controlGroup);
	}
	function createPresetUI()
	{
		var arrowOffset:Float = 100;
		var keybindPresetGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
		
		choosePreset = new FlxText(0, 175, FlxG.width / 2, LanguageManager.getTextString('keybind_preset'), 32);
		choosePreset.screenCenter(X);
		choosePreset.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		choosePreset.borderSize = 2;
		choosePreset.antialiasing = true;
		keybindPresetGroup.add(choosePreset);
		add(choosePreset);

		preset = new FlxText(0, choosePreset.y + 75, FlxG.width / 2, keybindPresets[curSelectedPreset], 32);
		preset.screenCenter(X);
		preset.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		preset.borderSize = 2;
		preset.antialiasing = true;
		add(preset);
		keybindPresetGroup.add(preset);
		selectableItems.push(preset);

		presetLeft = new FlxText(preset.x - arrowOffset, preset.y - preset.textField.height - 2, FlxG.width / 2, "<", 32);
		presetLeft.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		presetLeft.borderSize = 1;
		presetLeft.antialiasing = true;
		keybindPresetGroup.add(presetLeft);
		add(presetLeft);

		presetRight = new FlxText(preset.x + arrowOffset, preset.y - preset.textField.height - 2, FlxG.width / 2, ">", 32);
		presetRight.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		presetRight.borderSize = 1;
		presetRight.antialiasing = true;
		keybindPresetGroup.add(presetRight);
		add(presetRight);
		
		var presetGroup:TextGroup = new TextGroup('presetGroup', keybindPresetGroup);
		textGroups.push(presetGroup);

		changePresetSelection();
	}
	function changeSelection(amount:Int = 0)
	{
		curItemSelected += amount;
		if (amount != 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}

		if (curItemSelected > selectableItems.length - 1)
		{
			curItemSelected = 0;
		}
		if (curItemSelected < 0)
		{
			curItemSelected = selectableItems.length - 1;
		}
		curItem = selectableItems[curItemSelected];
		curTextGroup = textGroups[curItemSelected];
		
		for (item in selectableItems)
		{
			updateText(item, item == curItem);
		}
		camFollow.y = selectableItems[curItemSelected].y;
		if (curTextGroup.groupName == 'controlGroup')
		{
			currentUIControl = uiControls[controlGroups.indexOf(curTextGroup)];
		}
	}

	function changeKeybindSelection(amount:Int = 0)
	{
		curKeybindSelected += amount;
		if (amount != 0)
		{
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);
		}
		if (curKeybindSelected > curTextGroup.texts.length - 1)
		{
			curKeybindSelected = 0;
		}
		if (curKeybindSelected < 0)
		{
			curKeybindSelected = curTextGroup.texts.length - 1;
		}
		currentKeybind = curTextGroup.texts.members[curKeybindSelected];
		for (text in curTextGroup.texts)
		{
			updateText(text, text == currentKeybind);
		}
	}
	function changePresetSelection(amount:Int = 0)
	{
		curSelectedPreset += amount;

		if (curSelectedPreset > keybindPresets.length - 1)
		{
			curSelectedPreset = 0;
		}
		if (curSelectedPreset < 0)
		{
			curSelectedPreset = keybindPresets.length - 1;
		}
		curPreset = keybindPresets[curSelectedPreset];
		
		preset.text = curPreset;
		
		preset.y = (choosePreset.y + 40) - 30;
		preset.alpha = 0;
		FlxTween.tween(preset, {alpha: 1, y: preset.y + 30}, 0.07);

		presetLeft.x = preset.x - 100;
		presetRight.x = preset.x + 100;
	}
	function changePreset()
	{
		switch (curPreset)
		{
			case 'WASD':
				KeybindPrefs.setKeybindPreset(KeyboardScheme.Duo(true));
			case 'DFJK':
				KeybindPrefs.setKeybindPreset(KeyboardScheme.Solo);
			case 'ASKL':
				KeybindPrefs.setKeybindPreset(KeyboardScheme.Askl);
			case 'ZX,.':
				KeybindPrefs.setKeybindPreset(KeyboardScheme.ZxCommaDot);
		}
		FlxG.sound.play(Paths.sound('confirmMenu'));
		KeybindPrefs.saveControls();
		
		for (controlGroup in controlGroups)
		{
			for (text in controlGroup.texts)
			{
				FlxTween.tween(text, {alpha: 0}, 0.5);
			}
		}
		for (text in controlTexts)
		{
			FlxTween.tween(text, {alpha: 0}, 0.5);
		}
		FlxFlicker.flicker(preset, 1.1, 0.07, true, false, function(flicker:FlxFlicker)
		{
			FlxG.resetState();
		});
	}

	function updateText(text:FlxText, selected:Bool)
	{
		if (selected)
		{
			text.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			text.borderSize = 2;
		}
		else
		{
			text.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER);
		}
	}
}
enum KeybindState
{
	SelectControl; SelectKeybind; ChangeKeybind;
}
class TextGroup
{
	public var groupName:String;
	public var texts:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
	
	public function new(groupName:String, texts:FlxTypedGroup<FlxText>)
	{
		this.groupName = groupName;
		this.texts = texts;
	}
}
class ControlUI
{
	public var uiName:String;
	public var controlName:String;

	public function new(uiName:String, controlName:String)
	{
		this.uiName = uiName;
		this.controlName = controlName;
	}
}