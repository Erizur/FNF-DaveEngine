package;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;
import flixel.util.FlxDestroyUtil.IFlxDestroyable;
import hscript.Expr;
import hscript.Parser;
import hscript.Interp;
import haxe.Constraints.Function;
import haxe.DynamicAccess;
import lime.app.Application;

using StringTools;

/*
	HEAVILY BASED ON YOSHICRAFTER ENGINE'S SCRIPT CODE
	HAVE A LOOK: https://raw.githubusercontent.com/YoshiCrafter29/YoshiCrafterEngine
 */
class HScriptTool implements IFlxDestroyable
{
	public var fileName:String = "";
	public var filePath:String = null;

	public function new()
	{
	}

	public static function loadScript(path:String):HScriptTool
	{
		var script = create(path);
		if (script != null)
		{
			script.loadFile();
			return script;
		}
		else
		{
			return null;
		}
	}

	public static function create(path:String):HScriptTool
	{
		var p = path.toLowerCase();
		var ext = Path.extension(p);

		var script = switch (ext.toLowerCase())
		{
			case 'hx': new Script();
			default: null;
		}

		if (script == null)
			return null;
		var quickSplit = path.replace("\\", "/").split("/");
		script.filePath = p;
		script.fileName = quickSplit[quickSplit.length];
		return script;
	}

	public function executeFunc(funcName:String, ?args:Array<Any>):Dynamic
	{
		var ret = _executeFunc(funcName, args);
		return ret;
	}

	public function _executeFunc(funcName:String, ?args:Array<Any>):Dynamic
	{
		return null;
	}

	public function setVariable(name:String, val:Dynamic)
	{
	}

	public function getVariable(name:String):Dynamic
	{
		return null;
	}

	public function trace(text:String, error:Bool = false)
	{
		trace(text);
	}

	public function loadFile()
	{
	}

	public function destroy()
	{
	}
}

class Script extends HScriptTool
{
	public var hscript:Interp;

	public function new()
	{
		hscript = new Interp();
		hscript.errorHandler = function(e)
		{
			this.trace('$e', true);
		};
		super();
	}

	public override function executeFunc(funcName:String, ?args:Array<Any>):Dynamic
	{
		super.executeFunc(funcName, args);
		if (hscript == null)
			return null;
		if (hscript.variables.exists(funcName))
		{
			var f = hscript.variables.get(funcName);
			if (Reflect.isFunction(f))
			{
				if (args == null || args.length < 1)
					return f();
				else
					return Reflect.callMethod(null, f, args);
			}
		}
		return null;
	}

	public override function loadFile()
	{
		super.loadFile();
		if (filePath == null || filePath.trim() == "")
			return;
		var content:String = sys.io.File.getContent(filePath);
		var parser = new hscript.Parser();
		try
		{
			hscript.execute(parser.parseString(content));
		}
		catch (e)
		{
			this.trace('${e.message}', true);
		}
	}

	public function bruh()
	{
		super.loadFile();
	}

	public override function trace(text:String, error:Bool = false)
	{
		var posInfo = hscript.posInfos();

		var lineNumber = Std.string(posInfo.lineNumber);
		var methodName = posInfo.methodName;
		var className = posInfo.className;
	}

	public override function setVariable(name:String, val:Dynamic)
	{
		hscript.variables.set(name, val);
		@:privateAccess
		hscript.locals.set(name, {r: val, depth: 0});
	}

	public override function getVariable(name:String):Dynamic
	{
		if (@:privateAccess hscript.locals.exists(name) && @:privateAccess hscript.locals[name] != null)
		{
			@:privateAccess
			return hscript.locals.get(name).r;
		}
		else if (hscript.variables.exists(name))
			return hscript.variables.get(name);

		return null;
	}
}
