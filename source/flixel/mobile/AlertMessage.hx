package flixel.mobile;

import lime.app.Application;

class AlertMessage
{
	public static function show(message:String, title:String):Void
	{
		#if mobile
		Application.current.window.alert(message, title);
		#else
		trace(title + ": " + message);
		#end
	}
}
