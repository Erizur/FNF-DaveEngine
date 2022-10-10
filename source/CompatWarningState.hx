package;

import flixel.math.FlxMath;
import flixel.tweens.misc.ColorTween;
import flixel.addons.display.FlxBackdrop;
import flixel.FlxSprite;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.text.FlxText;
import flixel.effects.FlxFlicker;
import flixel.util.FlxSave;

class CompatWarningState extends MusicBeatState
{
    var bg:FlxBackdrop;
    var warningBox:FlxText;
    var textItems:Array<FlxText> = new Array<FlxText>();
    var curSelected:Int;
    var optionArray:Array<Int> = [1, 0]; //Yes, No
    var optionTranslate:Array<String> = [LanguageManager.getTextString("compat_yes"), LanguageManager.getTextString("compat_no")];
    var currentText:FlxText;
    var accepted:Bool;

    public override function create():Void
    {
        bg = new FlxBackdrop(Paths.image('ui/checkeredBG', 'preload'), 1, 1, true, true, 1, 1);
        bg.antialiasing = true;
        add(bg);

        warningBox = new FlxText(0, (FlxG.height / 2) - 300, FlxG.width, LanguageManager.getTextString("compat_warning"), 45);
        warningBox.setFormat("Comic Sans MS Bold", 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        warningBox.antialiasing = true;
        warningBox.borderSize = 2;
        warningBox.screenCenter(X);
        add(warningBox);

        for(i in 0...optionArray.length)
        {
            var optionText:FlxText = new FlxText((i * 75) - 50, FlxG.height / 2 - 150, FlxG.width, optionTranslate[i], 25);
            optionText.screenCenter(Y);
            optionText.setFormat("Comic Sans MS Bold", 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
            optionText.antialiasing = true;
            optionText.borderSize = 2;

            textItems.push(optionText);
            add(optionText);
        }

        changeSelection();
    }
    public override function update(elapsed:Float)
    {
        var scrollSpeed:Float = 50;
        bg.x -= scrollSpeed * elapsed;
        bg.y -= scrollSpeed * elapsed;

        if (!accepted)
            {
                if (controls.ACCEPT)
                {
                    accepted = true;

                    FlxG.sound.play(Paths.sound('confirmMenu'), 0.4);

                    var formattedBool:Bool = false;
                    if(optionArray[curSelected] == 1){formattedBool = true;}else{formattedBool = false;}

                    trace(formattedBool);

                    CompatTool.save.data.compatMode = formattedBool;
                    CompatTool.save.flush();

                    FlxFlicker.flicker(currentText, 1.1, 0.07, true, true, function(flick:FlxFlicker)
                    {
                        FlxG.switchState(new TitleState());
                        FlxG.sound.playMusic(Paths.music('freakyMenu'), 0);
                        FlxG.sound.music.fadeIn(4, 0, 0.7);
                    });
                }
                if (controls.LEFT_P)
                {
                    changeSelection(-1);
                }
                if (controls.RIGHT_P)
                {
                    changeSelection(1);
                }
            }
    }
    function changeSelection(amount:Int = 0)
    {
        if (amount != 0) FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        curSelected += amount;
        if (curSelected > optionArray.length - 1)
        {
            curSelected = 0;
        }
        if (curSelected < 0)
        {
            curSelected = optionArray.length - 1;
        }
        currentText = textItems[curSelected];
        for (menuItem in textItems)
        {
            updateText(menuItem, menuItem == textItems[curSelected]);
        }
    }
    function updateText(text:FlxText, selected:Bool)
    {
        if (selected)
        {
            text.setFormat("Comic Sans MS Bold", 25, FlxColor.YELLOW, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        }
        else
        {
            text.setFormat("Comic Sans MS Bold", 25, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
        }
    }
}