import '../../../../core/error/failure.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../entities/contact_message.dart';
import '../repositories/contact_repository.dart';
import '../validators/contact_message_validator.dart';

/// Validates a message and, if it is well formed, hands it to the repository.
///
/// Validation happens here rather than in the form widget so that any future
/// caller gets the same guarantees.
class SendContactMessage implements UseCase<void, ContactMessage> {
  final ContactRepository _repository;
  final ContactMessageValidator _validator;

  const SendContactMessage(
    this._repository, {
    ContactMessageValidator validator = const ContactMessageValidator(),
  }) : _validator = validator;

  @override
  Future<Result<void>> call(ContactMessage params) async {
    final ContactMessage message = params.trimmed();
    final Map<String, String> errors = _validator.validate(message);

    if (errors.isNotEmpty) {
      return Result<void>.failure(
        ValidationFailure(
          'Please correct the highlighted fields.',
          fieldErrors: errors,
        ),
      );
    }

    return _repository.sendMessage(message);
  }
}
