package;

import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.Event;
import openfl.system.System;
import openfl.Lib;

#if sys
import sys.io.Process;
#end

class DebugInfo extends TextField
{
	var times:Array<Float> = [];
	var peakMemory:Float = 0;
	var commit:String = "UNKNOWN";

	public function new(x:Float = 10, y:Float = 3)
	{
		super();

		this.x = x;
		this.y = y;

		width = 500;
		height = 200;

		selectable = false;
		mouseEnabled = false;

		defaultTextFormat = new TextFormat("_sans", 14, 0xFFFFFF);

		commit = getCommit();

		addEventListener(Event.ENTER_FRAME, updateInfo);
	}

	function getCommit():String
	{
		#if sys
		try
		{
			var process = new Process("git", ["rev-parse", "--short", "HEAD"]);
			var result = StringTools.trim(process.stdout.readAll().toString());

			process.close();

			if (result != "")
				return result;
		}
		catch (e:Dynamic)
		{
			trace("Failed to get git commit: " + e);
		}
		#end

		return "UNKNOWN";
	}

	function updateInfo(e:Event):Void
	{
		var now = Lib.getTimer();

		times.push(now);

		while (times.length > 0 && times[0] < now - 1000)
			times.shift();

		var fps:Int = times.length;

		var memory:Float = System.totalMemory / 1024 / 1024;

		if (memory > peakMemory)
			peakMemory = memory;

		text =
			"FPS: " + fps +
			"\nMEM: " + Std.int(memory) + " MB" +
			"\nPEAK: " + Std.int(peakMemory) + " MB" +
			"\nCOMMIT: " + commit;
	}
}
