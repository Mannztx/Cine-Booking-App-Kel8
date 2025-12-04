import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:provider/provider.dart';

// Providers
import 'providers/seat_provider_dinn.dart';
import 'controllers/auth_controller_ang5.dart';

// Pages
import 'pages/auth_wrapper_ang5.dart';
import 'pages/home_page_virdan.dart';
import 'pages/seat_page_nuris.dart';
import 'pages/login_page_ang5.dart';
import 'pages/register_page_ang5.dart';
import 'pages/profile_page_ang5.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SeatProvider_dinn()),
        ChangeNotifierProvider(create: (_) => AuthControllerAng5()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Cinema Booking App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),

        // 🔥 Auth Wrapper → cek login di awal aplikasi
        home: const AuthWrapperAng5(),

        // Semua route aplikasi
        routes: {
          "/home": (_) => const HomePageVirdan(),
          "/login": (_) => const LoginPageAng5(),
          "/register": (_) => const RegisterPageAng5(),
          "/profile": (_) => const ProfilePageAng5(),
          "/seat": (_) => SeatPage_Nuris(),
        },
      ),
    );
  }
}
