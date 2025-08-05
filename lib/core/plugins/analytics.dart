import 'dart:convert';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/plugins/texts.dart';

class Analytics {
  static const startingUrl =
      "https://docs.google.com/forms/d/e/1FAIpQLSftc_XMOAOvO53nazxN1hsKdqZ2Xp_JccI9BbGVUEzyXVnMCw/formResponse?&submit=Submit?usp=pp_url";

  Analytics({
    required this.currentLanguage,
    required this.currentTheme,
    required this.currentVersionOfAnApp,
    required this.country,
    required this.city,
    this.firstAppOpening,
    this.openedApp,
    this.timeOfLoadingVpnsAtStart,
    this.loadingMoreVpns,
    this.loadingMoreVpnsTiming,
    this.watchAdvertisement,
    this.clickedOnAdvertisement,
    this.wentToSettingsScreen,
    this.wentToAddCoinsScreen,
    this.clickedOnUpdateButton,
    this.switchedToAnotherLanguage,
    this.clickedOnShareAppButton,
    this.promoCodeUsed,
    this.errorHappened,
  }) {
    initEntriesMap();
    constructUrl();
  }

  final Language currentLanguage;
  final String currentTheme;
  final String currentVersionOfAnApp;
  final String country;
  final String city;
  final int? firstAppOpening;
  final int? openedApp;
  final String? timeOfLoadingVpnsAtStart;
  final int? loadingMoreVpns;
  final String? loadingMoreVpnsTiming;
  final int? watchAdvertisement;
  final int? clickedOnAdvertisement;
  final int? wentToSettingsScreen;
  final int? wentToAddCoinsScreen;
  final int? clickedOnUpdateButton;
  final int? switchedToAnotherLanguage;
  final int? clickedOnShareAppButton;
  final String? promoCodeUsed;
  final String? errorHappened;

  String url = startingUrl;
  final Map<String, dynamic> entriesMap = {};

  static Future<(String, String)> getCountryAndCity() async {
    final sharedPref = GetIt.I.get<SharedPreferences>();
    if (sharedPref.containsKey(countryAndCity)) {
      final countryAndCity_ = sharedPref.getString(countryAndCity)!.split('-');
      return (countryAndCity_[0], countryAndCity_[1]);
    }

    final ans = await get(Uri.parse('http://ip-api.com/json'));
    final ansJs = jsonDecode(ans.body);
    sharedPref.setString(
      countryAndCity,
      '${ansJs['country']}-${ansJs['city'].toString()}',
    );
    return (ansJs['country'].toString(), ansJs['city'].toString());
  }

  factory Analytics.useDefaultValues(
    (String, String) countryAndCity, {
    int? firstAppOpening,
    int? openedApp,
    String? timeOfLoadingVpnsAtStart,
    int? loadingMoreVpns,
    String? loadingMoreVpnsTiming,
    int? watchAdvertisement,
    int? clickedOnAdvertisement,
    int? wentToSettingsScreen,
    int? wentToAddCoinsScreen,
    int? clickedOnUpdateButton,
    int? switchedToAnotherLanguage,
    int? clickedOnShareAppButton,
    String? promoCodeUsed,
    String? errorHappened,
  }) {
    return Analytics(
      currentLanguage: Texts().currentLanguage,
      currentTheme: GetIt.I.get<SharedPreferences>().getString(themeMode)!,
      currentVersionOfAnApp: currentApplicationVersion.toString(),
      country: countryAndCity.$1,
      city: countryAndCity.$2,
      firstAppOpening: firstAppOpening,
      openedApp: openedApp,
      timeOfLoadingVpnsAtStart: timeOfLoadingVpnsAtStart,
      loadingMoreVpns: loadingMoreVpns,
      loadingMoreVpnsTiming: loadingMoreVpnsTiming,
      watchAdvertisement: watchAdvertisement,
      clickedOnAdvertisement: clickedOnAdvertisement,
      wentToSettingsScreen: wentToSettingsScreen,
      wentToAddCoinsScreen: wentToAddCoinsScreen,
      clickedOnUpdateButton: clickedOnUpdateButton,
      switchedToAnotherLanguage: switchedToAnotherLanguage,
      clickedOnShareAppButton: clickedOnShareAppButton,
      promoCodeUsed: promoCodeUsed,
      errorHappened: errorHappened,
    );
  }

  void initEntriesMap() {
    entriesMap['entry.975758321'] = currentLanguage.name;
    entriesMap['entry.297384315'] = currentTheme;
    entriesMap['entry.2097893608'] = currentVersionOfAnApp;
    entriesMap['entry.2034397295'] = country;
    entriesMap['entry.1284741653'] = city;
    if (firstAppOpening != null) {
      entriesMap['entry.1823823037'] = firstAppOpening;
    }
    if (openedApp != null) entriesMap['entry.1600491263'] = openedApp;
    if (timeOfLoadingVpnsAtStart != null) {
      entriesMap['entry.1049804942'] = timeOfLoadingVpnsAtStart;
    }
    if (loadingMoreVpns != null) {
      entriesMap['entry.1834929044'] = loadingMoreVpns;
    }
    if (loadingMoreVpnsTiming != null) {
      entriesMap['entry.2101984494'] = loadingMoreVpnsTiming;
    }
    if (watchAdvertisement != null) {
      entriesMap['entry.10394012'] = watchAdvertisement;
    }
    if (clickedOnAdvertisement != null) {
      entriesMap['entry.1534636318'] = clickedOnAdvertisement;
    }
    if (wentToSettingsScreen != null) {
      entriesMap['entry.44292154'] = wentToSettingsScreen;
    }
    if (wentToAddCoinsScreen != null) {
      entriesMap['entry.467780998'] = wentToAddCoinsScreen;
    }
    if (clickedOnUpdateButton != null) {
      entriesMap['entry.1487188419'] = clickedOnUpdateButton;
    }
    if (switchedToAnotherLanguage != null) {
      entriesMap['entry.1698336018'] = switchedToAnotherLanguage;
    }
    if (clickedOnShareAppButton != null) {
      entriesMap['entry.225315440'] = clickedOnShareAppButton;
    }
    if (promoCodeUsed != null) {
      entriesMap['entry.604522333'] = promoCodeUsed;
    }
    if (errorHappened != null) {
      entriesMap['entry.672479806'] = errorHappened;
    }
  }

  void constructUrl() {
    for (final entryId in entriesMap.keys) {
      url += "&$entryId=${entriesMap[entryId]}";
    }
  }

  void sendToAnalytics() {
    Isolate.run(
      () {
        log("Sending data to $url");
        return get(Uri.parse(url));
      },
    );
  }
}

/// Normal url should look like this https://docs.google.com/forms/d/e/1FAIpQLSftc_XMOAOvO53nazxN1hsKdqZ2Xp_JccI9BbGVUEzyXVnMCw/formResponse?&submit=Submit?usp=pp_url&entry.975758321=eng&entry.297384315=system&entry.1269595829=amount_of_coins&entry.2097893608=current_version_of_an_app&entry.2034397295=country&entry.1284741653=city&entry.1823823037=first_app_opening&entry.1600491263=opened_app&entry.1049804942=time_of_loading_vpns_at_start&entry.1834929044=loading_more_vpns&entry.2101984494=loading_more_vpns_timing&entry.10394012=watch_advertisement&entry.1534636318=clicked_on_advertisement&entry.44292154=went_to_settings_screen&entry.467780998=went_to_add_coins_screen&entry.1487188419=clicked_on_update_button&entry.1698336018=switched_to_another_language&entry.225315440=clicked_on_share_app_button&entry.604522333=promo_code_used&entry.672479806=error_happened
