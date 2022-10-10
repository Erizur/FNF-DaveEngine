package;

import flixel.util.FlxColor;
import flixel.util.FlxSave;

using StringTools;

class LanguageManager
{
   public static var currentLocaleList:Array<String>;
   public static var save:FlxSave;

   public static function initSave()
   {
      save = new FlxSave();
      save.bind('language', 'ninjamuffin99');
   }
   public static function init()
   {
      LanguageManager.currentLocaleList = CoolUtil.coolTextFile(Paths.file('locale/' + LanguageManager.save.data.language + '/textList.txt', TEXT, 'preload'));
   }

   public static function languageFromPathName(pathName:String):Language
   {
      var langauges:Array<Language> = getLanguages();

      for (langauge in langauges)
      {
         if (langauge.pathName == pathName)
         {
            return langauge;
         }
      }
      return null;
   }
   public static function getTextString(stringName:String):String
   {
      var returnedString:String = '';
      for (i in 0...currentLocaleList.length)
      {
         var currentValue = currentLocaleList[i].trim().split('==');
         if (currentValue[0] != stringName)
         {
            continue;
         }
         else
         {
            returnedString = currentValue[1];
         }
      }
      if (returnedString == '')
      {
         return stringName;
      }
      else
      {
         returnedString = returnedString.replace(':linebreak:', '\n');
         returnedString = returnedString.replace(':addquote:', '\"');
         return returnedString;
      }
   }
   public static function getLanguages():Array<Language>
   {
      var languages:Array<Language> = new Array<Language>();
      var languagesText:Array<String> = CoolUtil.coolTextFile(Paths.langaugeFile());

      for (language in languagesText)
      {
         var splitInfo = language.split(':');
         var languageClass:Language = new Language(splitInfo[0], splitInfo[1], FlxColor.fromString(splitInfo[2]));
         languages.push(languageClass);
      }
      return languages;
   }
}