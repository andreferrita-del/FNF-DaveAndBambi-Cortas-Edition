package;

import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import flixel.mobile.AlertMessage;
import Sys;

class ErrorHandler
{
	public static function init():Void
	{
		trace("ErrorHandler ACTIVE");

		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(
			UncaughtErrorEvent.UNCAUGHT_ERROR,
			onError
		);
	}

	static function onError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();

		handle("CODE ERROR", Std.string(event.error));
	}

	public static function onShaderError(shaderName:String, error:Dynamic):Void
	{
		handle(
			"OPENGL / SHADER ERROR",
			"Shader: " + shaderName + "\n\n" + Std.string(error)
		);
	}

	static function handle(errorType:String, message:String):Void
	{
		var stack:String = CallStack.toString(CallStack.exceptionStack());

		var fullMessage:String =
			"ENGINE CRASH\n\n" +
			"TYPE: " + errorType + "\n\n" +
			"ERROR:\n" + message + "\n\n" +
			"STACK TRACE:\n" + stack;

		// Show alert
		AlertMessage.show(fullMessage, "ENGINE CRASH");

		// Force exit after user closes alert (or fallback)
		Lib.application.window.onClose.add(function()
		{
			Sys.exit(1);
		});

		// Safety fallback crash
		haxe.Timer.delay(function()
		{
			Sys.exit(1);
		}, 5000);
	}
}
