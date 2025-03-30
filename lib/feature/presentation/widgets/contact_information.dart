import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactInformation extends StatelessWidget {
  const ContactInformation({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse('https://linkm.me/users/helohi'));
            },
            child: const Text('Link'),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse('https://tmstart.me/helohi'));
            },
            child: const Text('Start'),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              launchUrl(Uri.parse('https://t.me/he11ohi'));
            },
            child: const Text('Telegram'),
          ),
        ),
      ],
    );
  }
}
