<<<<<<< HEAD
part of 'main_bloc.dart';

mixin ErrorState {
  final String messageToShow = '';
}

abstract class MainBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends MainBlocState {}

class ShowSnackBarState extends MainBlocState {
  final Widget content;
  final bool hideCurrentSnackBar;

  ShowSnackBarState({
    required this.content,
    required this.hideCurrentSnackBar,
  });
}

class NoMoreKeysToLoadState extends MainBlocState {}

abstract class LastVpnListState extends MainBlocState {}

class LastVpnListLoadingState extends LastVpnListState {}

class LastVpnListLoadedState extends LastVpnListState {
  final VpnListEntity vpnList;

  LastVpnListLoadedState({required this.vpnList});
}

class LastVpnListErrorState extends LastVpnListState with ErrorState {
  LastVpnListErrorState({required this.localMessageToShow});

  final String localMessageToShow;

  @override
  String get messageToShow => localMessageToShow;
}

abstract class NextVpnListState extends MainBlocState {}

class NextVpnListLoadingState extends NextVpnListState {}

class NextVpnListLoadedState extends NextVpnListState {
  final VpnListEntity vpnList;

  NextVpnListLoadedState({required this.vpnList});
}

class NextVpnListErrorState extends NextVpnListState with ErrorState {
  final String localMessageToShow;

  NextVpnListErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}

abstract class DownloadVpnKeyState extends MainBlocState {}

class DownloadVpnKeyLoadingState extends DownloadVpnKeyState {}

class DownloadVpnKeyLoadedState extends DownloadVpnKeyState {
  final DownloadFileEntity downloadFile;

  DownloadVpnKeyLoadedState({required this.downloadFile});
}

class DownloadVpnKeyErrorState extends DownloadVpnKeyState with ErrorState {
  final String localMessageToShow;

  DownloadVpnKeyErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}

abstract class LoadAdvertisementState extends MainBlocState {}

class LoadAdvertisementLoadingState extends LoadAdvertisementState {}

class LoadAdvertisementLoadedState extends LoadAdvertisementState {
  final AdvertisementEntity advertisement;

  LoadAdvertisementLoadedState({required this.advertisement});
}

class LoadAdvertisementErrorState extends LoadAdvertisementState
    with ErrorState {
  final String localMessageToShow;

  LoadAdvertisementErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}

abstract class CheckPromocodeState extends MainBlocState {}

class CheckPromocodeLoadingState extends CheckPromocodeState {}

class CheckPromocodeLoadedState extends CheckPromocodeState {
  final bool doesExsist;
  final String promocode;

  CheckPromocodeLoadedState({
    required this.doesExsist,
    required this.promocode,
  });
}

class CheckPromocodeErrorState extends CheckPromocodeState with ErrorState {
  final String localMessageToShow;

  CheckPromocodeErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}

abstract class DeleteDownloadFolderState extends MainBlocState {}

class DeletingDownloadFolderState extends DeleteDownloadFolderState {}

class DeleteDownloadFolderDeletedState extends DeleteDownloadFolderState {}

class DeleteDownloadFolderErrorState extends DeleteDownloadFolderState
    with ErrorState {
  final String localMessageToShow;

  DeleteDownloadFolderErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}
=======
part of 'main_bloc.dart';

mixin ErrorState {
  final String messageToShow = '';
}

abstract class MainBlocState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends MainBlocState {}

class ShowSnackBarState extends MainBlocState {
  final Widget content;
  final bool hideCurrentSnackBar;

  ShowSnackBarState({
    required this.content,
    required this.hideCurrentSnackBar,
  });
}

class NoMoreKeysToLoadState extends MainBlocState {}

abstract class LastVpnListState extends MainBlocState {}

class LastVpnListLoadingState extends LastVpnListState {}

class LastVpnListLoadedState extends LastVpnListState {
  final VpnListEntity vpnList;

  LastVpnListLoadedState({required this.vpnList});
}

class LastVpnListErrorState extends LastVpnListState with ErrorState {
  LastVpnListErrorState({required this.localMessageToShow});

  final String localMessageToShow;

  @override
  String get messageToShow => localMessageToShow;
}

abstract class NextVpnListState extends MainBlocState {}

class NextVpnListLoadingState extends NextVpnListState {}

class NextVpnListLoadedState extends NextVpnListState {
  final VpnListEntity vpnList;

  NextVpnListLoadedState({required this.vpnList});
}

class NextVpnListErrorState extends NextVpnListState with ErrorState {
  final String localMessageToShow;

  NextVpnListErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}

abstract class DownloadVpnKeyState extends MainBlocState {}

class DownloadVpnKeyLoadingState extends DownloadVpnKeyState {}

class DownloadVpnKeyLoadedState extends DownloadVpnKeyState {
  final DownloadFileEntity downloadFile;

  DownloadVpnKeyLoadedState({required this.downloadFile});
}

class DownloadVpnKeyErrorState extends DownloadVpnKeyState with ErrorState {
  final String localMessageToShow;

  DownloadVpnKeyErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}

abstract class LoadAdvertisementState extends MainBlocState {}

class LoadAdvertisementLoadingState extends LoadAdvertisementState {}

class LoadAdvertisementLoadedState extends LoadAdvertisementState {
  final AdvertisementEntity advertisement;

  LoadAdvertisementLoadedState({required this.advertisement});
}

class LoadAdvertisementErrorState extends LoadAdvertisementState
    with ErrorState {
  final String localMessageToShow;

  LoadAdvertisementErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}

abstract class CheckPromoCodeState extends MainBlocState {}

class CheckPromoCodeLoadingState extends CheckPromoCodeState {}

class CheckPromoCodeLoadedState extends CheckPromoCodeState {
  final bool doesExist;
  final String promoCode;

  CheckPromoCodeLoadedState({
    required this.doesExist,
    required this.promoCode,
  });
}

class CheckPromoCodeErrorState extends CheckPromoCodeState with ErrorState {
  final String localMessageToShow;

  CheckPromoCodeErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}

abstract class DeleteDownloadFolderState extends MainBlocState {}

class DeletingDownloadFolderState extends DeleteDownloadFolderState {}

class DeleteDownloadFolderDeletedState extends DeleteDownloadFolderState {}

class DeleteDownloadFolderErrorState extends DeleteDownloadFolderState
    with ErrorState {
  final String localMessageToShow;

  DeleteDownloadFolderErrorState({required this.localMessageToShow});

  @override
  String get messageToShow => localMessageToShow;
}
>>>>>>> 3dd1ed906b04a9df2f5ddf01d804006534dfe65f
