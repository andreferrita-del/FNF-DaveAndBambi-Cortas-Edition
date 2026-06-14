package flixel.mobile;

import flixel.FlxState;
import flixel.text.FlxText;
import openfl.utils.Assets;
import sys.io.File;
import sys.FileSystem;
import states.TitleState;
import flixel.FlxG;

#if android
import android.Tools;
import lime.app.Application;
#end

class CopyState extends FlxState
{
override function create()
{
super.create();

var txt = new FlxText(0, 0, 0, "Initializing asset transfer...");
add(txt);

#if android

try
{
	var basePath = Tools.getExternalStorageDirectory()
		+ "/Android/data/"
		+ Application.current.meta.get("packageName")
		+ "/files/assets/";

	if (!FileSystem.exists(basePath))
		FileSystem.createDirectory(basePath);

	var assetList = Assets.list();

	if (assetList.length > 0)
	{
		for (asset in assetList)
		{
			copyAsset(asset, basePath + asset);
		}

		txt.text = "Asset transfer completed successfully.";
	}
	else
	{
		txt.text = "No assets to copy.";
	}

	FlxG.switchState(new TitleState());
}
catch (e:Dynamic)
{
	txt.text = "Asset transfer failed.";
	trace("Error during asset transfer: " + e);
	FlxG.switchState(new TitleState());
}

#else

txt.text = "This feature is available on Android devices only.";
FlxG.switchState(new TitleState());

#end

}

function copyAsset(assetPath, destination)
{
try
{
var dir = destination.substr(0, destination.lastIndexOf("/"));

	if (!FileSystem.exists(dir))
		FileSystem.createDirectory(dir);

	var bytes = Assets.getBytes(assetPath);

	if (bytes != null)
	{
		File.saveBytes(destination, bytes);
		trace("Successfully copied asset: " + assetPath);
	}
}
catch (e:Dynamic)
{
	trace("Failed to copy asset '" + assetPath + "': " + e);
}

}
}
