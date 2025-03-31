<<<<<<< HEAD
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
=======
import 'package:vpn2app/feature/domain/entities/secret_db_entity.dart';

class SecretDBModel extends SecretDBEntity {
  SecretDBModel({
    required super.currentVersion,
    required super.lastVpnList,
    required super.firstVpnList,
    required super.promoCodes,
  });

  factory SecretDBModel.fromJson(Map<String, dynamic> json) {
    return SecretDBModel(
      currentVersion: json['current_version'],
      lastVpnList: json['last_vpn_list'],
      firstVpnList: json['first_vpn_list'],
      promoCodes: json['promocodes'] != null
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
>>>>>>> 3dd1ed906b04a9df2f5ddf01d804006534dfe65f
