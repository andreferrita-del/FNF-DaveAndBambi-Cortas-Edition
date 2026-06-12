package;

import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import Sys;

class ErrorHandler
{
	public static function init():Void
	{
		trace("ErrorHandler initialized");

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(
			UncaughtErrorEvent.UNCAUGHT_ERROR,
			onError
		);
	}

	static function onError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();
		showCrash("CODE ERROR", Std.string(event.error));
	}

	public static function onShaderError(shaderName:String, error:Dynamic):Void
	{
		showCrash("SHADER ERROR", "Shader: " + shaderName + "\n\n" + Std.string(error));
	}

	static function showCrash(type:String, message:String):Void
	{
		var state = FlxG.state;

		var full = type + "\n\n" + message;

		// 💜 DARK BACKGROUND
		var bg = new FlxSprite().makeGraphic(
			Std.int(FlxG.width),
			Std.int(FlxG.height),
			0xCC120012
		);

		// 🟣 MODAL BOX (fake rounded look)
		var boxWidth = 500;
		var boxHeight = 300;

		var box = new FlxSprite().makeGraphic(boxWidth, boxHeight, 0xFF2A0033);

		box.x = FlxG.width / 2 - boxWidth / 2;
		box.y = FlxG.height / 2 - boxHeight / 2;

		// 💜 TEXT (CENTERED)
		var text = new FlxText(box.x + 20, box.y + 20, boxWidth - 40, full, 16);
		text.setFormat(null, 16, 0xFFE6CCFF, "center");

		// 🟣 OK BUTTON (ONLY CONTROL)
		var okBtn = new FlxButton(
			Std.int(FlxG.width / 2 - 40),
			Std.int(box.y + boxHeight - 60),
			"OK",
			function()
			{
				Sys.exit(1);
			}
		);

		okBtn.color = 0xFF7A00FF;
		okBtn.label.color = 0xFFFFFFFF;

		// ADD TO STATE
		state.add(bg);
		state.add(box);
		state.add(text);
		state.add(okBtn);

		FlxG.timeScale = 0;
		state.persistentUpdate = true;
		state.persistentDraw = true;
	}
}
