import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vpn2app/core/plugins/analytics.dart';
import 'package:vpn2app/core/routes.dart';
import 'package:vpn2app/core/theme.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:vpn2app/feature/presentation/bloc/new_version_check_cubit.dart';
import 'package:vpn2app/locator_service.dart' as di;
import 'package:vpn2app/shared_preferences_init.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Setting up Dependency Inversion/GetIt
  await di.init();

  /// Configuring SharedPreferences
  await sharedPreferencesInit();

  Analytics.useDefaultValues(
    await Analytics.getCountryAndCity(),
    openedApp: 1,
  ).sendToAnalytics();

  runApp(
    const ShowSnackBarWidget(child: MyApp()),
  );
}

class ShowSnackBarWidget extends InheritedWidget {
  const ShowSnackBarWidget({super.key, required super.child});

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  void showSnackBar(BuildContext context, Widget content,
      {bool? hideCurrentSnackBar}) {
    if (hideCurrentSnackBar ?? false) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: content));
  }

  static ShowSnackBarWidget of(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ShowSnackBarWidget>()!;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: GetIt.I<ValueNotifier<ThemeMode>>(),
      builder: (context, mode, child) => MultiBlocProvider(
        providers: [
          BlocProvider<MainBloc>(
            create: (context) => di.sl()..add(GetLastVpnList()),
          ),
          BlocProvider<NewVersionCheckCubit>(
            create: (context) => di.sl(),
          )
        ],
        child: MaterialApp(
          themeMode: mode,
          theme: Themes.light(),
          darkTheme: Themes.dark(),
          onGenerateRoute: Routes().call,
        ),
      ),
    );
  }
}
