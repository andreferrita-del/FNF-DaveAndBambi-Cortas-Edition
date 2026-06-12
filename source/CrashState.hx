package;

import flixel.FlxState;
import lime.app.Application;
import Sys;

class CrashState extends FlxState
{
	var errorType:String;
	var message:String;
	var stack:String;

	public function new(type:String, msg:String, st:String)
	{
		super();

		errorType = type;
		message = msg;
		stack = st;
	}

	override function create()
	{
		super.create();

		var fullText =
			"TYPE: " + errorType + "\n\n" +
			"ERROR:\n" + message + "\n\n" +
			"STACK TRACE:\n" + stack;

		// 💥 LIME ALERT (native popup)
		try
		{
			Application.current.window.alert(fullText, "ENGINE CRASH");
		}
		catch (e:Dynamic)
		{
			trace("Alert failed: " + e);
		}

		// 💀 ensure alert shows before exit
		haxe.Timer.delay(function()
		{
			Sys.exit(1);
		}, 200);
	}
}
