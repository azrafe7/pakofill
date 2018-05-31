package;

import haxe.Timer;
import haxe.io.Bytes;
import haxe.io.UInt8Array;
import pako.zlib.Constants.CompressionLevel;
import pakofill.ZipImplementation;

import pakofill.Compress;
import pakofill.Uncompress;
import pakofill.test.Utils.*;


class Tests {

  static function main()
  {
    trace(Macros.getDefinesAsString() + "\n");

    trace('--- USED IMPLEMENTATIONS');
    trace("COMPRESS   : " + Compress.USED_IMPLEMENTATION);
    trace("UNCOMPRESS : " + Uncompress.USED_IMPLEMENTATION + "\n");
    
    // create minimal gzipped bytes (with header)
    //var bytes = Bytes.alloc(0);
    //var compressed = pako.Pako.deflate(UInt8Array.fromBytes(bytes));
    //trace(compressed.length);
    //trace(pakofill.test.Utils.bytesToArray(compressed.view.buffer));
    
    var t0 = Timer.stamp();
    testCompress();
    trace('ELAPSED: ${Timer.stamp() - t0}s\n');
  
    t0 = Timer.stamp();
    testUncompress();
    trace('ELAPSED: ${Timer.stamp() - t0}s\n');
    
    TravixHelpers.exit(0);
  }
  
  
  // https://github.com/HaxeFoundation/haxe/blob/5f2926a879293c4ac19baa9f11c3c1d40c33a2e7/tests/unit/src/unitstd/haxe/zip/Compress.unit.hx
  static function testCompress()
  {
    trace('--- testCompress');
    var bytes = haxe.io.Bytes.ofString("test");
    var compressedBytes = Compress.run(bytes, 9);
    
    assert(compressedBytes.length == 12);
    trace('len OK');
    
    var compressedArray = bytesToArray(compressedBytes);
    var expected = [120, 218, 43, 73, 45, 46, 1, 0, 4, 93, 1, 193];
    
    arrayEq(compressedArray, expected);
  }
  
  // https://github.com/HaxeFoundation/haxe/blob/5f2926a879293c4ac19baa9f11c3c1d40c33a2e7/tests/unit/src/unitstd/haxe/zip/Uncompress.unit.hx
  static function testUncompress()
  {
    trace('--- testUncompress');
    var bytes = arrayToBytes([120, 218, 43, 73, 45, 46, 1, 0, 4, 93, 1, 193]);
    var uncompressedBytes = Uncompress.run(bytes);
    
    assert(uncompressedBytes.toString() == "test");
    trace('toString OK');
    
    bytes = arrayToBytes([120, 218, 3, 0, 0, 0, 0, 1]);
    uncompressedBytes = Uncompress.run(bytes);
    
    assert(uncompressedBytes.length == 0);
    trace('len OK');
  }
}
