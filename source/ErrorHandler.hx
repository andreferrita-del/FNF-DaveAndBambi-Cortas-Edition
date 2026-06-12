package;

import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import flixel.FlxG;

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

	// CODE ERROR
	static function onError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();

		showCrash("CODE ERROR", Std.string(event.error));
	}

	// SHADER ERROR
	public static function onShaderError(shaderName:String, error:Dynamic):Void
	{
		showCrash(
			"OPENGL / SHADER ERROR",
			"Shader: " + shaderName + "\n\n" + Std.string(error)
		);
	}

	// SEND TO CRASH STATE
	static function showCrash(type:String, message:String):Void
	{
		var stack = CallStack.toString(CallStack.exceptionStack());

		FlxG.switchState(new CrashState(type, message, stack));
	}
}
