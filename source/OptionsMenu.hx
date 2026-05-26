package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class OptionsMenu extends MusicBeatState
{
	var fullscreenText:FlxText;

	override function create()
	{
		#if mobile
		FlxG.switchState(new MainMenuState());
		#end
			
		var menuBG:FlxSprite = new FlxSprite().loadGraphic(AssetPaths.menuDesat__png);
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		fullscreenText = new FlxText(0, 300, FlxG.width, "(this not save!)FULLSCREEN: OFF", 32);
		fullscreenText.setFormat(null, 32, FlxColor.WHITE, CENTER);
		add(fullscreenText);

		updateText();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (controls.BACK)
			FlxG.switchState(new MainMenuState());

		if (controls.ACCEPT)
		{
			FlxG.fullscreen = !FlxG.fullscreen;
			updateText();
		}

		super.update(elapsed);
	}

	function updateText()
	{
		fullscreenText.text = "(this not save!)FULLSCREEN: " + (FlxG.fullscreen ? "ON" : "OFF");
	}
}
