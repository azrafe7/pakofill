package pakofill;

import haxe.io.UInt8Array;
import pako.Pako;
import pako.zlib.Constants.ErrorStatus;
import pako.zlib.Constants.CompressionLevel;


class Compress {

#if (PAKOFILL_ZIP_HXPAKO || PAKOFILL_HXPAKO)

  static public var USED_IMPLEMENTATION(default, null):ZipImplementation = HXPAKO;
  
// force native impl on flash, as it doesn't support "try/catch as a right-side expression"
// (https://github.com/HaxeFoundation/haxe/issues/7117)
#elseif (PAKOFILL_ZIP_HAXE || PAKOFILL_HAXE || flash)

  static public var USED_IMPLEMENTATION(default, null):ZipImplementation = HAXE;
  
#else

  static public var USED_IMPLEMENTATION(default, null):ZipImplementation = {
    
    // decide which impl to use based on whether it's available natively
    
    var bytes = haxe.io.Bytes.alloc(1);
    bytes.set(0, 0);
    var impl = ZipImplementation.HAXE;
    try {
      haxe.zip.Compress.run(bytes, CompressionLevel.Z_NO_COMPRESSION);
    } catch (e:Dynamic) {
      //trace("ERR: " + e);
    #if debug 
      if (Std.string(e).indexOf('Not implemented') < 0) {
        throw e;
      }
    #end
      impl = ZipImplementation.HXPAKO;
    }
    //trace('--- COMPRESS decided for $impl');
    return impl;
  }

#end



  inline public static function run(bytes:haxe.io.Bytes, level:Int):haxe.io.Bytes
	{
    switch (USED_IMPLEMENTATION) 
    {
      case ZipImplementation.HAXE:
        return haxeZipRun(bytes, level);
        
      case ZipImplementation.HXPAKO:
        return hxPakoRun(bytes, level);
        
      default:
        throw 'unreacheable';
    }
  }
  
  public static function hxPakoRun(bytes:haxe.io.Bytes, level:Int):haxe.io.Bytes
  {
    //trace(pakofill.test.Macros.getPosMethodName());
    var options:pako.Deflate.DeflateOptions = {level:level};
    var deflator = new pako.Deflate(options);
    
    deflator.push(UInt8Array.fromBytes(bytes), true);
    
    if (deflator.err != ErrorStatus.Z_OK) {
      throw('ERROR(${deflator.err}): ${deflator.msg}');
    }
    
    return deflator.result.view.buffer;
	}
  
  public static function haxeZipRun(bytes:haxe.io.Bytes, level:Int):haxe.io.Bytes
  {
    //trace(pakofill.test.Macros.getPosMethodName());
    return haxe.zip.Compress.run(bytes, level);
	}
}