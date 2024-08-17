import 'package:dartz/dartz.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/usecases/usecase.dart';
import 'package:vpn2app/feature/domain/repositories/data_source_repository.dart';

class CheckPromocode implements UseCaseWithParams<bool, CheckPromocodeParams> {
  final DataSourceRepository Function() repository;

  CheckPromocode({required this.repository});

  @override
  Future<Either<Failure, bool>> call(CheckPromocodeParams params) {
    return repository().checkPromocode(params.promocode);
  }
}

class CheckPromocodeParams {
  final String promocode;

  CheckPromocodeParams({required this.promocode});
}
