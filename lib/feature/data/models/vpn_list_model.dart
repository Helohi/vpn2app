import 'package:vpn2app/feature/data/models/vpn_key_model.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';

class VpnListModel extends VpnListEntity {
  VpnListModel({
    required super.prev,
    required super.next,
    required super.data,
  });

  factory VpnListModel.fromJson(Map<String, dynamic> json) {
    List<VpnKeyModel> vpnKeys = [];

    (json['data'] as Map<String, dynamic>).forEach((key, value) {
      value['id'] = key;
      vpnKeys.add(VpnKeyModel.fromJson(value));
    });

    return VpnListModel(
      prev: json['prev'],
      next: json['next'],
      data: vpnKeys,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "prev": prev,
      "next": next,
      "data": data.map((e) => (e as VpnKeyModel).toJson()),
    };
  }
}
