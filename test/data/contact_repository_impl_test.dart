import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:samarth_portfolio/core/error/failure.dart';
import 'package:samarth_portfolio/core/utils/result.dart';
import 'package:samarth_portfolio/features/portfolio/data/datasources/contact_remote_data_source.dart';
import 'package:samarth_portfolio/features/portfolio/data/datasources/portfolio_local_data_source.dart';
import 'package:samarth_portfolio/features/portfolio/data/repositories/contact_repository_impl.dart';
import 'package:samarth_portfolio/features/portfolio/domain/entities/contact_message.dart';
import 'package:samarth_portfolio/features/portfolio/domain/repositories/contact_repository.dart';

const ContactMessage _message = ContactMessage(
  senderName: 'Ada Lovelace',
  senderEmail: 'ada@example.com',
  subject: 'Collaboration',
  body: 'Let us build an analytical engine.',
);

ContactRepository _repositoryWith(MockClient client) {
  return ContactRepositoryImpl(
    remoteDataSource: ContactRemoteDataSourceImpl(client: client),
    localDataSource: PortfolioLocalDataSourceImpl(),
  );
}

void main() {
  test('sends the message addressed to the published email', () async {
    late http.Request captured;

    final ContactRepository repository = _repositoryWith(
      MockClient((http.Request request) async {
        captured = request;
        return http.Response(jsonEncode(<String, Object>{'success': true}), 200);
      }),
    );

    final Result<void> result = await repository.sendMessage(_message);

    expect(result.isSuccess, isTrue);

    final Map<String, String> fields = Uri.splitQueryString(captured.body);
    expect(fields['_to'], 'samarthadat2002@gmail.com');
    expect(fields['name'], 'Ada Lovelace');
    expect(fields['_replyto'], 'ada@example.com');
    expect(fields['_subject'], 'Portfolio Contact: Collaboration');
  });

  test('maps a rejected payload to a ServerFailure carrying its message', () async {
    final ContactRepository repository = _repositoryWith(
      MockClient((http.Request request) async {
        return http.Response(
          jsonEncode(<String, Object>{
            'success': false,
            'message': 'Daily quota reached.',
          }),
          200,
        );
      }),
    );

    final Result<void> result = await repository.sendMessage(_message);

    expect(result.failureOrNull, isA<ServerFailure>());
    expect(result.failureOrNull?.message, 'Daily quota reached.');
  });

  test('maps a non-success status to a ServerFailure', () async {
    final ContactRepository repository = _repositoryWith(
      MockClient((http.Request request) async => http.Response('', 500)),
    );

    final Failure? failure = (await repository.sendMessage(_message))
        .failureOrNull;

    expect(failure, isA<ServerFailure>());
    expect((failure! as ServerFailure).statusCode, 500);
  });

  test('maps a timeout to a TimeoutFailure', () async {
    final ContactRepository repository = ContactRepositoryImpl(
      remoteDataSource: ContactRemoteDataSourceImpl(
        client: MockClient((http.Request request) {
          return Future<http.Response>.delayed(
            const Duration(milliseconds: 200),
            () => http.Response('', 200),
          );
        }),
        timeout: const Duration(milliseconds: 20),
      ),
      localDataSource: PortfolioLocalDataSourceImpl(),
    );

    final Result<void> result = await repository.sendMessage(_message);

    expect(result.failureOrNull, isA<TimeoutFailure>());
  });

  test('maps a transport error to a NetworkFailure', () async {
    final ContactRepository repository = _repositoryWith(
      MockClient((http.Request request) async {
        throw const SocketExceptionStub();
      }),
    );

    final Result<void> result = await repository.sendMessage(_message);

    expect(result.failureOrNull, isA<NetworkFailure>());
  });
}

/// Stands in for a socket-level failure without importing `dart:io`, which is
/// unavailable on the web target.
class SocketExceptionStub implements Exception {
  const SocketExceptionStub();
}
