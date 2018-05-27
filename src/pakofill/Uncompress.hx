package pakofill;

import haxe.io.UInt8Array;
import pako.Pako;
import pako.zlib.Constants.ErrorStatus;


class Uncompress {
	
  public static function run(bytes:haxe.io.Bytes, ?bufSize:Int /* ignored for now */):haxe.io.Bytes
	{
    trace('pakofill.Uncompress.run()');
    var options:pako.Inflate.InflateOptions = {};
    var inflator = new pako.Inflate(options);
    
    inflator.push(UInt8Array.fromBytes(bytes), true);
    
    if (inflator.err != ErrorStatus.Z_OK) {
      throw('ERROR(${inflator.err}): ${inflator.msg}');
    }
    
    return inflator.result.view.buffer;
	}
}