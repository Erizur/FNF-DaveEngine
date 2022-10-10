package;

import flixel.FlxSprite;
    
class GenerateError extends MusicBeatState
{
    var sillySprite:FlxSprite;

    override public function create()
    {
        sillySprite.alpha = 0; // Modifying a value of a null sprite will cause an error
        
        super.create();
    }
}