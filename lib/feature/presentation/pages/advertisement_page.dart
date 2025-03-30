import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/plugins/analitycs.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:vpn2app/feature/presentation/widgets/widgets.dart';

class AdvertisementPage extends StatefulWidget {
  const AdvertisementPage({
    super.key,
    required this.afterPressingContinueButton,
  });

  final Function afterPressingContinueButton;

  @override
  State<AdvertisementPage> createState() => _AdvertisementPageState();
}

class _AdvertisementPageState extends State<AdvertisementPage>
    with TickerProviderStateMixin {
  bool showContinueButton = false;
  late AnimationController animationController;
  late OverlayPortalController overlayPortalController;
  int? indexOfImageForAdvertisement;

  @override
  void initState() {
    BlocProvider.of<MainBloc>(context).add(LoadAdvertisement());
    animationController = AnimationController(
      vsync: this,
      duration: durationOfAdvertisement,
    )
      ..addListener(
        () => setState(() {
          showContinueButton = animationController.isCompleted;
        }),
      )
      ..forward();

    addToAnalytics();

    overlayPortalController = OverlayPortalController();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: BlocBuilder<MainBloc, MainBlocState>(
                  bloc: BlocProvider.of<MainBloc>(context),
                  buildWhen: (previous, current) =>
                      current is LoadAdvertisementState,
                  builder: (context, state) {
                    switch (state.runtimeType) {
                      case LoadAdvertisementLoadingState:
                        return Center(
                          child:
                              Text(Texts().textYourAdvertisementCouldBeHere()),
                        );
                      case LoadAdvertisementLoadedState:
                        state as LoadAdvertisementLoadedState;
                        if (indexOfImageForAdvertisement == null ||
                            indexOfImageForAdvertisement! >
                                state.advertisement.images.length - 1) {
                          indexOfImageForAdvertisement = Random()
                              .nextInt(state.advertisement.images.length);
                        }
                        return GestureDetector(
                          onTap: () async {
                            Analytics.useDefaultValues(
                              await Analytics.getCountryAndCity(),
                              clickedOnAdvertisement: 1,
                            ).sendToAnalitics();

                            launchUrlString(state.advertisement.url);
                          },
                          child: Image.network(
                            state.advertisement
                                .images[indexOfImageForAdvertisement!],
                            fit: BoxFit.contain,
                            width: MediaQuery.of(context).size.width,
                          ),
                        );
                      case LoadAdvertisementErrorState:
                        state as LoadAdvertisementErrorState;
                        return Center(
                          child: Text(state.messageToShow),
                        );
                      default:
                        return Center(
                          child: Text("Unhandled state ${state.runtimeType}"),
                        );
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: LinearProgressIndicator(
                  value: animationController.value,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: showContinueButton
            ? FloatingActionButton(
                onPressed: () => widget.afterPressingContinueButton(),
                child: const Icon(Icons.arrow_forward),
              )
            : FloatingActionButton(
                onPressed: () => overlayPortalController.show(),
                child: OverlayPortal(
                  controller: overlayPortalController,
                  overlayChildBuilder: (context) => Stack(
                    children: [
                      BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                        child: const SizedBox.expand(),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(12.0)),
                          ),
                          padding: const EdgeInsets.all(16.0),
                          child: IntrinsicWidth(
                            child: IntrinsicHeight(
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: IconButton(
                                      onPressed: () =>
                                          overlayPortalController.hide(),
                                      icon: const Icon(
                                        CupertinoIcons.multiply_circle,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    Texts().textNoAds(),
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 10.0),
                                  const ContactInformation(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  child: const Icon(CupertinoIcons.multiply),
                ),
              ) // Add no add option,
        );
  }

  void addToAnalytics() async {
    Analytics.useDefaultValues(
      await Analytics.getCountryAndCity(),
      watchAdvertisement: 1,
    ).sendToAnalitics();
  }
}
