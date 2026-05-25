package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		loadGraphic('assets/images/characters/icons/' + char + '.png');

		antialiasing = true;
		scrollFactor.set();
	}
}
