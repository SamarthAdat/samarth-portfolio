import 'package:flutter_test/flutter_test.dart';
import 'package:samarth_portfolio/core/error/failure.dart';
import 'package:samarth_portfolio/core/utils/result.dart';
import 'package:samarth_portfolio/features/portfolio/domain/entities/contact_message.dart';
import 'package:samarth_portfolio/features/portfolio/domain/repositories/contact_repository.dart';
import 'package:samarth_portfolio/features/portfolio/domain/usecases/send_contact_message.dart';
import 'package:samarth_portfolio/features/portfolio/domain/validators/contact_message_validator.dart';

/// Records what reaches the repository, so the use case can be tested without
/// any network involvement.
class _RecordingContactRepository implements ContactRepository {
  final List<ContactMessage> sent = <ContactMessage>[];
  Result<void> response = const Result<void>.success(null);

  @override
  Future<Result<void>> sendMessage(ContactMessage message) async {
    sent.add(message);
    return response;
  }
}

void main() {
  late _RecordingContactRepository repository;
  late SendContactMessage useCase;

  setUp(() {
    repository = _RecordingContactRepository();
    useCase = SendContactMessage(repository);
  });

  test('trims every field before delivery', () async {
    final Result<void> result = await useCase(
      const ContactMessage(
        senderName: '  Ada  ',
        senderEmail: ' ada@example.com ',
        subject: ' Hello ',
        body: ' Message body ',
      ),
    );

    expect(result.isSuccess, isTrue);
    expect(repository.sent.single.senderName, 'Ada');
    expect(repository.sent.single.senderEmail, 'ada@example.com');
    expect(repository.sent.single.subject, 'Hello');
    expect(repository.sent.single.body, 'Message body');
  });

  test('rejects whitespace-only input without calling the repository', () async {
    final Result<void> result = await useCase(
      const ContactMessage(
        senderName: '   ',
        senderEmail: '   ',
        subject: '   ',
        body: '   ',
      ),
    );

    expect(repository.sent, isEmpty);

    final Failure? failure = result.failureOrNull;
    expect(failure, isA<ValidationFailure>());
    expect(
      (failure! as ValidationFailure).fieldErrors.keys,
      containsAll(<String>[
        ContactField.name,
        ContactField.email,
        ContactField.subject,
        ContactField.body,
      ]),
    );
  });

  test('rejects an address without an @ or a dot', () async {
    final Result<void> result = await useCase(
      const ContactMessage(
        senderName: 'Ada',
        senderEmail: 'not-an-address',
        subject: 'Hello',
        body: 'Body',
      ),
    );

    expect(repository.sent, isEmpty);
    expect(
      (result.failureOrNull! as ValidationFailure).fieldErrors,
      contains(ContactField.email),
    );
  });

  test('passes repository failures through untouched', () async {
    repository.response = const Result<void>.failure(NetworkFailure());

    final Result<void> result = await useCase(
      const ContactMessage(
        senderName: 'Ada',
        senderEmail: 'ada@example.com',
        subject: 'Hello',
        body: 'Body',
      ),
    );

    expect(result.failureOrNull, isA<NetworkFailure>());
  });
}
