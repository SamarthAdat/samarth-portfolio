/// Failures are the domain-facing representation of something going wrong.
///
/// Data-layer [Exception]s never cross into the domain or presentation layers;
/// repositories translate them into one of these types so that callers can
/// react to them without knowing anything about HTTP, assets, or plugins.
sealed class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() => '$runtimeType($message)';
}

/// The local content bundle could not be read or parsed.
final class ContentFailure extends Failure {
  const ContentFailure([
    super.message = 'Portfolio content could not be loaded.',
  ]);
}

/// The remote service was reachable but answered with an error.
final class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure([
    super.message = 'The service could not process the request.',
    this.statusCode,
  ]);
}

/// The remote service could not be reached at all.
final class NetworkFailure extends Failure {
  const NetworkFailure([
    super.message = 'Could not reach form service. Please try again.',
  ]);
}

/// The request took longer than the configured timeout.
final class TimeoutFailure extends Failure {
  const TimeoutFailure([
    super.message = 'Request timed out. Please check your connection.',
  ]);
}

/// Input did not satisfy the domain rules.
final class ValidationFailure extends Failure {
  /// Field name to error message, for forms that highlight individual inputs.
  final Map<String, String> fieldErrors;

  const ValidationFailure(
    super.message, {
    this.fieldErrors = const <String, String>{},
  });
}

/// An external URL, mail client, or dialer could not be opened.
final class LinkFailure extends Failure {
  const LinkFailure([super.message = 'Could not open the requested link.']);
}

/// Anything that was not anticipated.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure([super.message = 'Something went wrong.']);
}
