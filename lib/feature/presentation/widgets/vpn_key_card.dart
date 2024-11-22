import 'package:flutter/material.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/plugins/subscription_controller.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';

class VpnKeyCard extends StatelessWidget {
  const VpnKeyCard({super.key, required this.context, required this.vpnKey});

  final VpnKeyEntity vpnKey;
  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => SubscriptionController.isActivated
          ? Navigator.of(context).pushNamed(infoPage, arguments: vpnKey)
          : Navigator.of(context).pushNamed(
              advertisementPage,
              arguments: () => Navigator.of(context).pushNamedAndRemoveUntil(
                infoPage,
                (route) => route.isFirst,
                arguments: vpnKey,
              ),
            ),
      highlightColor: isDarkMode ? Colors.white : Colors.black,
      splashColor: isDarkMode ? Colors.white : Colors.black,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: mapNameToAsset(vpnKey.name),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black,
                      Colors.black,
                    ],
                  ),
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: SizedBox(
                    width: constraints.maxWidth,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          vpnKey.name,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                        Text(
                          vpnKey.date,
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall
                              ?.copyWith(color: Colors.white),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

AssetImage mapNameToAsset(String name) {
  if (name.startsWith('ShadowSocks')) {
    return const AssetImage("assets/images/shadowsocks_image.png");
  } else if (name.startsWith("VMESS")) {
    return const AssetImage("assets/images/vmess_image.png");
  } else if (name.startsWith("TelegramProxy")) {
    return const AssetImage("assets/images/telegram_proxy_image.png");
  } else if (name.substring(name.lastIndexOf(".") + 1).startsWith("dark")) {
    return const AssetImage("assets/images/dark_image.png");
  } else if (name.substring(name.lastIndexOf(".") + 1).startsWith("hc")) {
    return const AssetImage('assets/images/hc_image.png');
  } else if (name.substring(name.lastIndexOf(".") + 1).startsWith("nm")) {
    return const AssetImage('assets/images/nm_image.png');
  } else if (name.substring(name.lastIndexOf(".") + 1).startsWith("npv4")) {
    return const AssetImage("assets/images/npv4_image.png");
  } else if (name.substring(name.lastIndexOf(".") + 1).startsWith("inpv")) {
    return const AssetImage("assets/images/inpv.png");
  } else if (name.substring(name.lastIndexOf(".") + 1).startsWith("ovpn")) {
    return const AssetImage('assets/images/ovpn_image.png');
  } else if (name.substring(name.lastIndexOf(".") + 1).startsWith("txt")) {
    return const AssetImage('assets/images/txt_image.png');
  } else {
    return const AssetImage('assets/images/vta_image.png');
  }
}
