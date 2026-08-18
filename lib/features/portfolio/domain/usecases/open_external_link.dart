import '../../../../core/usecase/usecase.dart';
import '../../../../core/utils/result.dart';
import '../repositories/link_repository.dart';

/// Opens a link belonging to a contact channel or project.
class OpenExternalLink implements UseCase<void, String> {
  final LinkRepository _repository;

  const OpenExternalLink(this._repository);

  @override
  Future<Result<void>> call(String params) =>
      _repository.openExternalLink(params);
}
