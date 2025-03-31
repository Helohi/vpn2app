import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vpn2app/core/plugins/texts.dart';
import 'package:vpn2app/feature/domain/entities/vpn_key_entity.dart';
import 'package:vpn2app/feature/presentation/bloc/main_bloc/main_bloc.dart';
import 'package:vpn2app/feature/presentation/widgets/bold_name_and_thin_value.dart';
import 'package:vpn2app/feature/presentation/widgets/interactive_floating_action_button.dart';

class VpnKeyDetailsScreen extends StatefulWidget {
  const VpnKeyDetailsScreen({super.key, required this.vpnKey});

  final VpnKeyEntity vpnKey;

  @override
  State<VpnKeyDetailsScreen> createState() => _VpnKeyDetailsScreenState();
}

class _VpnKeyDetailsScreenState extends State<VpnKeyDetailsScreen> {
  bool isDownloading = false;

  void showFloatingActionButton() {
    setState(() {
      isDownloading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(Texts().textVpnKey()),
        centerTitle: true,
      ),
      body: ScrollDetailsView(
        isDarkMode: isDarkMode,
        vpnKey: widget.vpnKey,
        showFloatingActionButton: showFloatingActionButton,
      ),
      floatingActionButton: InteractiveFloatingActionButton(
        shouldBeDrawn: isDownloading,
        vpnKey: widget.vpnKey,
      ),
    );
  }
}

class ScrollDetailsView extends StatelessWidget {
  const ScrollDetailsView({
    super.key,
    required this.isDarkMode,
    required this.vpnKey,
    required this.showFloatingActionButton,
  });

  final bool isDarkMode;
  final VpnKeyEntity vpnKey;
  final Function showFloatingActionButton;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: isDarkMode ? const Color(0xff1A4D2E) : const Color(0xffF0EBE3),
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BoldNameAndThinValue(
              propertyName: "${Texts().textName()}: ",
              propertyValue: vpnKey.name,
            ),
            const SizedBox(height: 8.0),
            BoldNameAndThinValue(
              propertyName: "${Texts().textChannel()}: ",
              propertyValue: vpnKey.channel,
            ),
            const SizedBox(height: 8.0),
            BoldNameAndThinValue(
              propertyName: "${Texts().textDate()}: ",
              propertyValue: vpnKey.date,
            ),
            const SizedBox(height: 8.0),
            Text(
              "${Texts().textDescription()}:",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12.0),
                color: Theme.of(context)
                    .scaffoldBackgroundColor
                    .withValues(alpha: 0.5),
              ),
              padding: const EdgeInsets.all(8.0),
              child: SelectableText(
                vpnKey.description,
              ),
            ),
            const SizedBox(height: 8.0),
            ElevatedButton.icon(
              onPressed: () {
                BlocProvider.of<MainBloc>(context).add(
                  DownloadVpnKey(
                    vpnKey: vpnKey,
                    timestamp: DateTime.now().microsecondsSinceEpoch.toString(),
                  ),
                );
                showFloatingActionButton();
              },
              label: Text(
                Texts().textDownload(),
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              icon: const Icon(Icons.download),
            )
          ],
        ),
      ),
    );
  }
}
