import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utilities/colors.dart';
import '../utilities/custom_widgets/custom_button.dart';

class StatusScreen extends StatefulWidget {
  const StatusScreen({Key? key}) : super(key: key);

  @override
  State<StatusScreen> createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isProcessing = false;
  double rating = 0.0;
  String bp = "";
  String sugar = "";
  String heart = "";
  String spo2 = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'Daily Status',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryBlue),
            ).paddingForOnly(bottom: 10, top: 50),
            Text(
              'On a scale of 1 to 10, how are you feeling today?',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 15, color: CustomColors.primaryBlue),
            ).paddingForOnly(bottom: 10),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              keyboardType: TextInputType.number,
              validator: (value) {
                double? num = double.tryParse(value!);
                if (num != null) {
                  if (num.floorToDouble() == num) {
                    if(num > 0 && num < 10) {
                      return null;
                    } else {
                      return 'Value must be between 1 and 10';
                    }
                  } else {
                    return 'Value can\'t be in decimals';
                  }
                } else {
                  return 'Invalid Value';
                }
              },
              onChanged: (value) {
                double? num = double.tryParse(value);
                if (num != null) {
                  rating = num;
                }
              },
            ).paddingForOnly(bottom: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                bp = value;
              },
              decoration: const InputDecoration(labelText: 'Blood Pressure Reading'),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                sugar = value;
              },
              decoration: const InputDecoration(labelText: 'Glucometer Reading'),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                heart = value;
              },
              decoration: const InputDecoration(labelText: 'Heart Rate'),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              onChanged: (value) {
                spo2 = value;
              },
              decoration: const InputDecoration(labelText: 'SPO2 Level'),
            ).paddingForOnly(bottom: 20),
            primaryButton(context,
                label: 'Login',
                // onPressed: () => ,
                onPressed: () => onPressed(),
                processing: isProcessing)
          ],
        ).paddingWithSymmetry(horizontal: 16, vertical: 50),
      ),
    ).asButton(onTap: () => FocusManager.instance.primaryFocus?.unfocus());
  }

  void onPressed() async {
    setState(() {
      isProcessing = true;
    });
    if(key.currentState!.validate()) {
      print(rating);
      print(bp);
      print(sugar);
      print(heart);
      print(spo2);
    }
    setState(() {
      isProcessing = false;
    });
  }
}
