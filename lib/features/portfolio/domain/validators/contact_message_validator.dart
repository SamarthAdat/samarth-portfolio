import '../entities/contact_message.dart';

/// Field names used as keys in `ValidationFailure.fieldErrors`.
class ContactField {
  const ContactField._();

  static const String name = 'name';
  static const String email = 'email';
  static const String subject = 'subject';
  static const String body = 'body';
}

/// Validation rules for the contact form.
///
/// They live in the domain so the form widget and the use case apply exactly
/// the same rules — the UI cannot drift from what the server accepts.
class ContactMessageValidator {
  const ContactMessageValidator();

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your full name';
    return null;
  }

  String? validateEmail(String? value) {
    final String text = value?.trim() ?? '';
    if (text.isEmpty) return 'Enter your email address';
    if (!text.contains('@') || !text.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? validateSubject(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter a subject';
    return null;
  }

  String? validateBody(String? value) {
    if (value == null || value.trim().isEmpty) return 'Enter your message';
    return null;
  }

  /// Validates every field at once, returning field name to error message.
  /// An empty map means the message is valid.
  Map<String, String> validate(ContactMessage message) {
    final Map<String, String?> errors = <String, String?>{
      ContactField.name: validateName(message.senderName),
      ContactField.email: validateEmail(message.senderEmail),
      ContactField.subject: validateSubject(message.subject),
      ContactField.body: validateBody(message.body),
    };

    return <String, String>{
      for (final MapEntry<String, String?> entry in errors.entries)
        if (entry.value != null) entry.key: entry.value!,
    };
  }
}
