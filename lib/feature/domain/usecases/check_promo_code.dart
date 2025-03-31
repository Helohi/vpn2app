import 'package:dartz/dartz.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/usecases/usecase.dart';
import 'package:vpn2app/feature/domain/repositories/data_source_repository.dart';

class CheckPromoCode implements UseCaseWithParams<bool, CheckPromoCodeParams> {
  final DataSourceRepository Function() repository;

  CheckPromoCode({required this.repository});

  @override
  Future<Either<Failure, bool>> call(CheckPromoCodeParams params) {
    return repository().checkPromoCode(params.promoCode);
  }
}

class CheckPromoCodeParams {
  final String promoCode;

  CheckPromoCodeParams({required this.promoCode});
}
