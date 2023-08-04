package;

import Controls;
import flixel.FlxG;

class PlayerSettings
{
	static public var player1(default, null):PlayerSettings;

	public final controls:Controls;

	function new(scheme)
	{
		this.controls = new Controls('', scheme);
	}

	public function setKeyboardScheme(scheme)
		controls.setKeyboardScheme(scheme);

	static public function init():Void
	{
		if (player1 == null)
			player1 = new PlayerSettings(Solo);

		var numGamepads = FlxG.gamepads.numActiveGamepads;
		if (numGamepads > 0)
		{
			var gamepad = FlxG.gamepads.getByID(0);
			if (gamepad == null)
				throw 'Unexpected null gamepad. id:0';

			player1.controls.addDefaultGamepad(0);
		}
	}
}
