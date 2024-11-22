import 'package:flutter/material.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';
import 'package:vpn2app/feature/presentation/widgets/widgets.dart';

class ListOfVpnKeyCards extends StatelessWidget {
  const ListOfVpnKeyCards(
      {super.key, required this.vpnList, required this.typeOfVpnKey});

  final VpnListEntity vpnList;
  final TypeOfVpnKey typeOfVpnKey;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.sizeOf(context).width ~/ 200,
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: [
        ...vpnList.data
            .where(
              (element) =>
                  element.vpnType == typeOfVpnKey || element.vpnType == null,
            )
            .map((e) => VpnKeyCard(context: context, vpnKey: e)),
        const LoadMoreVpnKeysCard(),
      ],
    );
  }
}
