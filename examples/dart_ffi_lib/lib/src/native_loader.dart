import 'dart:ffi';
import 'dart:io';

class NativeLoader {
  static DynamicLibrary load(String name) {
    if (Platform.isMacOS) {
      return DynamicLibrary.open('lib$name.dylib');
    } else if (Platform.isLinux) {
      return DynamicLibrary.open('lib$name.so');
    } else if (Platform.isWindows) {
      return DynamicLibrary.open('$name.dll');
    } else if (Platform.isAndroid) {
      return DynamicLibrary.open('lib$name.so');
    } else if (Platform.isIOS) {
      return DynamicLibrary.process();
    }
    throw UnsupportedError('Platform ${Platform.operatingSystem} not supported');
  }
}
