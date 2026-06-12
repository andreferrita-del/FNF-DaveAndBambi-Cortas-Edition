package;

import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack;
import haxe.CallStack.StackItem;
import flixel.mobile.AlertMessage;
import Sys;

class ErrorHandler
{
	public static function init():Void
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(
			UncaughtErrorEvent.UNCAUGHT_ERROR,
			onCodeError
		);
	}

	static function onCodeError(event:UncaughtErrorEvent):Void
	{
		reportError("CODE ERROR", event.error);
	}

	public static function onShaderError(shaderName:String, error:Dynamic):Void
	{
		reportError(
			"OPENGL / SHADER ERROR",
			'Shader "$shaderName"\n\n${Std.string(error)}'
		);
	}

	static function reportError(errorType:String, error:Dynamic):Void
	{
		var stack = CallStack.exceptionStack();

		var fileName = "UNKNOWN";
		var lineNumber = -1;

		for (item in stack)
		{
			switch (item)
			{
				case FilePos(_, file, line, _):
					fileName = file;
					lineNumber = line;

				default:
			}
		}

		var msg = "";
		msg += "ENGINE CRASH\n\n";
		msg += "TYPE: " + errorType + "\n\n";
		msg += "FILE: " + fileName + "\n";
		msg += "LINE: " + lineNumber + "\n\n";
		msg += "ERROR:\n";
		msg += Std.string(error);

		AlertMessage.show(msg, "ENGINE CRASH");

		Sys.exit(1);
	}
}
