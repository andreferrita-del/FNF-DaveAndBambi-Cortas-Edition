package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxCamera;
import openfl.filters.ShaderFilter;
import flixel.system.FlxAssets.FlxShader;

class WiggleEffect extends FlxShader
{
	@:glFragmentSource('
	#pragma header

	uniform float uTime;
	uniform float uSpeed = 2;
	uniform float uFrequency;
	uniform float uWaveAmplitude;

	vec2 sineWave(vec2 pt)
	{
		float x = 0.0;
		float y = 0.0;

		float offsetY = sin(pt.y * uFrequency + 10.0 * pt.x + uTime * uSpeed) * uWaveAmplitude;
		float offsetX = sin(pt.x * uFrequency + 5.0 * pt.y + uTime * uSpeed) * uWaveAmplitude;

		pt.y += offsetY;
		pt.x += offsetX;

		return vec2(pt.x + x, pt.y + y);
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

	// UPDATE TIMER
	
	// ADD WIGGLE EFFECT
	public static function addWiggleEffect(
		object:FlxSprite,  // NUMBER 2
		speed:Float,     // NUMBER 3
		frequency:Float  // NUMBER 4
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
