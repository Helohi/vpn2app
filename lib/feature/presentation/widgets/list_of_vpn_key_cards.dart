import 'package:flutter/material.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';
import 'package:vpn2app/feature/presentation/widgets/widgets.dart';

class ListOfVpnKeyCards extends StatelessWidget {
  const ListOfVpnKeyCards({super.key, required this.vpnList});

  final VpnListEntity vpnList;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: [
        ...vpnList.data
            .map((e) => VpnKeyCard(context: context, vpnKey: e))
            .toList(),
        const LoadMoreVpnKeysCard(),
      ],
    );
  }
}
