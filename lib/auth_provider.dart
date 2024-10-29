import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> signInWithGoogle() async {
    try {
      // Logout dari GoogleSignIn sebelum login
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return; // User batal login

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in ke Firebase
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user != null) {
        // Simpan data user ke Firestore
        final userDoc = _firestore.collection('users').doc(user.uid);
        await userDoc.set({
          'name': user.displayName ?? '',
          'email': user.email ?? '',
          'photoURL': user.photoURL ?? '',
          'heartRate': 0,
          'height': 0,
          'weight': 0,
          'age': 0,
          'bloodPressure': '',
          'oxygenSaturation': 0,
        }, SetOptions(merge: true));

        _isLoggedIn = true;
        notifyListeners();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    _isLoggedIn = false;
    notifyListeners();
  }
}
