import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/config/app_config.dart';
import '../../../../core/error/exceptions.dart';
import '../models/contact_message_model.dart';

/// Submits contact messages to the form service.
abstract interface class ContactRemoteDataSource {
  /// Throws [ServerException], [NetworkException], or
  /// [RequestTimeoutException] when delivery fails.
  Future<void> submit(ContactMessageModel message);
}

class ContactRemoteDataSourceImpl implements ContactRemoteDataSource {
  final http.Client _client;
  final Uri _endpoint;
  final Duration _timeout;

  ContactRemoteDataSourceImpl({
    required http.Client client,
    Uri? endpoint,
    Duration timeout = AppConfig.requestTimeout,
  }) : _client = client,
       _endpoint = endpoint ?? Uri.parse(AppConfig.contactFormEndpoint),
       _timeout = timeout;

  @override
  Future<void> submit(ContactMessageModel message) async {
    final http.Response response;

    try {
      response = await _client
          .post(
            _endpoint,
            headers: const <String, String>{'Accept': 'application/json'},
            body: message.toFormFields(),
          )
          .timeout(_timeout);
    } on TimeoutException {
      throw const RequestTimeoutException();
    } on Object catch (error) {
      throw NetworkException('Could not reach the form service: $error');
    }

    _ensureAccepted(response);
  }

  /// The service answers 2xx for accepted submissions, but may still report a
  /// rejection in the body — both cases are checked here.
  void _ensureAccepted(http.Response response) {
    final Object? payload = _decodeBody(response.body);
    final bool statusOk =
        response.statusCode >= 200 && response.statusCode < 300;

    if (statusOk && _payloadIndicatesSuccess(payload)) return;

    throw ServerException(
      _failureMessage(payload) ?? 'Could not send message right now.',
      response.statusCode,
    );
  }

  Object? _decodeBody(String body) {
    if (body.isEmpty) return null;
    try {
      return jsonDecode(body);
    } on FormatException {
      return null;
    }
  }

  bool _payloadIndicatesSuccess(Object? payload) {
    if (payload is! Map) return true;

    final Object? success = payload['success'];
    if (success == null) return true;

    return success == true || success.toString().toLowerCase() == 'true';
  }

  String? _failureMessage(Object? payload) {
    if (payload is! Map) return null;

    final Object? message = payload['message'];
    if (message == null) return null;

    final String text = message.toString().trim();
    return text.isEmpty ? null : text;
  }
}
