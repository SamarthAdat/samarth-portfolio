import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/entities/contact_message.dart';
import '../../domain/repositories/contact_repository.dart';
import '../datasources/contact_remote_data_source.dart';
import '../datasources/portfolio_local_data_source.dart';
import '../models/contact_message_model.dart';

/// Sends contact messages, addressing them to the email published in the
/// portfolio content so the recipient is never hard-coded in the UI.
class ContactRepositoryImpl implements ContactRepository {
  final ContactRemoteDataSource _remoteDataSource;
  final PortfolioLocalDataSource _localDataSource;

  const ContactRepositoryImpl({
    required ContactRemoteDataSource remoteDataSource,
    required PortfolioLocalDataSource localDataSource,
  }) : _remoteDataSource = remoteDataSource,
       _localDataSource = localDataSource;

  @override
  Future<Result<void>> sendMessage(ContactMessage message) async {
    try {
      final String recipient = _localDataSource.getProfile().email;

      await _remoteDataSource.submit(
        ContactMessageModel.fromEntity(message, recipient: recipient),
      );

      return const Result<void>.success(null);
    } on RequestTimeoutException {
      return const Result<void>.failure(TimeoutFailure());
    } on NetworkException {
      return const Result<void>.failure(NetworkFailure());
    } on ServerException catch (exception) {
      return Result<void>.failure(
        ServerFailure(exception.message, exception.statusCode),
      );
    } on ContentParsingException catch (exception) {
      return Result<void>.failure(ContentFailure(exception.message));
    } on Object catch (error) {
      return Result<void>.failure(
        UnexpectedFailure('The message could not be sent: $error'),
      );
    }
  }
}
