package pakofill;

import haxe.io.UInt8Array;
import pako.Pako;
import pako.zlib.Constants.ErrorStatus;


class Compress {
	
  public static function run(bytes:haxe.io.Bytes, level:Int):haxe.io.Bytes
	{
    trace('pakofill.Compress.run()');
    var options:pako.Deflate.DeflateOptions = {level:level};
    var deflator = new pako.Deflate(options);
    
    deflator.push(UInt8Array.fromBytes(bytes), true);
    
    if (deflator.err != ErrorStatus.Z_OK) {
      throw('ERROR(${deflator.err}): ${deflator.msg}');
    }
    
    return deflator.result.view.buffer;
	}
}