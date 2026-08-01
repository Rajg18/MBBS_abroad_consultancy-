// Picks the web implementation when compiling for web, a no-op otherwise —
// same pattern as lib/shared/download/download_helper.dart.
export 'page_title_stub.dart' if (dart.library.html) 'page_title_web.dart';
