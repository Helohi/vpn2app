import 'package:dartz/dartz.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/usecases/usecase.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/repositories/data_source_repository.dart';

class DownloadVpnKey
    implements UseCaseWithParams<DownloadFileEntity, DownloadVpnKeyParams> {
  final DataSourceRepository Function() repository;

  DownloadVpnKey({required this.repository});

  @override
  Future<Either<Failure, DownloadFileEntity>> call(
      DownloadVpnKeyParams params) {
    return repository().downloadVpnKey(params.vpnKey);
  }
}

class DownloadVpnKeyParams {
  final VpnKeyEntity vpnKey;

  DownloadVpnKeyParams({required this.vpnKey});
}
