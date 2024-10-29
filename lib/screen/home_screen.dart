import 'package:bersamapulse/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {

  final VoidCallback onProfileTap;

  const HomeScreen({super.key, required this.onProfileTap});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: onProfileTap, // Panggil fungsi navigasi ke profil
          ),
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
