import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> signInWithGoogle() async {
    try {
      // Logout dari GoogleSignIn sebelum login untuk menghapus cache
      await _googleSignIn.signOut();

      // Inisialisasi login Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User batal login

      // Mendapatkan authentication Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Membuat credential dari token Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase menggunakan credential Google
      await _auth.signInWithCredential(credential);

      _isLoggedIn = true;
      notifyListeners(); // Update state ke UI
    } catch (e) {
      print('Error: $e');
    }
  }

  void signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut(); // Logout dari GoogleSignIn juga
    _isLoggedIn = false;
    notifyListeners(); // Update state ke UI
  }
}
