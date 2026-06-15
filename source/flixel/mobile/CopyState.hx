package flixel.mobile;

import flixel.FlxG;
import flixel.FlxState;
import flixel.StorageUtil;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxBar;
import flixel.ui.FlxBar.FlxBarFillDirection;
import openfl.utils.Assets;
import lime.app.Application;
import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

class CopyState extends FlxState
{
	var progressBar:FlxBar;
	var progressText:FlxText;

	var currentFile:Int = 0;
	var totalFiles:Int = 0;

	override function create():Void
	{
		super.create();

		StorageUtil.createFolders();

		add(new FlxSprite().makeGraphic(
			Std.int(FlxG.width),
			Std.int(FlxG.height),
			0xFF00AA00
		));

		var title:FlxText = new FlxText(
			0,
			100,
			FlxG.width,
			"Copying Game Files..."
		);
		title.setFormat(null, 24, 0xFFFFFFFF, "center");
		add(title);

		totalFiles = Assets.list().length;

		progressBar = new FlxBar(
			50,
			FlxG.height - 80,
			FlxBarFillDirection.LEFT_TO_RIGHT,
			FlxG.width - 100,
			30,
			this,
			"currentFile",
			0,
			totalFiles
		);

		progressBar.createFilledBar(
			0xFF3A3A3A, // cinza
			0xFF4DA6FF  // azul
		);

		add(progressBar);

		progressText = new FlxText(
			0,
			progressBar.y + 40,
			FlxG.width,
			"0%"
		);
		progressText.setFormat(null, 16, 0xFFFFFFFF, "center");
		add(progressText);

		copyAllAssets();
	}

	function copyAllAssets():Void
	{
		try
		{
			var files = Assets.list();

			for (asset in files)
			{
				copyAsset(asset);

				currentFile++;

				var percent:Int = Std.int((currentFile / totalFiles) * 100);

				progressText.text =
					percent + "% (" + currentFile + "/" + totalFiles + ")";
			}

			if (currentFile >= totalFiles)
			{
				Application.current.window.alert(
					"All files copied successfully!",
					"Cortas Edition Setup"
				);

				FlxG.switchState(new TitleState());
			}
		}
		catch (e:Dynamic)
		{
			Application.current.window.alert(
				Std.string(e),
				"Copy Error"
			);
		}
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

			var destination:String =
				StorageUtil.getExternalStorageDirectory() + asset;

			var directory:String = Path.directory(destination);

			if (!FileSystem.exists(directory))
				FileSystem.createDirectory(directory);

			File.saveBytes(destination, bytes);
		}
		catch (e:Dynamic)
		{
			trace("Failed to copy: " + asset + " -> " + e);
		}
	}
}
