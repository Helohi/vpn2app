import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn2app/core/constants.dart';
import 'package:vpn2app/core/datasources/datasource.dart';
import 'package:vpn2app/core/plugins/analitycs.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:vpn2app/feature/presentation/widgets/widgets.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    addToAnalytics();
    super.initState();
  }

  void addToAnalytics() async {
    Analytics.useDefaultValues(
      await Analytics.getCountryAndCity(),
      wentToSettingsScreen: 1,
    ).sendToAnalitics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Texts().textSettings()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${Texts().textLanguage()}:',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 8,
              ),
              SegmentedButton<Language>(
                showSelectedIcon: false,
                segments: const [
                  ButtonSegment(
                    value: Language.english,
                    enabled: true,
                    label: Text('🇺🇸 Eng'),
                  ),
                  ButtonSegment(
                    value: Language.russian,
                    enabled: true,
                    label: Text('🇷🇺 Ru'),
                  ),
                  ButtonSegment(
                    value: Language.turkmen,
                    enabled: true,
                    label: Text('🇹🇲 Tm'),
                  )
                ],
                selected: <Language>{Texts().currentLanguage},
                onSelectionChanged: (p0) async {
                  Analytics.useDefaultValues(
                    await Analytics.getCountryAndCity(),
                    switchedToAnotherLanguage: 1,
                  ).sendToAnalitics();

                  Texts().setNewCurrentLanguage(p0.first);
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              Text(
                "${Texts().textTheme()}:",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              SegmentedButton<ThemeMode>(
                segments: const [
                  ButtonSegment(
                    value: ThemeMode.system,
                    label: Text('System'),
                  ),
                  ButtonSegment(
                    value: ThemeMode.light,
                    label: Text("Light"),
                  ),
                  ButtonSegment(
                    value: ThemeMode.dark,
                    label: Text("Dark"),
                  )
                ],
                selected: <ThemeMode>{
                  ThemeMode.values.byName(
                    GetIt.I.get<SharedPreferences>().getString(themeMode)!,
                  )
                },
                onSelectionChanged: (p0) {
                  GetIt.I
                      .get<SharedPreferences>()
                      .setString(themeMode, p0.first.name);

                  GetIt.I.get<ValueNotifier<ThemeMode>>().value =
                      ThemeMode.values.byName(
                    p0.first.name,
                  );
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              Text(
                "${Texts().textServer()}:",
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 16),
              SegmentedButton<DataSourcesEnum>(
                segments: const [
                  ButtonSegment(
                    value: DataSourcesEnum.google,
                    label: Text("Google"),
                  ),
                  ButtonSegment(
                    value: DataSourcesEnum.yandexAuto,
                    enabled: false,
                    label: Text("Yandex Auto"),
                  ),
                  ButtonSegment(
                    value: DataSourcesEnum.yandexManual,
                    enabled: false,
                    label: Text('Yandex Manual'),
                  )
                ],
                selected: {
                  DataSourcesEnum.values.byName(
                    GetIt.I
                        .get<SharedPreferences>()
                        .getString(dataSourceToUse)!,
                  ),
                },
                onSelectionChanged: (p0) {
                  GetIt.I.get<SharedPreferences>().setString(
                        dataSourceToUse,
                        p0.first.name,
                      );
                  BlocProvider.of<MainBloc>(context).add(GetLastVpnList());
                  setState(() {});
                },
              ),
              const SizedBox(height: 16),
              Text(
                Texts().textInfo(),
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${Texts().textCreatedBy()}: ',
                      style: const TextStyle(fontSize: 20),
                    ),
                    const TextSpan(
                      text: 'HeloHi (TM_team)\n',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: Texts().textWithAHelpOfAPG(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: Texts().textThisApplicationIsFree(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  Analytics.useDefaultValues(
                    await Analytics.getCountryAndCity(),
                    clickedOnShareAppButton: 1,
                  ).sendToAnalitics();

                  Share.share(
                    Texts().textShareThisApplication(applicationSite),
                  );
                },
                icon: const Icon(Icons.share),
                label: Text(Texts().textShare()),
              ),
              const SizedBox(height: 16),
              Text(
                '${Texts().textSupportAdvertisement()}:',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const ContactInformation(),
            ],
          ),
        ),
      ),
    );
  }
}
