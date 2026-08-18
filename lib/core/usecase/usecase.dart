import '../utils/result.dart';

/// A single unit of application behaviour.
///
/// Use cases are the only entry point the presentation layer has into the
/// domain: controllers depend on these, never on repositories directly.
abstract interface class UseCase<T, P> {
  Future<Result<T>> call(P params);
}

/// Marker for use cases that need no input.
final class NoParams {
  const NoParams();

  @override
  bool operator ==(Object other) => other is NoParams;

  @override
  int get hashCode => 0;
}
