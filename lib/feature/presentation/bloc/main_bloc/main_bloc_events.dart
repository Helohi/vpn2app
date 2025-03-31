part of "main_bloc.dart";

abstract class MainBlocEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmptyEvent extends MainBlocEvent {}

class GetLastVpnList extends MainBlocEvent {}

class GetNextVpnList extends MainBlocEvent {}

class DownloadVpnKey extends MainBlocEvent {
  final VpnKeyEntity vpnKey;
  final String timestamp;

  DownloadVpnKey({required this.vpnKey, required this.timestamp});
}

class LoadAdvertisement extends MainBlocEvent {}

class CheckPromoCode extends MainBlocEvent {
  final String promoCode;

  CheckPromoCode(this.promoCode);
}

class CheckSubscription extends MainBlocEvent {
  final String userId;

  CheckSubscription(this.userId);
}

class DeleteDownloadFolder extends MainBlocEvent {}
