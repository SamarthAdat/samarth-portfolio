/// Exceptions thrown by data sources.
///
/// They exist only inside the data layer: repository implementations catch them
/// and convert them into `Failure`s before returning to the domain layer.
sealed class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// Raw content was missing a key or held an unexpected type.
final class ContentParsingException extends AppException {
  const ContentParsingException(super.message);
}

/// The server responded with a non-success status or an error payload.
final class ServerException extends AppException {
  final int? statusCode;

  const ServerException(super.message, [this.statusCode]);
}

/// The request never reached the server (socket, DNS, CORS, offline).
final class NetworkException extends AppException {
  const NetworkException([super.message = 'No connection to the service.']);
}

/// The request exceeded the allowed duration.
final class RequestTimeoutException extends AppException {
  const RequestTimeoutException([super.message = 'The request timed out.']);
}

/// The platform refused to open a URI.
final class LinkLaunchException extends AppException {
  const LinkLaunchException(super.message);
}
