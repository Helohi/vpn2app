import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:vpn2app/feature/presentation/bloc/new_version_check_cubit.dart';
import 'package:vpn2app/feature/presentation/widgets/widgets.dart';
import 'package:vpn2app/main.dart';

class VpnKeysListScreen extends StatefulWidget {
  const VpnKeysListScreen({super.key});

  @override
  State<VpnKeysListScreen> createState() => _VpnKeysListScreenState();
}

class _VpnKeysListScreenState extends State<VpnKeysListScreen> {
  int chosenTypeOfKeys = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainBloc, MainBlocState>(
      bloc: BlocProvider.of<MainBloc>(context),
      listenWhen: (previous, current) =>
          current is ShowSnackBarState ||
          current is DownloadVpnKeyLoadedState ||
          current is NoMoreKeysToLoadState,
      listener: (context, state) {
        if (state is ShowSnackBarState) {
          ShowSnackBarWidget.of(context).showSnackBar(
            context,
            state.content,
            hideCurrentSnackBar: state.hideCurrentSnackBar,
          );
        } else if (state is DownloadVpnKeyLoadedState) {
          ShowSnackBarWidget.of(context).showSnackBar(
            context,
            Text(Texts().textFileInDownloads(state.downloadFile.path)),
            hideCurrentSnackBar: true,
          );
        } else if (state is NoMoreKeysToLoadState) {
          ShowSnackBarWidget.of(context).showSnackBar(
            context,
            Text(Texts().textNoMoreKeys()),
            hideCurrentSnackBar: true,
          );
        } else if (state is NextVpnListErrorState) {
          ShowSnackBarWidget.of(context).showSnackBar(
            context,
            Text(state.localMessageToShow),
            hideCurrentSnackBar: true,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(settingsPage);
            },
            icon: Icon(
              Icons.settings_rounded,
              color: Theme.of(context).primaryColor,
            ),
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(profilePage);
              },
              icon: Icon(
                Icons.account_circle_rounded,
                color: Theme.of(context).primaryColor,
              ),
            )
          ],
          title: const Text("Vpn2App"),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                MaterialButton(
                  color: chosenTypeOfKeys == 0
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.grey[800],
                  onPressed: () {
                    setState(() {
                      chosenTypeOfKeys = 0;
                    });
                  },
                  child: Text(
                    "Turkmen keys",
                    style: chosenTypeOfKeys == 0
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                  ),
                ),
                MaterialButton(
                  color: chosenTypeOfKeys == 1
                      ? Theme.of(context).scaffoldBackgroundColor
                      : Colors.grey[800],
                  onPressed: () {
                    setState(() {
                      chosenTypeOfKeys = 1;
                    });
                  },
                  child: Text(
                    "Russian keys",
                    style: chosenTypeOfKeys == 1
                        ? Theme.of(context).textTheme.bodyMedium
                        : Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(color: Colors.white),
                  ),
                ),
              ],
            ),
            BlocBuilder<NewVersionCheckCubit, double?>(
              bloc: BlocProvider.of<NewVersionCheckCubit>(context),
              builder: (context, state) {
                if (state == null || state <= currentApplicationVersion) {
                  return const SizedBox.shrink();
                } else {
                  return NewVersionAvailableSign(latestVersion: state);
                }
              },
            ),
            const SizedBox(height: 10.0),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.sync(
                  () => BlocProvider.of<MainBloc>(context).add(
                    GetLastVpnList(),
                  ),
                ),
                child: VpnKeysListBlocBuilder(
                  typeOfVpnKey: switch (chosenTypeOfKeys) {
                    1 => TypeOfVpnKey.RUSSIAN_VPN,
                    _ => TypeOfVpnKey.TURKMEN_VPN,
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: BlocBuilder<MainBloc, MainBlocState>(
          bloc: BlocProvider.of<MainBloc>(context),
          buildWhen: (previous, current) =>
              current is DeleteDownloadFolderState,
          builder: (context, state) {
            switch (state.runtimeType) {
              case const (DeletingDownloadFolderState):
                return const FloatingActionButton(
                  onPressed: null,
                  child: CircularProgressIndicator(),
                );
              case const (DeleteDownloadFolderDeletedState):
                return FloatingActionButton(
                  onPressed: () {
                    ShowSnackBarWidget.of(context).showSnackBar(
                      context,
                      const Text("Done"),
                      hideCurrentSnackBar: true,
                    );
                  },
                  child: const Icon(Icons.done),
                );
              case const (DeleteDownloadFolderErrorState):
                state as DeleteDownloadFolderErrorState;
                return FloatingActionButton(
                  onPressed: () {
                    ShowSnackBarWidget.of(context).showSnackBar(
                      context,
                      Text(state.messageToShow),
                      hideCurrentSnackBar: true,
                    );
                  },
                  child: const Icon(Icons.error_outline),
                );
              default:
                return FloatingActionButton(
                  onPressed: () {
                    BlocProvider.of<MainBloc>(context)
                        .add(DeleteDownloadFolder());
                  },
                  child: const Icon(Icons.delete),
                );
            }
          },
        ),
      ),
    );
  }
}
