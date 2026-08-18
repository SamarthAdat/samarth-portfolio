/// A message composed in the contact form.
class ContactMessage {
  final String senderName;
  final String senderEmail;
  final String subject;
  final String body;

  const ContactMessage({
    required this.senderName,
    required this.senderEmail,
    required this.subject,
    required this.body,
  });

  /// Trims every field, so whitespace-only input is treated as empty by the
  /// validator and never reaches the network.
  ContactMessage trimmed() => ContactMessage(
    senderName: senderName.trim(),
    senderEmail: senderEmail.trim(),
    subject: subject.trim(),
    body: body.trim(),
  );
}
