import 'dart:convert';
import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:vpn2app/core/datasources/datasource.dart';
import 'package:vpn2app/core/error/error.dart';
import 'package:vpn2app/feature/data/models/vpn_list_model.dart';
import 'package:vpn2app/feature/data/models/vpn_manager_model.dart';
import 'package:vpn2app/feature/domain/entities/advertisement_entity.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_manager_enity.dart';

class GoogleDrive implements DataSource {
  final http.Client client;
  VpnListEntity? lastVpnList;
  double? _latestAppVersion;

  GoogleDrive({required this.client});

  Future<VpnManagerEntity> getVpnManager() async {
    final vpnManagerUri = Uri.parse(
      'https://drive.usercontent.google.com/download?id=1KLONGdoGDxtgsBy5Hb7xMfe3OIfJcUF5&export=download',
    );
    final vpnManagerAns = await client.get(vpnManagerUri);
    return VpnManagerModel.fromJson(
      jsonDecode(utf8.decode(vpnManagerAns.body.codeUnits))
          as Map<String, dynamic>,
    );
  }

  @override
  Future<VpnListEntity> getLastVpnList() async {
    final vpnManager = await getVpnManager();
    _latestAppVersion = double.parse(vpnManager.currentVersion);

    if (vpnManager.lastListLink == null) {
      throw Exception("No last_list_link in vpn_manager");
    }

    final vpnListUri = Uri.parse(vpnManager.lastListLink!);
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

    final vpnListUri = Uri.parse(lastVpnList!.prev!);
    final newVpnList = await getVpnList(vpnListUri);
    final return_ = VpnListEntity(
      prev: newVpnList.prev,
      next: newVpnList.next,
      data: lastVpnList!.data + newVpnList.data.reversed.toList(),
    );

    lastVpnList = return_;
    return return_;
  }

  Future<VpnListEntity> getVpnList(Uri uri) async {
    final vpnListAns = await client.get(uri);
    final vpnList = VpnListModel.fromJson(
      jsonDecode(utf8.decode(
        vpnListAns.body.codeUnits,
      )) as Map<String, dynamic>,
    );

    return vpnList;
  }

  @override
  Future<bool> checkPromocode(String promocode) async {
    final uri = Uri.parse(
      'https://drive.usercontent.google.com/download?id=1F0wbJV1tbcp1baFRg8TnEa_jERuyb0Jf&export=download',
    );
    final ans = await client.get(uri);
    final data =
        jsonDecode(utf8.decode(ans.body.codeUnits)) as Map<String, dynamic>;
    final promocodes = data['promocodes'] as Map<String, dynamic>;

    if (promocodes.keys.contains(promocode)) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<DownloadFileEntity> downloadVpnKey(VpnKeyEntity vpnKey) async {
    final url = Uri.parse(
      'https://drive.usercontent.google.com/download?id=${vpnKey.id}&export=download',
    );
    return downlaodVpnKeyAndSaveIt(url, vpnKey.id, vpnKey.name, client);
  }

  @override
  Future<AdvertisementEntity> loadAdvertisement() async {
    final uri = Uri.parse(
      "https://drive.usercontent.google.com/download?id=13zYbVHdcJvGWddQU50REKREk_uH4-QQ7&export=download",
    );
    final ans = await client.get(uri);
    final advertisements =
        jsonDecode(utf8.decode(ans.body.codeUnits)) as Map<String, dynamic>;
    final advertisementsKeys = advertisements.keys.toList();
    final chosenAd = advertisementsKeys[Random().nextInt(
      advertisementsKeys.length,
    )];

    return AdvertisementEntity(
      name: chosenAd,
      url: advertisements[chosenAd]['url'],
      images: List<String>.from(advertisements[chosenAd]['images']),
    );
  }

  /// Recomended to use after [getLastVpnList]
  @override
  Future<double> getLatestAppVersion() async {
    if (_latestAppVersion == null) {
      return double.parse((await getVpnManager()).currentVersion);
    }
    return _latestAppVersion!;
  }
}
