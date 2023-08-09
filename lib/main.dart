import 'package:ats_mobile/ui/auth/login/login_page.dart';
import 'package:ats_mobile/ui/auth/signup/signup_page.dart';
import 'package:ats_mobile/ui/home/applications_page.dart';
import 'package:ats_mobile/ui/home/applied_finish.dart';
import 'package:ats_mobile/ui/home/home_page.dart';
import 'package:ats_mobile/ui/home/job_details_page.dart';
import 'package:ats_mobile/ui/home/profile_page.dart';
import 'package:ats_mobile/ui/landing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HirePro',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: getMaterialColor(),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/home': (context) => const HomePage(),
        '/jobDetail': (context) => const JobDetailsPage(),
        '/applied': (context) => const AppliedFinishPage(),
        '/profile': (context) => const ProfilePage(),
        '/applications': (context) => const ApplicationsPage(),
      },
    );
  }

  MaterialColor getMaterialColor() {
    int colorValue = 0xFF1c1d26;
    Color color = Color(colorValue);
    Map<int, Color> shades = [50, 100, 200, 300, 400, 500, 600, 700, 800, 900]
        .asMap()
        .map((key, value) =>
            MapEntry(value, color.withOpacity(1 - (1 - (key + 1) / 10))));

    return MaterialColor(colorValue, shades);
  }
}
