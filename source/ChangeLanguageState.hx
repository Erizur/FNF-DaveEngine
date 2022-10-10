package;

import flixel.effects.FlxFlicker;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import Controls.KeyboardScheme;
import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import flixel.util.FlxTimer;
#if desktop
#end

class ChangeLanguageState extends MusicBeatState
{
   var currentLanguage:Int = 0;
   var languages:Array<Language> = new Array<Language>();
   var languageTextGroup:FlxTypedGroup<FlxText> = new FlxTypedGroup<FlxText>();
   var selectedLanguage:Bool = false;

   override function create()
	{
	   languages = LanguageManager.getLanguages();
      add(languageTextGroup);

      var menuBG:FlxSprite = new FlxSprite();
      menuBG.color = 0xFFea71fd;
      menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
      menuBG.updateHitbox();
      menuBG.antialiasing = true;
      menuBG.loadGraphic(MainMenuState.randomizeBG());
      add(menuBG);

	   var helper:FlxText = new FlxText(0, 150, FlxG.width, "Select a language", 40);
      helper.setFormat("Comic Sans MS Bold", 60, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
      helper.antialiasing = true;
      helper.borderSize = 3;
	   helper.screenCenter(X);
      add(helper);
      
      for (i in 0...languages.length)
      {
         var curLanguage = languages[i];

         var text:FlxText = new FlxText(0, 350 + (i * 75), FlxG.width, curLanguage.langaugeName, 40);
         text.setFormat("Comic Sans MS Bold", 30, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE);
         text.antialiasing = true;
         text.screenCenter(X);
         add(text);
         languageTextGroup.add(text);

         changeTextState(text, i == currentLanguage ? true : false);
      }

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

      if (!selectedLanguage)
      {
			if (FlxG.sound.music != null)
			{
				Conductor.songPosition = FlxG.sound.music.time;
			}
			if (controls.UP_P)
			{
				changeSelection(-1);
			}
			if (controls.DOWN_P)
			{
				changeSelection(1);
			}
			if (controls.ACCEPT)
			{
				selectLanguage();
			}
         if (controls.BACK)
         {
            FlxG.switchState(new OptionsMenu());
         }
      }
      
	}
   function changeSelection(amount:Int = 0)
   {
      if (amount != 0) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

      currentLanguage += amount;
      if (currentLanguage > languages.length - 1)
      {
         currentLanguage = 0;
      }
      if (currentLanguage < 0)
      {
         currentLanguage = languages.length - 1;
      }
      for (text in languageTextGroup)
      {
         changeTextState(text, languageTextGroup.members[currentLanguage] == text);
      }
   }
   function changeTextState(text:FlxText, selected:Bool)
   {
      if (selected)
      {
         text.setFormat("Comic Sans MS Bold", 40, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
         text.borderSize = 3;
      }
      else
      {
         text.setFormat("Comic Sans MS Bold", 40);
      }
   }
   function selectLanguage()
   {
      FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);

      selectedLanguage = true;

      LanguageManager.save.data.language = languages[currentLanguage].pathName;
      LanguageManager.save.flush();
      LanguageManager.init();
      CoolUtil.init();

      var curText = languageTextGroup.members[currentLanguage];
      FlxTween.tween(FlxG.camera, {zoom: 3}, 2);
      FlxFlicker.flicker(curText, 1.1, 0.15, false, false, function(flicker:FlxFlicker)
      {
         FlxG.resetState();
      });
   }
}