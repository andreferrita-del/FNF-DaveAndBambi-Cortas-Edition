package;

import openfl.display.FPS;
import openfl.system.System;
import openfl.events.Event;

class DebugInfo extends FPS
{
	public static var commit:String = "DEV";

	public function new(x:Float = 10, y:Float = 3, color:Int = 0xFFFFFF)
	{
		super(x, y, color);

		addEventListener(Event.ENTER_FRAME, updateText);
	}

	function updateText(e:Event):Void
	{
		var mem:Float = System.totalMemory / 1024 / 1024;

		text = "FPS: " + currentFPS
			+ "\nMEM: " + Std.int(mem) + " MB"
			+ "\nCOMMIT: " + commit;
	}
}
