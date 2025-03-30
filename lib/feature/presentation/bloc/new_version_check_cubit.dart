import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/feature/domain/usecases/get_latest_app_version.dart'
    as usecases;

class NewVersionCheckCubit extends Cubit<double?> {
  NewVersionCheckCubit({required this.getLatestAppVersion}) : super(null);

  final usecases.GetLatestAppVersion getLatestAppVersion;

  Future<void> checkLatestAppVersion() async {
    final failureOrLatestAppVersion = await getLatestAppVersion();

    failureOrLatestAppVersion.fold(
      (Failure failure) {},
      (double latestVersion) {
        emit(latestVersion);
      },
    );
  }
}
