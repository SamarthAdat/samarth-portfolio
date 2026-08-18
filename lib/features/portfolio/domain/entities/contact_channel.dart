/// The kind of a contact channel.
///
/// The domain describes *what* a channel is; the presentation layer decides
/// which icon represents it. That keeps this layer free of Flutter types.
enum ContactChannelType { email, phone, location, github, linkedIn }

/// One reachable channel shown in the profile sidebar.
class ContactChannel {
  final ContactChannelType type;

  /// Short caption, e.g. `EMAIL`.
  final String label;

  /// Human-readable value rendered under the label.
  final String displayValue;

  /// URI opened on tap; `null` for channels that are not actionable.
  final String? actionUrl;

  const ContactChannel({
    required this.type,
    required this.label,
    required this.displayValue,
    this.actionUrl,
  });

  bool get isActionable => actionUrl != null && actionUrl!.isNotEmpty;
}
