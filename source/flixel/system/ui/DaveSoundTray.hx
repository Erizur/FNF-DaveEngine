package flixel.system.ui;

#if FLX_SOUND_SYSTEM
import flixel.system.ui.FlxSoundTray;
import flixel.util.FlxColor;

import openfl.display.Bitmap;
import openfl.display.BitmapData;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.text.TextFormatAlign;

class DaveSoundTray extends FlxSoundTray
{
	var customText:TextField = new TextField(); // I want to use this in other functions hehe --erizur

	/**
    * Sets up the "sound tray", the little volume meter that pops down sometimes.
    */
	@:keep
    public function new()
    {
        super();

		visible = false;
		scaleX = _defaultScale;
		scaleY = _defaultScale;
		var tmp:Bitmap = new Bitmap(new BitmapData(_width, 30, true, 0x7F000000));
		screenCenter();
		addChild(tmp);

		customText.width = tmp.width;
		customText.height = tmp.height;
		customText.multiline = true;
		customText.wordWrap = true;
		customText.selectable = false;

		#if flash
		customText.embedFonts = true;
		customText.antiAliasType = AntiAliasType.NORMAL;
		customText.gridFitType = GridFitType.PIXEL;
		#else
		#end
		var dtf:TextFormat = new TextFormat("VCR OSD Mono", 8, 0xffffff);
		dtf.align = TextFormatAlign.CENTER;
		customText.defaultTextFormat = dtf;
		addChild(customText);
		customText.text = "Volume - 100%"; // HAHA! I REVERTED YOUR TEXT RAPAREP LOL! LETS GOOOO BABY
		customText.y = 14;

        if (this.contains(text) && text != null)
            removeChild(text); // they can overlap

		var bx:Int = 10;
		var by:Int = 14;
		_bars = new Array();

		for (i in 0...10)
		{
			tmp = new Bitmap(new BitmapData(4, i + 1, false, FlxColor.WHITE));
			tmp.x = bx;
			tmp.y = by;
			addChild(tmp);
			_bars.push(tmp);
			bx += 6;
			by--;
		}

		y = -height;
		visible = false;
    }

    /**
    * Makes the little volume tray slide out.
    *
    * @param	Silent	Whether or not it should beep.
    */
	public override function show(Silent:Bool = false):Void
	{
		if (!Silent)
		{
			var sound = Paths.sound("clicky", "shared");
			if (sound != null)
				FlxG.sound.load(sound).play();
		}

		_timer = 1;
		y = 0;
		visible = true;
		active = true;
		var globalVolume:Int = Math.round(FlxG.sound.volume * 10);

		if (FlxG.sound.muted)
		{
			globalVolume = 0;
		}

		for (i in 0..._bars.length)
		{
			if (i < globalVolume)
			{
				_bars[i].alpha = 1;
			}
			else
			{
				_bars[i].alpha = 0.4;
			}
		}

		text.text = "Volume - " + globalVolume * 10 + "%";
	}
}
#end