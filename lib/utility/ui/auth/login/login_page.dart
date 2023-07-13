import 'dart:convert';
import 'package:ats_mobile/api/api_response.dart';
import 'package:ats_mobile/api/http_service.dart';
import 'package:ats_mobile/models/auth/login_response.dart';
import 'package:ats_mobile/utility/constants.dart';
import 'package:ats_mobile/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/gestures.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  final HttpService httpService = HttpService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ApiResponse _apiResponse = ApiResponse();

  final Map<String, dynamic> formData = {'email': "", 'password': ""};
  final focusPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Align(
                          alignment: Alignment.center,
                          child: Text("Login",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                              )),
                        ),
                        const SizedBox(
                          height: 25.0,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFF1F4C77), width: 2)),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Email",
                              icon: Icon(Icons.email, color: Color(0xFF144c83)),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (String? value) {
                              formData['email'] = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Email is required';
                              }
                              return null;
                            },
                            maxLines: 1,
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (v) {
                              FocusScope.of(context)
                                  .requestFocus(focusPassword);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color: const Color(0xFF1F4C77), width: 2)),
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: "Password",
                              icon: Icon(Icons.password,
                                  color: Color(0xFF144c83)),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                            ),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            onSaved: (String? value) {
                              formData['password'] = value;
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Password is required';
                              }
                              return null;
                            },
                            focusNode: focusPassword,
                          ),
                        ),
                        const SizedBox(height: 40.0),
                        InkWell(
                            onTap: _loginUser,
                            child: Align(
                                alignment: Alignment.center,
                                child: Container(
                                    height: 50.0,
                                    width: 150,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F4C77),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0,
                                            spreadRadius: 1.0,
                                            offset: Offset(-2.0, 2.0))
                                      ],
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Row(
                                      children: [
                                        const Expanded(
                                            child: Padding(
                                          padding: EdgeInsets.only(left: 10),
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "Sign In",
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )),
                                        )),
                                        Container(
                                          height: double.infinity,
                                          width: 40,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(6),
                                                bottomRight:
                                                    Radius.circular(6)),
                                          ),
                                          child: const Icon(
                                            Icons.arrow_forward_ios,
                                            size: 25,
                                            color: Color(0xFF1F4C77),
                                          ),
                                        )
                                      ],
                                    ))))
                      ],
                    ),
                    const SizedBox(height: 40),
                    RichText(
                      text: TextSpan(
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 20.0),
                          children: <TextSpan>[
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                                text: 'Sign Up!',
                                style: const TextStyle(color: Colors.blue),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.pushNamed(
                                      context,
                                      '/signup',
                                    );
                                  }),
                          ]),
                    ),
                  ]),
            ),
          )
        ],
      ),
    );
  }

  void _loginUser() async {
    final form = _formKey.currentState;
    if (form?.validate() == false) {
      Utility.showSnack(
        'Please check all the field are correct',
        _scaffoldKey,
      );
      return;
    }
    form!.save();
    _apiResponse = await httpService.login(
      formData['email'],
      formData['password'],
    );
    final loginResponse = _apiResponse.Data as LoginResponse;
    if (loginResponse.user != null &&
        loginResponse.success == true &&
        loginResponse.user?.isEmployer == false) {
      _saveAndRedirectToCheckPin();
    } else {
      final message = (loginResponse.message == "User successfully Loggedin.")
          ? "User Doesn't Exist"
          : loginResponse.message ?? 'Please try again later';
      Utility.showSnack(message, _scaffoldKey);
    }
  }

  void _saveAndRedirectToCheckPin() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _apiResponse.Data as LoginResponse;

    await prefs.setString(
      SharedPreferencesConstants.USER,
      jsonEncode(data),
    );
    await prefs.setString(
      SharedPreferencesConstants.EMAIL,
      data.user!.email.toString(),
    );
    await prefs.setString(
      SharedPreferencesConstants.TOKEN,
      data.user!.token.toString(),
    );
    await prefs.setString(
      SharedPreferencesConstants.UNIQUE_ID,
      data.user!.id.toString(),
    );
    await prefs.setBool(
      SharedPreferencesConstants.LOGGED_IN,
      true,
    );

    Navigator.pushNamedAndRemoveUntil(
        context, '/home', ModalRoute.withName('/home'));
  }
}
