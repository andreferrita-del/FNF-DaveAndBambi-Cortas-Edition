package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxShader;

class WiggleEffect extends ErrorHandledShader
{
	@:glFragmentSource('
	#pragma headere

	uniform float uTime;
	uniform float uSpeed;
	uniform float uFrequency;
	uniform float uWaveAmplitude;

	vec2 sineWave(vec2 pt)
	{
		float offsetY = sin(pt.y * uFrequency + 10.0 * pt.x + uTime * uSpeed) * uWaveAmplitude;
		float offsetX = sin(pt.x * uFrequency + 5.0 * pt.y + uTime * uSpeed) * uWaveAmplitude;

		pt.y += offsetY;
		pt.x += offsetX;

		return pt;
	}

	void main()
	{
		vec2 uv = sineWave(openfl_TextureCoordv);
		gl_FragColor = texture2D(bitmap, uv);
	}
	')

	public function new()
	{
		super("WiggleEffect");

		uTime.value = [0.0];
		uSpeed.value = [1.0];
		uFrequency.value = [5.0];
		uWaveAmplitude.value = [0.01];
	}

	public function update(elapsed:Float):Void
	{
		uTime.value[0] += elapsed;
	}

	// APPLY EFFECT TO SPRITE
	public static function addWiggleEffect(sprite:FlxSprite, speed:Float, frequency:Float):WiggleEffect
	{
		var fx:WiggleEffect = null;

		try
		{
			fx = new WiggleEffect();

			fx.uSpeed.value = [speed];
			fx.uFrequency.value = [frequency];
			fx.uWaveAmplitude.value = [0.1];

			sprite.shader = fx;
		}
		catch (e:Dynamic)
		{
			ErrorHandler.onShaderError("WiggleEffect", e);
		}

		return fx;
	}
}
