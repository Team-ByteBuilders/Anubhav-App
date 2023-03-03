import 'package:anubhav/utilities/custom_widgets/custom_button.dart';
import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  const DetailsScreen({Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: primaryButton(context,
              onPressed: () {}, label: 'Send notification', processing: false)
          .wrapCenter(),
    );
  }
}
