import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:vpn2app/feature/presentation/bloc/new_version_check_cubit.dart';
import 'package:vpn2app/feature/presentation/widgets/widgets.dart';
import 'package:vpn2app/main.dart';

class VpnKeysListScreen extends StatelessWidget {
  const VpnKeysListScreen({super.key});

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
                child: const VpnKeysListBlocBuilder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
