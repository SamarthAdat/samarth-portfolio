import '../error/failure.dart';

/// A success-or-failure wrapper used as the return type of every repository
/// method and use case.
///
/// It keeps error handling explicit and free of `try/catch` above the data
/// layer, without pulling in a functional-programming dependency.
sealed class Result<T> {
  const Result();

  const factory Result.success(T value) = Success<T>;

  const factory Result.failure(Failure failure) = ResultFailure<T>;

  bool get isSuccess => this is Success<T>;

  bool get isFailure => this is ResultFailure<T>;

  /// The value on success, otherwise `null`.
  T? get valueOrNull => switch (this) {
    Success<T>(:final value) => value,
    ResultFailure<T>() => null,
  };

  /// The failure on error, otherwise `null`.
  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    ResultFailure<T>(:final failure) => failure,
  };

  /// Collapses both branches into a single value.
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Success<T>(:final value) => onSuccess(value),
    ResultFailure<T>(:final failure) => onFailure(failure),
  };

  /// Transforms a successful value, passing failures through untouched.
  Result<R> map<R>(R Function(T value) transform) => switch (this) {
    Success<T>(:final value) => Result<R>.success(transform(value)),
    ResultFailure<T>(:final failure) => Result<R>.failure(failure),
  };
}

final class Success<T> extends Result<T> {
  final T value;

  const Success(this.value);
}

final class ResultFailure<T> extends Result<T> {
  final Failure failure;

  const ResultFailure(this.failure);
}
