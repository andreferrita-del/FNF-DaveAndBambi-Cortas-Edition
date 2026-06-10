package;

//import flixel.FlxBasic;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxShader;

class WiggleEffect extends FlxShader
{
	public var shader:WiggleEffect;

	public function addWiggleEffect(target:FlxSprite, speed:Float = 1, frequency:Float = 5)
	{
		super.addWiggleEffect();

		shader = new WiggleEffect();

		shader.uSpeed.value = [speed];
		shader.uFrequency.value = [frequency];
		shader.uWaveAmplitude.value = [0.1];

		target.shader = shader;

		//FlxG.state.add(this);
	}

	override public function update(elapsed:Float):Void
	{
		super.update();

		shader.uTime.value[0] += elapsed;
	}
	
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
	}
}
