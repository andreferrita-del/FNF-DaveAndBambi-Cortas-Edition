package;

import openfl.display.FPS;
import openfl.events.Event;
import openfl.system.System;
import flixel.FlxG;

class DebugInfo extends FPS
{
	#if GIT_COMMIT
	public static inline var COMMIT:String = GIT_COMMIT;
	#else
	public static inline var COMMIT:String = "UNKNOWN";
	#end

	public static inline var ENGINE_VERSION:String = "0.2.5";

	var peakMemory:Float = 0;

	public function new(x:Float = 10, y:Float = 3, color:Int = 0xFFFFFF)
	{
		super(x, y, color);

		selectable = false;
		mouseEnabled = false;

		addEventListener(Event.ENTER_FRAME, updateInfo);
	}

	function updateInfo(e:Event):Void
	{
		var memory:Float = System.totalMemory / 1024 / 1024;

		if (memory > peakMemory)
			peakMemory = memory;

		var state:String = "Unknown";

		if (FlxG.state != null)
			state = Type.getClassName(Type.getClass(FlxG.state));

		text =
			"FPS: " + currentFPS +
			"\nMEM: " + Std.int(memory) + " MB" +
			"\nPEAK: " + Std.int(peakMemory) + " MB" +
			"\nSTATE: " + state +
			"\nENGINE: " + ENGINE_VERSION +
			"\nCOMMIT: " + COMMIT;
	}
}
