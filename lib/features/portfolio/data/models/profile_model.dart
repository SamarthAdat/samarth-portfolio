import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/profile.dart';
import 'contact_channel_model.dart';

/// Data-layer representation of a [Profile].
class ProfileModel {
  final String fullName;
  final String role;
  final String subtitle;
  final String location;
  final String email;
  final String phone;
  final String initials;
  final List<ContactChannelModel> channels;

  const ProfileModel({
    required this.fullName,
    required this.role,
    required this.subtitle,
    required this.location,
    required this.email,
    required this.phone,
    required this.initials,
    required this.channels,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      fullName: json.requireString('fullName'),
      role: json.requireString('role'),
      subtitle: json.requireString('subtitle'),
      location: json.requireString('location'),
      email: json.requireString('email'),
      phone: json.requireString('phone'),
      initials: json.requireString('initials'),
      channels: json
          .requireObjectList('channels')
          .map(ContactChannelModel.fromJson)
          .toList(growable: false),
    );
  }

  Profile toEntity() => Profile(
    fullName: fullName,
    role: role,
    subtitle: subtitle,
    location: location,
    email: email,
    phone: phone,
    initials: initials,
    channels: channels
        .map((ContactChannelModel model) => model.toEntity())
        .toList(growable: false),
  );
}
