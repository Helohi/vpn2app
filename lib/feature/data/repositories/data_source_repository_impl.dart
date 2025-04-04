import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:vpn2app/core/datasources/datasource.dart';
import 'package:vpn2app/core/error/error.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/plugins/analytics.dart';
import 'package:vpn2app/feature/domain/entities/advertisement_entity.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';
import 'package:vpn2app/feature/domain/repositories/data_source_repository.dart';

class DataSourceRepositoryImpl implements DataSourceRepository {
  final DataSource dataSource;

  DataSourceRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, VpnListEntity>> getLastVpnList() async {
    try {
      return Right(await dataSource.getLastVpnList());
    } catch (e) {
      Analytics.useDefaultValues(
        await Analytics.getCountryAndCity(),
        errorHappened: e.toString(),
      ).sendToAnalytics();
      return Left(FetchingFirstDataFailure());
    }
  }

  @override
  Future<Either<Failure, VpnListEntity>> getNextVpnList() async {
    Analytics.useDefaultValues(await Analytics.getCountryAndCity(),
            loadingMoreVpns: 1)
        .sendToAnalytics();
    try {
      return Right(await dataSource.getNextVpnList());
    } on NoMoreKeysToLoad catch (_) {
      return Left(NoMoreKeysToLoadFailure());
    } catch (e) {
      Analytics.useDefaultValues(
        await Analytics.getCountryAndCity(),
        errorHappened: e.toString(),
      ).sendToAnalytics();
      return Left(FetchingNextDatasFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> checkPromoCode(String promoCode) async {
    try {
      return Right(await dataSource.checkPromoCode(promoCode));
    } catch (e) {
      Analytics.useDefaultValues(
        await Analytics.getCountryAndCity(),
        errorHappened: e.toString(),
      ).sendToAnalytics();
      return Left(PromoCodeCheckFailure());
    }
  }

  @override
  Future<Either<Failure, DownloadFileEntity>> downloadVpnKey(
      VpnKeyEntity vpnKey) async {
    try {
      return Right(await dataSource.downloadVpnKey(vpnKey));
    } catch (e) {
      Analytics.useDefaultValues(
        await Analytics.getCountryAndCity(),
        errorHappened: e.toString(),
      ).sendToAnalytics();
      return Left(DownloadVpnKeyFailure());
    }
  }

  @override
  Future<Either<Failure, AdvertisementEntity>> loadAdvertisement() async {
    try {
      return Right(await dataSource.loadAdvertisement());
    } catch (e) {
      Analytics.useDefaultValues(
        await Analytics.getCountryAndCity(),
        errorHappened: e.toString(),
      ).sendToAnalytics();
      return Left(LoadAdvertisementFailure());
    }
  }

  @override
  Future<Either<Failure, double>> getLatestAppVersion() async {
    try {
      return Right(await dataSource.getLatestAppVersion());
    } catch (e) {
      Analytics.useDefaultValues(
        await Analytics.getCountryAndCity(),
        errorHappened: e.toString(),
      ).sendToAnalytics();
      return Left(GetLatestAppVersionFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteDownloadFolder() async {
    try {
      return Right(await dataSource.deleteDownloadFolder());
    } on PathNotFoundException catch (_) {
      return Left(DownloadFolderNotExist());
    } catch (e) {
      Analytics.useDefaultValues(
        await Analytics.getCountryAndCity(),
        errorHappened: e.toString(),
      ).sendToAnalytics();
      return Left(DeleteDownloadFolderFailure());
    }
  }
}
