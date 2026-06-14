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
			var program = super.__createGLProgram(vertexSource, fragmentSource);

			if (program == null)
				ErrorHandler.onShaderError(shaderName, "GLProgram returned NULL.");

			return program;
		}
		catch (error:Dynamic)
		{
			ErrorHandler.onShaderError(shaderName, error);
			return null;
		}
	}
}
