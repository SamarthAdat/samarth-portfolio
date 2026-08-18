import '../../../../core/constants/app_assets.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/utils/result.dart';
import '../../domain/repositories/link_repository.dart';
import '../datasources/link_launcher_data_source.dart';

/// Opens external destinations through the platform launcher.
class LinkRepositoryImpl implements LinkRepository {
  final LinkLauncherDataSource _launcher;

  const LinkRepositoryImpl(this._launcher);

  @override
  Future<Result<void>> openExternalLink(String url) => _open(url);

  @override
  Future<Result<void>> openResume() => _open(AppAssets.resumePdf);

  Future<Result<void>> _open(String url) async {
    try {
      await _launcher.open(url);
      return const Result<void>.success(null);
    } on LinkLaunchException catch (exception) {
      return Result<void>.failure(LinkFailure(exception.message));
    } on Object catch (error) {
      return Result<void>.failure(
        LinkFailure('Could not open the requested link: $error'),
      );
    }
  }
}
