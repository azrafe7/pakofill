package;

import haxe.PosInfos;
import haxe.macro.Compiler;
import haxe.macro.Context;
import haxe.macro.Expr.ExprOf;
import haxe.macro.PositionTools;


class Macros {
  
  #if !macro macro #end
  static public function getDefinesAsString() {
    var buf = new StringBuf();
    buf.add("\nDEFINES: ");
    var definesMap = haxe.macro.Context.getDefines();
    for (d in definesMap.keys()) {
      var v = definesMap[d];
      buf.add("\n  " + d + "=" + v);
    }
    var str = buf.toString();
    return macro $v{str};
  }

  #if !macro macro #end
  static public function setDefine(flag:String, ?value:String) {
    Compiler.define(flag, value);
    return macro null;
  }
  
  #if !macro macro #end
  static public function isDefined(flag:String) {
    return macro $v{Context.defined(flag)};
  }
  
  #if !macro macro #end
  static public function getPosClassName():ExprOf<String> {
    return { expr: EConst(CString(Context.getLocalClass().toString())), pos: Context.currentPos() };
  }
  
  //#if !macro macro #end
  static public function getPosInfos(?pos:PosInfos) {
    return pos;
  }
  
  //#if !macro macro #end
  static public function getPosMethodName(?pos:PosInfos) {
    return pos.methodName;
  }
  
  #if !macro macro #end
  static public function getPosFilePath() {
    var filePath = PositionTools.getInfos(Context.currentPos()).file;
    return macro $v{sys.FileSystem.fullPath(filePath)};
  }
}