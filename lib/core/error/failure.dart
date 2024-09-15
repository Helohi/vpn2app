import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchingFirstDataFailure extends Failure {}

class FetchingNextDatasFailure extends Failure {}

class NoMoreKeysToLoadFailure extends Failure {}

class PromocodeCheckFailure extends Failure {}

class DownloadVpnKeyFailure extends Failure {}

class LoadAdvertisementFailure extends Failure {}

class GetLatestAppVersionFailure extends Failure {}

class DeleteDownloadFolderFailure extends Failure {}

class DownloadFolderNotExist extends Failure {}
