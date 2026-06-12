package;

import flixel.system.FlxAssets.FlxShader;
import lime.graphics.opengl.GLProgram;

class ErrorHandledShader extends FlxShader
{
	public var shaderName:String;

	public function new(?shaderName:String = "Unknown Shader")
	{
		this.shaderName = shaderName;
		super();
	}

	override function __createGLProgram(vertexSource:String, fragmentSource:String):GLProgram
	{
		try
		{
			return super.__createGLProgram(vertexSource, fragmentSource);
		}
		catch (error:Dynamic)
		{
			ErrorHandler.onShaderError(shaderName, error);
			return null;
		}
	}
}
