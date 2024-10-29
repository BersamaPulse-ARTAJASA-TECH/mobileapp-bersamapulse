import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../auth_provider.dart';


class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login with Google')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).signInWithGoogle();
          },
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
