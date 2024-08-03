package debug;

import flixel.FlxG;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.system.System as OpenFlSystem;
import lime.system.System as LimeSystem;

import debug.Memory;

/**
	The FPS class provides an easy-to-use monitor to display
	the current frame rate of an OpenFL project
**/
#if cpp
	#if windows
	@:cppFileCode('#include <windows.h>')
	#elseif (ios || mac)
	@:cppFileCode('#include <mach-o/arch.h>')
	#else
	@:headerInclude('sys/utsname.h')
	#end
#end
class FpsDisplay extends TextField
{
	/**
		The current frame rate, expressed using frames-per-second
	**/
	public var currentFPS(default, null):Int;

	@:noCompletion private var times:Array<Float>;

	public var osShit:String = '';

	public var memoryMegas(get, never):Float;

	public function new(x:Float = 10, y:Float = 10, color:Int = 0x000000)
	{
		super();

		this.x = x;
		this.y = y;

		final shit:Bool = (LimeSystem.platformName == LimeSystem.platformVersion || LimeSystem.platformVersion == null);

		// os stuff
		#if (openfl && gl_stats)
		if (!shit)
			osShit = "\nOS: " + '${LimeSystem.platformLabel}' #if cpp + ' ${getArch()}' #end + ' - ${LimeSystem.platformVersion}';
		else
			osShit = "\nOS: " + '${LimeSystem.platformLabel}' #if cpp + ' ${getArch()}' #end;
		osShit += "\nGL Render: " + '${getGLInfo(RENDERER)}';
		osShit += "\nGL Shading Version: " + '${getGLInfo(SHADING_LANGUAGE_VERSION)}';
		#end

		positionFPS(x, y);

		currentFPS = 0;
		selectable = false;
		mouseEnabled = false;
		defaultTextFormat = new TextFormat("_sans", 12, color);
		width = FlxG.width;
		multiline = true;
		text = "FPS: ";	

		times = [];
	}

    var deltaTimeout:Float = 0.0;

	// Event Handlers
	@:noCompletion
	private #if !flash override #end function __enterFrame(deltaTime:Float):Void
	{
		// prevents the overlay from updating every frame, why would you need to anyways
		if (deltaTimeout > 1000) {
			deltaTimeout = 0.0;
			return;
		}

		final now:Float = haxe.Timer.stamp() * 1000;
		times.push(now);
		while (times[0] < now - 1000) times.shift();

		currentFPS = times.length < FlxG.updateFramerate ? times.length : FlxG.updateFramerate;		
		updateText();
		deltaTimeout += deltaTime;
	}

	public dynamic function updateText():Void // so people can override it in hscript
	{
		text = 'FPS: $currentFPS' + '\nMemory: ${flixel.util.FlxStringUtil.formatBytes(memoryMegas)}' + osShit;

		textColor = 0xFFFFFFFF;
		if (currentFPS < FlxG.drawFramerate * 0.5)
			textColor = 0xFFFF0000;
	}

	inline function get_memoryMegas():Float
		return Memory.gay();

	public inline function positionFPS(X:Float, Y:Float, ?scale:Float = 1){
		scaleX = scaleY = #if mobile (scale > 1 ? scale : 1) #else (scale < 1 ? scale : 1) #end;
		x = FlxG.game.x + X;
		y = FlxG.game.y + Y;
	}

	#if cpp
	#if windows
	@:functionCode('
		SYSTEM_INFO osInfo;

		GetSystemInfo(&osInfo);

		switch(osInfo.wProcessorArchitecture)
		{
			case 9:
				return ::String("x86_64");
			case 5:
				return ::String("ARM");
			case 12:
				return ::String("ARM64");
			case 6:
				return ::String("IA-64");
			case 0:
				return ::String("x86");
			default:
				return ::String("Unknown");
		}
	')
	#elseif (ios || mac)
	@:functionCode('
		const NXArchInfo *archInfo = NXGetLocalArchInfo();
    	return ::String(archInfo == NULL ? "Unknown" : archInfo->name);
	')
	#else
	@:functionCode('
		struct utsname osInfo{};
		uname(&osInfo);
		return ::String(osInfo.machine);
	')
	#end
	@:noCompletion
	private function getArch():String
	{
		return null;
	}
	#end
}
