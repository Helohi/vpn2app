import 'package:flutter/material.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/presentation/pages/advertisement_page.dart';
import 'package:vpn2app/feature/presentation/pages/pages.dart';
import 'package:vpn2app/feature/presentation/pages/profile_info.dart';

class Routes {
  Route<MaterialPageRoute>? call(RouteSettings settings) {
    switch (settings.name) {
      case homePage:
        return MaterialPageRoute(
          builder: (context) => const VpnKeysListScreen(),
        );
      case infoPage:
        final vpnKey = settings.arguments as VpnKeyEntity;
        return MaterialPageRoute(
          builder: (context) => VpnKeyDetailsScreen(
            vpnKey: vpnKey,
          ),
        );
      case settingsPage:
        return MaterialPageRoute(
          builder: (context) => const SettingsScreen(),
        );
      case advertisementPage:
        return MaterialPageRoute(
          builder: (context) => AdvertisementPage(
            afterPressingContinueButton: settings.arguments as Function,
          ),
        );
      case profilePage:
        return MaterialPageRoute(
          builder: (context) => const ProfileInfo(),
        );
      default:
        throw Exception('No such route: ${settings.name}');
    }
  }
}
