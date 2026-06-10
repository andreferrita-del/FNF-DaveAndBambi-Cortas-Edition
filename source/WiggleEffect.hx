package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxShader;

class WiggleEffect extends FlxShader
{
	@:glFragmentSource('
	#pragma header

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
		super();

		uTime.value = [0];
		uSpeed.value = [1];
		uFrequency.value = [5];
		uWaveAmplitude.value = [0.01];
	}

	public function update(elapsed:Float):Void
	{
		uTime.value[0] += elapsed;
	}

	public static function addWiggleEffect(
		object:FlxSprite,
		speed:Float,
		frequency:Float
	):WiggleEffect
	{
		var wiggle = new WiggleEffect();

		wiggle.uWaveAmplitude.value = [0.1];
		wiggle.uSpeed.value = [speed];
		wiggle.uFrequency.value = [frequency];

		object.shader = wiggle;

		return wiggle;
	}
}
