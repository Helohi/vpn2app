import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/plugins/storage_permission_granter.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/domain/entities/advertisement_entity.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';
import 'package:vpn2app/feature/domain/usecases/check_promo_code.dart';
import 'package:vpn2app/feature/domain/usecases/usecases.dart' as usecases;
import 'package:vpn2app/feature/presentation/bloc/new_version_check_cubit.dart';

part 'main_bloc_states.dart';
part 'main_bloc_events.dart';

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  final usecases.CheckPromoCode checkPromoCode;
  final usecases.DownloadVpnKey downloadVpnKey;
  final usecases.GetLastVpnList getLastVpnList;
  final usecases.GetNextVpnList getNextVpnList;
  final usecases.LoadAdvertisements loadAdvertisement;
  final usecases.DeleteDownloadFolder deleteDownloadFolder;

  MainBloc(
    this.checkPromoCode,
    this.downloadVpnKey,
    this.getLastVpnList,
    this.getNextVpnList,
    this.loadAdvertisement,
    this.deleteDownloadFolder,
  ) : super(InitialState()) {
    on<EmptyEvent>((event, emit) => null);
    on<GetLastVpnList>((event, emit) => _getLastVpnList(event, emit));
    on<GetNextVpnList>((event, emit) => _getNextVpnList(event, emit));
    on<DownloadVpnKey>((event, emit) => _downloadVpnKey(event, emit));
    on<LoadAdvertisement>((event, emit) => _loadAdvertisement(event, emit));
    on<CheckPromoCode>((event, emit) => _checkPromoCode(event, emit));
    on<CheckSubscription>((event, emit) => _checkSubscription(event, emit));
    on<DeleteDownloadFolder>(
        (event, emit) => _deleteDownloadFolder(event, emit));
  }

  _getLastVpnList(GetLastVpnList event, Emitter<MainBlocState> emit) async {
    emit(LastVpnListLoadingState());
    final vpnListOrFailure = await getLastVpnList();

    await GetIt.I.get<NewVersionCheckCubit>().checkLatestAppVersion();

    vpnListOrFailure.fold(
      (Failure failure) => emit(
        LastVpnListErrorState(
          localMessageToShow: _mapFailureToMessage(failure),
        ),
      ),
      (VpnListEntity lastVpnList) {
        if (lastVpnList.data.length < 3) {
          add(GetNextVpnList());
        }
        emit(
          (LastVpnListLoadedState(vpnList: lastVpnList)),
        );
      },
    );
  }

  _getNextVpnList(GetNextVpnList event, Emitter<MainBlocState> emit) async {
    emit(NextVpnListLoadingState());
    final vpnListOrFailure = await getNextVpnList();

    vpnListOrFailure.fold(
      (Failure failure) {
        if (failure is NoMoreKeysToLoadFailure) {
          emit(NoMoreKeysToLoadState());
        } else {
          emit(
            NextVpnListErrorState(
                localMessageToShow: _mapFailureToMessage(failure)),
          );
        }
      },
      (VpnListEntity vpnList) => emit(
        NextVpnListLoadedState(vpnList: vpnList),
      ),
    );
  }

  _downloadVpnKey(DownloadVpnKey event, Emitter<MainBlocState> emit) async {
    if (!(await StoragePermissionGranter.arePermissionsGranted)) {
      emit(
        ShowSnackBarState(
          content: Text(Texts().textAllowExternalStorage()),
          hideCurrentSnackBar: true,
        ),
      );
      StoragePermissionGranter.requestPermissions();
      return;
    }

    emit(DownloadVpnKeyLoadingState());

    final downloadFileOrFailure = await downloadVpnKey(
      usecases.DownloadVpnKeyParams(vpnKey: event.vpnKey),
    );

    downloadFileOrFailure.fold(
      (Failure failure) => emit(
        DownloadVpnKeyErrorState(
            localMessageToShow: _mapFailureToMessage(failure)),
      ),
      (DownloadFileEntity downloadFile) => emit(
        DownloadVpnKeyLoadedState(downloadFile: downloadFile),
      ),
    );
  }

  _loadAdvertisement(
    LoadAdvertisement event,
    Emitter<MainBlocState> emit,
  ) async {
    emit(LoadAdvertisementLoadingState());

    final advertisementOrFailure = await loadAdvertisement();

    advertisementOrFailure.fold(
      (Failure failure) => emit(
        LoadAdvertisementErrorState(
          localMessageToShow: _mapFailureToMessage(failure),
        ),
      ),
      (AdvertisementEntity advertisement) => emit(
        LoadAdvertisementLoadedState(advertisement: advertisement),
      ),
    );
  }

  _checkPromoCode(CheckPromoCode event, Emitter<MainBlocState> emit) async {
    emit(CheckPromoCodeLoadingState());

    final boolOrFailure =
        await checkPromoCode(CheckPromoCodeParams(promoCode: event.promoCode));

    boolOrFailure.fold(
      (Failure failure) => emit(
        CheckPromoCodeErrorState(
            localMessageToShow: _mapFailureToMessage(failure)),
      ),
      (bool doesExist) => emit(CheckPromoCodeLoadedState(
        doesExist: doesExist,
        promoCode: event.promoCode,
      )),
    );
  }

  _checkSubscription(CheckSubscription event, Emitter<MainBlocState> emit) {}

  @override
  void emit(MainBlocState state) {
    log(state.runtimeType.toString());
    // ignore: invalid_use_of_visible_for_testing_member
    super.emit(state);
  }

  @override
  void add(MainBlocEvent event) {
    log(event.runtimeType.toString());
    super.add(event);
  }

  _deleteDownloadFolder(
    DeleteDownloadFolder event,
    Emitter<MainBlocState> emit,
  ) async {
    if (!(await StoragePermissionGranter.arePermissionsGranted)) {
      emit(
        ShowSnackBarState(
          content: Text(Texts().textAllowExternalStorage()),
          hideCurrentSnackBar: true,
        ),
      );
      StoragePermissionGranter.requestPermissions();
      return;
    }

    emit(DeletingDownloadFolderState());

    final voidOrFailure = await deleteDownloadFolder();

    voidOrFailure.fold(
      (Failure failure) => emit(
        DeleteDownloadFolderErrorState(
          localMessageToShow: _mapFailureToMessage(failure),
        ),
      ),
      (void _) => emit(DeleteDownloadFolderDeletedState()),
    );
  }
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case const (FetchingFirstDataFailure):
      return "Could not fetch first data";
    case const (FetchingNextDatasFailure):
      return "Next data fetch went wrong";
    case const (NoMoreKeysToLoadFailure):
      return "No more keys to load left";
    case const (PromoCodeCheckFailure):
      return "Could not check your promo code";
    case const (DownloadVpnKeyFailure):
      return "Downloading failed";
    case const (LoadAdvertisementFailure):
      return "Could not load Advertisement";
    case const (GetLatestAppVersionFailure):
      return "Could not check latest version";
    case const (DeleteDownloadFolderFailure):
      return "Could not delete download folder";
    case const (DownloadFolderNotExist):
      return "Download folder does not exist";
    default:
      log("Uncaught failure: ${failure.runtimeType}");
      return "Unexpected Exception";
  }
}
