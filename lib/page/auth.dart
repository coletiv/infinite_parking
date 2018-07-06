import 'package:flutter/material.dart';

import 'package:coletiv_infinite_parking/network/network.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    final email = emailController.text;
    final password = passwordController.text;

    final response = await Network.login(email, password);

    if (response.statusCode == 200) {
      // TODO go to next screen
    } else {
      // TODO show error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  maxLines: 1,
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: TextField(
                  maxLines: 1,
                  obscureText: true,
                  controller: passwordController,
                  decoration: InputDecoration(hintText: 'Password'),
                ),
              ),
              RaisedButton(
                onPressed: login,
                child: Text('LOGIN'),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
