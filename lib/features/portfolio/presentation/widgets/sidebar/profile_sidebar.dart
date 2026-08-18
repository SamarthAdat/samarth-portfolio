import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/contact_channel.dart';
import '../../../domain/entities/profile.dart';
import '../../state/view_state.dart';
import '../common/glass_card.dart';
import '../common/view_state_builder.dart';
import 'contact_channel_tile.dart';
import 'profile_photo.dart';

/// The left-hand card: photo, name, role, and contact channels.
class ProfileSidebar extends StatelessWidget {
  final ViewState<Profile> state;
  final ValueChanged<String> onOpenLink;

  const ProfileSidebar({
    super.key,
    required this.state,
    required this.onOpenLink,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(26),
      child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ViewStateBuilder<Profile>(
          state: state,
          builder: (BuildContext context, Profile profile) =>
              _SidebarContent(profile: profile, onOpenLink: onOpenLink),
        ),
      ),
    );
  }
}

class _SidebarContent extends StatelessWidget {
  final Profile profile;
  final ValueChanged<String> onOpenLink;

  const _SidebarContent({required this.profile, required this.onOpenLink});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ProfilePhoto(initials: profile.initials),
        const SizedBox(height: 22),
        Text(
          profile.fullName,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.cardLight,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            profile.role,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(color: AppColors.muted),
          ),
        ),
        const SizedBox(height: 22),
        const Divider(color: AppColors.border),
        const SizedBox(height: 8),
        ...profile.channels.map(
          (ContactChannel channel) =>
              ContactChannelTile(channel: channel, onOpen: onOpenLink),
        ),
      ],
    );
  }
}
