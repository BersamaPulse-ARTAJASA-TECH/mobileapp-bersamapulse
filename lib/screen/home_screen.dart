import 'package:bersamapulse/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<AuthProvider>(context, listen: false).signOut();
              },
              icon: const Icon(Icons.logout)
          )
        ],
      ),
      body: Center(
        child: Text(
          'Welcome to BersamaApp Healthkathon 2024',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
