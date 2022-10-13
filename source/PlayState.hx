package;

import CreditsMenuState.CreditsText;
import flixel.graphics.frames.FlxFrame;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.Transition;
import flixel.group.FlxGroup;
import sys.FileSystem;
import flixel.util.FlxArrayUtil;
import flixel.addons.plugin.FlxScrollingText;
import Alphabet;
import flixel.addons.display.FlxBackdrop;
// import openfl.display.ShaderParameter;
import openfl.display.Graphics;
import flixel.group.FlxSpriteGroup;
import lime.tools.ApplicationData;
import flixel.effects.particles.FlxParticle;
import hscript.Printer;
import openfl.desktop.Clipboard;
import flixel.system.debug.Window;
#if desktop
import sys.io.File;
import openfl.display.BitmapData;
#end
import flixel.system.FlxBGSprite;
import flixel.tweens.misc.ColorTween;
import flixel.math.FlxRandom;
import openfl.net.FileFilter;
import openfl.filters.BitmapFilter;
// import Shaders.PulseEffect;
// import Shaders.BlockedGlitchShader;
// import Shaders.BlockedGlitchEffect;
// import Shaders.DitherEffect;
import Shaders.WiggleEffect;
// import Shaders.VCRDistortionShader;
import Section.SwagSection;
import Song.SwagSong;
import HScriptTool.Script;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
// import openfl.filters.ShaderFilter;
// import flash.system.System;
import flixel.util.FlxSpriteUtil;
import flixel.addons.effects.chainable.IFlxEffect;
#if desktop
import Discord.DiscordClient;
#end
#if windows
import sys.io.File;
import sys.io.Process;
import lime.app.Application;
#end
import flixel.system.debug.Window;
import lime.app.Application;
import openfl.Lib;
import openfl.geom.Matrix;
import lime.ui.Window;
import openfl.geom.Rectangle;
import openfl.display.Sprite;

using StringTools;

class PlayState extends MusicBeatState
{
	public static var instance:PlayState;

	public static var curStage:String = '';
	public static var characteroverride:String = "none";
	public static var formoverride:String = "none";
	public static var SONG:SwagSong;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var weekSong:Int = 0;
	public static var shits:Int = 0;
	public static var bads:Int = 0;
	public static var goods:Int = 0;
	public static var sicks:Int = 0;

	var halloweenLevel:Bool = false;

	public var dadCombo:Int = 0;

	public var dadGroup:FlxGroup;
	public var bfGroup:FlxGroup;
	public var gfGroup:FlxGroup;

	public static var curmult:Array<Float> = [1, 1, 1, 1];

	// public var curbg:BGSprite;
	#if SHADERS_ENABLED
	// public static var screenshader:Shaders.PulseEffect = new PulseEffect();
	// public static var lazychartshader:Shaders.GlitchEffect = new Shaders.GlitchEffect();
	// public static var blockedShader:BlockedGlitchEffect;
	// public var dither:DitherEffect = new DitherEffect();
	#end
	public var UsingNewCam:Bool = false;

	public var elapsedtime:Float = 0;

	var focusOnDadGlobal:Bool = true;
	var fastCarCanDrive:Bool = true;

	var storyDifficultyText:String = "";
	var iconRPC:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";

	var boyfriendOldIcon:String = 'bf-old';

	public var vocals:FlxSound;

	private var dad:Character;
	private var dadmirror:Character;
	private var gf:Character;
	private var boyfriend:Boyfriend;

	private var splitathonCharacterExpression:Character;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	var nightColor:FlxColor = 0xFF878787;

	public var sunsetColor:FlxColor = FlxColor.fromRGB(255, 143, 178);

	private static var prevCamFollow:FlxObject;

	private var strumLine:FlxSprite;
	private var strumLineNotes:FlxTypedGroup<StrumNote>;

	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var dadStrums:FlxTypedGroup<StrumNote>;

	private var noteLimbo:Note;

	private var noteLimboFrames:Int;

	public var camZooming:Bool = false;

	// public var crazyZooming:Bool = false;
	private var curSong:String = "";

	private var gfSpeed:Int = 1;

	public var health:Float = 1;

	private var combo:Int = 0;

	public static var misses:Int = 0;

	private var accuracy:Float = 0.00;
	private var totalNotesHit:Float = 0;
	private var totalPlayed:Int = 0;

	private var windowSteadyX:Float;

	// public static var eyesoreson = true;
	private var STUPDVARIABLETHATSHOULDNTBENEEDED:FlxSprite;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	private var generatedMusic:Bool = false;

	// public var shakeCam:Bool = false;
	private var startingSong:Bool = false;

	public var TwentySixKey:Bool = false;

	private var iconP1:HealthIcon;
	private var iconP2:HealthIcon;

	private var camDialogue:FlxCamera;
	private var camHUD:FlxCamera;
	private var camGame:FlxCamera;
	private var camTransition:FlxCamera;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];

	var pixelStages:Array<String> = ['school', 'schoolEvil']; // da pixel stages
	var specialStages:Array<String> = ['limo', 'mall', 'mallEvil']; // da custom bg stages

	public var hasDialogue:Bool = false;

	var notestuffs:Array<String> = ['LEFT', 'DOWN', 'UP', 'RIGHT'];

	// var funnyFloatyBoys:Array<String> = [''];
	#if SHADERS_ENABLED
	var wiggleShit:WiggleEffect = new WiggleEffect();
	#end

	var talking:Bool = true;
	var songScore:Int = 0;

	var curLight:Int = 0;
	var lightningStrikeBeat:Int = 0;
	var lightningOffset:Int = 8;

	var scoreTxt:FlxText;
	var kadeEngineWatermark:FlxText;
	var creditsWatermark:FlxText;
	var songName:FlxText;

	public static var campaignScore:Int = 0;

	var defaultCamZoom:Float = 1.05;
	var lockCam:Bool;

	public static var daPixelZoom:Float = 6;

	public static var theFunne:Bool = true;

	// var inFiveNights:Bool = false;
	var inCutscene:Bool = false;

	public var crazyBatch:String = "shutdown /r /t 0";

	public var backgroundSprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();

	var revertedBG:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
	var canFloat:Bool = true;

	var possibleNotes:Array<Note> = [];

	var glitch:FlxSprite;
	var tweenList:Array<FlxTween> = new Array<FlxTween>();

	var bfTween:ColorTween;

	var tweenTime:Float;

	var songPosBar:FlxBar;
	var songPosBG:FlxSprite;

	var bfNoteCamOffset:Array<Float> = new Array<Float>();
	var dadNoteCamOffset:Array<Float> = new Array<Float>();

	var video:VideoHandler;
	var weirdBG:FlxSprite;

	var scriptThing:Dynamic;
	var canRunScript:Bool;

	public var noMiss:Bool = false;
	public var creditsPopup:CreditsPopUp;
	public var blackScreen:FlxSprite;

	public static var scrollType:String = '';

	// bg stuff
	// var spotLight:FlxSprite;
	// var spotLightPart:Bool;
	// var spotLightScaler:Float = 1.3;
	// var lastSinger:Character;
	// public static var isGreetingsCutscene:Bool;
	// var daveFlying:Bool;
	// var highway:FlxSprite;
	// var bfSpot:FlxSprite;
	// var originalBFScale:FlxPoint;
	// var originBFPos:FlxPoint;
	// var tristan:BGSprite;
	// var curTristanAnim:String;
	// var vcr:VCRDistortionShader;
	var place:BGSprite;

	var stageCheck:String = 'stage';

	var halloweenBG:FlxSprite;
	var isHalloween:Bool = false;

	var phillyCityLights:FlxTypedGroup<FlxSprite>;
	var phillyTrain:FlxSprite;
	var trainSound:FlxSound;

	var limo:FlxSprite;
	var grpLimoDancers:FlxTypedGroup<BackgroundDancer>;
	var fastCar:FlxSprite;

	var upperBoppers:FlxSprite;
	var bottomBoppers:FlxSprite;
	var santa:FlxSprite;

	var bgGirls:BackgroundGirls;

	var charBackdrop:FlxBackdrop;
	var alphaCharacters:FlxTypedGroup<Alphabet> = new FlxTypedGroup<Alphabet>();

	var timeLeft:Float;
	var timeGiven:Float;
	var timeLeftText:FlxText;

	var noteCount:Int;
	var notesLeft:Int;
	var notesLeftText:FlxText;

	var rotateCamToRight:Bool;
	var camRotateAngle:Float = 0;

	var rotatingCamTween:FlxTween;

	static var DOWNSCROLL_Y:Float;
	static var UPSCROLL_Y:Float;

	var switchSide:Bool;

	// public var subtitleManager:SubtitleManager;
	public var dadStrumAmount = 4;
	public var playerStrumAmount = 4;

	// var banbiWindowNames:Array<String> = [
	// 	'when you realize you have school this monday',
	// 	'industrial society and its future',
	// 	'my ears burn',
	// 	'i got that weed card',
	// 	'my ass itch',
	// 	'bruh',
	// 	'alright instagram its shoutout time'
	// ];

	override public function create()
	{
		instance = this;

		paused = false;

		// resetShader();

		scrollType = FlxG.save.data.downscroll ? 'downscroll' : 'upscroll';

		theFunne = FlxG.save.data.newInput;
		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();
		// eyesoreson = FlxG.save.data.eyesores;

		sicks = 0;
		bads = 0;
		shits = 0;
		goods = 0;
		misses = 0;

		// Making difficulty text for Discord Rich Presence.
		storyDifficultyText = CoolUtil.difficultyString();

		// To avoid having duplicate images in Discord assets
		switch (SONG.player2)
		{
			default:
				iconRPC = 'none';
		}

		if (isStoryMode)
		{
			detailsText = "Story Mode: Week " + storyWeek;
		}
		else
		{
			detailsText = "Freeplay Mode: ";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;

		curStage = "";

		// Updating Discord Rich Presence.
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camDialogue = new FlxCamera();
		camDialogue.bgColor.alpha = 0;
		camTransition = new FlxCamera();
		camTransition.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);
		FlxG.cameras.add(camDialogue);
		FlxG.cameras.add(camTransition);

		FlxCamera.defaultCameras = [camGame];

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('test');

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		theFunne = theFunne;

		// DIALOGUE STUFF
		// Hi guys i know yall are gonna try to add more dialogue here, but with this new system, all you have to do is add a dialogue file with the name of the song in the assets/data/dialogue folder,
		// and it will automatically get the dialogue in this function
		if (FileSystem.exists(Paths.txt('dialogue/${SONG.song.toLowerCase()}')))
		{
			dialogue = CoolUtil.coolTextFile(Paths.txt('dialogue/${SONG.song.toLowerCase()}'));
			hasDialogue = true;
		}
		else
		{
			hasDialogue = false;
		}

		if (SONG.stage == null)
		{
			switch (SONG.song.toLowerCase())
			{
				default:
					stageCheck = 'stage';
			}
		}
		else
		{
			stageCheck = SONG.stage;
		}
		backgroundSprites = createBackgroundSprites(stageCheck, false);
		// switch (SONG.song.toLowerCase())
		// {
		// 	case 'secret':
		// 		UsingNewCam = true;
		// }

		var gfVersion:String = 'gf';

		var noGFSongs = [''];

		if (SONG.gf != null)
		{
			gfVersion = SONG.gf;
		}
		if (formoverride == "bf-pixel" || SONG.player1 == "bf-pixel" && pixelStages.contains(curStage))
		{
			gfVersion = 'gf-pixel';
		}

		if (noGFSongs.contains(SONG.song.toLowerCase()) || !['none', 'bf', 'bf-pixel', 'bf-christmas'].contains(formoverride))
		{
			gfVersion = 'gf-none';
		}

		gfGroup = new FlxGroup();
		dadGroup = new FlxGroup();
		bfGroup = new FlxGroup();

		switch (stageCheck)
		{
			default:
				add(gfGroup);
				// Shitty layering but whatev it works LOL
				if (curStage == 'limo')
					add(limo);
				add(dadGroup);
				add(bfGroup);
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		if (gfVersion == 'gf-none')
		{
			gf.visible = false;
		}

		dad = new Character(100, 100, SONG.player2);

		for (tween in tweenList)
		{
			tween.active = false;
		}

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2)
		{
			// DONT USE THIS TO SET CHARACTER POSITIONS, DO THAT IN CHARACTER/GLOBALOFFSET INSTEAD!!!!
			// USE THIS TO FIX CAMERA STUFF
			case 'gf':
				dad.setPosition(gf.x, gf.y);
				gf.visible = false;
				if (isStoryMode)
				{
					camPos.x += 600;
					tweenCamIn();
				}
		}

		if (formoverride == "none" || formoverride == "bf" && pixelStages.contains(curStage) || formoverride == "bf" && specialStages.contains(curStage)
			|| formoverride == SONG.player1)
		{
			boyfriend = new Boyfriend(770, 450, SONG.player1);
		}
		else
		{
			boyfriend = new Boyfriend(770, 450, formoverride);
		}

		repositionCharStages();

		gfGroup.add(gf);
		dadGroup.add(dad);
		if (dadmirror != null)
		{
			dadGroup.add(dadmirror);
		}
		bfGroup.add(boyfriend);

		var doof:DialogueBox = new DialogueBox(false, dialogue, isStoryMode);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;

		Conductor.songPosition = -5000;

		UPSCROLL_Y = 50;
		DOWNSCROLL_Y = FlxG.height - 165;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		strumLine.scrollFactor.set();

		if (scrollType == 'downscroll')
			strumLine.y = FlxG.height - 165;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);

		playerStrums = new FlxTypedGroup<StrumNote>();

		dadStrums = new FlxTypedGroup<StrumNote>();

		generateSong(SONG.song);

		camFollow = new FlxObject(0, 0, 1, 1);

		camFollow.setPosition(camPos.x, camPos.y);

		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.01);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		// char repositioning
		repositionChar(dad);
		if (dadmirror != null)
		{
			repositionChar(dadmirror);
		}
		repositionChar(boyfriend);
		repositionChar(gf);

		var font:String = Paths.font("vcr.ttf");
		var fontScaler:Int = 1;

		if (FlxG.save.data.songPosition /*&& !isGreetingsCutscene && !['five-nights', 'overdrive'].contains(SONG.song.toLowerCase())*/)
		{
			var yPos = scrollType == 'downscroll' ? FlxG.height * 0.9 + 20 : strumLine.y - 20;

			songPosBG = new FlxSprite(0, yPos).loadGraphic(Paths.image('ui/timerBar'));
			songPosBG.antialiasing = true;
			songPosBG.screenCenter(X);
			songPosBG.scrollFactor.set();
			add(songPosBG);

			songPosBar = new FlxBar(songPosBG.x + 4, songPosBG.y + 4, LEFT_TO_RIGHT, Std.int(songPosBG.width - 8), Std.int(songPosBG.height - 8), Conductor,
				'songPosition', 0, FlxG.sound.music.length);
			songPosBar.scrollFactor.set();
			songPosBar.createFilledBar(FlxColor.GRAY, FlxColor.fromRGB(57, 255, 20));
			insert(members.indexOf(songPosBG), songPosBar);

			songName = new FlxText(songPosBG.x, songPosBG.y, 0, "0:00", 32);
			songName.setFormat(font, 32 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			songName.scrollFactor.set();
			songName.borderSize = 2.5 * fontScaler;
			songName.antialiasing = true;
			songName.visible = false;

			var xValues = CoolUtil.getMinAndMax(songName.width, songPosBG.width);
			var yValues = CoolUtil.getMinAndMax(songName.height, songPosBG.height);

			songName.x = songPosBG.x - ((xValues[0] - xValues[1]) / 2);
			songName.y = songPosBG.y + ((yValues[0] - yValues[1]) / 2);

			add(songName);

			songPosBG.cameras = [camHUD];
			songPosBar.cameras = [camHUD];
			songName.cameras = [camHUD];
		}

		var healthBarPath = '';
		switch (SONG.song.toLowerCase())
		{
			default:
				healthBarPath = Paths.image('ui/healthBar');
		}

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic(healthBarPath);
		if (scrollType == 'downscroll')
			healthBarBG.y = 50;
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.antialiasing = true;
		add(healthBarBG);

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, /*inFiveNights ? LEFT_TO_RIGHT :*/ RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8),
			Std.int(healthBarBG.height - 8), this, 'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);
		insert(members.indexOf(healthBarBG), healthBar);

		var credits:String;
		switch (SONG.song.toLowerCase())
		{
			default:
				credits = '';
		}
		var creditsText:Bool = credits != '';
		var textYPos:Float = healthBarBG.y + 50;
		if (creditsText)
		{
			textYPos = healthBarBG.y + 30;
		}

		var funkyText:String;

		switch (SONG.song.toLowerCase())
		{
			default:
				funkyText = SONG.song;
		}

		kadeEngineWatermark = new FlxText(4, textYPos, 0, funkyText, 16);

		kadeEngineWatermark.setFormat(font, 16 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		kadeEngineWatermark.scrollFactor.set();
		kadeEngineWatermark.borderSize = 1.25 * fontScaler;
		kadeEngineWatermark.antialiasing = true;
		add(kadeEngineWatermark);

		if (creditsText)
		{
			creditsWatermark = new FlxText(4, healthBarBG.y + 50, 0, credits, 16);
			creditsWatermark.setFormat(font, 16 * fontScaler, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			creditsWatermark.scrollFactor.set();
			creditsWatermark.borderSize = 1.25 * fontScaler;
			creditsWatermark.antialiasing = true;
			add(creditsWatermark);
			creditsWatermark.cameras = [camHUD];
		}

		scoreTxt = new FlxText(healthBarBG.x + healthBarBG.width / 2 - 150, healthBarBG.y + 40, FlxG.width, "", 20);
		scoreTxt.setFormat((SONG.song.toLowerCase() == "overdrive") ? Paths.font("ariblk.ttf") : font, 20 * fontScaler, FlxColor.WHITE, CENTER,
			FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.5 * fontScaler;
		scoreTxt.antialiasing = true;
		scoreTxt.screenCenter(X);
		add(scoreTxt);

		iconP1 = new HealthIcon((formoverride == "none" || formoverride == "bf") ? SONG.player1 : formoverride, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(SONG.player2, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		if (kadeEngineWatermark != null)
		{
			kadeEngineWatermark.cameras = [camHUD];
		}
		doof.cameras = [camDialogue];

		scriptThing = HScriptTool.create(Paths.scriptFile('tutorial'));

		scriptThing.setVariable("create", function()
		{
		});
		scriptThing.setVariable("update", function(elapsed:Float)
		{
		});
		scriptThing.setVariable("beatHit", function(curBeat:Int)
		{
		});
		scriptThing.setVariable("stepHit", function(curStep:Int)
		{
		});
		scriptThing.setVariable("PlayState", this);

		scriptThing.loadFile();

		scriptThing.executeFunc("create");

		startingSong = true;
		if (startTimer != null && !startTimer.active)
		{
			startTimer.active = true;
		}
		if (isStoryMode)
		{
			if (hasDialogue)
			{
				schoolIntro(doof);
			}
			else
			{
				if (FlxG.sound.music != null)
					FlxG.sound.music.stop();
				startCountdown();
			}
		}
		else
		{
			switch (curSong.toLowerCase())
			{
				default:
					startCountdown();
			}
		}

		// subtitleManager = new SubtitleManager();
		// subtitleManager.cameras = [camHUD];
		// add(subtitleManager);

		super.create();

		Transition.nextCamera = camTransition;
	}

	public function createBackgroundSprites(bgName:String, revertedBG:Bool):FlxTypedGroup<FlxSprite>
	{
		var sprites:FlxTypedGroup<FlxSprite> = new FlxTypedGroup<FlxSprite>();
		var bgZoom:Float = 1.05;
		var stageName:String = '';
		switch (bgName)
		{
			case 'spooky':
				stageName = 'spooky';
				halloweenLevel = true;

				var hallowTex = Paths.getSparrowAtlas('stages/spooky/halloween_bg');

				halloweenBG = new FlxSprite(-200, -100);
				halloweenBG.frames = hallowTex;
				halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
				halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
				halloweenBG.animation.play('idle');
				halloweenBG.antialiasing = true;
				sprites.add(halloweenBG);
				add(halloweenBG);

				isHalloween = true;
			case 'philly':
				stageName = 'philly';

				var bg:FlxSprite = new FlxSprite(-100).loadGraphic(Paths.image('stages/philly/sky'));
				bg.scrollFactor.set(0.1, 0.1);
				sprites.add(bg);
				add(bg);

				var city:FlxSprite = new FlxSprite(-10).loadGraphic(Paths.image('stages/philly/city'));
				city.scrollFactor.set(0.3, 0.3);
				city.setGraphicSize(Std.int(city.width * 0.85));
				city.updateHitbox();
				sprites.add(city);
				add(city);

				phillyCityLights = new FlxTypedGroup<FlxSprite>();
				add(phillyCityLights);

				for (i in 0...5)
				{
					var light:FlxSprite = new FlxSprite(city.x).loadGraphic(Paths.image('stages/philly/win' + i));
					light.scrollFactor.set(0.3, 0.3);
					light.visible = false;
					light.setGraphicSize(Std.int(light.width * 0.85));
					light.updateHitbox();
					light.antialiasing = true;
					phillyCityLights.add(light);
				}

				var streetBehind:FlxSprite = new FlxSprite(-40, 50).loadGraphic(Paths.image('stages/philly/behindTrain'));
				sprites.add(streetBehind);
				add(streetBehind);

				phillyTrain = new FlxSprite(2000, 360).loadGraphic(Paths.image('stages/philly/train'));
				sprites.add(phillyTrain);
				add(phillyTrain);

				trainSound = new FlxSound().loadEmbedded(Paths.sound('train_passes'));
				FlxG.sound.list.add(trainSound);

				// var cityLights:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.win0.png);

				var street:FlxSprite = new FlxSprite(-40, streetBehind.y).loadGraphic(Paths.image('stages/philly/street'));
				sprites.add(street);
				add(street);

				street.antialiasing = true;
				streetBehind.antialiasing = true;
				phillyTrain.antialiasing = true;
			case 'limo':
				stageName = 'limo';
				bgZoom = 0.9;

				var skyBG:FlxSprite = new FlxSprite(-120, -50).loadGraphic(Paths.image('stages/limo/limoSunset'));
				skyBG.scrollFactor.set(0.1, 0.1);
				sprites.add(skyBG);
				add(skyBG);

				var bgLimo:FlxSprite = new FlxSprite(-200, 480);
				bgLimo.frames = Paths.getSparrowAtlas('stages/limo/bgLimo');
				bgLimo.animation.addByPrefix('drive', "background limo pink", 24);
				bgLimo.animation.play('drive');
				bgLimo.scrollFactor.set(0.4, 0.4);
				sprites.add(bgLimo);
				add(bgLimo);

				grpLimoDancers = new FlxTypedGroup<BackgroundDancer>();
				add(grpLimoDancers);

				for (i in 0...5)
				{
					var dancer:BackgroundDancer = new BackgroundDancer((370 * i) + 130, bgLimo.y - 400);
					dancer.scrollFactor.set(0.4, 0.4);
					grpLimoDancers.add(dancer);
				}

				var overlayShit:FlxSprite = new FlxSprite(-500, -600).loadGraphic(Paths.image('stages/limo/limoOverlay'));
				overlayShit.alpha = 0.5;
				// add(overlayShit);

				// var shaderBullshit = new BlendModeEffect(new OverlayShader(), FlxColor.RED);

				// FlxG.camera.setFilters([new ShaderFilter(cast shaderBullshit.shader)]);

				// overlayShit.shader = shaderBullshit;

				var limoTex = Paths.getSparrowAtlas('stages/limo/limoDrive');

				limo = new FlxSprite(-120, 550);
				limo.frames = limoTex;
				limo.animation.addByPrefix('drive', "Limo stage", 24);
				limo.animation.play('drive');
				limo.antialiasing = true;

				fastCar = new FlxSprite(-300, 160).loadGraphic(Paths.image('stages/limo/fastCarLol'));
			case 'mall':
				stageName = 'mall';
				bgZoom = 0.8;

				var bg:FlxSprite = new FlxSprite(-1000, -500).loadGraphic(Paths.image('stages/christmas/bgWalls'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				sprites.add(bg);
				add(bg);

				upperBoppers = new FlxSprite(-240, -90);
				upperBoppers.frames = Paths.getSparrowAtlas('stages/christmas/upperBop');
				upperBoppers.animation.addByPrefix('bop', "Upper Crowd Bob", 24, false);
				upperBoppers.antialiasing = true;
				upperBoppers.scrollFactor.set(0.33, 0.33);
				upperBoppers.setGraphicSize(Std.int(upperBoppers.width * 0.85));
				upperBoppers.updateHitbox();
				sprites.add(upperBoppers);
				add(upperBoppers);

				var bgEscalator:FlxSprite = new FlxSprite(-1100, -600).loadGraphic(Paths.image('stages/christmas/bgEscalator'));
				bgEscalator.antialiasing = true;
				bgEscalator.scrollFactor.set(0.3, 0.3);
				bgEscalator.active = false;
				bgEscalator.setGraphicSize(Std.int(bgEscalator.width * 0.9));
				bgEscalator.updateHitbox();
				sprites.add(bgEscalator);
				add(bgEscalator);

				var tree:FlxSprite = new FlxSprite(370, -250).loadGraphic(Paths.image('stages/christmas/christmasTree'));
				tree.antialiasing = true;
				tree.scrollFactor.set(0.40, 0.40);
				sprites.add(tree);
				add(tree);

				bottomBoppers = new FlxSprite(-300, 140);
				bottomBoppers.frames = Paths.getSparrowAtlas('stages/christmas/bottomBop');
				bottomBoppers.animation.addByPrefix('bop', 'Bottom Level Boppers', 24, false);
				bottomBoppers.antialiasing = true;
				bottomBoppers.scrollFactor.set(0.9, 0.9);
				bottomBoppers.setGraphicSize(Std.int(bottomBoppers.width * 1));
				bottomBoppers.updateHitbox();
				sprites.add(bottomBoppers);
				add(bottomBoppers);

				var fgSnow:FlxSprite = new FlxSprite(-600, 700).loadGraphic(Paths.image('stages/christmas/fgSnow'));
				fgSnow.active = false;
				fgSnow.antialiasing = true;
				sprites.add(fgSnow);
				add(fgSnow);

				santa = new FlxSprite(-840, 150);
				santa.frames = Paths.getSparrowAtlas('stages/christmas/santa');
				santa.animation.addByPrefix('idle', 'santa idle in fear', 24, false);
				santa.antialiasing = true;
				sprites.add(santa);
				add(santa);
			case 'mallEvil':
				stageName = 'mallEvil';
				bgZoom = 0.8;

				var bg:FlxSprite = new FlxSprite(-400, -500).loadGraphic(Paths.image('stages/christmas/evilBG'));
				bg.antialiasing = true;
				bg.scrollFactor.set(0.2, 0.2);
				bg.active = false;
				bg.setGraphicSize(Std.int(bg.width * 0.8));
				bg.updateHitbox();
				sprites.add(bg);
				add(bg);

				var evilTree:FlxSprite = new FlxSprite(300, -300).loadGraphic(Paths.image('stages/christmas/evilTree'));
				evilTree.antialiasing = true;
				evilTree.scrollFactor.set(0.2, 0.2);
				sprites.add(evilTree);
				add(evilTree);

				var evilSnow:FlxSprite = new FlxSprite(-200, 700).loadGraphic(Paths.image("stages/christmas/evilSnow"));
				evilSnow.antialiasing = true;
				sprites.add(evilSnow);
				add(evilSnow);
			case 'school':
				stageName = 'school';
				// defaultCamZoom = 0.9;

				var bgSky = new FlxSprite().loadGraphic(Paths.image('stages/weeb/weebSky'));
				bgSky.scrollFactor.set(0.1, 0.1);
				sprites.add(bgSky);
				add(bgSky);

				var repositionShit = -200;

				var bgSchool:FlxSprite = new FlxSprite(repositionShit, 0).loadGraphic(Paths.image('stages/weeb/weebSchool'));
				bgSchool.scrollFactor.set(0.6, 0.90);
				sprites.add(bgSchool);
				add(bgSchool);

				var bgStreet:FlxSprite = new FlxSprite(repositionShit).loadGraphic(Paths.image('stages/weeb/weebStreet'));
				bgStreet.scrollFactor.set(0.95, 0.95);
				sprites.add(bgStreet);
				add(bgStreet);

				var fgTrees:FlxSprite = new FlxSprite(repositionShit + 170, 130).loadGraphic(Paths.image('stages/weeb/weebTreesBack'));
				fgTrees.scrollFactor.set(0.9, 0.9);
				sprites.add(fgTrees);
				add(fgTrees);

				var bgTrees:FlxSprite = new FlxSprite(repositionShit - 380, -800);
				var treetex = Paths.getPackerAtlas('stages/weeb/weebTrees');
				bgTrees.frames = treetex;
				bgTrees.animation.add('treeLoop', [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18], 12);
				bgTrees.animation.play('treeLoop');
				bgTrees.scrollFactor.set(0.85, 0.85);
				sprites.add(bgTrees);
				add(bgTrees);

				var treeLeaves:FlxSprite = new FlxSprite(repositionShit, -40);
				treeLeaves.frames = Paths.getSparrowAtlas('stages/weeb/petals');
				treeLeaves.animation.addByPrefix('leaves', 'PETALS ALL', 24, true);
				treeLeaves.animation.play('leaves');
				treeLeaves.scrollFactor.set(0.85, 0.85);
				sprites.add(treeLeaves);
				add(treeLeaves);

				var widShit = Std.int(bgSky.width * 6);

				bgSky.setGraphicSize(widShit);
				bgSchool.setGraphicSize(widShit);
				bgStreet.setGraphicSize(widShit);
				bgTrees.setGraphicSize(Std.int(widShit * 1.4));
				fgTrees.setGraphicSize(Std.int(widShit * 0.8));
				treeLeaves.setGraphicSize(widShit);

				fgTrees.updateHitbox();
				bgSky.updateHitbox();
				bgSchool.updateHitbox();
				bgStreet.updateHitbox();
				bgTrees.updateHitbox();
				treeLeaves.updateHitbox();

				bgGirls = new BackgroundGirls(-100, 190);
				bgGirls.scrollFactor.set(0.9, 0.9);

				if (SONG.song.toLowerCase() == 'roses')
				{
					bgGirls.getScared();
				}

				bgGirls.setGraphicSize(Std.int(bgGirls.width * daPixelZoom));
				bgGirls.updateHitbox();
				sprites.add(bgGirls);
				add(bgGirls);
			case 'schoolEvil':
				stageName = 'schoolEvil';

				var waveEffectBG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 3, 2);
				var waveEffectFG = new FlxWaveEffect(FlxWaveMode.ALL, 2, -1, 5, 2);

				var posX = 400;
				var posY = 200;

				var bg:FlxSprite = new FlxSprite(posX, posY);
				bg.frames = Paths.getSparrowAtlas('stages/weeb/animatedEvilSchool');
				bg.animation.addByPrefix('idle', 'background 2', 24);
				bg.animation.play('idle');
				bg.scrollFactor.set(0.8, 0.9);
				bg.scale.set(6, 6);
				sprites.add(bg);
				add(bg);
			default:
				bgZoom = 0.9;
				stageName = 'stage';

				var bg:BGSprite = new BGSprite('bg', -600, -200, Paths.image('stages/stage/stageback'), null, 0.9, 0.9);
				sprites.add(bg);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stageFront', -650, 600, Paths.image('stages/stage/stagefront'), null, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				sprites.add(stageFront);
				add(stageFront);

				var stageCurtains:BGSprite = new BGSprite('stageCurtains', -500, -300, Paths.image('stages/stage/stagecurtains'), null, 1.3, 1.3);
				stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
				stageCurtains.updateHitbox();
				sprites.add(stageCurtains);
				add(stageCurtains);
		}
		if (!revertedBG)
		{
			defaultCamZoom = bgZoom;
			curStage = stageName;
		}

		return sprites;
	}

	public function getBackgroundColor(stage:String):FlxColor
	{
		var variantColor:FlxColor = FlxColor.WHITE;
		switch (stage)
		{
			default:
				variantColor = FlxColor.WHITE;
		}
		return variantColor;
	}

	function schoolIntro(?dialogueBox:DialogueBox, isStart:Bool = true):Void
	{
		inCutscene = true;
		camFollow.setPosition(boyfriend.getGraphicMidpoint().x - 200, dad.getGraphicMidpoint().y - 10);
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var stupidBasics:Float = 1;
		if (isStart)
		{
			FlxTween.tween(black, {alpha: 0}, stupidBasics);
		}
		else
		{
			black.alpha = 0;
			stupidBasics = 0;
		}
		new FlxTimer().start(stupidBasics, function(fuckingSussy:FlxTimer)
		{
			if (dialogueBox != null)
			{
				add(dialogueBox);
			}
			else
			{
				startCountdown();
			}
		});
	}

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void
	{
		inCutscene = false;

		generateStaticArrows(0);
		generateStaticArrows(1);

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;
		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
		{
			dad.dance();
			gf.dance();
			boyfriend.playAnim('idle', true);

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			var introSoundAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			var soundAssetsAlt:Array<String> = new Array<String>();

			introAssets.set('default', ['ui/ready', "ui/set", "ui/go"]);

			introSoundAssets.set('default', ['default/intro3', 'default/intro2', 'default/intro1', 'default/introGo']);
			introSoundAssets.set('pixel', [
				'pixel/intro3-pixel',
				'pixel/intro2-pixel',
				'pixel/intro1-pixel',
				'pixel/introGo-pixel'
			]);

			switch (SONG.song.toLowerCase())
			{
				default:
					soundAssetsAlt = introSoundAssets.get('default');
			}

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			var doing_funny:Bool = true;

			for (value in introAssets.keys())
			{
				if (value == curStage)
				{
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter)
			{
				case 0:
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[0]), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = false;
						ZoomCam(false);
					}
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
					ready.scrollFactor.set();
					ready.updateHitbox();
					ready.antialiasing = true;

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							ready.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[1]), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
					set.scrollFactor.set();

					set.screenCenter();

					set.antialiasing = true;
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							set.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[2]), 0.6);
					if (doing_funny)
					{
						focusOnDadGlobal = false;
						ZoomCam(false);
					}
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
					go.scrollFactor.set();

					go.updateHitbox();

					go.screenCenter();

					go.antialiasing = true;
					add(go);

					var sex:Float = 1000;

					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / sex, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween)
						{
							go.destroy();
						}
					});
					FlxG.sound.play(Paths.sound('introSounds/' + soundAssetsAlt[3]), 0.6);

					if (doing_funny)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}
					if (songName != null)
					{
						songName.visible = true;
					}
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	function playCutscene(name:String)
	{
		inCutscene = true;
		FlxG.sound.music.stop();

		video = new VideoHandler();
		video.finishCallback = function()
		{
			switch (curSong.toLowerCase())
			{
				case 'house':
					var doof:DialogueBox = new DialogueBox(false, dialogue, isStoryMode);
					// doof.x += 70;
					// doof.y = FlxG.height * 0.5;
					doof.scrollFactor.set();
					doof.finishThing = startCountdown;
					schoolIntro(doof);
				default:
					startCountdown();
			}
		}
		video.playVideo(Paths.video(name));
	}

	function playEndCutscene(name:String)
	{
		inCutscene = true;

		video = new VideoHandler();
		video.finishCallback = function()
		{
			LoadingState.loadAndSwitchState(new PlayState());
		}
		video.playVideo(Paths.video(name));
	}

	var previousFrameTime:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;

		if (!paused)
		{
			FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
			vocals.play();
		}
		for (tween in tweenList)
		{
			tween.active = true;
		}

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
		FlxG.sound.music.onComplete = endSong;
		if (songPosBar != null)
		{
			songPosBar.setRange(0, FlxG.sound.music.length);
		}
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void
	{
		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song, ""));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		for (section in noteData)
		{
			var sectionCount = noteData.indexOf(section);

			var coolSection:Int = Std.int(section.lengthInSteps / 4);

			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % 4);
				var OGNoteDat = daNoteData;
				var daNoteStyle:String = songNotes[3];

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > 3)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, gottaHitNote, daNoteStyle, false /*, false*/);
				swagNote.originalType = OGNoteDat;
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set(0, 0);

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				for (susNote in 0...Math.floor(susLength))
				{
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
						gottaHitNote, daNoteStyle, false /*, false*/);
					sustainNote.originalType = OGNoteDat;
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;
				}

				swagNote.mustPress = gottaHitNote;
			}
		}

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int, regenerate:Bool = false):Void
	{
		var note_order:Array<Int> = [0, 1, 2, 3];
		for (i in 0...4)
		{
			var arrowType:Int = note_order[i];
			var strumType:String = '';
			var babyArrow:StrumNote = new StrumNote(0, strumLine.y, strumType, arrowType, player == 1);

			if (!isStoryMode)
			{
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {y: babyArrow.y + 10, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			babyArrow.x += Note.swagWidth * Math.abs(i);
			babyArrow.x += 78 + 78 / playerStrumAmount;
			babyArrow.x += ((FlxG.width / 2) * player);

			babyArrow.baseX = babyArrow.x;
			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				dadStrums.add(babyArrow);
			}
			strumLineNotes.add(babyArrow);
		}
	}

	function regenerateStaticArrows(player:Int)
	{
		switch (player)
		{
			case 0:
				dadStrums.forEach(function(spr:StrumNote)
				{
					dadStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
			case 1:
				playerStrums.forEach(function(spr:StrumNote)
				{
					playerStrums.remove(spr);
					strumLineNotes.remove(spr);
					remove(spr);
					spr.destroy();
				});
		}
		generateStaticArrows(player);
	}

	function tweenCamIn():Void
	{
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.sineInOut});
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}
			if (tweenList != null && tweenList.length != 0)
			{
				for (tween in tweenList)
				{
					if (!tween.finished)
					{
						tween.active = false;
					}
				}
			}
			if (rotatingCamTween != null)
			{
				rotatingCamTween.active = false;
			}

			#if desktop
			DiscordClient.changePresence("PAUSED on "
				+ SONG.song
				+ " ("
				+ storyDifficultyText
				+ ") |",
				"Acc: "
				+ truncateFloat(accuracy, 2)
				+ "% | Score: "
				+ songScore
				+ " | Misses: "
				+ misses, iconRPC);
			#end
			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;

			if (tweenList != null && tweenList.length != 0)
			{
				for (tween in tweenList)
				{
					if (!tween.finished)
					{
						tween.active = true;
					}
				}
			}
			if (rotatingCamTween != null)
			{
				rotatingCamTween.active = true;
			}
			paused = false;

			if (startTimer != null && startTimer.finished)
			{
				#if desktop
				DiscordClient.changePresence(detailsText
					+ " "
					+ SONG.song
					+ " ("
					+ storyDifficultyText
					+ ") ",
					"\nAcc: "
					+ truncateFloat(accuracy, 2)
					+ "% | Score: "
					+ songScore
					+ " | Misses: "
					+ misses, iconRPC, true,
					FlxG.sound.music.length
					- Conductor.songPosition);
				#end
			}
			else
			{
				#if desktop
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ") ", iconRPC);
				#end
			}
		}

		super.closeSubState();
	}

	function resyncVocals():Void
	{
		vocals.pause();
		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();

		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	public static var paused:Bool = false;

	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	function truncateFloat(number:Float, precision:Int):Float
	{
		var num = number;
		num = num * Math.pow(10, precision);
		num = Math.round(num) / Math.pow(10, precision);
		return num;
	}

	override public function update(elapsed:Float)
	{
		elapsedtime += elapsed;

		scriptThing.executeFunc("update", [elapsed]);

		if (songName != null)
		{
			songName.text = FlxStringUtil.formatTime((FlxG.sound.music.length - FlxG.sound.music.time) / 1000);
		}

		if (startingSong && startTimer != null && !startTimer.active)
			startTimer.active = true;

		if (paused && FlxG.sound.music != null && vocals != null && vocals.playing)
		{
			FlxG.sound.music.pause();
			vocals.pause();
		}
		// if (curbg != null)
		// {
		// 	if (curbg.active) // only the polygonized background is active
		// 	{
		// 		#if SHADERS_ENABLED
		// 		var shad = cast(curbg.shader, Shaders.GlitchShader);
		// 		shad.uTime.value[0] += elapsed;
		// 		#end
		// 	}
		// }

		var toy = -100 + -Math.sin((curStep / 9.5) * 2) * 30 * 5;
		var tox = -330 - Math.cos((curStep / 9.5)) * 100;

		// welcome to 3d sinning avenue

		// if (funnyFloatyBoys.contains(dad.curCharacter.toLowerCase()) && canFloat)
		// {
		// 	dad.y += (Math.sin(elapsedtime) * 0.2);
		// }
		// if (funnyFloatyBoys.contains(boyfriend.curCharacter.toLowerCase()) && canFloat)
		// {
		// 	boyfriend.y += (Math.sin(elapsedtime) * 0.2);
		// }
		/*if(funnyFloatyBoys.contains(dadmirror.curCharacter.toLowerCase()))
			{
				dadmirror.y += (Math.sin(elapsedtime) * 0.6);
		}*/

		// if (funnyFloatyBoys.contains(gf.curCharacter.toLowerCase()) && canFloat)
		// {
		// 	gf.y += (Math.sin(elapsedtime) * 0.2);
		// }
		// no more 3d sinning avenue
		// if (daveFlying)
		// {
		// 	dad.y -= elapsed * 50;
		// 	dad.angle -= elapsed * 6;
		// }
		if (tweenList != null && tweenList.length != 0)
		{
			for (tween in tweenList)
			{
				if (tween.active && !tween.finished)
					tween.percent = FlxG.sound.music.time / tweenTime;
			}
		}

		// if (shakeCam && eyesoreson)
		// {
		// 	// var shad = cast(FlxG.camera.screen.shader,Shaders.PulseShader);
		// 	FlxG.camera.shake(0.010, 0.010);
		// }

		switch (curStage)
		{
			case 'philly':
				if (trainMoving)
				{
					trainFrameTiming += elapsed;

					if (trainFrameTiming >= 1 / 24)
					{
						updateTrainPos();
						trainFrameTiming = 0;
					}
				}
				// phillyCityLights.members[curLight].alpha -= (Conductor.crochet / 1000) * FlxG.elapsed;
		}

		super.update(elapsed);

		switch (SONG.song.toLowerCase())
		{
			default:
				scoreTxt.text = LanguageManager.getTextString('play_score') + Std.string(songScore) + " | " + LanguageManager.getTextString('play_miss')
					+ misses + " | " + LanguageManager.getTextString('play_accuracy') + truncateFloat(accuracy, 2) + "%";
		}
		if (noMiss)
		{
			scoreTxt.text += " | NO MISS!!";
		}
		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause)
		{
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1))
			{
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			}
			else
			{
				playerStrums.forEach(function(note:StrumNote)
				{
					FlxTween.completeTweensOf(note);
				});
				dadStrums.forEach(function(note:StrumNote)
				{
					FlxTween.completeTweensOf(note);
				});
				openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
			}
		}

		if (FlxG.keys.justPressed.SEVEN)
		{
			if (FlxTransitionableState.skipNextTransIn)
			{
				Transition.nextCamera = null;
			}

			switch (curSong.toLowerCase())
			{
				default:
					// #if SHADERS_ENABLED
					// resetShader();
					// #end
					FlxG.switchState(new ChartingState());
					#if desktop
					DiscordClient.changePresence("Chart Editor", null, null, true);
					#end
			}
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var thingy = 0.88; // (144 / Main.fps.currentFPS) * 0.88;
		// still gotta make this fps consistent crap

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, thingy)), Std.int(FlxMath.lerp(150, iconP1.height, thingy)));
		iconP1.updateHitbox();

		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, thingy)), Std.int(FlxMath.lerp(150, iconP2.height, thingy)));
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.changeState('losing');
		else
			iconP1.changeState('normal');

		if (healthBar.percent > 80)
			iconP2.changeState('losing');
		else
			iconP2.changeState('normal');

		#if debug
		if (FlxG.keys.justPressed.FOUR)
		{
			trace('DUMP LOL:\nDAD POSITION: ${dad.getPosition()}\nBOYFRIEND POSITION: ${boyfriend.getPosition()}\nGF POSITION: ${gf.getPosition()}\nCAMERA POSITION: ${camFollow.getPosition()}');
		}
		if (FlxG.keys.justPressed.FIVE)
		{
			FlxG.switchState(new CharacterDebug(dad.curCharacter));
		}
		if (FlxG.keys.justPressed.SEMICOLON)
		{
			FlxG.switchState(new CharacterDebug(boyfriend.curCharacter));
		}
		if (FlxG.keys.justPressed.COMMA)
		{
			FlxG.switchState(new CharacterDebug(gf.curCharacter));
		}
		if (FlxG.keys.justPressed.EIGHT)
			FlxG.switchState(new AnimationDebug(dad.curCharacter));
		if (FlxG.keys.justPressed.SIX)
			FlxG.switchState(new AnimationDebug(boyfriend.curCharacter));
		if (FlxG.keys.justPressed.TWO) // Go 10 seconds into the future :O
		{
			FlxG.sound.music.pause();
			vocals.pause();
			boyfriend.stunned = true;
			Conductor.songPosition += 10000;
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.strumTime + 800 < Conductor.songPosition)
				{
					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
			for (i in 0...unspawnNotes.length)
			{
				var daNote:Note = unspawnNotes[0];
				if (daNote.strumTime + 800 >= Conductor.songPosition)
				{
					break;
				}

				daNote.active = false;
				daNote.visible = false;

				daNote.kill();
				unspawnNotes.splice(unspawnNotes.indexOf(daNote), 1);
				daNote.destroy();
			}

			FlxG.sound.music.time = Conductor.songPosition;
			FlxG.sound.music.play();

			vocals.time = Conductor.songPosition;
			vocals.play();
			boyfriend.stunned = false;
		}
		if (FlxG.keys.justPressed.THREE)
			FlxG.switchState(new AnimationDebug(gf.curCharacter));
		#end

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
				{
					startSong();
				}
			}
		}
		else
		{
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}
		// if (crazyZooming)
		// {
		// 	FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
		// 	camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		// }

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (health <= 0)
		{
			if (!perfectMode)
			{
				boyfriend.stunned = true;

				persistentUpdate = false;
				persistentDraw = false;
				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				// #if SHADERS_ENABLED
				// screenshader.shader.uampmul.value[0] = 0;
				// screenshader.Enabled = false;
				// #end
			}

			if (!perfectMode)
			{
				gameOver();
			}

			// FlxG.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null)
		{
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500)
			{
				var dunceNote:Note = unspawnNotes[0];
				dunceNote.finishedGenerating = true;

				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}
		var currentSection = SONG.notes[Math.floor(curStep / 16)];

		if (generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.y > FlxG.height)
				{
					daNote.active = false;
					daNote.visible = false;
				}
				else
				{
					daNote.visible = true;
					daNote.active = true;
				}
				if (!daNote.mustPress && daNote.wasGoodHit)
				{
					if (SONG.song != 'Tutorial')
						camZooming = true;

					var altAnim:String = "";
					var healthtolower:Float = 0.02;

					if (currentSection != null)
					{
						if (currentSection.altAnim || daNote.noteStyle == 'alt-animation')
							altAnim = '-alt';
					}
					// if (inFiveNights && !daNote.isSustainNote)
					// {
					// 	dadCombo++;
					// 	createScorePopUp(0, 0, true, FlxG.random.int(0, 10) == 0 ? "good" : "sick", dadCombo, "3D");
					// }

					var noteTypes = notestuffs;
					var noteToPlay:String = noteTypes[Math.round(Math.abs(daNote.originalType)) % dadStrumAmount];
					switch (daNote.noteStyle)
					{
						default:
							if (dad.nativelyPlayable)
							{
								switch (noteToPlay)
								{
									case 'LEFT':
										noteToPlay = 'RIGHT';
									case 'RIGHT':
										noteToPlay = 'LEFT';
								}
							}
							dad.playAnim('sing' + noteToPlay + altAnim, true);
							if (dadmirror != null)
							{
								dadmirror.playAnim('sing' + noteToPlay + altAnim, true);
							}
					}
					cameraMoveOnNote(daNote.originalType, 'dad');

					dadStrums.forEach(function(sprite:StrumNote)
					{
						if (Math.abs(Math.round(Math.abs(daNote.noteData)) % dadStrumAmount) == sprite.ID)
						{
							sprite.animation.play('confirm', true);
							if (sprite.animation.curAnim.name == 'confirm')
							{
								sprite.centerOffsets();
								sprite.offset.x -= 13;
								sprite.offset.y -= 13;
							}
							else
							{
								sprite.centerOffsets();
							}
							sprite.animation.finishCallback = function(name:String)
							{
								sprite.animation.play('static', true);
								sprite.centerOffsets();
							}
						}
					});
					if (UsingNewCam)
					{
						focusOnDadGlobal = true;
						ZoomCam(true);
					}

					// boyfriend.playAnim('hit',true);
					dad.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
				switch (SONG.song.toLowerCase())
				{
					default:
						daNote.y = yFromNoteStrumTime(daNote, strumLine, scrollType == 'downscroll');
				}
				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));
				var noteSpeed = (daNote.LocalScrollSpeed == 0 ? 1 : daNote.LocalScrollSpeed);

				if (daNote.wasGoodHit && daNote.isSustainNote && Conductor.songPosition >= (daNote.strumTime + 10))
				{
					destroyNote(daNote);
				}
				if (!daNote.wasGoodHit
					&& daNote.mustPress
					&& daNote.finishedGenerating
					&& Conductor.songPosition >= daNote.strumTime + (350 / (0.45 * FlxMath.roundDecimal(SONG.speed * noteSpeed, 2))))
				{
					if (!noMiss)
						noteMiss(daNote.originalType, daNote);

					vocals.volume = 0;

					destroyNote(daNote);
				}
			});
		}

		ZoomCam(focusOnDadGlobal);

		if (!inCutscene)
			keyShit();

		#if debug
		if (FlxG.keys.justPressed.ONE)
			endSong();
		#end
	}

	function destroyNote(note:Note)
	{
		note.active = false;
		note.visible = false;
		note.kill();
		notes.remove(note, true);
		note.destroy();
	}

	function yFromNoteStrumTime(note:Note, strumLine:FlxSprite, downScroll:Bool):Float
	{
		var change = downScroll ? -1 : 1;
		var speed:Float = SONG.speed;
		var val:Float = strumLine.y - (Conductor.songPosition - note.strumTime) * (change * 0.45 * FlxMath.roundDecimal(speed * note.LocalScrollSpeed, 2));
		if (note.isSustainNote && downScroll && note.animation != null)
		{
			if (note.animation.curAnim.name.endsWith('end'))
			{
				val += (note.height * speed);
			}
		}
		return val;
	}

	function ZoomCam(focusondad:Bool):Void
	{
		var bfplaying:Bool = false;
		if (focusondad)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (!bfplaying)
				{
					if (daNote.mustPress)
					{
						bfplaying = true;
					}
				}
			});
			if (UsingNewCam && bfplaying)
			{
				return;
			}
		}
		if (!lockCam)
		{
			if (focusondad)
			{
				camFollow.setPosition(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
				// camFollow.setPosition(lucky.getMidpoint().x - 120, lucky.getMidpoint().y + 210);

				switch (dad.curCharacter)
				{
					case 'mom':
						camFollow.y = dad.getMidpoint().y;
					case 'senpai':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
					case 'senpai-angry':
						camFollow.y = dad.getMidpoint().y - 430;
						camFollow.x = dad.getMidpoint().x - 100;
				}

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					tweenCamIn();
				}

				bfNoteCamOffset[0] = 0;
				bfNoteCamOffset[1] = 0;

				camFollow.x += dadNoteCamOffset[0];
				camFollow.y += dadNoteCamOffset[1];
			}
			else
			{
				camFollow.setPosition(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);

				/*switch (boyfriend.curCharacter)
					{
						case 'bf-pixel':
							camFollow.x = boyfriend.getMidpoint().x - 100;
							camFollow.y = boyfriend.getMidpoint().y - 225;
				}*/

				switch (curStage)
				{
					case 'limo':
						camFollow.x = boyfriend.getMidpoint().x - 300;
					case 'mall':
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'school':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
					case 'schoolEvil':
						camFollow.x = boyfriend.getMidpoint().x - 200;
						camFollow.y = boyfriend.getMidpoint().y - 200;
				}

				dadNoteCamOffset[0] = 0;
				dadNoteCamOffset[1] = 0;

				camFollow.x += bfNoteCamOffset[0];
				camFollow.y += bfNoteCamOffset[1];

				if (SONG.song.toLowerCase() == 'tutorial')
				{
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.sineInOut});
				}
			}
		}
	}

	function endSong():Void
	{
		inCutscene = false;
		canPause = false;

		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore)
		{
			trace("score is valid");

			FlxG.save.flush();

			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty, characteroverride == "none"
				|| characteroverride == "bf" ? "bf" : characteroverride);
			#end
		}

		if (isStoryMode)
		{
			campaignScore += songScore;

			var completedSongs:Array<String> = [];
			var allSongsCompleted:Bool = true;
			if (FlxG.save.data.songsCompleted == null)
			{
				FlxG.save.data.songsCompleted = new Array<String>();
			}
			completedSongs = FlxG.save.data.songsCompleted;
			completedSongs.push(storyPlaylist[0]);
			FlxG.save.data.songsCompleted = completedSongs;
			FlxG.save.flush();

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0)
			{
				if (FlxTransitionableState.skipNextTransIn)
				{
					Transition.nextCamera = null;
				}
				switch (curSong.toLowerCase())
				{
					default:
						FlxG.sound.playMusic(Paths.music('freakyMenu'));
						FlxG.switchState(new StoryMenuState());
				}
				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				// if ()
				StoryMenuState.weekUnlocked[Std.int(Math.min(storyWeek + 1, StoryMenuState.weekUnlocked.length - 1))] = true;

				if (SONG.validScore)
				{
					Highscore.saveWeekScore(storyWeek, campaignScore,
						storyDifficulty, characteroverride == "none" || characteroverride == "bf" ? "bf" : characteroverride);
				}

				FlxG.save.data.weekUnlocked = StoryMenuState.weekUnlocked;
				FlxG.save.flush();
			}
			else
			{
				switch (SONG.song.toLowerCase())
				{
					default:
						nextSong();
				}
			}
		}
		else
		{
			switch (SONG.song.toLowerCase())
			{
				default:
					FlxG.switchState(new FreeplayState());
			}
			if (FlxTransitionableState.skipNextTransIn)
			{
				Transition.nextCamera = null;
			}
		}
	}

	var endingSong:Bool = false;

	function nextSong()
	{
		FlxTransitionableState.skipNextTransIn = true;
		FlxTransitionableState.skipNextTransOut = true;
		prevCamFollow = camFollow;

		PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0]);
		FlxG.sound.music.stop();

		switch (curSong.toLowerCase())
		{
			default:
				LoadingState.loadAndSwitchState(new PlayState());
		}
	}

	public function createScorePopUp(daX:Float, daY:Float, autoPos:Bool, daRating:String, daCombo:Int, daStyle:String):Void
	{
		var assetPath:String = '';

		var placement:String = Std.string(daCombo);

		var coolText:FlxText = new FlxText(daX, daY, 0, placement, 32);
		if (autoPos)
		{
			coolText.screenCenter();
			coolText.x = FlxG.width * 0.55;
		}
		var rating = new FlxSprite().loadGraphic(Paths.image("ui/" + assetPath + daRating));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image("ui/" + assetPath + "combo"));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);
		if (combo >= 10)
		{
			add(comboSpr);
		}

		rating.setGraphicSize(Std.int(rating.width * 0.7));
		rating.antialiasing = true;
		comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
		comboSpr.antialiasing = true;

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		var comboSplit:Array<String> = (daCombo + "").split('');

		if (comboSplit.length == 2)
			seperatedScore.push(0); // make sure theres a 0 in front or it looks weird lol!

		for (i in 0...comboSplit.length)
		{
			var str:String = comboSplit[i];
			seperatedScore.push(Std.parseInt(str));
		}

		var daLoop:Int = 0;
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image("ui/" + assetPath + "num" + Std.int(i)));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.antialiasing = true;
			numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (daCombo >= 10 || daCombo == 0)
				add(numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/* 
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});
	}

	private function popUpScore(strumtime:Float, note:Note):Void
	{
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		// boyfriend.playAnim('hey');
		vocals.volume = 1;

		var score:Int = 350;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = 10;
			shits++;
		}
		else if (noteDiff < Conductor.safeZoneOffset * -2)
		{
			daRating = 'shit';
			totalNotesHit -= 2;
			score = 25;
			shits++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.45)
		{
			daRating = 'bad';
			score = 100;
			totalNotesHit += 0.2;
			bads++;
		}
		else if (noteDiff > Conductor.safeZoneOffset * 0.25)
		{
			daRating = 'good';
			totalNotesHit += 0.65;
			score = 200;
			goods++;
		}
		if (daRating == 'sick')
		{
			totalNotesHit += 1;
			sicks++;
		}
		score = cast(FlxMath.roundDecimal(cast(score, Float) * curmult[note.noteData],
			0), Int); // this is old code thats stupid Std.Int exists but i dont feel like changing this

		if (!noMiss)
		{
			songScore += score;
		}

		createScorePopUp(0, 0, true, daRating, combo, note.noteStyle);

		curSection += 1;
	}

	public function NearlyEquals(value1:Float, value2:Float, unimportantDifference:Float = 10):Bool
	{
		return Math.abs(FlxMath.roundDecimal(value1, 1) - FlxMath.roundDecimal(value2, 1)) < unimportantDifference;
	}

	var upHold:Bool = false;
	var downHold:Bool = false;
	var rightHold:Bool = false;
	var leftHold:Bool = false;

	private function keyShit():Void
	{
		// HOLDING
		var up = controls.UP;
		var right = controls.RIGHT;
		var down = controls.DOWN;
		var left = controls.LEFT;

		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var upR = controls.UP_R;
		var rightR = controls.RIGHT_R;
		var downR = controls.DOWN_R;
		var leftR = controls.LEFT_R;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];
		var releaseArray:Array<Bool> = [leftR, downR, upR, rightR];

		#if botplay
		var BOTPLAY_pressed_anything = false;

		notes.forEachAlive(function(daNote:Note)
		{
			if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && daNote.finishedGenerating)
			{
				if (daNote.strumTime <= Conductor.songPosition)
				{
					BOTPLAY_pressed_anything = true;
					if (!daNote.isSustainNote)
					{
						controlArray[daNote.noteData % 4] = true;
						switch (daNote.noteData % 4)
						{
							case 0:
								leftP = true;
							case 1:
								downP = true;
							case 2:
								upP = true;
							case 3:
								rightP = true;
						}
					}
					switch (daNote.noteData % 4)
					{
						case 0:
							left = true;
						case 1:
							down = true;
						case 2:
							up = true;
						case 3:
							right = true;
					}
				}
			}
		});
		if (!BOTPLAY_pressed_anything)
		{
			releaseArray = [true, true, true, true];
		}
		#end

		if (noteLimbo != null)
		{
			if (noteLimbo.exists)
			{
				if (noteLimbo.wasGoodHit)
				{
					goodNoteHit(noteLimbo);
					if (noteLimbo.wasGoodHit)
					{
						noteLimbo.kill();
						notes.remove(noteLimbo, true);
						noteLimbo.destroy();
					}
					noteLimbo = null;
				}
				else
				{
					noteLimbo = null;
				}
			}
		}

		if (noteLimboFrames != 0)
		{
			noteLimboFrames--;
		}
		else
		{
			noteLimbo = null;
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if ((upP || rightP || downP || leftP) && !boyfriend.stunned && generatedMusic)
		{
			boyfriend.holdTimer = 0;

			possibleNotes = [];

			var ignoreList:Array<Int> = [];

			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && daNote.finishedGenerating)
				{
					possibleNotes.push(daNote);
				}
			});

			haxe.ds.ArraySort.sort(possibleNotes, function(a, b):Int
			{
				var notetypecompare:Int = Std.int(a.noteData - b.noteData);

				if (notetypecompare == 0)
				{
					return Std.int(a.strumTime - b.strumTime);
				}
				return notetypecompare;
			});

			if (possibleNotes.length > 0)
			{
				var daNote = possibleNotes[0];

				if (perfectMode)
					noteCheck(true, daNote);

				// Jump notes
				var lasthitnote:Int = -1;
				var lasthitnotetime:Float = -1;

				for (note in possibleNotes)
				{
					if (!note.mustPress)
					{
						continue;
					}
					if (controlArray[note.noteData % 4])
					{
						if (lasthitnotetime > Conductor.songPosition - Conductor.safeZoneOffset
							&& lasthitnotetime < Conductor.songPosition +
							(Conductor.safeZoneOffset * 0.07)) // reduce the past allowed barrier just so notes close together that aren't jacks dont cause missed inputs
						{
							if ((note.noteData % 4) == (lasthitnote % 4))
							{
								lasthitnotetime = -999999; // reset the last hit note time
								continue; // the jacks are too close together
							}
						}
						lasthitnote = note.noteData;
						lasthitnotetime = note.strumTime;
						goodNoteHit(note);
					}
				}

				if (daNote.wasGoodHit)
				{
					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			}
			else if (!theFunne)
			{
				if (!inCutscene)
					badNoteCheck(null);
			}
		}

		if ((up || right || down || left) && generatedMusic)
		{
			notes.forEachAlive(function(daNote:Note)
			{
				if (daNote.canBeHit && daNote.mustPress && daNote.isSustainNote)
				{
					switch (daNote.noteData)
					{
						// NOTES YOU ARE HOLDING
						case 2:
							if (up || upHold)
								goodNoteHit(daNote);
						case 3:
							if (right || rightHold)
								goodNoteHit(daNote);
						case 1:
							if (down || downHold)
								goodNoteHit(daNote);
						case 0:
							if (left || leftHold)
								goodNoteHit(daNote);
					}
				}
			});
		}

		if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
		{
			if ((boyfriend.animation.curAnim.name.startsWith('sing')) && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.playAnim('idle');

				bfNoteCamOffset[0] = 0;
				bfNoteCamOffset[1] = 0;
			}
		}

		playerStrums.forEach(function(spr:StrumNote)
		{
			if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm')
			{
				spr.animation.play('pressed');
			}
			if (releaseArray[spr.ID])
			{
				spr.animation.play('static');
			}

			if (spr.animation.curAnim.name == 'confirm')
			{
				spr.centerOffsets();
				spr.offset.x -= 13;
				spr.offset.y -= 13;
			}
			else
				spr.centerOffsets();
		});
	}

	function noteMiss(direction:Int = 1, note:Note):Void
	{
		if (true)
		{
			misses++;
			health -= 0.04;

			if (combo > 5 && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;
			songScore -= 100;

			var deathSound:FlxSound = new FlxSound();
			switch (curSong.toLowerCase())
			{
				default:
					deathSound.loadEmbedded(Paths.soundRandom('missnote', 1, 3));
			}
			deathSound.volume = FlxG.random.float(0.1, 0.2);
			deathSound.play();

			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			var noteTypes = notestuffs;
			var noteToPlay:String = noteTypes[Math.round(Math.abs(direction)) % playerStrumAmount];
			if (!boyfriend.nativelyPlayable)
			{
				switch (noteToPlay)
				{
					case 'LEFT':
						noteToPlay = 'RIGHT';
					case 'RIGHT':
						noteToPlay = 'LEFT';
				}
			}
			if (boyfriend.animation.getByName('sing${noteToPlay}miss') != null)
			{
				boyfriend.playAnim('sing' + noteToPlay + "miss", true);
			}
			else
			{
				boyfriend.color = 0xFF000084;
				boyfriend.playAnim('sing' + noteToPlay, true);
			}
			updateAccuracy();
		}
	}

	function cameraMoveOnNote(note:Int, character:String)
	{
		var amount:Array<Float> = new Array<Float>();
		var followAmount:Float = FlxG.save.data.noteCamera ? 20 : 0;
		switch (note)
		{
			case 0:
				amount[0] = -followAmount;
				amount[1] = 0;
			case 1:
				amount[0] = 0;
				amount[1] = followAmount;
			case 2:
				amount[0] = 0;
				amount[1] = -followAmount;
			case 3:
				amount[0] = followAmount;
				amount[1] = 0;
		}
		switch (character)
		{
			case 'dad':
				dadNoteCamOffset = amount;
			case 'bf':
				bfNoteCamOffset = amount;
		}
	}

	function badNoteCheck(note:Note = null)
	{
		// just double pasting this shit cuz fuk u
		// REDO THIS SYSTEM!
		if (note != null)
		{
			if (note.mustPress && note.finishedGenerating)
			{
				if (!noMiss)
					noteMiss(note.noteData, note);
			}
			return;
		}
		var upP = controls.UP_P;
		var rightP = controls.RIGHT_P;
		var downP = controls.DOWN_P;
		var leftP = controls.LEFT_P;

		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		for (i in 0...controlArray.length)
		{
			if (controlArray[i])
			{
				if (!noMiss)
					noteMiss(i, note);
			}
		}
		updateAccuracy();
	}

	function updateAccuracy()
	{
		totalPlayed += 1;
		accuracy = totalNotesHit / totalPlayed * 100;
	}

	function noteCheck(keyP:Bool, note:Note):Void // sorry lol
	{
		if (keyP)
		{
			goodNoteHit(note);
		}
		else if (!theFunne)
		{
			badNoteCheck(note);
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if (!note.isSustainNote)
			{
				popUpScore(note.strumTime, note);
				if (FlxG.save.data.donoteclick)
				{
					FlxG.sound.play(Paths.sound('note_click'));
				}
				combo += 1;
			}
			else
			{
				totalNotesHit += 1;
			}

			health += 0.023;

			switch (note.noteStyle)
			{
				default:
					// 'LEFT', 'DOWN', 'UP', 'RIGHT'
					var fuckingDumbassBullshitFuckYou:String;
					var noteTypes = notestuffs;
					fuckingDumbassBullshitFuckYou = noteTypes[Math.round(Math.abs(note.originalType)) % playerStrumAmount];
					if (!boyfriend.nativelyPlayable)
					{
						switch (noteTypes[Math.round(Math.abs(note.originalType)) % playerStrumAmount])
						{
							case 'LEFT':
								fuckingDumbassBullshitFuckYou = 'RIGHT';
							case 'RIGHT':
								fuckingDumbassBullshitFuckYou = 'LEFT';
						}
					}
					boyfriend.playAnim('sing' + fuckingDumbassBullshitFuckYou, true);
			}
			cameraMoveOnNote(note.originalType, 'bf');
			if (UsingNewCam)
			{
				focusOnDadGlobal = false;
				ZoomCam(false);
			}

			playerStrums.forEach(function(spr:StrumNote)
			{
				if (Math.abs(note.noteData) == spr.ID)
				{
					spr.animation.play('confirm', true);
				}
			});

			note.wasGoodHit = true;
			vocals.volume = 1;

			note.kill();
			notes.remove(note, true);
			note.destroy();

			updateAccuracy();
		}
	}

	function cinematicBars(time:Float, closeness:Float)
	{
		var upBar = new FlxSprite().makeGraphic(Std.int(FlxG.width * ((1 / defaultCamZoom) * 2)), Std.int(FlxG.height / 2), FlxColor.BLACK);
		var downBar = new FlxSprite().makeGraphic(Std.int(FlxG.width * ((1 / defaultCamZoom) * 2)), Std.int(FlxG.height / 2), FlxColor.BLACK);

		upBar.screenCenter();
		downBar.screenCenter();
		upBar.scrollFactor.set();
		downBar.scrollFactor.set();
		upBar.cameras = [camHUD];
		downBar.cameras = [camHUD];

		upBar.y -= 2000;
		downBar.y += 2000;

		add(upBar);
		add(downBar);

		FlxTween.tween(upBar, {y: (FlxG.height - upBar.height) / 2 - closeness}, (Conductor.crochet / 1000) / 2, {
			ease: FlxEase.expoInOut,
			onComplete: function(tween:FlxTween)
			{
				new FlxTimer().start(time, function(timer:FlxTimer)
				{
					FlxTween.tween(upBar, {y: upBar.y - 2000}, (Conductor.crochet / 1000) / 2, {
						ease: FlxEase.expoIn,
						onComplete: function(tween:FlxTween)
						{
							remove(upBar);
						}
					});
				});
			}
		});
		FlxTween.tween(downBar, {y: (FlxG.height - downBar.height) / 2 + closeness}, (Conductor.crochet / 1000) / 2, {
			ease: FlxEase.expoInOut,
			onComplete: function(tween:FlxTween)
			{
				new FlxTimer().start(time, function(timer:FlxTimer)
				{
					FlxTween.tween(downBar, {y: downBar.y + 2000}, (Conductor.crochet / 1000) / 2, {
						ease: FlxEase.expoIn,
						onComplete: function(tween:FlxTween)
						{
							remove(downBar);
						}
					});
				});
			}
		});
	}

	override function stepHit()
	{
		super.stepHit();

		scriptThing.executeFunc("stepHit", [curStep]);

		if (FlxG.sound.music.time > Conductor.songPosition + 20 || FlxG.sound.music.time < Conductor.songPosition - 20)
			resyncVocals();

		/*switch (SONG.song.toLowerCase())
			{
				TEMPORARY DISABLED
				MAKING A NEW SYSTEM
		}*/
		#if desktop
		DiscordClient.changePresence(detailsText
			+ " "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"Acc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC, true,
			FlxG.sound.music.length
			- Conductor.songPosition);
		#end

		if (dad.curCharacter == 'spooky' && curStep % 4 == 2)
		{
			// dad.dance();
		}
	}

	override function beatHit()
	{
		super.beatHit();

		scriptThing.executeFunc("beatHit", [curBeat]);

		var currentSection = SONG.notes[Std.int(curStep / 16)];
		if (!UsingNewCam)
		{
			if (generatedMusic && currentSection != null)
			{
				if (curBeat % 4 == 0)
				{
					// trace(currentSection.mustHitSection);
				}

				focusOnDadGlobal = !currentSection.mustHitSection;
				ZoomCam(!currentSection.mustHitSection);
			}
		}
		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, FlxSort.DESCENDING);
		}

		if (currentSection != null)
		{
			if (currentSection.changeBPM)
			{
				Conductor.changeBPM(currentSection.bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);
		}
		if (dad.animation.finished)
		{
			switch (SONG.song.toLowerCase())
			{
				case 'tutorial':
					dad.dance();
					if (dadmirror != null)
					{
						dadmirror.dance();
					}
				default:
					if (dad.holdTimer <= 0 && curBeat % 2 == 0)
					{
						dad.dance();
						if (dadmirror != null)
						{
							dadmirror.dance();
						}

						dadNoteCamOffset[0] = 0;
						dadNoteCamOffset[1] = 0;
					}
			}
		}

		if (boyfriend.animation.finished)
		{
			switch (SONG.song.toLowerCase())
			{
				default:
					if (boyfriend.holdTimer <= 0 && curBeat % 2 == 0)
					{
						boyfriend.dance();
					}
			}
		}

		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		#if SHADERS_ENABLED
		wiggleShit.update(Conductor.crochet);
		#end

		if (curSong.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		if (camZooming && curBeat % 4 == 0)
		{
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}
		// if (crazyZooming && curBeat % 1 == 0)
		// {
		// 	FlxG.camera.zoom += 0.015;
		// 	camHUD.zoom += 0.03;
		// }
		/*switch (curSong.toLowerCase())
			{
				TEMPORARILY DISABLED
				MAKING A NEW SYSTEM
			}
		 */
		// if (shakeCam)
		// {
		// 	gf.playAnim('scared', true);
		// }
		if (curBeat % 8 == 7 && curSong == 'Bopeebo')
		{
			boyfriend.playAnim('hey', true);
		}

		if (curBeat % 16 == 15 && SONG.song == 'Tutorial' && dad.curCharacter == 'gf' && curBeat > 16 && curBeat < 48)
		{
			boyfriend.playAnim('hey', true);
			dad.playAnim('cheer', true);
		}

		var funny:Float = Math.max(Math.min(healthBar.value, 1.9),
			0.1); // Math.clamp(healthBar.value,0.02,1.98);//Math.min(Math.min(healthBar.value,1.98),0.02);

		iconP1.setGraphicSize(Std.int(iconP1.width + (50 * (funny + 0.1))), Std.int(iconP1.height - (25 * funny)));
		iconP2.setGraphicSize(Std.int(iconP2.width + (50 * ((2 - funny) + 0.1))), Std.int(iconP2.height - (25 * ((2 - funny) + 0.1))));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0)
		{
			// if (!shakeCam)
			// {
			gf.dance();
			// }
		}

		switch (curStage)
		{
			case 'school':
				bgGirls.dance();

			case 'mall':
				upperBoppers.animation.play('bop', true);
				bottomBoppers.animation.play('bop', true);
				santa.animation.play('idle', true);

			case 'limo':
				grpLimoDancers.forEach(function(dancer:BackgroundDancer)
				{
					dancer.dance();
				});

				if (FlxG.random.bool(10) && fastCarCanDrive)
					fastCarDrive();
			case "philly":
				if (!trainMoving)
					trainCooldown += 1;

				if (curBeat % 4 == 0)
				{
					phillyCityLights.forEach(function(light:FlxSprite)
					{
						light.visible = false;
					});

					curLight = FlxG.random.int(0, phillyCityLights.length - 1);

					phillyCityLights.members[curLight].visible = true;
					// phillyCityLights.members[curLight].alpha = 1;
				}

				if (curBeat % 8 == 4 && FlxG.random.bool(30) && !trainMoving && trainCooldown > 8)
				{
					trainCooldown = FlxG.random.int(-4, 0);
					trainStart();
				}
		}

		if (isHalloween && FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset)
		{
			lightningStrikeShit();
		}
	}

	function gameOver()
	{
		var deathSkinCheck = formoverride == "bf" || formoverride == "none" ? SONG.player1 : formoverride;

		openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y, deathSkinCheck));

		#if desktop
		DiscordClient.changePresence("GAME OVER -- "
			+ SONG.song
			+ " ("
			+ storyDifficultyText
			+ ") ",
			"\nAcc: "
			+ truncateFloat(accuracy, 2)
			+ "% | Score: "
			+ songScore
			+ " | Misses: "
			+ misses, iconRPC);
		#end
	}

	function eatShit(ass:String):Void
	{
		if (dialogue[0] == null)
		{
			trace(ass);
		}
		else
		{
			trace(dialogue[0]);
		}
	}

	public function preload(graphic:String) // preload assets
	{
		if (boyfriend != null)
		{
			boyfriend.stunned = true;
		}
		var newthing:FlxSprite = new FlxSprite(9000, -9000).loadGraphic(Paths.image(graphic));
		add(newthing);
		remove(newthing);
		if (boyfriend != null)
		{
			boyfriend.stunned = false;
		}
	}

	public function repositionChar(char:Character)
	{
		char.x += char.globalOffset[0];
		char.y += char.globalOffset[1];
	}

	public function repositionCharStages()
	{
		switch (curStage)
		{
			case 'limo':
				boyfriend.y -= 220;
				boyfriend.x += 260;

				resetFastCar();
				add(fastCar);

			case 'mall':
				boyfriend.x += 200;

			case 'mallEvil':
				boyfriend.x += 320;
				dad.y -= 80;
		}
	}

	public function getCamZoom():Float
	{
		return defaultCamZoom;
	}

	public static function resetShader()
	{
		// PlayState.instance.shakeCam = false;
		// PlayState.instance.camZooming = false;
		// #if SHADERS_ENABLED
		// screenshader.shader.uampmul.value[0] = 0;
		// screenshader.Enabled = false;
		// #end
	}

	function sectionStartTime(section:Int):Float
	{
		var daBPM:Float = SONG.bpm;
		var daPos:Float = 0;
		for (i in 0...section)
		{
			daPos += 4 * (1000 * 60 / daBPM);
		}
		return daPos;
	}

	function switchNoteScroll(cancelTweens:Bool = true)
	{
		switch (scrollType)
		{
			case 'upscroll':
				strumLine.y = DOWNSCROLL_Y;
				scrollType = 'downscroll';
			case 'downscroll':
				strumLine.y = UPSCROLL_Y;
				scrollType = 'upscroll';
		}
		for (strumNote in strumLineNotes)
		{
			if (cancelTweens)
			{
				FlxTween.completeTweensOf(strumNote);
			}
			strumNote.angle = 0;

			FlxTween.angle(strumNote, strumNote.angle, strumNote.angle + 360, 0.4, {ease: FlxEase.expoOut});
			FlxTween.tween(strumNote, {y: strumLine.y}, 0.6, {ease: FlxEase.backOut});
		}
	}

	function switchNoteSide()
	{
		for (i in 0...4)
		{
			var curOpponentNote = dadStrums.members[i];
			var curPlayerNote = playerStrums.members[i];

			FlxTween.tween(curOpponentNote, {x: curPlayerNote.x}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
			FlxTween.tween(curPlayerNote, {x: curOpponentNote.x}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
		}
		switchSide = !switchSide;
	}

	function switchNotePositions(order:Array<Int>)
	{
		var positions:Array<Float> = [];
		for (i in 0...4)
		{
			var curNote = playerStrums.members[i];
			positions.push(curNote.baseX);
		}
		for (i in 0...4)
		{
			var curNote = dadStrums.members[i];
			positions.push(curNote.baseX);
		}
		for (i in 0...4)
		{
			var curOpponentNote = dadStrums.members[i];
			var curPlayerNote = playerStrums.members[i];

			FlxTween.tween(curOpponentNote, {x: positions[order[i + playerStrumAmount]]}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
			FlxTween.tween(curPlayerNote, {x: positions[order[i]]}, 0.6, {ease: FlxEase.expoOut, startDelay: 0.01 * i});
		}
		switchSide = !switchSide;
	}

	function switchDad(newChar:String, position:FlxPoint, reposition:Bool = true, updateColor:Bool = true)
	{
		if (reposition)
		{
			position.x -= dad.globalOffset[0];
			position.y -= dad.globalOffset[1];
		}
		dadGroup.remove(dad);
		dad = new Character(position.x, position.y, newChar, false);
		dadGroup.add(dad);
		if (FileSystem.exists(Paths.image('ui/iconGrid/${dad.curCharacter}', 'preload')))
		{
			iconP2.changeIcon(dad.curCharacter);
		}
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);

		if (updateColor)
		{
			dad.color = getBackgroundColor(curStage);
		}
		if (reposition)
		{
			repositionChar(dad);
		}
	}

	function switchBF(newChar:String, position:FlxPoint, reposition:Bool = true, updateColor:Bool = true)
	{
		if (reposition)
		{
			position.x -= boyfriend.globalOffset[0];
			position.y -= boyfriend.globalOffset[1];
		}
		bfGroup.remove(boyfriend);
		boyfriend = new Boyfriend(position.x, position.y, newChar);
		bfGroup.add(boyfriend);
		if (FileSystem.exists(Paths.image('ui/iconGrid/${boyfriend.curCharacter}', 'preload')))
		{
			iconP1.changeIcon(boyfriend.curCharacter);
		}
		healthBar.createFilledBar(dad.barColor, boyfriend.barColor);

		if (updateColor)
		{
			boyfriend.color = getBackgroundColor(curStage);
		}
		if (reposition)
		{
			repositionChar(boyfriend);
		}
	}

	function switchGF(newChar:String, position:FlxPoint, reposition:Bool = true, updateColor:Bool = true)
	{
		if (reposition)
		{
			position.x -= gf.globalOffset[0];
			position.y -= gf.globalOffset[1];
		}
		gfGroup.remove(gf);
		gf = new Character(position.x, position.y, newChar);
		gfGroup.add(gf);

		if (updateColor)
		{
			gf.color = getBackgroundColor(curStage);
		}
		if (reposition)
		{
			repositionChar(gf);
		}
	}

	function makeInvisibleNotes(invisible:Bool)
	{
		if (invisible)
		{
			for (strumNote in strumLineNotes)
			{
				FlxTween.cancelTweensOf(strumNote);
				FlxTween.tween(strumNote, {alpha: 0}, 1);
			}
		}
		else
		{
			for (strumNote in strumLineNotes)
			{
				FlxTween.cancelTweensOf(strumNote);
				FlxTween.tween(strumNote, {alpha: 1}, 1);
			}
		}
	}

	function fastCarDrive()
	{
		FlxG.sound.play(Paths.soundRandom('carPass', 0, 1), 0.7);

		fastCar.velocity.x = (FlxG.random.int(170, 220) / FlxG.elapsed) * 3;
		fastCarCanDrive = false;
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			resetFastCar();
		});
	}

	function resetFastCar()
	{
		fastCar.x = -12600;
		fastCar.y = FlxG.random.int(140, 250);
		fastCar.velocity.x = 0;
		fastCarCanDrive = true;
	}

	var trainMoving:Bool = false;
	var trainFrameTiming:Float = 0;

	var trainCars:Int = 8;
	var trainFinishing:Bool = false;
	var trainCooldown:Int = 0;

	function trainStart():Void
	{
		trainMoving = true;
		if (!trainSound.playing)
			trainSound.play(true);
	}

	var startedMoving:Bool = false;

	function updateTrainPos():Void
	{
		if (trainSound.time >= 4700)
		{
			startedMoving = true;
			gf.playAnim('hairBlow');
		}

		if (startedMoving)
		{
			phillyTrain.x -= 400;

			if (phillyTrain.x < -2000 && !trainFinishing)
			{
				phillyTrain.x = -1150;
				trainCars -= 1;

				if (trainCars <= 0)
					trainFinishing = true;
			}

			if (phillyTrain.x < -4000 && trainFinishing)
				trainReset();
		}
	}

	function trainReset():Void
	{
		gf.playAnim('hairFall');
		phillyTrain.x = FlxG.width + 200;
		trainMoving = false;
		// trainSound.stop();
		// trainSound.time = 0;
		trainCars = 8;
		trainFinishing = false;
		startedMoving = false;
	}

	function lightningStrikeShit():Void
	{
		FlxG.sound.play(Paths.soundRandom('thunder_', 1, 2));
		halloweenBG.animation.play('lightning');

		lightningStrikeBeat = curBeat;
		lightningOffset = FlxG.random.int(8, 24);

		boyfriend.playAnim('scared', true);
		gf.playAnim('scared', true);
	}
}
