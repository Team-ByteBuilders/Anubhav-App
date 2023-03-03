import 'package:anubhav/utilities/colors.dart';
import 'package:anubhav/utilities/custom_widgets/custom_button.dart';
import 'package:anubhav/utilities/custom_widgets/custom_snackbar.dart';
import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String name = "";
  String email = "";
  String password = "";
  String confirmPassword = "";
  bool isVisible = true;
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Form(
        key: key,
        child: ListView(
          children: [
            Text(
              'Create your Account',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryBlue),
            ).paddingForOnly(bottom: 10, top: 50),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Already have an account? ',
                  style: GoogleFonts.sourceSansPro(
                      color: CustomColors.primaryBlue, fontSize: 15)),
              TextSpan(
                  text: 'Login',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false);
                    },
                  style: GoogleFonts.sourceSansPro(
                      color: CustomColors.primaryOrange, fontSize: 15))
            ])).paddingForOnly(bottom: 30),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                final RegExp nameRegExp =
                    RegExp(r'(^[a-zA-Z]+(?: [a-zA-Z]+)*$)');
                if (value != null && nameRegExp.hasMatch(value)) {
                  return null;
                } else {
                  return 'Enter a valid name';
                }
              },
              onChanged: (value) {
                name = value;
              },
              decoration: const InputDecoration(labelText: 'Name'),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                bool isValid = EmailValidator.validate(email);
                if (isValid) {
                  return null;
                } else {
                  return 'Email is not valid';
                }
              },
              onChanged: (value) {
                email = value;
              },
              decoration: const InputDecoration(labelText: 'Email'),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              obscureText: isVisible,
              validator: (value) {
                if (value != null && value.length >= 6) {
                  return null;
                } else {
                  return 'Password must be atleast 6 characters';
                }
              },
              onChanged: (value) {
                password = value;
              },
              decoration: InputDecoration(
                  suffixIcon: Icon(
                    isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: CustomColors.grey,
                  ).asButton(onTap: () => changeVisibility()),
                  labelText: 'Password'),
            ).paddingForOnly(bottom: 20),
            TextFormField(
              obscureText: isVisible,
              autovalidateMode: AutovalidateMode.always,
              validator: (value) {
                if (password == confirmPassword) {
                  return null;
                } else {
                  return 'Password must be same!';
                }
              },
              onChanged: (value) {
                confirmPassword = value;
              },
              decoration: InputDecoration(
                  suffixIcon: Icon(
                    isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: CustomColors.grey,
                  ).asButton(onTap: () => changeVisibility()),
                  labelText: 'Confirm Password'),
            ).paddingForOnly(bottom: 20),
            primaryButton(context,
                label: 'Register',
                onPressed: () => buttonPressed(),
                processing: isProcessing)
          ],
        ).paddingWithSymmetry(horizontal: 16, vertical: 50),
      ),
    ).asButton(onTap: () => FocusManager.instance.primaryFocus?.unfocus()));
  }

  void changeVisibility() {
    setState(() {
      isVisible = !isVisible;
    });
  }

  Future<void> buttonPressed() async {
    if (!isProcessing) {
      setState(() {
        isProcessing = true;
      });
      if (key.currentState!.validate()) {
        debugPrint(name);
        debugPrint(email);
        debugPrint(password);
        await Future.delayed(const Duration(seconds: 2));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(awesomeBar(
            title: 'Error !!',
            message: 'Enter valid Details',
            contentType: 'failure'));
      }
      setState(() {
        isProcessing = false;
      });
    }
  }
}
