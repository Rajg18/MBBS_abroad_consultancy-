import 'dart:typed_data';

/// A document the student picked from their device.
///
/// On web, [bytes] holds the file contents and [path] is null; on mobile the
/// reverse. We keep just enough to preview, validate, and later upload.
class PickedDoc {
  final String fileName;
  final int sizeBytes;
  final Uint8List? bytes; // web
  final String? path; // mobile/desktop

  const PickedDoc({
    required this.fileName,
    required this.sizeBytes,
    this.bytes,
    this.path,
  });

  String get readableSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    if (sizeBytes < 1024 * 1024) {
      return '${(sizeBytes / 1024).toStringAsFixed(0)} KB';
    }
    return '${(sizeBytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get extension {
    final dot = fileName.lastIndexOf('.');
    return dot == -1 ? '' : fileName.substring(dot + 1).toLowerCase();
  }
}
