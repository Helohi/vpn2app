import 'package:vpn2app/feature/domain/entities/vpn_manager_enity.dart';

class VpnManagerModel extends VpnManagerEntity {
  VpnManagerModel({
    required super.firstListLink,
    required super.lastListLink,
    required super.currentVersion,
  });

  factory VpnManagerModel.fromJson(Map<String, dynamic> json) {
    return VpnManagerModel(
      firstListLink: json['first_list_link'],
      lastListLink: json['last_list_link'],
      currentVersion: json['current_version'],
    );
  }
}
