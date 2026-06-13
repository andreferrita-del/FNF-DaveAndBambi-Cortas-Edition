package;

import lime.app.Application;

import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import openfl.events.ErrorEvent;
import openfl.errors.Error;

import haxe.CallStack;
import haxe.CallStack.StackItem;

class ErrorHandler
{
	public static var crashed:Bool = false;

	public static function init():Void
	{
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(
			UncaughtErrorEvent.UNCAUGHT_ERROR,
			onError
		);

		untyped __global__.__hxcpp_set_critical_error_handler(onCriticalError);
	}

	static function onError(e:UncaughtErrorEvent):Void
	{
		if (crashed) return;
		crashed = true;

		try
		{
			e.preventDefault();
			e.stopPropagation();
			e.stopImmediatePropagation();
		}
		catch (_:Dynamic) {}

		handleCrash(e.error, "Uncaught Error:(!");
	}

	static function onCriticalError(message:Dynamic):Void
	{
		if (crashed) return;
		crashed = true;

		handleCrash(message, "Uncaught Error:(!");
	}

	static function handleCrash(error:Dynamic, title:String):Void
	{
		var errorMessage:String = "";

		if (Std.isOfType(error, Error))
		{
			errorMessage = cast(error, Error).message;
		}
		else if (Std.isOfType(error, ErrorEvent))
		{
			errorMessage = cast(error, ErrorEvent).text;
		}
		else
		{
			errorMessage = Std.string(error);
		}

		var stack:Array<StackItem> = CallStack.exceptionStack(true);
		var stackText:String = "";

		for (item in stack)
		{
			switch (item)
			{
				case FilePos(_, file, line, _):
					stackText += file + " (line " + line + ")\n";

				case Method(cls, func):
					stackText += cls + "." + func + "()\n";

				default:
			}
		}

		var crashText =
			title +
			"\n\nERROR:\n" +
			errorMessage +
			"\n\nSTACK TRACE:\n" +
			stackText;

		trace(crashText);

		try
		{
			Application.current.window.alert(
				crashText,
				title
			);
		}
		catch (e:Dynamic)
		{
			trace("FAILED TO SHOW ALERT: " + e);
		}

		Sys.exit(1);
	}

	// =========================
	// SHADER SUPPORT
	// =========================

	public static function shaderCrash(shaderName:String, error:Dynamic):Void
	{
		if (crashed) return;
		crashed = true;

		var stack:String = CallStack.toString(CallStack.callStack());

		var crashText =
			"SHADER COMPILATION ERROR:(!\n\n" +
			"SHADER:\n" + shaderName +
			"\n\nERROR:\n" + Std.string(error) +
			"\n\nSTACK TRACE:\n" + stack;

		trace(crashText);

		try
		{
			Application.current.window.alert(
				crashText,
				"SHADER COMPILATION ERROR:(!"
			);
		}
		catch (e:Dynamic)
		{
			trace("FAILED TO SHOW ALERT: " + e);
		}

		Sys.exit(1);
	}

	
	public static function onShaderError(shaderName:String, error:Dynamic):Void
	{
		shaderCrash(shaderName, error);
	
