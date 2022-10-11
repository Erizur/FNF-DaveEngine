package;
import Controls.KeyboardScheme;
import flixel.util.FlxSave;
import flixel.input.keyboard.FlxKey;

class KeybindPrefs
{
   public static var keybinds:Map<String, Array<FlxKey>> = new Map<String, Array<FlxKey>>();

   public static var defaultKeybinds:Map<String, Array<FlxKey>> = [
		'left'		=> [A, LEFT],
		'down'		=> [S, DOWN],
		'up'		   => [W, UP],
		'right'	   => [D, RIGHT],
		'accept'		=> [SPACE, ENTER],
		'back'	   => [BACKSPACE, ESCAPE],
		'pause'		=> [ENTER, ESCAPE],
		'reset'		=> [R, DELETE]
	];
	public static var controlNames:Array<String> = ['left', 'down', 'up', 'right', 'accept', 'back', 'pause', 'reset'];

	public static function saveControls()
	{
		var controlsSave:FlxSave = new FlxSave();
		controlsSave.bind('controls', 'ninjamuffin99');
		controlsSave.data.keybinds = keybinds;
		controlsSave.flush();
	}
	public static function loadControls()
	{
		var controlsSave:FlxSave = new FlxSave();
		controlsSave.bind('controls', 'ninjamuffin99');
		if (controlsSave != null && controlsSave.data.keybinds != null)
		{
			var funnyKeybinds:Map<String, Array<FlxKey>> = controlsSave.data.keybinds;
			setKeybinds(funnyKeybinds);
		}
		else
		{
			keybinds = defaultKeybinds.copy();
			saveControls();
		}
	}
	public static function setKeybinds(customControls:Map<String, Array<FlxKey>>)
	{
		for (controlName => key in customControls)
		{
			keybinds.set(controlName, key);
		}
		PlayerSettings.player1.controls.setKeyboardScheme(Custom);
	}
	public static function setKeybindPreset(scheme:KeyboardScheme)
	{
		PlayerSettings.player1.controls.setKeyboardScheme(scheme);

		var controls:Controls = PlayerSettings.player1.controls;
		for (control in controlNames)
		{
			keybinds.set(control, controls.getInputsFor(Controls.stringControlToControl(control), Controls.Device.Keys));
		}
	}
}