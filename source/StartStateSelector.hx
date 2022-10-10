package;

import flixel.FlxG;
import flixel.FlxState;

class StartStateSelector extends FlxState
{
   public override function create()
   {
      LanguageManager.initSave();
      LanguageManager.save.data.language == null;
      if (LanguageManager.save.data.language == null)
      {
         FlxG.switchState(new SelectLanguageState());
      }
      else
      {
         FlxG.switchState(new TitleState());
      }
   }
}