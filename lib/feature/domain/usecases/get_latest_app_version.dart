import 'package:dartz/dartz.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/usecases/usecase.dart';
import 'package:vpn2app/feature/domain/repositories/data_source_repository.dart';

class GetLatestAppVersion extends UseCase<double> {
  final DataSourceRepository Function() repository;

  GetLatestAppVersion({required this.repository});

  @override
  Future<Either<Failure, double>> call() {
    return repository().getLatestAppVersion();
  }
}
