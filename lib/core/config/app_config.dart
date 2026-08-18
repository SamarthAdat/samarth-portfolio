/// Environment-level settings for the app.
///
/// Values that would differ between deployments live here rather than being
/// buried in a data source or widget.
class AppConfig {
  const AppConfig._();

  /// Endpoint that receives contact-form submissions.
  static const String contactFormEndpoint = 'https://flowform.to/submit';

  /// How long a contact submission may take before it is abandoned.
  static const Duration requestTimeout = Duration(seconds: 20);

  /// Width at or above which the two-column desktop layout is used.
  static const double desktopBreakpoint = 980;
}
