import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';

/// The three states any asynchronously loaded section can be in.
sealed class ViewState<T> {
  const ViewState();

  const factory ViewState.loading() = ViewLoading<T>;

  const factory ViewState.ready(T data) = ViewReady<T>;

  const factory ViewState.failed(Failure failure) = ViewFailed<T>;

  /// Builds a state directly from a use case [Result].
  factory ViewState.fromResult(Result<T> result) => result.fold(
    onSuccess: (T value) => ViewState<T>.ready(value),
    onFailure: (Failure failure) => ViewState<T>.failed(failure),
  );

  T? get dataOrNull => switch (this) {
    ViewReady<T>(:final data) => data,
    _ => null,
  };
}

final class ViewLoading<T> extends ViewState<T> {
  const ViewLoading();
}

final class ViewReady<T> extends ViewState<T> {
  final T data;

  const ViewReady(this.data);
}

final class ViewFailed<T> extends ViewState<T> {
  final Failure failure;

  const ViewFailed(this.failure);
}
