import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/link_repository.dart';

/// Opens the bundled resume PDF.
class DownloadResume implements UseCase<void, NoParams> {
  final LinkRepository _repository;

  const DownloadResume(this._repository);

  @override
  Future<Result<void>> call(NoParams params) => _repository.openResume();
}
