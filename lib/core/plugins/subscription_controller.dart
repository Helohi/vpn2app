import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/plugins/texts.dart';

class SubscriptionController {
  static bool get isActivated {
    final savedTimestamp = SubscriptionController.getSubscriptionTimestamp();

    if (savedTimestamp > DateTime.now().millisecondsSinceEpoch) {
      return true;
    }
    return false;
  }

  static bool isNewDateBiggerThanCurrentSubscriptionDate(DateTime newDate) {
    if (SubscriptionController.getSubscriptionTimestamp() >
        newDate.millisecondsSinceEpoch) {
      return false;
    }
    return true;
  }

  static void changeSubscriptionDate(DateTime newDate) {
    GetIt.I
        .get<SharedPreferences>()
        .setInt(subscriptionDate, newDate.millisecondsSinceEpoch);
  }

  static int getSubscriptionTimestamp() {
    return GetIt.I.get<SharedPreferences>().getInt(subscriptionDate) ?? 0;
  }

  static String getUuid() {
    return GetIt.I.get<SharedPreferences>().getString(userUuid) ??
        "Error with user id. Please contact developer";
  }

  static int getUuidNumbersSum() {
    var sum = 0;
    final uuid = SubscriptionController.getUuid();
    for (final letter in uuid.characters) {
      if (int.tryParse(letter) != null) {
        sum += int.parse(letter);
      }
    }
    return sum;
  }

  static DateTime? getEndDateFromPromocode(String promocode) {
    final allMatches = RegExp(r"(?=.)\d+").allMatches(promocode).toList();
    final lastMatch = allMatches.last[0];
    final additionDaysOrTimeStamp = int.tryParse(lastMatch ?? "");
    if (additionDaysOrTimeStamp == null) {
      return null;
    }
    if (additionDaysOrTimeStamp < 1000000) {
      return DateTime.now().add(Duration(days: additionDaysOrTimeStamp));
    } else {
      return DateTime.fromMillisecondsSinceEpoch(additionDaysOrTimeStamp);
    }
  }

  static (bool, String) isPromocodeValid(String promocode) {
    if (GetIt.I
        .get<SharedPreferences>()
        .getString(usedPromocodesPref)!
        .contains(promocode)) {
      return (false, Texts().textAlreadyWasUsed());
    } else if (promocode.contains("#") &&
        RegExp(r"\d+(?=#)").hasMatch(promocode)) {
      final sumOfAllNumbersInUuid =
          int.tryParse(RegExp(r"\d+(?=#)").firstMatch(promocode)![0] ?? "");
      if (SubscriptionController.getUuidNumbersSum() != sumOfAllNumbersInUuid) {
        return (false, Texts().textThisisNotYourPromocode());
      }
    }
    return (true, "OK");
  }
}
