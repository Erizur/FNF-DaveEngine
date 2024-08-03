package;

// import haxe.Log;
import openfl.text.TextFormat;
import flixel.FlxGame;
import flixel.FlxState;
import openfl.Assets;
import openfl.Lib;
import openfl.display.FPS;
import openfl.display.Sprite;
import openfl.events.Event;
import flixel.system.FlxSound;
import flixel.FlxG;
import backend.SSPlugin as ScreenShotPlugin;
import debug.FpsDisplay;
#if CRASH_HANDLER
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.io.Path;
#end
#if sys
import sys.FileSystem;
import sys.io.File;
#end

class Main extends Sprite
{
	var gameWidth:Int = 1280; // Width of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var gameHeight:Int = 720; // Height of the game in pixels (might be less / more in actual pixels depending on your zoom).
	var initialState:Class<FlxState> = StartStateSelector; // The FlxState the game starts with.
	var zoom:Float = -1; // If -1, zoom is automatically calculated to fit the window dimensions.

	public static var framerate:Int = 144; // How many frames per second the game should run at.

	var skipSplash:Bool = false; // Whether to skip the flixel splash screen that appears in release mode.
	var startFullscreen:Bool = false; // Whether to start the game in fullscreen on desktop targets

	public static var fps:FpsDisplay;
	public static var funkinGame:FlxGame = null;

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());

		openfl.system.System.gc();
		#if cpp
		cpp.NativeGc.enable(true);
		cpp.NativeGc.run(true);
		#end
	}

	public function new()
	{
		super();

		final stageWidth:Int = Lib.current.stage.stageWidth;
		final stageHeight:Int = Lib.current.stage.stageHeight;

		if (zoom == -1)
		{
			final ratioX:Float = stageWidth / gameWidth;
			final ratioY:Float = stageHeight / gameHeight;
			zoom = Math.min(ratioX, ratioY);
			gameWidth = Math.ceil(stageWidth / zoom);
			gameHeight = Math.ceil(stageHeight / zoom);
		}

		FlxG.signals.preStateSwitch.add(function()
		{
			FlxG.bitmap.dumpCache();
			FlxG.sound.destroy(false);

			#if cpp
			cpp.NativeGc.enable(true);
			cpp.NativeGc.run(true);
			#end
			openfl.system.System.gc();
		});

		FlxG.signals.postStateSwitch.add(function()
		{
			#if cpp
			cpp.NativeGc.enable(true);
			cpp.NativeGc.run(true);
			#end
			openfl.system.System.gc();
		});
		backend.CrashHandler.init();

		FlxG.fixedTimestep = false;

		funkinGame = new FlxGame(gameWidth, gameHeight, initialState, #if (flixel < "5.0.0") zoom, #end framerate, framerate, skipSplash, startFullscreen); 
		addChild(funkinGame);

		fps = new FpsDisplay(10, 3, 0xFFFFFF);
		// fps.defaultTextFormat = new TextFormat("_sans", 12, 0xFFFFFF, false);
		addChild(fps);

		#if (!web && flixel < "5.5.0")
		FlxG.plugins.add(new ScreenShotPlugin());
		#elseif (flixel >= "5.6.0")
		FlxG.plugins.addIfUniqueType(new ScreenShotPlugin());
		#end

		#if FLX_SOUND_TRAY
		@:privateAccess
		{
			if (funkinGame._customSoundTray != null)
				funkinGame._customSoundTray = flixel.system.ui.DaveSoundTray;
		}
		#end
	}
}
