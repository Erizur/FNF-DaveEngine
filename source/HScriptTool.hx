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


    public function new(){}
    public function loadScript(path:String):HScriptTool {
        var script = create(path);
        if (script != null) {
            script.readFile();
            return script;
        }
        else
        {
            return null;
        }
    }

    public function create(path:String):HScriptTool
    {
        var p = path.toLowerCase();
        var ext = Path.extension(p);

        var script = switch(ext.toLowerCase()) {
            case 'hx':      new Script();
            default:        null;
        }

        if (script == null) return null;
        var quickSplit = path.replace("\\", "/").split("/");
        script.filePath = p;
        script.fileName = quickSplit[quickSplit.length];
        return script;
    }

    public function executeFunc(funcName:String, ?args:Array<Any>):Dynamic {
        return null;
    }

}

class Script extends HScriptTool
{

}