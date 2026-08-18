import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/theme/app_colors.dart';

/// The circular avatar, falling back to the owner's initials when the image
/// cannot be loaded.
class ProfilePhoto extends StatelessWidget {
  final String initials;

  const ProfilePhoto({super.key, required this.initials});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.accent, width: 3),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: AppColors.accentGlow,
            blurRadius: 28,
            spreadRadius: 4,
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          AppAssets.profilePhoto,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
            return Container(
              color: AppColors.cardLight,
              alignment: Alignment.center,
              child: Text(
                initials,
                style: const TextStyle(
                  color: AppColors.accent,
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
