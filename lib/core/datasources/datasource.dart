import 'dart:io';

import 'package:http/http.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/feature/domain/entities/advertisement_entity.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';

abstract class DataSource {
  Future<VpnListEntity> getLastVpnList();

  Future<VpnListEntity> getNextVpnList();

  Future<DownloadFileEntity> downloadVpnKey(VpnKeyEntity vpnKey);

  Future<bool> checkPromocode(String promocode);

  Future<AdvertisementEntity> loadAdvertisement();

  Future<double> getLatestAppVersion();
}

enum DataSourcesEnum { google, yandexAuto, yandexManual }

/// Gets answer from [downloadLink] threw http get request and saves data into file in downlaods folder
///
/// [downloadLink] - link from where vpn key can be downloaded
/// [id], [name] - for correct [DownloadFileEntity] creation
/// [client] - http client just for fun
Future<DownloadFileEntity> downlaodVpnKeyAndSaveIt(
  Uri downloadLink,
  String id,
  String name,
  Client client,
) async {
  final currentDate = DateTime.now();
  final localFilePath = '$localVpnStorageDirectory/$name';

  final ans = await client.get(downloadLink);
  final localFile = File(localFilePath);
  if (!localFile.existsSync()) {
    localFile.createSync(recursive: true);
  }

  await localFile.writeAsBytes(ans.bodyBytes);
  return DownloadFileEntity(
    id: id,
    name: name,
    date: currentDate,
    path: localFilePath,
  );
}
