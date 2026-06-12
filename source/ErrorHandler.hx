package;

import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import lime.app.Application;
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

	// CODE ERRORS (HAXE / OPENFL)
	static function onError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();

		handleError(
			"CODE ERROR",
			Std.string(event.error)
		);
	}

	// SHADER ERRORS (MANUAL CALL)
	public static function onShaderError(shaderName:String, error:Dynamic):Void
	{
		handleError(
			"OPENGL / SHADER ERROR",
			"Shader: " + shaderName + "\n\n" + Std.string(error)
		);
	}

	// MAIN CRASH HANDLER
	static function handleError(errorType:String, message:String):Void
	{
		var stack:String = CallStack.toString(CallStack.exceptionStack());

		var fullMessage:String =
			"============================\n" +
			"        ENGINE CRASH        \n" +
			"============================\n\n" +
			"TYPE: " + errorType + "\n\n" +
			"ERROR:\n" + message + "\n\n" +
			"STACK TRACE:\n" + stack;

		// LIME ALERT (engine-level popup)
		Application.current.window.alert(fullMessage, "ENGINE CRASH");

		// TRY SAFE EXIT AFTER WINDOW CLOSE
		try
		{
			Application.current.window.onClose.add(function()
			{
				Sys.exit(1);
			});
		}
		catch (e:Dynamic)
		{
			// fallback if window is not available
			Sys.exit(1);
		}

		// HARD SAFETY FALLBACK
		haxe.Timer.delay(function()
		{
			Sys.exit(1);
		}, 5000);
	}
}
