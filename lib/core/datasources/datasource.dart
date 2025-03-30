import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/feature/domain/entities/advertisement_entity.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';
// ignore: avoid_web_libraries_in_flutter
//import "dart:html" show AnchorElement, document;
import "package:web/web.dart" as web;

abstract class DataSource {
  static String get useProxyServer {
    if (kIsWasm) {
      return "https://everyorigin.jwvbremen.nl/get?url="; // public cors proxy
    }
    // if (kIsWeb) return "http://127.0.0.1:5000/proxy?url="; // local cors proxy
    return "";
  }

  Future<VpnListEntity> getLastVpnList();

  Future<VpnListEntity> getNextVpnList();

  Future<DownloadFileEntity> downloadVpnKey(VpnKeyEntity vpnKey);

  Future<bool> checkPromocode(String promocode);

  Future<AdvertisementEntity> loadAdvertisement();

  Future<double> getLatestAppVersion();

  Future<void> deleteDownloadFolder() async {
    await Directory(localVpnStorageDirectory).delete(recursive: true);
  }
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
  if (kIsWeb) {
    downloadVpnKeyForWeb(downloadLink, name, client);
    return DownloadFileEntity(
      id: "web",
      name: "web",
      date: DateTime.now(),
      path: "web",
    );
  }

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

void downloadVpnKeyForWeb(Uri downloadLink, String name, Client client) async {
  final uri = Uri.parse(DataSource.useProxyServer + downloadLink.toString());
  final ans = await client.get(uri);

  final base64 = base64Encode(ans.bodyBytes);

  final anchor = web.HTMLAnchorElement()
    ..href = "data:application/octet-stream;base64,$base64"
    ..target = "blank"
    ..download = name;

  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  return;
}
