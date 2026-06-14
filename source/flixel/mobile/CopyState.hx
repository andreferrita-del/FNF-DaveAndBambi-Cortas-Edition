package flixel.mobile;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxState;
import flixel.util.FlxTimer;

import openfl.utils.Assets;
import lime.app.Application;

import sys.FileSystem;
import sys.io.File;

class CopyState extends FlxState
{
	override function create():Void
	{
		super.create();

		add(new FlxSprite().makeGraphic(
			Std.int(FlxG.width),
			Std.int(FlxG.height),
			0xFF00AA00
		));

		var txt = new FlxText(0, 0, FlxG.width, "Copying assets...");
		txt.screenCenter();
		add(txt);

		try
		{
			var files = Assets.list();

			for (file in files)
			{
				copyAsset(file);
			}

			Application.current.window.alert(
				"All game assets were copied successfully!",
				"Cortas Edition Setup"
			);
		}
		catch (e:Dynamic)
		{
			Application.current.window.alert(
				Std.string(e),
				"Copy Error"
			);
		}

		new FlxTimer().start(1, function(_)
		{
			FlxG.switchState(new TitleState());
		});
	}

	function copyAsset(asset:String):Void
	{
		try
		{
			if (!Assets.exists(asset))
				return;

			var bytes = Assets.getBytes(asset);

			if (bytes == null)
				return;

			var dir = haxe.io.Path.directory(asset);

			if (dir != "" && !FileSystem.exists(dir))
				FileSystem.createDirectory(dir);

			File.saveBytes(asset, bytes);
		}
		catch (e:Dynamic)
		{
			trace("Failed to copy: " + asset);
		}
	}
}
