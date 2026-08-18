import '../../../../core/utils/json_reader.dart';
import '../../domain/entities/contact_channel.dart';

/// Data-layer representation of a [ContactChannel].
class ContactChannelModel {
  final ContactChannelType type;
  final String label;
  final String displayValue;
  final String? actionUrl;

  const ContactChannelModel({
    required this.type,
    required this.label,
    required this.displayValue,
    required this.actionUrl,
  });

  factory ContactChannelModel.fromJson(Map<String, dynamic> json) {
    return ContactChannelModel(
      type: json.requireEnum('type', ContactChannelType.values),
      label: json.requireString('label'),
      displayValue: json.requireString('displayValue'),
      actionUrl: json.optionalString('actionUrl'),
    );
  }

  ContactChannel toEntity() => ContactChannel(
    type: type,
    label: label,
    displayValue: displayValue,
    actionUrl: actionUrl,
  );
}
