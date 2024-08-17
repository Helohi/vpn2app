import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/plugins/subscription_controller.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart'
    as bloc;
import 'package:vpn2app/feature/presentation/widgets/contact_information.dart';
import 'package:vpn2app/main.dart';

class ProfileInfo extends StatefulWidget {
  const ProfileInfo({super.key});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  late DateTime subscriptionDate_;
  late final TextEditingController promocodeTextController;

  @override
  void initState() {
    promocodeTextController = TextEditingController();
    updateSubscriptionDate();

    super.initState();
  }

  void updateSubscriptionDate() {
    subscriptionDate_ = DateTime.fromMillisecondsSinceEpoch(
      GetIt.I.get<SharedPreferences>().getInt(subscriptionDate) ?? 0,
    );
  }

  @override
  void dispose() {
    promocodeTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<bloc.MainBloc, bloc.MainBlocState>(
      listenWhen: (previous, current) =>
          current is bloc.CheckPromocodeLoadedState ||
          current is bloc.CheckPromocodeErrorState,
      listener: (context, state) {
        if (state is bloc.CheckPromocodeLoadedState) {
          if (state.doesExsist) {
            String usedPromocodes =
                "${GetIt.I.get<SharedPreferences>().getString(usedPromocodesPref)!}${state.promocode}";
            GetIt.I
                .get<SharedPreferences>()
                .setString(usedPromocodesPref, usedPromocodes);

            final newDate = SubscriptionController.getEndDateFromPromocode(
                  state.promocode,
                ) ??
                DateTime.fromMillisecondsSinceEpoch(0);

            if (SubscriptionController
                .isNewDateBiggerThanCurrentSubscriptionDate(newDate)) {
              setState(() {
                SubscriptionController.changeSubscriptionDate(newDate);
                updateSubscriptionDate();
              });
            } else {
              ShowSnackBarWidget.of(context).showSnackBar(
                context,
                const Text("Your current subscription is longer than new one"),
              );
            }
          } else {
            ShowSnackBarWidget.of(context).showSnackBar(
              context,
              Text(Texts().textNoSuchPromocode()),
              hideCurrentSnackBar: true,
            );
          }
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(Texts().textProfile()),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SubscriptionController.isActivated
                    ? Text(
                        Texts().textSubscribed().toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.green[800]),
                      )
                    : Text(
                        Texts().textNotSubscribed().toUpperCase(),
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge
                            ?.copyWith(color: Colors.red[900]),
                      ),
              ),
              const SizedBox(height: 18.0),
              if (SubscriptionController.isActivated)
                Text(
                  Texts().textActivatedTill(subscriptionDate_),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              const SizedBox(height: 18.0),
              ElevatedButton(
                onPressed: onSubscriptionCheck,
                child: Text(Texts().textCheckSubscription()),
              ),
              const SizedBox(height: 18.0),
              TextFormField(
                controller: promocodeTextController,
                onFieldSubmitted: onPromocodeSubmit,
                onEditingComplete: () =>
                    onPromocodeSubmit(promocodeTextController.value.text),
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  label: Text(Texts().textPromocode()),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () =>
                        onPromocodeSubmit(promocodeTextController.value.text),
                  ),
                ),
              ),
              const SizedBox(height: 18.0),
              const UserIdWidget(),
              const SizedBox(height: 18.0),
              Text(
                "${Texts().textSupportAdvertisement()}:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const ContactInformation(),
            ],
          ),
        ),
      ),
    );
  }

  void onSubscriptionCheck() {
    // TODO: Implement later
    setState(() {
      updateSubscriptionDate();
      ShowSnackBarWidget.of(context).showSnackBar(
        context,
        Text(Texts().textUpdated()),
      );
    });
  }

  void onPromocodeSubmit(String promocode) {
    final promocodeValidation =
        SubscriptionController.isPromocodeValid(promocode);

    if (promocodeValidation.$1) {
      BlocProvider.of<bloc.MainBloc>(context).add(
        bloc.CheckPromocode(promocode),
      );
    } else {
      ShowSnackBarWidget.of(context).showSnackBar(
        context,
        Text(promocodeValidation.$2),
        hideCurrentSnackBar: true,
      );
    }
  }
}

class UserIdWidget extends StatelessWidget {
  const UserIdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.brown,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "User ID:",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              IconButton(
                onPressed: () async => Clipboard.setData(
                  ClipboardData(text: SubscriptionController.getUuid()),
                ).whenComplete(
                  () => ShowSnackBarWidget.of(context).showSnackBar(
                    context,
                    Text(Texts().textCopiedToClipboard()),
                    hideCurrentSnackBar: true,
                  ),
                ),
                icon: Icon(
                  Icons.copy,
                  size: 30,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          Text(SubscriptionController.getUuid()),
        ],
      ),
    );
  }
}
