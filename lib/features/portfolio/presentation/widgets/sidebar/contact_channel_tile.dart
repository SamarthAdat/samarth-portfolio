import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/contact_channel.dart';
import '../../mappers/portfolio_icons.dart';

/// One row in the sidebar: icon, caption, and value.
class ContactChannelTile extends StatelessWidget {
  final ContactChannel channel;

  /// Invoked with the channel's URL; omitted for non-actionable channels.
  final ValueChanged<String>? onOpen;

  const ContactChannelTile({
    super.key,
    required this.channel,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final bool tappable = channel.isActionable && onOpen != null;

    return InkWell(
      onTap: tappable ? () => onOpen!(channel.actionUrl!) : null,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11),
        child: Row(
          children: <Widget>[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.cardLight,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Icon(
                PortfolioIcons.forChannel(channel.type),
                color: AppColors.accent,
                size: 20,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    channel.label,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: AppColors.softMuted,
                      fontSize: 10,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    channel.displayValue,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.text,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
