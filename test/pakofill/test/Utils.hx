package pakofill.test;

import haxe.io.Bytes;


class Utils {

  static public inline function bytesToArray(bytes:Bytes):Array<Int>
  {
    return [for (i in 0...bytes.length) bytes.get(i)];
  }
  
  static public inline function arrayToBytes(array:Array<Int>):Bytes
  {
    var bytes = Bytes.alloc(array.length);
    for (i in 0...array.length) bytes.set(i, array[i]);
    return bytes;
  }
  
  static public function assert(cond:Bool, msg:String = ""):Void
  {
    var err = "ERROR ";
    err += msg;
    
    if (!cond) {
      throw(err);
    }
  }
  
  static public function arrayEq<T>(actual:Array<T>, expected:Array<T>)
  {
    for (i in 0...expected.length) {
      assert(actual[i] == expected[i], '@$i: ${actual[i]} should be ${expected[i]}');
    }
    trace('array OK');
  }
}