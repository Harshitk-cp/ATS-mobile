import 'package:ats_mobile/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<LandingPage> {
  bool loggedIn = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    loggedIn = (prefs.getBool(SharedPreferencesConstants.LOGGED_IN) ?? false);
    if (loggedIn) {
      Navigator.pushNamedAndRemoveUntil(context, '/home', ModalRoute.withName('/home'));
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/login'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
