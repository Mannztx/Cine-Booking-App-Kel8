import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page_virdan.dart';
import 'login_page_ang5.dart';

class AuthWrapperAng5 extends StatelessWidget {
  const AuthWrapperAng5({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Jika masih cek status auth
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Jika error Firebase
        if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text("Terjadi kesalahan")));
        }

        // Jika user sudah login → masuk Home
        if (snapshot.hasData && snapshot.data != null) {
          return const HomePageVirdan();
        }

        // Jika tidak login → ke Login Page
        return const LoginPageAng5();
      },
    );
  }
}
