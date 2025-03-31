<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/plugins/analitycs.dart';
import 'package:vpn2app/core/plugins/texts.dart';

class NewVersionAvailableSign extends StatelessWidget {
  const NewVersionAvailableSign({super.key, required this.latestVersion});

  final double latestVersion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(
          Texts().textApplicationUpdate(
            currentApplicationVersion.toString(),
            latestVersion.toString(),
          ),
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.black),
        ),
        trailing: IconButton(
          onPressed: () async {
            Analytics.useDefaultValues(
              await Analytics.getCountryAndCity(),
              clickedOnUpdateButton: 1,
            ).sendToAnalitics();

            launchUrl(
              Uri.parse(applicationSite),
            );
          },
          icon: Image.asset(
            'assets/gifs/update.gif',
            scale: 10,
          ),
        ),
      ),
    );
  }
}
=======
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/plugins/analytics.dart';
import 'package:vpn2app/core/plugins/texts.dart';

class NewVersionAvailableSign extends StatelessWidget {
  const NewVersionAvailableSign({super.key, required this.latestVersion});

  final double latestVersion;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text(
          Texts().textApplicationUpdate(
            currentApplicationVersion.toString(),
            latestVersion.toString(),
          ),
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: Colors.black),
        ),
        trailing: IconButton(
          onPressed: () async {
            Analytics.useDefaultValues(
              await Analytics.getCountryAndCity(),
              clickedOnUpdateButton: 1,
            ).sendToAnalytics();

            launchUrl(
              Uri.parse(applicationSite),
            );
          },
          icon: Image.asset(
            'assets/gifs/update.gif',
            scale: 10,
          ),
        ),
      ),
    );
  }
}
>>>>>>> 3dd1ed906b04a9df2f5ddf01d804006534dfe65f
