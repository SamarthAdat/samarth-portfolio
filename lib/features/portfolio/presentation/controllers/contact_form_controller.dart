import 'package:flutter/widgets.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/contact_message.dart';
import '../../domain/usecases/send_contact_message.dart';
import '../../domain/validators/contact_message_validator.dart';

/// The outcome of a submission, ready to be shown in a snack bar.
class ContactSubmissionOutcome {
  final bool isSent;
  final String message;

  const ContactSubmissionOutcome.sent()
    : isSent = true,
      message = 'Message sent successfully.';

  ContactSubmissionOutcome.failed(Failure failure)
    : isSent = false,
      message = failure.message;
}

/// Owns the contact form's text controllers and submission state.
///
/// Validation rules come from the domain validator, and delivery goes through
/// the [SendContactMessage] use case — this class only coordinates.
class ContactFormController extends ChangeNotifier {
  final SendContactMessage _sendContactMessage;
  final ContactMessageValidator validator;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool _isSending = false;

  ContactFormController({
    required SendContactMessage sendContactMessage,
    this.validator = const ContactMessageValidator(),
  }) : _sendContactMessage = sendContactMessage;

  bool get isSending => _isSending;

  /// Sends the form's current contents. Returns `null` while a previous
  /// submission is still in flight.
  Future<ContactSubmissionOutcome?> submit() async {
    if (_isSending) return null;

    _isSending = true;
    notifyListeners();

    final Result<void> result = await _sendContactMessage(
      ContactMessage(
        senderName: nameController.text,
        senderEmail: emailController.text,
        subject: subjectController.text,
        body: messageController.text,
      ),
    );

    _isSending = false;

    final ContactSubmissionOutcome outcome = result.fold(
      onSuccess: (_) {
        _clearFields();
        return const ContactSubmissionOutcome.sent();
      },
      onFailure: ContactSubmissionOutcome.failed,
    );

    notifyListeners();
    return outcome;
  }

  void _clearFields() {
    nameController.clear();
    emailController.clear();
    subjectController.clear();
    messageController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }
}
