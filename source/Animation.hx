package;

typedef Animation =
{
	public var name:String;
	public var prefixName:String;
	public var frames:Int;
	public var looped:Bool;
	public var ?flip:Array<Bool>;
	public var ?indices:Array<Int>;
}
