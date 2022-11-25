package;

import flixel.input.keyboard.FlxKey;
import flixel.FlxObject;
import Controls.Device;
import flixel.text.FlxText;
import flixel.math.FlxRandom;
import flixel.addons.effects.FlxSkewedSprite;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.math.FlxMath;
import flixel.util.FlxColor;
import PlayState;

using StringTools;

import StringTools;

class Note extends FlxSprite
{
	public var strumTime:Float = 0;

	public var mustPress:Bool = false;
	public var finishedGenerating:Bool = false;
	public var noteData:Int = 0;
	public var canBeHit:Bool = false;
	public var tooLate:Bool = false;
	public var wasGoodHit:Bool = false;
	public var prevNote:Note;
	@:keep public var LocalScrollSpeed:Float = 1;

	public var sustainLength:Float = 0;
	public var isSustainNote:Bool = false;

	public static var swagWidth:Float = 160 * 0.7;
	public static var PURP_NOTE:Int = 0;
	public static var GREEN_NOTE:Int = 2;
	public static var BLUE_NOTE:Int = 1;
	public static var RED_NOTE:Int = 3;

	private var notetolookfor = 0;

	public var originalType = 0;

	public var MyStrum:StrumNote;

	public var noteStyle:String = 'normal';

	public var alphaMult:Float = 1.0;
	public var noteOffset:Float = 0;

	var notes = ['purple', 'blue', 'green', 'red'];

	public function new(strumTime:Float, noteData:Int, ?prevNote:Note, ?sustainNote:Bool = false, ?musthit:Bool = true, noteStyle:String = "normal",
			inCharter:Bool = false /*, guitarSection:Bool = false*/)
	{
		super();

		if (prevNote == null)
			prevNote = this;

		this.prevNote = prevNote;
		this.noteStyle = noteStyle;
		this.isSustainNote = sustainNote;
		this.originalType = noteData;
		this.noteData = noteData;

		x += 78;
		// MAKE SURE ITS DEFINITELY OFF SCREEN?
		y -= 2000;

		inCharter ? this.strumTime = strumTime : {
			this.strumTime = Math.round(strumTime);
			alpha = 0;
		}

		if (this.strumTime < 0)
			this.strumTime = 0;

		if (isInState('PlayState'))
		{
			this.strumTime += FlxG.save.data.offset;
		}
		var notePathLol:String = 'notes/NOTE_assets';
		var noteSize:Float = 0.7; // Here incase we need to do something like pixel arrows

		switch (noteStyle)
		{
			case 'alt-animation':
				notePathLol = 'notes/NOTE_assets';
		}
		switch (this.noteStyle)
		{
			default:
				frames = Paths.getSparrowAtlas(notePathLol, 'shared');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				setGraphicSize(Std.int(width * noteSize));
				updateHitbox();
				// antialiasing = noteStyle != '3D';
				antialiasing = true;
			case 'alt-animation':
				frames = Paths.getSparrowAtlas(notePathLol, 'shared');

				animation.addByPrefix('greenScroll', 'green0');
				animation.addByPrefix('redScroll', 'red0');
				animation.addByPrefix('blueScroll', 'blue0');
				animation.addByPrefix('purpleScroll', 'purple0');

				animation.addByPrefix('purpleholdend', 'pruple end hold');
				animation.addByPrefix('greenholdend', 'green hold end');
				animation.addByPrefix('redholdend', 'red hold end');
				animation.addByPrefix('blueholdend', 'blue hold end');

				animation.addByPrefix('purplehold', 'purple hold piece');
				animation.addByPrefix('greenhold', 'green hold piece');
				animation.addByPrefix('redhold', 'red hold piece');
				animation.addByPrefix('bluehold', 'blue hold piece');

				setGraphicSize(Std.int(width * noteSize));
				updateHitbox();
				// antialiasing = noteStyle != '3D';
				antialiasing = true;
		}
		var str:String = PlayState.SONG.song.toLowerCase();
		if (isInState('PlayState'))
		{
			var state:PlayState = cast(FlxG.state, PlayState);
		}
		switch (str)
		{
			default:
				x += swagWidth * originalType;
				notetolookfor = originalType;

				animation.play('${notes[originalType]}Scroll');
		}
		if (isInState('PlayState'))
		{
			SearchForStrum(musthit);
		}

		if (isSustainNote && prevNote != null)
		{
			alphaMult = 0.6;

			noteOffset += width / 2;

			animation.play('${notes[noteData]}holdend');

			if (PlayState.scrollType == 'downscroll')
			{
				flipY = true;
			}

			updateHitbox();

			noteOffset -= width / 2;

			if (prevNote.isSustainNote)
			{
				prevNote.animation.play('${notes[prevNote.noteData]}hold');

				if (noteStyle != 'shape')
				{
					prevNote.scale.y *= (Conductor.stepCrochet / 100) * PlayState.SONG.speed * 1.5;
					prevNote.updateHitbox();
				}
				else
				{
					// INCOMPLETE
					prevNote.scale.y *= (Conductor.stepCrochet / 100) * PlayState.SONG.speed * 0.75;
					prevNote.scale.x *= (Conductor.stepCrochet / 100) * PlayState.SONG.speed * 0.5;
					prevNote.offset.y += prevNote.height / 3;
					prevNote.updateHitbox();
				}
			}
		}

		if (noteData == 2 && noteStyle == 'shape')
		{
			noteOffset += 10;
		}
		else if (noteData == 1 && noteStyle == 'shape')
		{
			noteOffset += 4;
		}

		if (noteStyle == 'shape' && isSustainNote)
		{
			alphaMult = 1;
			noteOffset += (width / 2);
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (MyStrum != null)
		{
			GoToStrum(MyStrum);
		}
		else
		{
			if (isInState('PlayState'))
			{
				SearchForStrum(mustPress);
			}
		}
		if (mustPress && isInState('PlayState'))
		{
			// The * 0.5 is so that it's easier to hit them too late, instead of too early
			if (strumTime > Conductor.songPosition - Conductor.safeZoneOffset
				&& strumTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
				canBeHit = true;
			else
				canBeHit = false;

			if (strumTime < Conductor.songPosition - Conductor.safeZoneOffset && !wasGoodHit)
				tooLate = true;
		}
		else
		{
			canBeHit = false;

			if (strumTime <= Conductor.songPosition)
				wasGoodHit = true;
		}

		if (tooLate)
		{
			alphaMult = 0.3;
		}
	}

	public function GoToStrum(strum:StrumNote)
	{
		x = strum.x + noteOffset;
		alpha = strum.alpha * alphaMult;
		if (!strum.playerStrum)
		{
			return;
		}
	}

	public function isInState(state:String)
	{
		return Type.getClassName(Type.getClass(FlxG.state)).contains(state);
	}

	public function SearchForStrum(musthit:Bool)
	{
		var state:PlayState = cast(FlxG.state, PlayState);
		if (musthit)
		{
			state.playerStrums.forEach(function(spr:StrumNote)
			{
				if (spr.ID == notetolookfor)
				{
					GoToStrum(spr);
					MyStrum = spr;
					return;
				}
			});
		}
		else
		{
			state.dadStrums.forEach(function(spr:StrumNote)
			{
				if (spr.ID == notetolookfor)
				{
					GoToStrum(spr);
					MyStrum = spr;
					return;
				}
			});
		}
	}
}
