import 'package:user_servicehub/core/constants/api.dart';

class ImageUtils {
  ImageUtils._();

  /// Resolves a backend image path into a fully-qualified URL.
  ///
  /// - Returns null for null/empty inputs.
  /// - Returns absolute URLs (http/https) as-is.
  /// - Prepends [APIURL.IMAGE_URL] for relative file names (e.g. "ac.jpg"),
  ///   adding an `/uploads/` segment unless the value already carries a
  ///   leading path (e.g. "uploads/...", "/uploads/...", "package/...").
  static String? resolveImageUrl(String? image) {
    if (image == null) return null;
    final trimmed = image.trim();
    if (trimmed.isEmpty) return null;
    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      return trimmed;
    }

    final normalized = trimmed.startsWith('/')
        ? trimmed.substring(1)
        : trimmed;

    if (normalized.startsWith('uploads/')) {
      return '${APIURL.IMAGE_URL}/$normalized';
    }

    return '${APIURL.IMAGE_URL}/uploads/$normalized';
  }
}
