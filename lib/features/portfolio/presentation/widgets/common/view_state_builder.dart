import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../state/view_state.dart';

/// Renders one of the three [ViewState] branches, so no section has to repeat
/// its own loading and error handling.
class ViewStateBuilder<T> extends StatelessWidget {
  final ViewState<T> state;
  final Widget Function(BuildContext context, T data) builder;

  const ViewStateBuilder({
    super.key,
    required this.state,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return switch (state) {
      ViewLoading<T>() => const _SectionLoading(),
      ViewReady<T>(:final T data) => builder(context, data),
      ViewFailed<T>(:final Failure failure) => _SectionError(failure: failure),
    };
  }
}

class _SectionLoading extends StatelessWidget {
  const _SectionLoading();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Center(
        child: SizedBox(
          width: 26,
          height: 26,
          child: CircularProgressIndicator(
            strokeWidth: 2.4,
            color: AppColors.accent,
          ),
        ),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  final Failure failure;

  const _SectionError({required this.failure});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardLight.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: AppColors.error,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              failure.message,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.text),
            ),
          ),
        ],
      ),
    );
  }
}
