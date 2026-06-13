package;

import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import openfl.errors.Error;
import openfl.events.ErrorEvent;
import haxe.CallStack;
import flixel.FlxG;

class ErrorHandler
{
	public static var crashed:Bool = false;

	public static function init():Void
	{
		// 💥 HAXE / OPENFL ERRORS
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(
			UncaughtErrorEvent.UNCAUGHT_ERROR,
			onUncaughtError
		);

		// 💀 NATIVE CRASH (HXCPP)
		untyped __global__.__hxcpp_set_critical_error_handler(onCriticalError);
	}

	// =========================
	// 💥 MAIN UNCUGHT HANDLER
	// =========================
	static function onUncaughtError(e:UncaughtErrorEvent):Void
	{
		if (crashed) return;
		crashed = true;

		try
		{
			e.preventDefault();
			e.stopPropagation();
			e.stopImmediatePropagation();
		}
		catch (ex:Dynamic) {}

		var msg:String = Std.string(e.error);

		if (Std.isOfType(e.error, Error))
		{
			var err:Error = cast e.error;
			msg = err.message;
		}
		else if (Std.isOfType(e.error, ErrorEvent))
		{
			var err:ErrorEvent = cast e.error;
			msg = err.text;
		}

		var stack = CallStack.toString(CallStack.exceptionStack());

		finishCrash("CODE ERROR", msg, stack);
	}

	// =========================
	// 💀 NATIVE CRASH HANDLER
	// =========================
	static function onCriticalError(msg:Dynamic):Void
	{
		if (crashed) return;
		crashed = true;

		var stack = CallStack.toString(CallStack.callStack());

		finishCrash("NATIVE ERROR", Std.string(msg), stack);
	}

	// =========================
	// 💥 FINAL CRASH ROUTE
	// =========================
	static function finishCrash(type:String, msg:String, stack:String):Void
	{
		try
		{
			FlxG.resetState();

			haxe.Timer.delay(function()
			{
				FlxG.switchState(new CrashState(type, msg, stack));
			}, 50);
		}
		catch (e:Dynamic)
		{
			// 💀 fallback hard crash if everything dies
			trace("CRASH FAILED: " + e);
		}
	}

	// =========================
	// 💥 SHADER ERROR CALL
	// =========================
	public static function shaderCrash(name:String, err:Dynamic):Void
	{
		if (crashed) return;
		crashed = true;

		var stack = CallStack.toString(CallStack.callStack());

		finishCrash(
			"SHADER ERROR: " + name,
			Std.string(err),
			stack
		);
	}
}
