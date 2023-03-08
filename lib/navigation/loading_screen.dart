import 'package:anubhav/navigation/splash_screen.dart';
import 'package:anubhav/navigation/status_screen.dart';
import 'package:anubhav/service/notification_service.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}
class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    NotificationApi.init(initScheduled: true);
    listenNotifications();
    super.initState();
  }

  void listenNotifications() {
    onNotifications.stream.listen(onClickedNotifications);
  }

  void onClickedNotifications(String? payload) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => StatusScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
