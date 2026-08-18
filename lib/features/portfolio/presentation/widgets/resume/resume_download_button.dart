import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

/// Opens the bundled resume PDF.
class ResumeDownloadButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ResumeDownloadButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.download_outlined, size: 18),
      label: const Text('Download Resume'),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.cardLight,
        foregroundColor: AppColors.accent,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.accent.withValues(alpha: 0.35)),
        ),
        textStyle: Theme.of(
          context,
        ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
      ),
    );
  }
}
