import '../../../../core/utils/result.dart';
import '../entities/contact_message.dart';

/// Delivery of messages composed in the contact form.
abstract interface class ContactRepository {
  Future<Result<void>> sendMessage(ContactMessage message);
}
