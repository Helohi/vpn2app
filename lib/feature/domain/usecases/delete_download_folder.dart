import 'package:dartz/dartz.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/usecases/usecase.dart';
import 'package:vpn2app/feature/domain/repositories/data_source_repository.dart';

class DeleteDownloadFolder implements UseCase<void> {
  final DataSourceRepository Function() repository;

  DeleteDownloadFolder({required this.repository});

  @override
  Future<Either<Failure, void>> call() {
    return repository().deleteDownloadFolder();
  }
}
