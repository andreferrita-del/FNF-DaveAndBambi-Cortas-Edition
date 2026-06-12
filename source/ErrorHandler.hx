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

	// CODE ERROR (HAXE / ENGINE)
	static function onError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();

		showCrash("CODE ERROR", Std.string(event.error));
	}

	// SHADER ERROR (MANUAL CALL)
	public static function onShaderError(shaderName:String, error:Dynamic):Void
	{
		showCrash(
			"OPENGL / SHADER ERROR",
			"Shader: " + shaderName + "\n\n" + Std.string(error)
		);
	}

	// MAIN CRASH SCREEN
	static function showCrash(errorType:String, message:String):Void
	{
		var stack:String = CallStack.toString(CallStack.exceptionStack());

		var fullMessage:String =
			"TYPE: " + errorType + "\n\n" +
			"ERROR:\n" + message + "\n\n" +
			"STACK TRACE:\n" + stack;

		var state = FlxG.state;

		// 💜 BACKGROUND
		var bg = new FlxSprite().makeGraphic(
			Std.int(FlxG.width),
			Std.int(FlxG.height),
			0xFF1A001F
		);

		// 💜 GLOW TITLE
		var glow = new FlxText(22, 22, FlxG.width - 40, "ENGINE CRASH", 28);
		glow.setFormat(null, 28, 0xFF6A00FF, "center");
		glow.alpha = 0.5;

		// 💜 TITLE
		var title = new FlxText(20, 20, FlxG.width - 40, "ENGINE CRASH", 28);
		title.setFormat(null, 28, 0xFFB300FF, "center");

		// 💜 ERROR TEXT
		var text = new FlxText(20, 80, FlxG.width - 40, fullMessage, 14);
		text.setFormat(null, 14, 0xFFE6CCFF, "left");

		// 🟣 OK BUTTON
		var okBtn = new FlxButton(
			Std.int(FlxG.width / 2 - 50),
			Std.int(FlxG.height - 80),
			"OK",
			function()
			{
				Sys.exit(1);
			}
		);

		okBtn.color = 0xFFB300FF;
		okBtn.label.color = 0xFFFFFFFF;

		// ADD TO STATE
		state.add(bg);
		state.add(glow);
		state.add(title);
		state.add(text);
		state.add(okBtn);

		// FREEZE GAME
		FlxG.timeScale = 0;
		state.persistentUpdate = true;
		state.persistentDraw = true;
	}
}
