import 'dart:convert';

import 'package:ats_mobile/utility/constants.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/auth/login_response.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({
    Key? key,
  }) : super(key: key);

  @override
  _MyProfilePageState createState() {
    return _MyProfilePageState();
  }
}

class _MyProfilePageState extends State<ProfilePage> {
  late LoginResponse user = LoginResponse();

  @override
  void initState() {
    _getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF2a4d74),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F5282),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 12,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  _showData('Name:', user.user?.name.toString() ?? ""),
                  const SizedBox(
                    height: 30,
                  ),
                  _showData('Email:', user.user?.email.toString() ?? ""),
                  const SizedBox(
                    height: 30,
                  ),
                  _showData('Phone:', user.user?.phone.toString() ?? "")
                ]),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFF1F5282),
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3F000000),
                      blurRadius: 12,
                      offset: Offset(0, 1),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: _showData("Bio:", user.user?.bio.toString() ?? ""),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: GestureDetector(
                  onTap: () {
                    _logOut();
                  },
                  child: Container(
                    width: 150,
                    height: 35,
                    padding: const EdgeInsets.only(right: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F4C77),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF01FAFA)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x63000000),
                          blurRadius: 19,
                          offset: Offset(1, 3),
                          spreadRadius: 0,
                        )
                      ],
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Signout',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.42,
                              ),
                            ),
                          ),
                        ),
                        Icon(
                          Icons.logout_rounded,
                          color: Colors.white,
                          size: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _showData(label, text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 4,
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0xFF01FAFA)),
              borderRadius: BorderRadius.circular(5),
            ),
          ),
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    );
  }

  void _logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      SharedPreferencesConstants.USER,
      "",
    );
    await prefs.setString(
      SharedPreferencesConstants.EMAIL,
      "",
    );
    await prefs.setString(
      SharedPreferencesConstants.TOKEN,
      "",
    );
    await prefs.setString(
      SharedPreferencesConstants.UNIQUE_ID,
      "",
    );
    await prefs.setBool(
      SharedPreferencesConstants.LOGGED_IN,
      false,
    );

    Navigator.pushNamedAndRemoveUntil(context, '/login', ModalRoute.withName('/login'));
  }

  void _getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user = LoginResponse.fromJson(jsonDecode((prefs.getString(SharedPreferencesConstants.USER)!)));
    });
  }
}
