package flixel.mobile;

import flixel.FlxState;
import flixel.FlxText;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;

import openfl.utils.Assets;

import sys.io.File;
import sys.FileSystem;

import states.TitleState;

#if android
import android.Tools;
import android.Permissions;
import android.PermissionsList;
import lime.app.Application;
#end

class CopyState extends FlxState
{
override function create():Void
{
super.create();

	var bg = new FlxSprite().makeGraphic(
		Std.int(FlxG.width),
		Std.int(FlxG.height),
		0xFF00AA00
	);
	add(bg);

	var txt = new FlxText(
		0,
		0,
		FlxG.width,
		"Copying game assets..."
	);
	txt.setFormat(null, 24, 0xFFFFFFFF, "center");
	txt.screenCenter();
	add(txt);

	#if android

	try
	{
		Permissions.requestPermissions([
			PermissionsList.READ_EXTERNAL_STORAGE,
			PermissionsList.WRITE_EXTERNAL_STORAGE
		]);

		var basePath:String =
			Tools.getExternalStorageDirectory()
			+ "/Android/data/"
			+ Application.current.meta.get("packageName")
			+ "/files/assets/";

		if (!FileSystem.exists(basePath))
			FileSystem.createDirectory(basePath);

		for (asset in Assets.list())
		{
			copyAsset(asset, basePath + asset);
		}

		Application.current.window.alert(
			"All game assets have been copied successfully.\nPress OK to continue.",
			"Cortas Edition Setup"
		);
	}
	catch (e:Dynamic)
	{
		Application.current.window.alert(
			"Failed to copy game assets.\n\n" + Std.string(e),
			"Cortas Edition Error"
		);
	}

	#end

	new FlxTimer().start(1, function(tmr:FlxTimer)
	{
		FlxG.switchState(new TitleState());
	});
}

function copyAsset(assetPath:String, destination:String):Void
{
	try
	{
		var slash = destination.lastIndexOf("/");

		if (slash > -1)
		{
			var dir = destination.substr(0, slash);

			if (!FileSystem.exists(dir))
				FileSystem.createDirectory(dir);
		}

		var bytes = Assets.getBytes(assetPath);

		if (bytes != null)
		{
			File.saveBytes(destination, bytes);
		}
	}
	catch (e:Dynamic)
	{
		trace(e);
	}
}

}
