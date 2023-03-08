import 'package:anubhav/navigation/splash_screen.dart';
import 'package:anubhav/service/secure_service.dart';
import 'package:anubhav/utilities/colors.dart';
import 'package:anubhav/utilities/custom_widgets/custom_button.dart';
import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:anubhav/utilities/user_details.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../utilities/custom_widgets/custom_snackbar.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({Key? key}) : super(key: key);

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  GlobalKey<FormState> key = GlobalKey<FormState>();
  String? dob;
  String gender = "None";
  String mobile = "";
  String coordinates = "";
  double lat = 30.411;
  double long = 78.060;
  bool fetching = false;
  bool isProcessing = false;

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
            ).paddingForOnly(bottom: 30, top: 50),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value != null && value.length == 10) {
                  return null;
                } else {
                  return 'Number is not valid';
                }
              },
              onChanged: (value) {
                mobile = value;
              },
              decoration: const InputDecoration(labelText: 'Phone number'),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              key: GlobalKey(),
              readOnly: true,
              initialValue: dob,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Select Date of Birth';
                }
              },
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime((DateTime.now().year - 18)),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2100));
                if (pickedDate != null) {
                  setState(() {
                    dob = DateFormat('dd-MM-yyyy').format(pickedDate);
                  });
                }
              },
              decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: CustomColors.grey, width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(
                          color: CustomColors.primaryOrange, width: 2),
                      borderRadius: BorderRadius.circular(8)),
                  labelText: 'Date of Birth'),
            ).paddingForOnly(bottom: 20),
            DropdownButtonFormField(
                value: gender,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (String? value) {
                  setState(() {
                    gender = value!;
                  });
                },
                validator: (String? value) {
                  if (value == "None") {
                    return 'Enter Gender';
                  }
                  return null;
                },
                items: const [
                  DropdownMenuItem(
                      value: "None",
                      child: Text(
                        "Gender",
                      )),
                  DropdownMenuItem(value: "Male", child: Text("Male")),
                  DropdownMenuItem(value: "Female", child: Text("Female")),
                  DropdownMenuItem(value: "Others", child: Text("Others")),
                ],
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.arrow_drop_down,
                  color: CustomColors.primaryBlue,
                ),
                decoration: const InputDecoration(
                  hintText: "Gender",
                )).paddingForOnly(bottom: 20),
            TextFormField(
              key: GlobalKey(),
              validator: (value) {
                if (value != '') {
                  return null;
                } else {
                  return 'Please fetch location';
                }
              },
              initialValue: coordinates,
              readOnly: true,
              onTap: () => _getCurrentPosition(),
              decoration: InputDecoration(
                  suffixIcon: (fetching)
                      ? const CircularProgressIndicator(
                          color: CustomColors.primaryOrange,
                        ).paddingForAll(8)
                      : const SizedBox(),
                  labelText: 'Location'),
            ).paddingForOnly(bottom: 20),
            primaryButton(context,
                label: 'Submit',
                onPressed: () => buttonPressed(),
                processing: isProcessing)
          ],
        ).paddingWithSymmetry(horizontal: 16, vertical: 50),
      ),
    ).asButton(onTap: () => FocusManager.instance.primaryFocus?.unfocus());
  }

  void buttonPressed() async {
    setState(() {
      isProcessing = true;
    });
    if (key.currentState!.validate()) {
      debugPrint(mobile);
      debugPrint(gender);
      debugPrint(dob);
      debugPrint(coordinates);
      SecureStorage storage = SecureStorage();
      final res = await storage.personalDetails(
          phone: mobile, gender: gender, lat: lat, long: long, dob: dob!);
      if (res!.responseCode == 200) {
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

  Future<void> _getCurrentPosition() async {
    setState(() {
      fetching = true;
    });
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      Position currentPosition = position;
      long = currentPosition.longitude;
      lat = currentPosition.latitude;
      String lo = '${long.abs().toString().substring(0, 6)}° ';
      if (long < 0) {
        lo = '${lo}W';
      } else {
        lo = '${lo}E';
      }
      String la = '${lat.abs().toString().substring(0, 6)}° ';
      if (lat < 0) {
        la = '${la}S';
      } else {
        la = '${la}N';
      }
      setState(() {
        coordinates = '$la, $lo';
        fetching = false;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}
