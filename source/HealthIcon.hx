package;

import flixel.FlxSprite;

class HealthIcon extends FlxSprite
{
	public function new(char:String = 'bf', isPlayer:Bool = false)
	{
		super();

		loadGraphic(AssetPaths.iconSpam__png, true, 150, 150);

		antialiasing = true;
		animation.add('bf', [0, 1], 0, false, isPlayer);
		animation.add('gf', [2], 0, false, isPlayer);
		animation.add('conbi', [3, 4], 0, false, isPlayer);
		animation.add('hortas', [5, 6], 0, false, isPlayer);
		animation.play(char);
		scrollFactor.set();
	}
}
