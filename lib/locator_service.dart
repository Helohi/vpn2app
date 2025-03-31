import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/datasources/datasource.dart';
import 'package:vpn2app/feature/data/datasources/google_drive.dart';
import 'package:vpn2app/feature/data/datasources/yandex_disk.dart';
import 'package:vpn2app/feature/data/repositories/data_source_repository_impl.dart';
import 'package:vpn2app/feature/domain/repositories/data_source_repository.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:vpn2app/feature/domain/usecases/usecases.dart' as usecases;
import 'package:http/http.dart' as http;
import 'package:vpn2app/feature/presentation/bloc/new_version_check_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.allowReassignment = true;

  // Bloc
  sl.registerFactory(() => MainBloc(sl(), sl(), sl(), sl(), sl(), sl()));
  sl.registerLazySingleton(
    () => NewVersionCheckCubit(getLatestAppVersion: sl()),
  );

  // Usecases
  sl.registerFactory(() => usecases.CheckPromoCode(repository: sl()));
  sl.registerFactory(() => usecases.LoadAdvertisements(repository: sl()));
  sl.registerFactory(() => usecases.DownloadVpnKey(repository: sl()));
  sl.registerFactory(() => usecases.GetLastVpnList(repository: sl()));
  sl.registerFactory(() => usecases.GetNextVpnList(repository: sl()));
  sl.registerFactory(() => usecases.GetLatestAppVersion(repository: sl()));
  sl.registerFactory(() => usecases.DeleteDownloadFolder(repository: sl()));

  // Repositories
  sl.registerFactory<DataSourceRepository Function()>(
    () {
      return () => DataSourceRepositoryImpl(dataSource: sl());
    },
  );

  sl.registerFactory<DataSource>(
    () {
      final savedDataSource = DataSourcesEnum.values
          .byName(sl.get<SharedPreferences>().getString(dataSourceToUse)!);
      if (savedDataSource == DataSourcesEnum.yandexManual) {
        return sl.get(instanceName: "yandexManual");
      } else if (savedDataSource == DataSourcesEnum.yandexAuto) {
        return sl.get<YandexDisk>();
      } else {
        return sl.get<GoogleDrive>();
      }
    },
  );

  sl.registerLazySingleton(() => GoogleDrive(client: sl()));
  sl.registerLazySingleton(() => YandexDisk(client: sl(), noTimeout: true));
  sl.registerLazySingleton(
    () => YandexDisk(client: sl(), noTimeout: false),
    instanceName: "yandexManual",
  );

  // Core
  sl.registerLazySingleton<ValueNotifier<ThemeMode>>(
    () => ValueNotifier(
      ThemeMode.values.byName(
        GetIt.I.get<SharedPreferences>().getString(themeMode)!,
      ),
    ),
  );

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  sl.registerLazySingleton<http.Client>(() => http.Client());
}
