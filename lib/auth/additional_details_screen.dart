import 'package:anubhav/service/secure_service.dart';
import 'package:anubhav/utilities/colors.dart';
import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../navigation/splash_screen.dart';
import '../utilities/custom_widgets/custom_button.dart';
import '../utilities/custom_widgets/custom_snackbar.dart';

class AdditionalDetailsScreen extends StatefulWidget {
  const AdditionalDetailsScreen({Key? key}) : super(key: key);

  @override
  State<AdditionalDetailsScreen> createState() =>
      _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState extends State<AdditionalDetailsScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  bool isVisible = true;
  bool isProcessing = false;
  String altMobile = "";
  String bldGrp = "unknown";
  bool bp = false;
  bool sugar = false;
  bool heart = false;
  bool pulse = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: key,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'Additional Details',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryBlue),
            ).paddingForOnly(bottom: 10, top: 50),
            Text(
              'Enter some additional details that help us understand you better',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 15, color: CustomColors.primaryBlue),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value?.length == 10) {
                  return null;
                } else {
                  return 'Enter a valid number';
                }
              },
              onChanged: (value) {
                altMobile = value;
              },
              decoration:
                  const InputDecoration(labelText: 'Alternate mobile number'),
            ).paddingForOnly(bottom: 20),
            DropdownButtonFormField(
                value: bldGrp,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (String? value) {
                  setState(() {
                    bldGrp = value!;
                  });
                },
                menuMaxHeight: 150,
                validator: (String? value) {
                  if (value == "None") {
                    return 'Select Blood group';
                  }
                  return null;
                },
                items: const [
                  DropdownMenuItem(
                      value: "unknown",
                      child: Text(
                        "Select Blood Group",
                      )),
                  DropdownMenuItem(value: "A +ve", child: Text("A +ve")),
                  DropdownMenuItem(value: "A -ve", child: Text("A -ve")),
                  DropdownMenuItem(value: "B +ve", child: Text("B +ve")),
                  DropdownMenuItem(value: "B -ve", child: Text("B -ve")),
                  DropdownMenuItem(value: "AB +ve", child: Text("AB +ve")),
                  DropdownMenuItem(value: "AB -ve", child: Text("AB -ve")),
                  DropdownMenuItem(value: "O +ve", child: Text("O +ve")),
                  DropdownMenuItem(value: "O -ve", child: Text("O -ve"))
                ],
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: CustomColors.primaryBlue,
                ),
                decoration: const InputDecoration(
                  hintText: "Gender",
                )).paddingForOnly(bottom: 20),
            Text(
              'Select all those that you have available at home',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 15, color: CustomColors.primaryBlue),
            ),
            CheckboxListTile(
              value: bp,
              onChanged: (value) {
                setState(() {
                  bp = value!;
                });
              },
              title: Text('Blood Pressure machine'),
            ),
            CheckboxListTile(
              value: sugar,
              onChanged: (value) {
                setState(() {
                  sugar = value!;
                });
              },
              title: Text('Glucometer'),
            ),
            CheckboxListTile(
              value: heart,
              onChanged: (value) {
                setState(() {
                  heart = value!;
                });
              },
              title: Text('Heart Rate Monitor'),
            ),
            CheckboxListTile(
              value: pulse,
              onChanged: (value) {
                setState(() {
                  pulse = value!;
                });
              },
              title: Text('Pulse Oximeter'),
            ),
            primaryButton(context,
                    label: 'Submit',
                    // onPressed: () => ,
                    onPressed: () => buttonPressed(),
                    processing: isProcessing)
                .paddingForOnly(top: 10)
          ],
        ).paddingWithSymmetry(horizontal: 16, vertical: 50),
      ),
    ).asButton(onTap: () => FocusManager.instance.primaryFocus?.unfocus());
  }

  void changeVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  Future<void> buttonPressed() async {
    setState(() {
      isProcessing = true;
    });
    if (key.currentState!.validate()) {
      print(bldGrp);
      print(altMobile);
      print(bp);
      print(sugar);
      print(heart);
      print(pulse);
      SecureStorage storage = SecureStorage();
      final response = await storage.additionalDetails(
          altMobile: altMobile,
          bldGrp: bldGrp,
          bp: bp,
          sugar: sugar,
          heart: heart,
          pulse: pulse);
      if (response!.responseCode == 200) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => SplashScreen()),
            (route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(awesomeBar(
            contentType: 'failure',
            title: 'Error',
            message: 'An error occured'));
      }
    }
    setState(() {
      isProcessing = false;
    });
  }
}
