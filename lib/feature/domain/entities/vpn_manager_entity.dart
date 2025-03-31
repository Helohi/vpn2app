class VpnManagerEntity {
  final String? firstListLink;
  final String? lastListLink;
  final String currentVersion;
  String? prev;

  VpnManagerEntity({
    required this.firstListLink,
    required this.lastListLink,
    required this.currentVersion,
  });
}
