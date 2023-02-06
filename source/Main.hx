package;

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

#if (hxCodec < "2.5.1")
#error "hxCodec is the haxelib version, please use the git version instead"
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

	public static final applicationName:String = "Friday Night Funkin' | Dave Engine";

	// You can pretty much ignore everything from here on - your code should go in your states.

	public static function main():Void
	{
		Lib.current.addChild(new Main());
	}

	public function new()
	{
		super();

		if (stage != null)
			init();
		else
			addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init(?E:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		}

		setupGame();
	}

	private function setupGame():Void
	{
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

		FlxG.signals.preSwitchState.add(function(){
			FlxG.bitmap.dumpCache();
			FlxG.sound.destroy(false);

			#if cpp
			cpp.vm.Gc.enable(true);
			#else
			openfl.system.System.gc();
			#end
		});

		FlxG.signals.postStateSwitch.add(function(){
			#if cpp
			cpp.vm.Gc.enable(true);
			#else
			openfl.system.System.gc();
			#end
		});

		addChild(new FlxGame(gameWidth, gameHeight, initialState, #if (flixel < "5.0.0") zoom, #end framerate, framerate, skipSplash, startFullscreen));

		fps = new FpsDisplay(10, 3, 0xFFFFFF);
		var fpsFormat = new TextFormat("_sans", 12, 0xFFFFFF, false);
		fps.defaultTextFormat = fpsFormat;
		addChild(fps);
	}
}
