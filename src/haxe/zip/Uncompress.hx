package haxe.zip;


class Uncompress {
	
  public static function run(bytes:haxe.io.Bytes, ?bufSize:Int /* ignored for now */):haxe.io.Bytes
	{
    trace("overridden haxe.zip.Uncompress");
    return bytes;
	}
}