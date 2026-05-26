package;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;

using StringTools;

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;
	var menuItems:FlxTypedGroup<FlxSprite>;

	#if !switch
	var optionShit:Array<String> = ['freeplay', 'options', 'donate'];
	#else
	var optionShit:Array<String> = ['freeplay', 'options'];
	#end

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var selectedSomethin:Bool = false;

	// TOUCH / SWIPE
	var touchStartY:Float = 0;
	var isTouching:Bool = false;
	var swipeThreshold:Float = 40;

	override function create()
	{
		if (!FlxG.sound.music.playing)
		{
			FlxG.sound.playMusic('assets/music/freakyMenu' + TitleState.soundExt);
		}

		persistentUpdate = true;
		persistentDraw = true;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(AssetPaths.menuBG__png);
		bg.scrollFactor.set(0, 0.18);
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(AssetPaths.menuDesat__png);
		magenta.scrollFactor.set(0, 0.18);
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var tex = FlxAtlasFrames.fromSparrow(
			AssetPaths.FNF_main_menu_assets__png,
			AssetPaths.FNF_main_menu_assets__xml
		);

		for (i in 0...optionShit.length)
		{
			var item = new FlxSprite(0, 60 + (i * 160));
			item.frames = tex;
			item.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			item.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			item.animation.play('idle');
			item.ID = i;
			item.screenCenter(X);
			item.antialiasing = true;
			menuItems.add(item);
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		changeItem();

		super.create();
	}

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;

		if (!selectedSomethin)
		{
			// =========================
			// KEYBOARD (PC)
			// =========================
			if (controls.UP_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(-1);
			}

			if (controls.DOWN_P)
			{
				FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
				changeItem(1);
			}

			if (controls.BACK)
				FlxG.switchState(new TitleState());

			if (controls.ACCEPT)
				triggerSelection();

			// =========================
			// TOUCH (MOBILE)
			// =========================
			#if mobile
			var touch = FlxG.touches.list[0];

			if (touch != null)
			{
				// START TOUCH
				if (touch.justPressed)
				{
					isTouching = true;
					touchStartY = touch.y;

					// CLICK DETECT
					menuItems.forEach(function(item:FlxSprite)
					{
						if (touch.overlaps(item))
						{
							curSelected = item.ID;
							changeItem(0);
							FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
						}
					});
				}

				// SWIPE MOVE
				if (isTouching)
				{
					var deltaY = touch.y - touchStartY;

					if (deltaY > swipeThreshold)
					{
						changeItem(1);
						FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
						touchStartY = touch.y;
					}
					else if (deltaY < -swipeThreshold)
					{
						changeItem(-1);
						FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt);
						touchStartY = touch.y;
					}
				}

				// RELEASE = SELECT
				if (touch.justReleased)
				{
					isTouching = false;
					triggerSelection();
				}
			}
		}
		#end

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function triggerSelection()
	{
		if (optionShit[curSelected] == 'donate')
		{
			#if linux
			Sys.command('/usr/bin/xdg-open',
				["https://ninja-muffin24.itch.io/funkin", "&"]);
			#else
			FlxG.openURL('https://ninja-muffin24.itch.io/funkin');
			#end
		}
		else
		{
			selectedSomethin = true;

			FlxG.sound.play('assets/sounds/confirmMenu' + TitleState.soundExt);
			FlxFlicker.flicker(magenta, 1.1, 0.15, false);

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				}
				else
				{
					FlxFlicker.flicker(spr, 1, 0.06, false, false,
						function(flick:FlxFlicker)
						{
							switch (optionShit[curSelected])
							{
								case 'options':
									FlxG.switchState(new OptionsMenu());

								case 'freeplay':
									FlxG.switchState(new FreeplayState());
							}
						});
				}
			});
		}
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				camFollow.setPosition(
					spr.getGraphicMidpoint().x,
					spr.getGraphicMidpoint().y
				);
			}

			spr.updateHitbox();
		});
	}
}
