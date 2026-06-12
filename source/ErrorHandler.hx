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
			onError
		);

		trace("ErrorHandler initialized");
	}

	static function onError(event:UncaughtErrorEvent):Void
	{
		event.preventDefault();

		var error:Dynamic = event.error;

		showCrash(
			"CODE ERROR",
			Std.string(error),
			CallStack.exceptionStack()
		);
	}

	public static function onShaderError(shaderName:String, error:Dynamic):Void
	{
		showCrash(
			"OPENGL / SHADER ERROR",
			'Shader: $shaderName\n\n${Std.string(error)}',
			CallStack.exceptionStack()
		);
	}

	static function showCrash(type:String, error:String, stack:Array<StackItem>):Void
	{
		var fileName:String = "UNKNOWN";
		var lineNumber:Int = -1;

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

		var msg:String = "";

		msg += "ENGINE CRASH\n\n";

		msg += "TYPE:\n";
		msg += type + "\n\n";

		msg += "FILE:\n";
		msg += fileName + "\n\n";

		msg += "LINE:\n";
		msg += lineNumber + "\n\n";

		msg += "ERROR:\n";
		msg += error + "\n\n";

		msg += "STACK TRACE:\n";
		msg += CallStack.toString(stack);

		AlertMessage.show(msg, "ENGINE CRASH");

		Sys.exit(1);
	}
}
