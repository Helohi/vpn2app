import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';

class VpnListEntity {
  final String? prev;
  final String? next;
  final List<VpnKeyEntity> data;

  VpnListEntity({
    required this.prev,
    required this.next,
    required this.data,
  });
}
