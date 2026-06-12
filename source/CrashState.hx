package;

import flixel.FlxState;
import lime.app.Application;

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

		// 💥 ONLY POPUP (NO CUSTOM UI)
		Application.current.window.alert(fullText, "ENGINE CRASH");

		// close af
Sys.exit(0);
