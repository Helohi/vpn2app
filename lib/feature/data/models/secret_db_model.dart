import 'package:vpn2app/feature/domain/entities/secret_db_entity.dart';

class SecretDBModel extends SecretDBEntity {
  SecretDBModel({
    required super.currentVersion,
    required super.lastVpnList,
    required super.firstVpnList,
    required super.promocodes,
  });

  factory SecretDBModel.fromJson(Map<String, dynamic> json) {
    return SecretDBModel(
      currentVersion: json['current_version'],
      lastVpnList: json['last_vpn_list'],
      firstVpnList: json['first_vpn_list'],
      promocodes: json['promocodes'] != null
          ? json['promocodes'] as Map<String, dynamic>
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "current_version": currentVersion,
      "last_vpn_list": lastVpnList,
      "first_vpn_list": firstVpnList,
    };
  }
}
