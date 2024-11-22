class VpnKeyEntity {
  final String id;
  final String name;
  final String channel;
  final String description;
  final int likes;
  final int dislikes;
  final String date;
  final TypeOfVpnKey? vpnType;

  VpnKeyEntity({
    required this.id,
    required this.name,
    required this.channel,
    required this.description,
    required this.likes,
    required this.dislikes,
    required this.date,
    this.vpnType,
  });

  @override
  String toString() {
    return "$id: $date; $name - $channel '$description' ";
  }
}

// ignore: constant_identifier_names
enum TypeOfVpnKey { TURKMEN_VPN, RUSSIAN_VPN }
