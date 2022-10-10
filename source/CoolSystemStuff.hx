package;

// crazy system shit!!!!!
// lordryan wrote this :) (erizur added cross platform env vars)
import sys.io.File;
import sys.io.Process;
import haxe.io.Bytes;

class CoolSystemStuff
{
	public static function getUsername():String
	{
		// uhh this one is self explanatory
		#if windows
		return Sys.getEnv("USERNAME");
		#else
		return Sys.getEnv("USER");
		#end
	}

	public static function getUserPath():String
	{
		// this one is also self explantory
		#if windows
		return Sys.getEnv("USERPROFILE");
		#else
		return Sys.getEnv("HOME");
		#end
	}

	public static function getTempPath():String
	{
		// gets appdata temp folder lol
		#if windows
		return Sys.getEnv("TEMP");
		#else
		// most non-windows os dont have a temp path, or if they do its not 100% compatible, so the user folder will be a fallback
		return Sys.getEnv("HOME");
		#end
	}
	public static function executableFileName()
	{
		#if windows
		var programPath = Sys.programPath().split("\\");
		#else
		var programPath = Sys.programPath().split("/");
		#end
		return programPath[programPath.length - 1];
	}
}
