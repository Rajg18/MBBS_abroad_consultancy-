// ignore_for_file: deprecated_member_use, avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:typed_data';

/// Saves [bytes] as a file named [filename] via a temporary blob URL.
void downloadBytes(Uint8List bytes, String filename) {
  final blob = html.Blob(<Uint8List>[bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..download = filename
    ..click();
  html.Url.revokeObjectUrl(url);
}
