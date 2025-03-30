import 'dart:io';

import 'package:open_filex/open_filex.dart' as open_file_safe;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn2app/core/plugins/analitycs.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/domain/entities/download_file_entity.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:vpn2app/main.dart';

class InteractiveFloatingActionButton extends StatelessWidget {
  const InteractiveFloatingActionButton({
    super.key,
    required this.shouldBeDrawn,
    required this.vpnKey,
  });

  final bool shouldBeDrawn;
  final VpnKeyEntity vpnKey;

  Future<void> openFile(BuildContext context, String filePath) async {
    try {
      open_file_safe.OpenFilex.open(
        filePath,
        type: filePath.substring(vpnKey.name.lastIndexOf(".") + 1),
      );
      if (context.mounted) {
        ShowSnackBarWidget.of(context).showSnackBar(
          // ignore: use_build_context_synchronously
          context,
          Text(
            ((await open_file_safe.OpenFilex.open(
              filePath,
              type: filePath.substring(vpnKey.name.lastIndexOf(".") + 1),
            ))
                .message),
          ),
          hideCurrentSnackBar: true,
        );
      }
    } catch (e) {
      /// Analytics
      Analytics.useDefaultValues(
        await Analytics.getCountryAndCity(),
        errorHappened: "ErrorWhileOpeningAFile: $e",
      );

      if (context.mounted) {
        ShowSnackBarWidget.of(context).showSnackBar(
          context,
          Text("Error $e"),
          hideCurrentSnackBar: true,
        );
      }
    }
  }

  Widget emptyWidget() {
    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    return shouldBeDrawn
        ? BlocBuilder<MainBloc, MainBlocState>(
            bloc: BlocProvider.of<MainBloc>(context),
            buildWhen: (previous, current) => current is DownloadVpnKeyState,
            builder: (context, state) {
              switch (state.runtimeType) {
                case const (DownloadVpnKeyLoadingState):
                  return FloatingActionButton(
                    onPressed: null,
                    backgroundColor: Colors.white,
                    child: Image.asset('assets/gifs/download.gif'),
                  );
                case const (DownloadVpnKeyLoadedState):
                  state as DownloadVpnKeyLoadedState;
                  return FloatingActionButton(
                    onPressed: () => _doActionAccordingToKey(
                      context,
                      state.downloadFile,
                    ),
                    child: _mapKeyToIcon(),
                  );
                case const (DownloadVpnKeyErrorState):
                  state as DownloadVpnKeyErrorState;

                  return FloatingActionButton(
                    onPressed: () {
                      ShowSnackBarWidget.of(context).showSnackBar(
                        context,
                        Text(state.localMessageToShow),
                      );
                    },
                    child: const Icon(Icons.error_outline),
                  );
                default:
                  return emptyWidget();
              }
            },
          )
        : emptyWidget();
  }

  Icon _mapKeyToIcon() {
    if (vpnKey.name
            .substring(vpnKey.name.lastIndexOf(".") + 1)
            .startsWith("dark") ||
        vpnKey.name
            .substring(vpnKey.name.lastIndexOf(".") + 1)
            .startsWith("txt")) {
      return const Icon(Icons.copy);
    } else {
      return const Icon(Icons.open_in_new);
    }
  }

  Future<void> _doActionAccordingToKey(
    BuildContext context,
    DownloadFileEntity downloadFile,
  ) async {
    if (vpnKey.name
            .substring(vpnKey.name.lastIndexOf(".") + 1)
            .startsWith("dark") ||
        vpnKey.name
            .substring(vpnKey.name.lastIndexOf(".") + 1)
            .startsWith("txt")) {
      await _copyFileDataToClipboard(downloadFile);

      if (context.mounted) {
        ShowSnackBarWidget.of(context).showSnackBar(
          context,
          Text(Texts().textCopiedToClipboard()),
          hideCurrentSnackBar: true,
        );
      }
    } else {
      await openFile(context, downloadFile.path);
    }
  }

  Future<void> _copyFileDataToClipboard(DownloadFileEntity downloadFile) async {
    final data = await File(downloadFile.path).readAsString();
    await Clipboard.setData(ClipboardData(text: data));
  }
}
