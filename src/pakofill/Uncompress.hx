package pakofill;

import haxe.io.UInt8Array;
import pako.Pako;
import pako.zlib.Constants.ErrorStatus;


class Uncompress {

#if (PAKOFILL_UNZIP_HXPAKO || PAKOFILL_HXPAKO)

  static public var USED_IMPLEMENTATION(default, null):ZipImplementation = HXPAKO;
  
#elseif (PAKOFILL_UNZIP_HAXE || PAKOFILL_HAXE)

  static public var USED_IMPLEMENTATION(default, null):ZipImplementation = HAXE;
  
#elseif (flash)

  //NOTE: flash will automatically choose the native one.
  static public var USED_IMPLEMENTATION(default, null):ZipImplementation = {
    trace('FLASH: using ${ZipImplementation.HAXE}');
    HAXE;
  }
  
#else

  /**
   * Decide which impl to use based on whether it's available natively.
   **/
  static public var USED_IMPLEMENTATION(default, null):ZipImplementation = {
    
    var bytes = haxe.io.Bytes.alloc(8);
    //[120, 156, 3, 0, 0, 0, 0, 1] minimal gzipped bytes
    bytes.set(0, 120);
    bytes.set(1, 156);
    bytes.set(2,   3);
    bytes.set(3,   0);
    bytes.set(4,   0);
    bytes.set(5,   0);
    bytes.set(6,   0);
    bytes.set(7,   1);
    var impl = ZipImplementation.HAXE;
    try {
      haxe.zip.Uncompress.run(bytes);
    } catch (e:Dynamic) {
      //trace("ERR: " + e);
    #if debug 
      if (Std.string(e).indexOf('Not implemented') < 0) {
        throw e;
      }
    #end
      impl = ZipImplementation.HXPAKO;
    }
    //trace('--- UNCOMPRESS decided for $impl');
    return impl;
  }

#end



  inline public static function run(bytes:haxe.io.Bytes, ?bufSize:Int):haxe.io.Bytes
  {
    switch (USED_IMPLEMENTATION) 
    {
      case ZipImplementation.HAXE:
        return haxeZipRun(bytes, bufSize);
        
      case ZipImplementation.HXPAKO:
        return hxPakoRun(bytes, bufSize);
        
      default:
        throw 'unreacheable';
    }
  }
  
  public static function hxPakoRun(bytes:haxe.io.Bytes, ?bufSize:Int):haxe.io.Bytes
  {
    //trace(pakofill.test.Macros.getPosMethodName());
    var options:pako.Inflate.InflateOptions = {chunkSize:bufSize};
    var inflator = new pako.Inflate(options);
    
    inflator.push(UInt8Array.fromBytes(bytes), true);
    
    if (inflator.err != ErrorStatus.Z_OK) {
      throw('ERROR(${inflator.err}): ${inflator.msg}');
    }
    
    return inflator.result.view.buffer;
  }
  
  public static function haxeZipRun(bytes:haxe.io.Bytes, ?bufSize:Int):haxe.io.Bytes
  {
    //trace(pakofill.test.Macros.getPosMethodName());
    return haxe.zip.Uncompress.run(bytes, bufSize);
  }
}
