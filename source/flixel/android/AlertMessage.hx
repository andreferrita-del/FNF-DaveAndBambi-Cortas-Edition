package;

import lime.app.Application;

class AlertMessage
{
	public static function show(title:String, message:String):Void
	{
		#if (desktop || android || ios)
		lime.Application.current.window.alert(message, title);
		#else
		trace(title + ": " + message);
		#end
	}
}
