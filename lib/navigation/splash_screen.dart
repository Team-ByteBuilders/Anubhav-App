import 'package:anubhav/auth/additional_details_screen.dart';
import 'package:anubhav/auth/login_screen.dart';
import 'package:anubhav/auth/user_detail_screen.dart';
import 'package:anubhav/service/notification_service.dart';
import 'package:anubhav/service/secure_service.dart';
import 'package:anubhav/utilities/extensions/widget_extensions.dart';
import 'package:anubhav/utilities/user_details.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SecureStorage storage = SecureStorage();
    return FutureBuilder(
      future: storage.getToken(),
      builder: (context, snapshot) {
        NotificationApi.showScheduledNotification(
          title: 'Test',
          body: 'Test',
          payload: 'Something',
          scheduledDate: DateTime.now().add(const Duration(seconds: 30)),
        );
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator().wrapCenter();
        }
        if (snapshot.hasData) {
          if (snapshot.data != "") {
            return FutureBuilder(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (UserDetails.currentUser.phone == 'null') {
                      return UserDetailsScreen();
                    } else if (UserDetails.currentUser.altPhone == null) {
                      return AdditionalDetailsScreen();
                    }
                    return HomeScreen();
                  }
                  return Scaffold(
                    body: CircularProgressIndicator().wrapCenter(),
                  );
                });
          } else {
            return LoginScreen();
          }
        }
        return LoginScreen();
      },
    );
  }

  Future getData() async {
    SecureStorage storage = SecureStorage();
    await storage.getUserDetails();
  }
}
