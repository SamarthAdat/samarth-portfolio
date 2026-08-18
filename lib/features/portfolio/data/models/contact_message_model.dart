import '../../domain/entities/contact_message.dart';

/// Data-layer representation of a [ContactMessage].
///
/// Owns the field names the form service expects, keeping that wire format out
/// of the domain and the UI.
class ContactMessageModel {
  final String senderName;
  final String senderEmail;
  final String subject;
  final String body;

  /// Address the service forwards the message to.
  final String recipient;

  const ContactMessageModel({
    required this.senderName,
    required this.senderEmail,
    required this.subject,
    required this.body,
    required this.recipient,
  });

  factory ContactMessageModel.fromEntity(
    ContactMessage message, {
    required String recipient,
  }) {
    return ContactMessageModel(
      senderName: message.senderName,
      senderEmail: message.senderEmail,
      subject: message.subject,
      body: message.body,
      recipient: recipient,
    );
  }

  Map<String, String> toFormFields() => <String, String>{
    '_to': recipient,
    'name': senderName,
    'email': senderEmail,
    'subject': subject,
    'message': body,
    '_subject': 'Portfolio Contact: $subject',
    '_replyto': senderEmail,
  };
}
