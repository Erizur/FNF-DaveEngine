package;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.util.FlxSave;

class CompatTool
{
    public static var save:FlxSave;

    public static function initSave()
    {
        save = new FlxSave();
        save.bind('compatcheck','ninjamuffin99');
    }
}