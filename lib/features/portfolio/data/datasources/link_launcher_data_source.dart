import 'package:url_launcher/url_launcher.dart';

import '../../../../core/error/exceptions.dart';

/// Opens URIs through the host platform.
abstract interface class LinkLauncherDataSource {
  /// Throws [LinkLaunchException] when the platform refuses the URI.
  Future<void> open(String url);
}

class UrlLauncherDataSource implements LinkLauncherDataSource {
  const UrlLauncherDataSource();

  @override
  Future<void> open(String url) async {
    if (url.isEmpty || url == '#') {
      throw const LinkLaunchException('No destination was provided.');
    }

    final Uri parsed = Uri.parse(url);

    // Absolute URIs (https, mailto, tel) go to an external handler; relative
    // ones are resolved against the app's own origin, which is how the bundled
    // resume is served on the web.
    final Uri target = parsed.hasScheme
        ? parsed
        : Uri.base.resolveUri(parsed);
    final LaunchMode mode = parsed.hasScheme
        ? LaunchMode.externalApplication
        : LaunchMode.platformDefault;

    final bool launched = await launchUrl(target, mode: mode);
    if (!launched) {
      throw LinkLaunchException('The platform could not open $target.');
    }
  }
}
