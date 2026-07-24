// Triggers a browser download of the given bytes.
//
// Uses a web implementation on web, and a stub elsewhere (the admin panel is
// web-only). Import this file; the right implementation is picked at build.
export 'download_stub.dart' if (dart.library.html) 'download_web.dart';
