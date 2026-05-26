package android;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import android.flixel.FlxButton;

class FlxHitbox extends FlxSpriteGroup
{
	public var hitbox:FlxSpriteGroup;

	public var buttonLeft:FlxButton;
	public var buttonDown:FlxButton;
	public var buttonUp:FlxButton;
	public var buttonRight:FlxButton;

	public function new()
	{
		super();

		hitbox = new FlxSpriteGroup();
		add(hitbox);

		var sectionWidth:Float = FlxG.width / 4;

		buttonLeft = createhitbox(0, 0, sectionWidth, "left");
		buttonDown = createhitbox(sectionWidth, 0, sectionWidth, "down");
		buttonUp = createhitbox(sectionWidth * 2, 0, sectionWidth, "up");
		buttonRight = createhitbox(sectionWidth * 3, 0, sectionWidth, "right");

		hitbox.add(buttonLeft);
		hitbox.add(buttonDown);
		hitbox.add(buttonUp);
		hitbox.add(buttonRight);

		var hints:FlxSprite = new FlxSprite();
		hints.loadGraphic(AssetPaths.hitbox_hint__png);
		hints.scrollFactor.set();
		hints.antialiasing = true;
		hints.alpha = 0.75;
		add(hints);
	}

	public function createhitbox(x:Float, y:Float, width:Float, frame:String):FlxButton
	{
		var button:FlxButton = new FlxButton(x, y);

		button.loadGraphic(
			FlxGraphic.fromFrame(getFrames().getByName(frame))
		);

		button.setGraphicSize(Std.int(width), FlxG.height);
		button.updateHitbox();

		button.scrollFactor.set();
		button.antialiasing = true;
		button.alpha = 0.15;

		button.onDown.callback = function()
		{
			FlxTween.cancelTweensOf(button);

			FlxTween.tween(button, {alpha: 0.35}, 0.08,
			{
				ease: FlxEase.quadOut
			});
		};

		button.onUp.callback = function()
		{
			FlxTween.cancelTweensOf(button);

			FlxTween.tween(button, {alpha: 0.15}, 0.1,
			{
				ease: FlxEase.quadOut
			});
		};

		button.onOut.callback = function()
		{
			FlxTween.cancelTweensOf(button);

			FlxTween.tween(button, {alpha: 0.15}, 0.1,
			{
				ease: FlxEase.quadOut
			});
		};

		return button;
	}

	public function getFrames():FlxAtlasFrames
	{
		return FlxAtlasFrames.fromSparrow(
	AssetPaths.hitbox__png,
	AssetPaths.hitbox__xml
);
	}

	override public function destroy():Void
	{
		super.destroy();

		buttonLeft = null;
		buttonDown = null;
		buttonUp = null;
		buttonRight = null;
	}
}
