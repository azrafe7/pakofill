package haxe.zip;


class Compress {
	
  public static function run(bytes:haxe.io.Bytes, level:Int):haxe.io.Bytes
	{
    trace("overridden haxe.zip.Compress");
    return bytes;
  }
}