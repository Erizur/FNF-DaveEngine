package;

using StringTools;

class Animation
{
	public var name:String;
	public var prefixName:String;
	public var frames:Int;
	public var looped:Bool;
	public var flip:Array<Bool>;
	public var indices:Array<Int>;

	public function new(name:String, prefixName:String, frames:Int, looped:Bool, ?flip:Array<Bool>, indices:Array<Int> = null)
	{
		if (flip == null)
		{
			flip = [false, false];
		}
		this.name = name;
		this.prefixName = prefixName;
		this.frames = frames;
		this.looped = looped;
		this.flip = flip;
		this.indices = indices;
	}
}
