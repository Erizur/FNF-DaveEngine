package flixel.system;

import flixel.text.FlxText;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.Lib;
import flash.text.TextField;
import flash.text.TextFormat;
import flash.text.TextFormatAlign;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.graphics.frames.FlxAtlasFrames;
import sys.FileSystem;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

class FlxSplash extends FlxState
{
	public static var nextState:Class<FlxState>;

	/**
	 * @since 4.8.0
	 */
	public static var muted:Bool = #if html5 true #else false #end;

	var animatedIntro:FlxSprite;
	var animatedTex:FlxAtlasFrames;

	var _cachedBgColor:FlxColor;
	var _cachedTimestep:Bool;
	var _cachedAutoPause:Bool;
	var skipScreen:FlxText;

	override public function create():Void
	{
		_cachedBgColor = FlxG.cameras.bgColor;
		FlxG.cameras.bgColor = FlxColor.BLACK;

		// This is required for sound and animation to synch up properly
		_cachedTimestep = FlxG.fixedTimestep;
		FlxG.fixedTimestep = false;

		_cachedAutoPause = FlxG.autoPause;
		FlxG.autoPause = false;

		animatedTex = Paths.getSplashSparrowAtlas('ui/flixel_intro', 'preload');

		animatedIntro = new FlxSprite(0,0);
		animatedIntro.frames = animatedTex;
		animatedIntro.animation.addByPrefix('intro', 'intro', 24);
		animatedIntro.animation.play('intro');
		animatedIntro.updateHitbox();
		animatedIntro.antialiasing = false;
		animatedIntro.screenCenter();
		add(animatedIntro);

		new FlxTimer().start(0.636, timerCallback);

		var stageWidth:Int = Lib.current.stage.stageWidth;
		var stageHeight:Int = Lib.current.stage.stageHeight;

		onResize(stageWidth, stageHeight);

		#if FLX_SOUND_SYSTEM
		if (!muted)
		{
			FlxG.sound.load(Paths.sound("flixel", 'preload')).play();
		}
		#end
		if (FlxG.save.data.hasSeenSplash != null && FlxG.save.data.hasSeenSplash)
		{
			skipScreen = new FlxText(0, FlxG.height, 0, 'Press Enter To Skip', 16);
			skipScreen.setFormat("Comic Sans MS Bold", 18, FlxColor.WHITE, FlxTextAlign.LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			skipScreen.borderSize = 1.5;
			skipScreen.antialiasing = true;
			skipScreen.scrollFactor.set();
			skipScreen.alpha = 0;
			skipScreen.y -= skipScreen.textField.textHeight;
			add(skipScreen);

			FlxTween.tween(skipScreen, {alpha: 1}, 1);
		}
	}
	override public function update(elapsed:Float)
	{
		if (FlxG.save.data.hasSeenSplash && FlxG.keys.justPressed.ENTER)
		{
			onComplete(null);
		}
		super.update(elapsed);
	}

	override public function destroy():Void
	{
		super.destroy();
		animatedIntro.destroy();
	}

	override public function onResize(Width:Int, Height:Int):Void
	{
		super.onResize(Width, Height);
	}

	function timerCallback(Timer:FlxTimer):Void
	{
		FlxTween.tween(animatedIntro, {alpha: 0}, 3.0, {ease: FlxEase.quadOut, onComplete: onComplete});
	}

	function onComplete(Tween:FlxTween):Void
	{
		FlxG.cameras.bgColor = _cachedBgColor;
		FlxG.fixedTimestep = _cachedTimestep;
		FlxG.autoPause = _cachedAutoPause;
		#if FLX_KEYBOARD
		FlxG.keys.enabled = true;
		#end
		FlxG.switchState(Type.createInstance(nextState, []));
		FlxG.game._gameJustStarted = true;

		if (FlxG.save.data.hasSeenSplash == null)
		{
			FlxG.save.data.hasSeenSplash = true;
			FlxG.save.flush();
		}
	}
}
