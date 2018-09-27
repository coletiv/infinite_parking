import 'package:flutter/material.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:coletiv_infinite_parking/network/client/auth_client.dart';
import 'package:coletiv_infinite_parking/page/sessions.dart';
import 'package:coletiv_infinite_parking/page/auth.dart';
import 'package:coletiv_infinite_parking/service/push_notifications.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

class SplashPage extends StatefulWidget {
  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _login();
  }

  void _login() async {
    await AndroidAlarmManager.initialize();
    await pushNotifications.initialize();
    
    final isLoggedIn = await authClient.refreshToken();

    _redirectUser(isLoggedIn);
  }

  void _redirectUser(bool isLoggedIn) {
    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SessionsPage(),
        ),
      );
    } else {
      sessionManager.deleteSession();
      pushNotifications.cancelAll();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => AuthPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
