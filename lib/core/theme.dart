import 'package:flutter/material.dart';

class Themes {
  static const TextStyle labelMedium = TextStyle(
    color: Colors.white,
    fontWeight: FontWeight.bold,
  );

  static const appBarLabelSize = 24.0;

  static const pageTransitionsTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
    },
  );

  static TextStyle bodyLarge(ThemeMode mode) => TextStyle(
        color: mode == ThemeMode.light
            ? ThemeData.light().textTheme.bodyLarge?.color
            : ThemeData.dark().textTheme.bodyLarge?.color,
        fontSize: 20,
      );

  static TextStyle bodyMedium(ThemeMode mode) => TextStyle(
        color: mode == ThemeMode.light
            ? ThemeData.light().textTheme.bodyMedium?.color
            : ThemeData.dark().textTheme.bodyLarge?.color,
        fontSize: 16,
      );

  static ThemeData light() => ThemeData.light().copyWith(
        textTheme: ThemeData.light().textTheme.copyWith(
              labelMedium: labelMedium,
              bodyLarge: bodyLarge(ThemeMode.light),
              bodyMedium: bodyMedium(ThemeMode.light),
            ),
        pageTransitionsTheme: pageTransitionsTheme,
        progressIndicatorTheme: const ProgressIndicatorThemeData().copyWith(
          color: Colors.black,
        ),
        scaffoldBackgroundColor: const Color(0xffB5C18E),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: const Color(0xffB5C18E),
          titleTextStyle: const TextStyle(
            fontSize: appBarLabelSize,
            color: Colors.black,
          ),
        ),
        primaryColor: Colors.black,
      );

  static ThemeData dark() => ThemeData.dark().copyWith(
        textTheme: ThemeData.dark().textTheme.copyWith(
              labelMedium: labelMedium,
              bodyLarge: bodyLarge(ThemeMode.dark),
              bodyMedium: bodyMedium(ThemeMode.dark),
            ),
        pageTransitionsTheme: pageTransitionsTheme,
        progressIndicatorTheme: const ProgressIndicatorThemeData().copyWith(
          color: Colors.white,
        ),
        scaffoldBackgroundColor: const Color(0xff040D12),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: const Color(0xff040D12),
          titleTextStyle: const TextStyle(
            fontSize: appBarLabelSize,
          ),
        ),
        primaryColor: Colors.white,
      );
}
