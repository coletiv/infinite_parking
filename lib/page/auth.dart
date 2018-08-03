import 'package:coletiv_infinite_parking/network/client/auth_client.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  BuildContext buildContext;

  final progressKey = GlobalKey();
  final loginBtnKey = GlobalKey();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  void login() async {
    updateLoadingState(true);

    final email = emailController.text;
    final password = passwordController.text;

    final isLoggedIn = await authClient.login(email, password);

    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/Sessions');
    } else {
      showError();
    }
  }

  void showError() {
    updateLoadingState(false);

    final snackBar = SnackBar(content: Text("Authentication Error"));
    Scaffold.of(buildContext).showSnackBar(snackBar);
  }

  void updateLoadingState(bool isLoading) {
    setState(() {
      this.isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          buildContext = context;
          return Container(
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
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Opacity(
                        opacity: isLoading ? 1.0 : 0.0,
                        child: CircularProgressIndicator(),
                      ),
                      Opacity(
                        opacity: isLoading ? 0.0 : 1.0,
                        child: RaisedButton(
                          onPressed: login,
                          child: Text('LOGIN'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
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
