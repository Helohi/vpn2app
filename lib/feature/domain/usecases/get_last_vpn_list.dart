import 'package:dartz/dartz.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/usecases/usecase.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';
import 'package:vpn2app/feature/domain/repositories/data_source_repository.dart';

class GetLastVpnList extends UseCase<VpnListEntity> {
  final DataSourceRepository Function() repository;

  GetLastVpnList({required this.repository});

  @override
  Future<Either<Failure, VpnListEntity>> call() {
    return repository().getLastVpnList();
  }
}
