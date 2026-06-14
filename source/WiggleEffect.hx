package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxShader;

class WiggleEffect extends ErrorHandledShader
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
		super("WiggleEffect");

		//uSpeed.value = [1.0];
		//uFrequency.value = [5.0];
		//uWaveAmplitude.value = [0.01];
	}
}

