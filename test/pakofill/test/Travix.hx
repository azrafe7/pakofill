package pakofill.test;


class Travix
{
  
  // https://github.com/haxetink/tink_testrunner/blob/d762f78/src/tink/testrunner/Reporter.hx#L168-L177
  inline static public function println(v:String) {
  #if travix
    travix.Logger.println(v);
  #elseif (air || air3)
    flash.Lib.trace(v);
  #elseif (sys || nodejs)
    Sys.println(v);
  #else
    haxe.Log.trace(v);
  #end
  }
  
  static public function exit(code:Int) {
  #if travix
    travix.Logger.exit(code);
  #elseif (sys || hxnodejs)
    Sys.exit(code);
  #else
    println('"exit($code)" call not supported on this target.');
  #end
  }
}
