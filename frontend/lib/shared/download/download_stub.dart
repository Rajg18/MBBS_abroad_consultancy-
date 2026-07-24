import 'dart:typed_data';

/// Non-web fallback (the admin panel is used on the web).
void downloadBytes(Uint8List bytes, String filename) {
  throw UnsupportedError('File download is only supported on the web.');
}
