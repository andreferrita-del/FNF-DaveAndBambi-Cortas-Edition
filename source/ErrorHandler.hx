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
	}

	static function onError(event:UncaughtErrorEvent):Void
	{
		var error:Dynamic = event.error;
		var stack = CallStack.exceptionStack();

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
		msg += "FILE: " + fileName + "\n";
		msg += "LINE: " + lineNumber + "\n\n";
		msg += "ERROR:\n";
		msg += Std.string(error) + "\n\n";
		msg += "STACK TRACE:\n";
		msg += CallStack.toString(stack);

		AlertMessage.show(msg, "ENGINE CRASH");

		Sys.exit(1);
	}
}
