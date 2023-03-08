import 'package:anubhav/auth/signup_screen.dart';
import 'package:anubhav/auth/user_detail_screen.dart';
import 'package:anubhav/navigation/loading_screen.dart';
// import 'package:anubhav/main.dart';
import 'package:anubhav/service/api_service.dart';
import 'package:anubhav/service/secure_service.dart';
import 'package:anubhav/utilities/colors.dart';
import 'package:anubhav/utilities/custom_widgets/custom_button.dart';
import 'package:anubhav/utilities/custom_widgets/custom_snackbar.dart';
import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:anubhav/utilities/user_details.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> key = GlobalKey<FormState>();
  String email = "";
  String password = "";
  bool isVisible = true;
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
              'Login',
              style: GoogleFonts.sourceSansPro(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryBlue),
            ).paddingForOnly(bottom: 10, top: 50),
            RichText(
                text: TextSpan(children: [
              TextSpan(
                  text: 'Don\'t have an account? ',
                  style: GoogleFonts.sourceSansPro(
                      color: CustomColors.primaryBlue, fontSize: 15)),
              TextSpan(
                  text: 'Create Now',
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignupScreen()),
                          (route) => false);
                    },
                  style: GoogleFonts.sourceSansPro(
                      color: CustomColors.primaryOrange, fontSize: 15))
            ])).paddingForOnly(bottom: 30),
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
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
            primaryButton(context,
                label: 'Login',
                // onPressed: () => ,
                onPressed: () => buttonPressed(),
                processing: isProcessing)
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
    if (!isProcessing) {
      setState(() {
        isProcessing = true;
      });
      if (key.currentState!.validate()) {
        debugPrint(email);
        debugPrint(password);

        HTTPService http = HTTPService();

        final response = await http.loginUser(email, password);
        if (response != null) {
          if (response.responseCode == 200) {
            String token = response.msg;
            SecureStorage storage = SecureStorage();
            storage.setToken(token);
            print('user');
            await storage.getUserDetails();
            print(UserDetails.currentUser.phone);
            if(UserDetails.currentUser.phone == null) {
              print('sdf');
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => UserDetailsScreen()),
                      (route) => false);
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoadingScreen()),
                (route) => false);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(awesomeBar(
                title: 'Failed',
                message: response.msg,
                contentType: 'failure'));
          }
        }
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
