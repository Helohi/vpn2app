class VpnKeyEntity {
  final String id;
  final String name;
  final String channel;
  final String description;
  final int likes;
  final int dislikes;
  final String date;

  VpnKeyEntity({
    required this.id,
    required this.name,
    required this.channel,
    required this.description,
    required this.likes,
    required this.dislikes,
    required this.date,
  });

  @override
  String toString() {
    return "$id: $date; $name - $channel '$description' ";
  }
}
