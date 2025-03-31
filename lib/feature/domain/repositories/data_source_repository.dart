import 'package:dartz/dartz.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/feature/domain/entities/advertisement_entity.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';

abstract class DataSourceRepository {
  Future<Either<Failure, VpnListEntity>> getLastVpnList();

  Future<Either<Failure, VpnListEntity>> getNextVpnList();

  Future<Either<Failure, DownloadFileEntity>> downloadVpnKey(
    VpnKeyEntity vpnKey,
  );

  Future<Either<Failure, bool>> checkPromoCode(String promoCode);

  Future<Either<Failure, AdvertisementEntity>> loadAdvertisement();

  Future<Either<Failure, double>> getLatestAppVersion();

  Future<Either<Failure, void>> deleteDownloadFolder();
}
