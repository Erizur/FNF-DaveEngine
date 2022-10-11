package;

import flixel.input.gamepad.FlxGamepad;
import openfl.Lib;
import flixel.FlxG;

/**
 * handles save data initialization
*/
class SaveDataHandler
{
    public static function initSave()
    {
      if (FlxG.save.data.newInput == null)
			FlxG.save.data.newInput = true;
		
		if (FlxG.save.data.downscroll == null)
			FlxG.save.data.downscroll = false;

		if (FlxG.save.data.freeplayCuts == null)
			FlxG.save.data.freeplayCuts = false;

		if (FlxG.save.data.eyesores == null)
			FlxG.save.data.eyesores = true;

		if (FlxG.save.data.donoteclick == null)
			FlxG.save.data.donoteclick = false;

		if (FlxG.save.data.newInput != null && FlxG.save.data.lastversion == null)
			FlxG.save.data.lastversion = "pre-beta2";
		
		if (FlxG.save.data.newInput == null && FlxG.save.data.lastversion == null)
			FlxG.save.data.lastversion = "beta2";
		
		if (FlxG.save.data.songPosition == null)
			FlxG.save.data.songPosition = true;
		
		if (FlxG.save.data.noteCamera == null)
			FlxG.save.data.noteCamera = true;
		
		if (FlxG.save.data.offset == null)
			FlxG.save.data.offset = 0;

		if (FlxG.save.data.selfAwareness == null)
			FlxG.save.data.selfAwareness = true;
		
		if (FlxG.save.data.wasInCharSelect == null)
			FlxG.save.data.wasInCharSelect = false;

		if (FlxG.save.data.charactersUnlocked == null)
			FlxG.save.data.charactersUnlocked = ['bf', 'bf-pixel', 'bf-christmas']; // i didnt notice this was used to unlock characters woops -redstoneSC

		if (FlxG.save.data.disableFps == null)
			FlxG.save.data.disableFps = false;

    }
}