import 'package:flutter/material.dart';
import 'package:coletiv_infinite_parking/data/session_manager.dart';
import 'package:coletiv_infinite_parking/network/client/auth_client.dart';
import 'package:coletiv_infinite_parking/page/sessions.dart';
import 'package:coletiv_infinite_parking/page/auth.dart';

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
