import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';

class VpnKeyModel extends VpnKeyEntity {
  VpnKeyModel({
    required super.id,
    required super.name,
    required super.channel,
    required super.description,
    required super.likes,
    required super.dislikes,
    required super.date,
    required super.vpnType,
  });

  factory VpnKeyModel.fromJson(Map<String, dynamic> json) {
    return VpnKeyModel(
      id: json['id'],
      name: json['name'],
      channel: json['channel'],
      description: json['description'],
      likes: json['likes'],
      dislikes: json['dislikes'],
      date: json['date'],
      vpnType: json.containsKey("vpn_type")
          ? TypeOfVpnKey.values.byName(json['vpn_type'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "channel": channel,
      "description": description,
      "likes": likes,
      "dislikes": dislikes,
      "date": date.toString(),
    };
  }
}
