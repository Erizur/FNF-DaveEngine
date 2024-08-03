package;

#if HSCRIPT_ALLOWED
#if sys
import sys.FileSystem;
import sys.io.File;
#end
import hscript.Expr;
import hscript.Parser;
import hscript.Interp;
import flixel.FlxBasic;
import openfl.utils.Assets;
import haxe.ds.StringMap;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;

// rewriting this thing to not be based on YCE, and not require hscript-improved
// this is very much a WIP, everything is subject to change
class HScriptTool {
	public static var exprs:StringMap<Dynamic>;

	public function new(){
		final parser:Parser = new Parser();
		parser.allowJSON = parser.allowMetadata = parser.allowTypes = true;

		exprs = new StringMap<Dynamic>();

		exprs.set('Paths', Paths);
		exprs.set('FlxG', FlxG);
		exprs.set('FlxTween', flixel.tweens.FlxTween);
		exprs.set('FlxEase', flixel.tweens.FlxEase);
		exprs.set('FlxSprite', flixel.FlxSprite);
		exprs.set('FlxBasic', flixel.FlxBasic);
		exprs.set('FlxTimer', flixel.util.FlxTimer);
		exprs.set('importClass', function(className:String, ?shouldTrace:Bool){
			final splitted:Array<String> = className.split('.');
			var shit = splitted[splitted.length-1];

			if (shit == '*'){
				var e = Type.resolveClass(className);

				while(shit.length > 0 && e==null){
					shit = splitted.pop();
					e = Type.resolveClass(splitted.join("."));
					if (e!=null) break;
				}
				if (e != null){
					for (field in Reflect.fields(e)){
						exprs.set(field, Reflect.field(e, field));

						if (shouldTrace) trace('Imported: $field from $e');
					}
				}
				else{
					FlxG.log.error('Could not import class $className');
					if (shouldTrace) trace('Could not import class $className');
				}
			}
			else{
				var e = Type.resolveClass(className);
				if (e == null){
					FlxG.log.error('Could not import class $className');
					if (shouldTrace) trace('Could not import class $className');
				}
				exprs.set(shit, e);
				if (shouldTrace) trace('Imported: $shit from $e');
			}
		});
		// yeah, I'm just gonna import this from pibby apocalypse,
		// I'm lazy and I don't feel like going through the pain that is abstracts
		// this is more or less the only other solution really, the only other solution...
		exprs.set("FlxColor", {
			// not a part of FlxColor btw, just helper funcs
			toRGBArray: (color:FlxColor) ->
			{
				return [color.red, color.green, color.blue];
			},
			lerp: (from:FlxColor, to:FlxColor, ratio:Float) ->
			{
				return FlxColor.fromRGBFloat(FlxMath.lerp(from.redFloat, to.redFloat, ratio), FlxMath.lerp(from.greenFloat, to.greenFloat, ratio),
					FlxMath.lerp(from.blueFloat, to.blueFloat, ratio), FlxMath.lerp(from.alphaFloat, to.alphaFloat, ratio));
			},

			////
			set_hue: (color:FlxColor, hue:Float) ->
			{
				color.hue = hue;
				return color;
			},
			set_saturation: (color:FlxColor, saturation:Float) ->
			{
				color.saturation = saturation;
				return color;
			},
			set_brightness: (color:FlxColor, brightness:Float) ->
			{
				color.brightness = brightness;
				return color;
			},

			fromCMYK: FlxColor.fromCMYK,
			fromHSL: FlxColor.fromHSL,
			fromHSB: FlxColor.fromHSB,
			fromInt: FlxColor.fromInt,
			fromRGBFloat: FlxColor.fromRGBFloat,
			fromString: FlxColor.fromString,
			fromRGB: FlxColor.fromRGB,

			TRANSPARENT: 0x00000000,
			WHITE: 0xFFFFFFFF,
			GRAY: 0xFF808080,
			BLACK: 0xFF000000,

			GREEN: 0xFF008000,
			LIME: 0xFF00FF00,
			YELLOW: 0xFFFFFF00,
			ORANGE: 0xFFFFA500,
			RED: 0xFFFF0000,
			PURPLE: 0xFF800080,
			BLUE: 0xFF0000FF,
			BROWN: 0xFF8B4513,
			PINK: 0xFFFFC0CB,
			MAGENTA: 0xFFFF00FF,
			CYAN: 0xFF00FFFF
		});
		// Same for FlxPoint
		exprs.set("FlxPoint", {
			get: FlxPoint.get,
			weak: FlxPoint.weak
		});

		exprs.set("Math", Math);
		exprs.set("Std", Std);
		exprs.set("Conductor", Conductor);

		for (string => value in exprs)
			trace('Added in ${string}, with the library ${value}');
	}

	public static function loadScript(path:String, ?params:StringMap<Dynamic>):Script{
		if (!PlayState.canRunScript)
			return null;

		var script:Script = null;
		final parser:Parser = new Parser();
		try{
			if (!#if !sys Assets.exists #else FileSystem.exists #end (Paths.scriptFile(path)))
				trace('Script not found in $path');

			var m = null;

			try{
				m = parser.parseString(Assets.getText(path));
			}
			catch(e:Dynamic){
				trace("Error parsing script: " + path + ' with error: ${e}');
				return null;
			}

			script = new Script(m, params);
			return script;
		}
		catch(e:Dynamic){
			trace('Error running script file: ' + e);
			return null;
		}
		return null;
	}
}

// the base stuff for HScript
class Script extends FlxBasic {
	public var script:Interp = new Interp();
	public function new(content:Expr, ?additionalParams:StringMap<Dynamic>){
		if (additionalParams != null){
			for (key in additionalParams.keys())
				script.variables.set(key, additionalParams.get(key));
		}
		try{
			script.execute(content);
		}
		catch(e:Dynamic){
			trace('Error executing script: $e');
		}
		super();
	}

	inline public function interpVarExists(e:String):Bool{
		return (script != null) ? script.variables.exists(e) : false;
	}

	public function setVariable(e:String,val:Dynamic){
		if (!PlayState.canRunScript || script == null)
			return;

		script.variables.set(e,val);
	}

	inline public function getVariable(e:String){
		if (!PlayState.canRunScript || script == null)
			return null;

		return script.variables.get(e);
	}

	public function executeFunction(functionName:String, ?args:Array<Dynamic>):Dynamic{
		if (script == null) return null;

		if (script.variables.exists(functionName)){
			final f = script.variables.get(functionName);
			if (Reflect.isFunction(f))
				return (args == null || args.length < 1) ? f() : Reflect.callMethod(null, f, args);
			return null;
		}
		return null;
	}

	override function destroy(){
		if (script != null) script = null;
		super.destroy();
	}
}
#end