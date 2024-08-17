import 'package:flutter/material.dart';

class BoldNameAndThinValue extends StatelessWidget {
  const BoldNameAndThinValue({
    super.key,
    required this.propertyName,
    required this.propertyValue,
  });

  final String propertyName;
  final String propertyValue;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: propertyName,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text: propertyValue,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
