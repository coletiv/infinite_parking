import 'package:coletiv_infinite_parking/network/client/auth_client.dart';
import 'package:coletiv_infinite_parking/page/sessions.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  @override
  AuthPageState createState() => AuthPageState();
}

class AuthPageState extends State<AuthPage> {
  BuildContext _context;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() async {
    _updateLoadingState(true);

    final email = _emailController.text;
    final password = _passwordController.text;

    final isLoggedIn = await authClient.login(email, password);

    if (isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SessionsPage(),
        ),
      );
    } else {
      _showError();
    }
  }

  void _showError() {
    _updateLoadingState(false);

    Scaffold.of(_context).showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        backgroundColor: Colors.red,
        content: Text("Authentication failed."),
      ),
    );
  }

  void _updateLoadingState(bool isLoading) {
    setState(() {
      this._isLoading = isLoading;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Authentication'),
      ),
      body: Builder(
        builder: (BuildContext context) {
          _context = context;
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
                      controller: _emailController,
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
                      controller: _passwordController,
                      decoration: InputDecoration(hintText: 'Password'),
                    ),
                  ),
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Opacity(
                        opacity: _isLoading ? 1.0 : 0.0,
                        child: CircularProgressIndicator(),
                      ),
                      Opacity(
                        opacity: _isLoading ? 0.0 : 1.0,
                        child: RaisedButton(
                          onPressed: _login,
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
}
