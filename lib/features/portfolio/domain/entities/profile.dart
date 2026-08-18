import 'contact_channel.dart';

/// Identity of the portfolio owner, rendered by the sidebar.
class Profile {
  final String fullName;
  final String role;
  final String subtitle;
  final String location;
  final String email;
  final String phone;

  /// Fallback shown when the profile photo cannot be decoded.
  final String initials;

  final List<ContactChannel> channels;

  const Profile({
    required this.fullName,
    required this.role,
    required this.subtitle,
    required this.location,
    required this.email,
    required this.phone,
    required this.initials,
    required this.channels,
  });
}
