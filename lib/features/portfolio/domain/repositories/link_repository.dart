import '../../../../core/utils/result.dart';

/// Opening destinations outside the app: web links, mail, dialer, and the
/// bundled resume.
abstract interface class LinkRepository {
  /// Opens an absolute URL or a `mailto:` / `tel:` URI.
  Future<Result<void>> openExternalLink(String url);

  /// Opens the resume asset relative to the app's own origin.
  Future<Result<void>> openResume();
}
