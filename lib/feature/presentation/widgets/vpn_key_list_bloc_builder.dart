import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:vpn2app/feature/presentation/widgets/widgets.dart';

class VpnKeysListBlocBuilder extends StatelessWidget {
  const VpnKeysListBlocBuilder({super.key, required this.typeOfVpnKey});

  final TypeOfVpnKey typeOfVpnKey;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainBloc, MainBlocState>(
      bloc: BlocProvider.of<MainBloc>(context),
      buildWhen: (previous, current) =>
          current is InitialState ||
          current is LastVpnListState ||
          (current is NextVpnListState &&
              current is! NextVpnListLoadingState &&
              current is! NextVpnListErrorState),
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (InitialState):
            return Center(
              child: Text.rich(
                TextSpan(
                  text: Texts().textToContinueSwipe(),
                  children: const [
                    WidgetSpan(child: Icon(Icons.swipe_down_alt)),
                  ],
                ),
              ),
            );
          case const (LastVpnListLoadingState):
            return const Center(child: CircularProgressIndicator());
          case const (NextVpnListLoadedState):
            state as NextVpnListLoadedState;
            return ListOfVpnKeyCards(
              vpnList: state.vpnList,
              typeOfVpnKey: typeOfVpnKey,
            );
          case const (LastVpnListLoadedState):
            state as LastVpnListLoadedState;
            return ListOfVpnKeyCards(
              vpnList: state.vpnList,
              typeOfVpnKey: typeOfVpnKey,
            );
          case const (LastVpnListErrorState):
            return ListView(
              children: [
                Center(
                  child: Text("Error: ${(state as ErrorState).messageToShow}"),
                )
              ],
            );
          default:
            return Center(
              child: Text("Error: Unhandled State (${state.runtimeType})"),
            );
        }
      },
    );
  }
}
