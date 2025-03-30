class SecretDBEntity {
  final String currentVersion;
  final String? lastVpnList;
  final String? firstVpnList;
  final Map<String, dynamic>? promocodes;

  SecretDBEntity({
    required this.currentVersion,
    required this.lastVpnList,
    required this.firstVpnList,
    required this.promocodes,
  });
}
