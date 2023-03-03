import 'package:anubhav/auth/login_screen.dart';
import 'package:anubhav/utilities/colors.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder: OutlineInputBorder(
              borderSide:
              const BorderSide(color: CustomColors.grey, width: 2),
              borderRadius: BorderRadius.circular(8)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                  color: CustomColors.primaryOrange, width: 2),
              borderRadius: BorderRadius.circular(8)),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red, width: 2
            ),
            borderRadius: BorderRadius.circular(8)
          ),
            focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Colors.red, width: 2
                ),
                borderRadius: BorderRadius.circular(8)
            )
        )
      ),
      home: const LoginScreen(),
    );
  }
}
