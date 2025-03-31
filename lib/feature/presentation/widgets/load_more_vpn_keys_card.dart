import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';

class LoadMoreVpnKeysCard extends StatelessWidget {
  const LoadMoreVpnKeysCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: BlocBuilder<MainBloc, MainBlocState>(
          bloc: BlocProvider.of<MainBloc>(context),
          builder: (context, state) {
            switch (state.runtimeType) {
              case const (NextVpnListLoadingState):
                return CircularProgressIndicator(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.9),
                );
              default:
                return IconButton(
                  icon: LayoutBuilder(
                    builder: (context, constraints) => Icon(
                      Icons.add,
                      size: constraints.biggest.height / 2,
                    ),
                  ),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.9),
                  onPressed: () {
                    BlocProvider.of<MainBloc>(context).add(GetNextVpnList());
                  },
                );
            }
          },
        ),
      ),
    );
  }
}
