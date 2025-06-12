import 'dart:io' show Platform;

bool isDesktop() {
  return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
}

bool isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}