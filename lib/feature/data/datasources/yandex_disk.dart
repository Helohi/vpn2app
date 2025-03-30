import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:vpn2app/core/datasources/datasource.dart';
import 'package:vpn2app/core/error/error.dart';
import 'package:vpn2app/feature/data/models/secret_db_model.dart';
import 'package:vpn2app/feature/data/models/vpn_list_model.dart';
import 'package:vpn2app/feature/domain/entities/advertisement_entity.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';

class YandexDisk extends DataSource {
  static const baseLink =
      "https://cloud-api.yandex.net/v1/disk/public/resources/download?public_key=https://disk.yandex.ru/d/HFmRw3zdqDYnBA&path=";
  static const serverSecretDBFile = "db.json";
  static const serverAdvertisementFile = "advertisement_db.json";
  static const serverVpnsFolder = "vpns";

  final http.Client client;
  VpnListEntity? lastVpnList;
  double? _latestAppVersion;
  final bool noTimeout;
  static const timeout = Duration(seconds: 2);

  YandexDisk({required this.client, required this.noTimeout});

  Future<http.Response> noTimeoutUntilResponse(Uri url) async {
    try {
      return await client.get(url).timeout(timeout);
    } on TimeoutException catch (_) {
      if (!noTimeout) rethrow;
      return await noTimeoutUntilResponse(url);
    }
  }

  Future<SecretDBModel> getSecretDB() async {
    final downloadLinkUri = Uri.parse(
      "$baseLink/$serverSecretDBFile",
    );
    final downloadLinkAns =
        jsonDecode((await client.get(downloadLinkUri).timeout(
                  timeout,
                  onTimeout: () => noTimeoutUntilResponse(downloadLinkUri),
                ))
            .body);

    final secretUri = Uri.parse(downloadLinkAns['href']);
    final secretAns = await client.get(secretUri).timeout(
          timeout,
          onTimeout: () => noTimeoutUntilResponse(secretUri),
        );

    return SecretDBModel.fromJson(
      jsonDecode(utf8.decode(secretAns.body.codeUnits)),
    );
  }

  @override
  Future<VpnListEntity> getLastVpnList() async {
    final secretModel = await getSecretDB();
    _latestAppVersion = double.tryParse(secretModel.currentVersion);

    if (secretModel.lastVpnList == null) {
      throw Exception("No last_vpn_list in vpn_manager");
    }

    final vpnListUri = Uri.parse("$baseLink/${secretModel.lastVpnList}");
    final lastVpnListAns = await getVpnList(vpnListUri);

    lastVpnList = VpnListEntity(
      prev: lastVpnListAns.prev,
      next: lastVpnListAns.next,
      data: lastVpnListAns.data.reversed.toList(),
    );
    return lastVpnList!;
  }

  @override
  Future<VpnListEntity> getNextVpnList() async {
    if (lastVpnList == null || lastVpnList!.prev == null) {
      throw NoMoreKeysToLoad();
    }

    final vpnListUri = Uri.parse("$baseLink/${lastVpnList!.prev!}");
    final newVpnList = await getVpnList(vpnListUri);
    final return_ = VpnListEntity(
      prev: newVpnList.prev,
      next: newVpnList.next,
      data: lastVpnList!.data + newVpnList.data.reversed.toList(),
    );

    lastVpnList = return_;
    return return_;
  }

  Future<VpnListEntity> getVpnList(Uri downloadLinkUri) async {
    final downloadLinkAns =
        jsonDecode((await client.get(downloadLinkUri).timeout(
                  timeout,
                  onTimeout: () => noTimeoutUntilResponse(downloadLinkUri),
                ))
            .body);

    final vpnListAns =
        await client.get(Uri.parse(downloadLinkAns['href'])).timeout(
              timeout,
              onTimeout: () => noTimeoutUntilResponse(
                Uri.parse(downloadLinkAns['href']),
              ),
            );

    final vpnList = VpnListModel.fromJson(
      jsonDecode(utf8.decode(
        vpnListAns.body.codeUnits,
      )),
    );
    return vpnList;
  }

  @override
  Future<bool> checkPromocode(String promocode) async {
    final secretModel = await getSecretDB();
    if (secretModel.promocodes == null ||
        !secretModel.promocodes!.containsKey(promocode)) {
      return false;
    }
    return true;
  }

  @override
  Future<DownloadFileEntity> downloadVpnKey(VpnKeyEntity vpnKey) async {
    final downloadLinkUrl =
        Uri.parse("$baseLink/$serverVpnsFolder/${vpnKey.id}");
    final url =
        Uri.parse(jsonDecode((await client.get(downloadLinkUrl)).body)['href']);
    return downlaodVpnKeyAndSaveIt(url, vpnKey.id, vpnKey.name, client);
  }

  @override
  Future<AdvertisementEntity> loadAdvertisement() async {
    final downloadLinkUrl = Uri.parse("$baseLink/$serverAdvertisementFile");
    final advertisementsUrl =
        jsonDecode((await client.get(downloadLinkUrl)).body)['href'];

    final advertisementsAns = await client.get(Uri.parse(advertisementsUrl));
    final advertisements =
        jsonDecode(utf8.decode(advertisementsAns.body.codeUnits))
            as Map<String, dynamic>;
    final advertisementsKeys = advertisements.keys.toList();
    final chosenAd = advertisementsKeys[Random().nextInt(
      advertisements.length,
    )];
    advertisements[chosenAd]['realImages'] = [];
    for (int i = 0; i < advertisements[chosenAd]['images'].length; i++) {
      final imageUri = Uri.parse(advertisements[chosenAd]['images'][i]);
      final imageAns = await client.get(imageUri);
      final realImageUrl = jsonDecode(imageAns.body)['href'];

      advertisements[chosenAd]['realImages'].add(realImageUrl);
    }

    return AdvertisementEntity(
      name: chosenAd,
      url: advertisements[chosenAd]['url'],
      images: List<String>.from(advertisements[chosenAd]['realImages']),
    );
  }

  /// Recomended to use after [getLastVpnList]
  @override
  Future<double> getLatestAppVersion() async {
    if (_latestAppVersion == null) {
      return double.parse((await getSecretDB()).currentVersion);
    }
    return _latestAppVersion!;
  }
}
