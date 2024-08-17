import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vpn2app/core/error/failure.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/domain/entities/advertisement_entity.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_list_entity.dart';
import 'package:vpn2app/feature/domain/usecases/check_promocode.dart';
import 'package:vpn2app/feature/domain/usecases/usecases.dart' as usecases;
import 'package:vpn2app/feature/presentation/bloc/new_version_check_cubit.dart';

part 'main_bloc_states.dart';
part 'main_bloc_events.dart';

class MainBloc extends Bloc<MainBlocEvent, MainBlocState> {
  final usecases.CheckPromocode checkPromocode;
  final usecases.DownloadVpnKey downloadVpnKey;
  final usecases.GetLastVpnList getLastVpnList;
  final usecases.GetNextVpnList getNextVpnList;
  final usecases.LoadAdvertisements loadAdvertisement;

  MainBloc(
    this.checkPromocode,
    this.downloadVpnKey,
    this.getLastVpnList,
    this.getNextVpnList,
    this.loadAdvertisement,
  ) : super(InitialState()) {
    on<EmptyEvent>((event, emit) => null);
    on<GetLastVpnList>((event, emit) => _getLastVpnList(event, emit));
    on<GetNextVpnList>((event, emit) => _getNextVpnList(event, emit));
    on<DownloadVpnKey>((event, emit) => _downloadVpnKey(event, emit));
    on<LoadAdvertisement>((event, emit) => _loadAdvertisement(event, emit));
    on<CheckPromocode>((event, emit) => _checkPromocode(event, emit));
    on<CheckSubscription>((event, emit) => _checkSubscription(event, emit));
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
    if (!(await Permission.manageExternalStorage.isGranted) &&
        !(await Permission.storage.isGranted)) {
      emit(
        ShowSnackBarState(
          content: Text(Texts().textAllowExternalStorage()),
          hideCurrentSnackBar: true,
        ),
      );
      await Permission.manageExternalStorage.request();
      await Permission.storage.request();
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

  _checkPromocode(CheckPromocode event, Emitter<MainBlocState> emit) async {
    emit(CheckPromocodeLoadingState());

    final boolOrFailure =
        await checkPromocode(CheckPromocodeParams(promocode: event.promocode));

    boolOrFailure.fold(
      (Failure failure) => emit(
        CheckPromocodeErrorState(
            localMessageToShow: _mapFailureToMessage(failure)),
      ),
      (bool doesExsist) => emit(CheckPromocodeLoadedState(
        doesExsist: doesExsist,
        promocode: event.promocode,
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
}

String _mapFailureToMessage(Failure failure) {
  switch (failure.runtimeType) {
    case FetchingFirstDataFailure:
      return "Could not fetch first data";
    case FetchingNextDatasFailure:
      return "Next data fetch went wrong";
    case NoMoreKeysToLoadFailure:
      return "No more keys to load left";
    case PromocodeCheckFailure:
      return "Could not check your promocode";
    case DownloadVpnKeyFailure:
      return "Downloading failed";
    case LoadAdvertisementFailure:
      return "Could not load Advertisement";
    case GetLatestAppVersionFailure:
      return "Could not check latest version";
    default:
      log("Uncought failure: ${failure.runtimeType}");
      return "Unexpected Exception";
  }
}
