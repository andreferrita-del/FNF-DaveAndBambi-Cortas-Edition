package;

import flixel.FlxState;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import sys.io.File;
import sys.FileSystem;
import Sys;

class CrashState extends FlxState
{
	var type:String;
	var message:String;
	var stack:String;

	public function new(t:String, m:String, s:String)
	{
		super();
		type = t;
		message = m;
		stack = s;
	}

	override function create()
	{
		super.create();

		var full = "TYPE: " + type + "\n\nERROR:\n" + message + "\n\nSTACK:\n" + stack;

		// 💜 BACKGROUND
		var bg = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xFF120012);

		// 💜 BOX
		var box = new FlxSprite().makeGraphic(520, 360, 0xFF2A0033);
		box.x = FlxG.width / 2 - box.width / 2;
		box.y = FlxG.height / 2 - box.height / 2;

		// 💜 TITLE
		var title = new FlxText(0, box.y + 10, FlxG.width, "ENGINE CRASH", 26);
		title.setFormat(null, 26, 0xFFB300FF, "center");

		// 💜 TEXT
		var text = new FlxText(
			box.x + 20,
			box.y + 60,
			box.width - 40,
			full,
			14
		);
		text.setFormat(null, 14, 0xFFE6CCFF, "left");

		// 📁 SAVE LOG
		saveLog(full);

		// 🟣 OK BUTTON (EXIT)
		var ok = new FlxButton(
			Std.int(FlxG.width / 2 - 110),
			Std.int(box.y + box.height - 50),
			"OK",
			function()
			{
				Sys.exit(1);
			}
		);

		ok.color = 0xFF7A00FF;

		// 🔥 RESTART BUTTON
		var restart = new FlxButton(
			Std.int(FlxG.width / 2 + 10),
			Std.int(box.y + box.height - 50),
			"RESTART",
			function()
			{
				FlxG.resetGame();
			}
		);

		restart.color = 0xFFB300FF;

		add(bg);
		add(box);
		add(title);
		add(text);
		add(ok);


		FlxG.timeScale = 0;
		#if !mobile
		FlxG.mouse.enabled = true;
		#end
	}

	function saveLog(data:String)
	{
		try
		{
			
		}
		catch (e:Dynamic)
		{
			trace("log failed: " + e);
		}
	}
}
