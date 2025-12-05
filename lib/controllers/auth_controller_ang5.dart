import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthControllerAng5 extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fire = FirebaseFirestore.instance;

  bool loading = false;
  String? errorMessage;

  User? get user => _auth.currentUser;

  Future<void> registerWithEmail({
    required String email,
    required String password,
    required String username,
    required String balance,
    required BuildContext context,
  }) async {
    try {
      loading = true;
      errorMessage = null;
      notifyListeners();

      Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _fire.collection('users').doc(credential.user!.uid).set({
        'uid': credential.user!.uid,
        'email': email,
        'username': username,
        'balance': balance,
        'created_at': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      loading = true;
      errorMessage = null;
      notifyListeners();

      Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);

      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      errorMessage = e.message;
    } finally {
      loading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}