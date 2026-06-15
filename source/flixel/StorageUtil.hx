package flixel;

import sys.FileSystem;

class StorageUtil
{
public static inline var ROOT_FOLDER:String = ".CortasEdition";

public static function getExternalStorageDirectory():String
{
	#if android
	return "/storage/emulated/0/" + ROOT_FOLDER + "/";
	#else
	return ROOT_FOLDER + "/";
	#end
}

public static function getAssetsPath():String
{
	return getExternalStorageDirectory() + "assets/";
}

public static function getModsPath():String
{
	return getExternalStorageDirectory() + "mods/";
}

public static function createFolders():Void
{
	create(getExternalStorageDirectory());
	create(getAssetsPath());
	create(getModsPath());
}

static function create(path:String):Void
{
	if (!FileSystem.exists(path))
		FileSystem.createDirectory(path);
}

}
