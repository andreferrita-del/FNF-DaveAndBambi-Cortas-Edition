package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxCamera;
import flixel.FlxBasic;
import flixel.group.FlxGroup;
import flixel.tweens.FlxTween;

class BlackFade
{
    public static function addBlackFade(parent:FlxGroup, cam:FlxCamera = null, time:Float = 10):FlxSprite
    {
        var black:FlxSprite = new FlxSprite();
        black.makeGraphic(
            Std.int(FlxG.width),
            Std.int(FlxG.height),
            0xFF000000
        );

        black.scrollFactor.set();

        if (cam != null)
            black.cameras = [cam];

        parent.add(black);

        FlxTween.tween(black, {alpha: 0}, time, {
            onComplete: function(_)
            {
                black.kill();
                black.destroy();
            }
        });

        return black;
    }
}
