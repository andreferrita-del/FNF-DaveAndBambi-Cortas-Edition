package;

import flixel.FlxGame;
import openfl.display.FPS;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();
		ErrorHandler.init();
		
		addChild(new FlxGame(1280, 720, TitleState));

		addChild(new DebugInfo(10, 3));
	}
}
