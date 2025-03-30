import 'package:dartz/dartz.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/usecases/usecase.dart';
import 'package:vpn2app/feature/domain/entities/advertisement_entity.dart';
import 'package:vpn2app/feature/domain/repositories/data_source_repository.dart';

class LoadAdvertisements implements UseCase<AdvertisementEntity> {
  final DataSourceRepository Function() repository;

  LoadAdvertisements({required this.repository});

  @override
  Future<Either<Failure, AdvertisementEntity>> call() {
    return repository().loadAdvertisement();
  }
}
