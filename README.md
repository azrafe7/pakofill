# pakofill
A compress/uncompress polyfill useful for targets that don't directly support them.

## overview
This lib tries to fill in the `run()` functions in `haxe.zip.Compress/Uncompress` where they're not directly supported. 

It does so with customs versions that fall back to using [hxPako](https://github.com/azrafe7/hxPako) if no supported implementation is available.

For example the _plain_ js target doesn't have an implementation for compressing bytes yet. This lib aims to fix that, using the same `run()` function signature.

It's almost a drop-in replacement. The only thing that you have to do is `import pakofill.Compress/Uncompress` instead of `haxe.zip.Compress/Uncompress`.

(**NOTE:** this is intended - for transparency/easy-debugging -, as after thinking about it I came to the conclusion that shadowing `haxe.zip` directly would cause more harm than good)

## install
Since this lib depends on `hxPako`, you'll have to install that first.
You can do that by running this:

`haxelib git hxPako https://github.com/azrafe7/hxPako.git`

(this will donwload `hxPako` and set it as a haxe lib)

Installing `pakofill` is very similar. Run this next:

`haxelib git pakofill https://github.com/azrafe7/pakofill.git`

## examples
The usage is exactly like how you would use `haxe.zip.Compress/Uncompress.run()`.

```haxe
import haxe.io.Bytes;
import haxe.io.UInt8Array;
import pakofill.Compress;    // instead of haxe.zip.Compress
import pakofill.Uncompress;  // instead of haxe.zip.Uncompress

static function testThereAndBackAgain() {
  var text = "long string to c0mpress";
  var bytes = Bytes.ofString(text);
  var compressed = Compress.run(bytes, 9);
  
  var uncompressed = Uncompress.run(compressed);
  
  var uncompressedText = bytesToString(uncompressed);
  assert(text == uncompressedText);
  trace(text + " == " + uncompressedText + " OK");
}
```

(see [Tests.hx](test/Tests.hx))

## defines
By default `pakofill` will first check if a native implementation is available and try to use that (this happens once!). Otherwise the alternate version using `hxPako` will be called.

You can override this behaviour with a set of compiler defines:
 - `PAKOFILL_ZIP_HAXE`: use `haxe.zip` for compressing
 - `PAKOFILL_UNZIP_HAXE`: use `haxe.zip` for uncompressing
 - `PAKOFILL_ZIP_HXPAKO`: use `hxPako` for compressing
 - `PAKOFILL_UNZIP_HXPAKO`: use `hxPako` for uncompressing
 
 - `PAKOFILL_HAXE`: use `haxe.zip` for both compressing/uncompressing
 - `PAKOFILL_HXPAKO`: use `hxPako` for both compressing/uncompressing

(see [local_tests.hxml](local_tests.hxml))

## supported targets
This should work for most targets (`neko,python,node,js,java,cpp,cs,php`).

flash and hl have some issues on travis.

lua is not currently passing the test.

(see [travis log](https://travis-ci.org/azrafe7/pakofill)).

## license
See license file ([MIT](LICENSE)).