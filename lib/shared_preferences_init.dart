<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/datasources/datasource.dart';
import 'package:vpn2app/core/plugins/analitycs.dart';
import 'package:vpn2app/core/plugins/texts.dart';

Future<void> sharedPreferencesInit() async {
  var sharedPref = await SharedPreferences.getInstance();
  if (!sharedPref.containsKey(coinsAmount)) {
    sharedPref.setInt(coinsAmount, startingCoins);
  }
  if (!sharedPref.containsKey(usedPromocodesPref)) {
    sharedPref.setString(usedPromocodesPref, '');
  }
  if (!sharedPref.containsKey(savedLanguage)) {
    sharedPref.setString(savedLanguage, Language.english.name);
  }
  if (!sharedPref.containsKey(themeMode)) {
    sharedPref.setString(themeMode, ThemeMode.dark.name);
  }
  if (!sharedPref.containsKey(dataSourceToUse)) {
    sharedPref.setString(dataSourceToUse, DataSourcesEnum.google.name);
  }
  if (!sharedPref.containsKey(subscriptionDate)) {
    sharedPref.setInt(subscriptionDate, 0);
  }
  if (!sharedPref.containsKey(userUuid)) {
    sharedPref.setString(userUuid, const Uuid().v4());
  }
  if (!sharedPref.containsKey(firstOpening)) {
    sharedPref.setBool(firstOpening, false);
    Analytics.useDefaultValues(
      await Analytics.getCountryAndCity(),
      firstAppOpening: 1,
    ).sendToAnalitics();
  }
}
=======
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/datasources/datasource.dart';
import 'package:vpn2app/core/plugins/analytics.dart';
import 'package:vpn2app/core/plugins/texts.dart';

Future<void> sharedPreferencesInit() async {
  var sharedPref = await SharedPreferences.getInstance();
  if (!sharedPref.containsKey(coinsAmount)) {
    sharedPref.setInt(coinsAmount, startingCoins);
  }
  if (!sharedPref.containsKey(usedPromoCodesPref)) {
    sharedPref.setString(usedPromoCodesPref, '');
  }
  if (!sharedPref.containsKey(savedLanguage)) {
    sharedPref.setString(savedLanguage, Language.english.name);
  }
  if (!sharedPref.containsKey(themeMode)) {
    sharedPref.setString(themeMode, ThemeMode.dark.name);
  }
  if (!sharedPref.containsKey(dataSourceToUse)) {
    sharedPref.setString(dataSourceToUse, DataSourcesEnum.google.name);
  }
  if (!sharedPref.containsKey(subscriptionDate)) {
    sharedPref.setInt(subscriptionDate, 0);
  }
  if (!sharedPref.containsKey(userUuid)) {
    sharedPref.setString(userUuid, const Uuid().v4());
  }
  if (!sharedPref.containsKey(firstOpening)) {
    sharedPref.setBool(firstOpening, false);
    Analytics.useDefaultValues(
      await Analytics.getCountryAndCity(),
      firstAppOpening: 1,
    ).sendToAnalytics();
  }
}
>>>>>>> 3dd1ed906b04a9df2f5ddf01d804006534dfe65f
