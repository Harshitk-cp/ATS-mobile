import 'dart:io';
import 'package:ats_mobile/api/api_response.dart';
import 'package:ats_mobile/api/http_service.dart';
import 'package:ats_mobile/models/auth/login_response.dart';
import 'package:ats_mobile/utility/utility.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUpPage> {
  final HttpService httpService = HttpService();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late ApiResponse _apiResponse = ApiResponse();
  File? _selectedFile;
  String fileName = "";

  final Map<String, dynamic> _formData = {'email': "", 'password': "", 'name': "", 'phone': "", 'dob': "", 'bio': ""};
  final focusPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Color(0xFF144c83)),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.center,
                      child: Text("Signup",
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
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1F4C77), width: 2)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Name",
                          icon: Icon(Icons.person, color: Color(0xFF144c83)),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.name,
                        onSaved: (String? value) {
                          _formData['name'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Name is required';
                          }
                          return null;
                        },
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusPassword);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1F4C77), width: 2)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          icon: Icon(Icons.email, color: Color(0xFF144c83)),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (String? value) {
                          _formData['email'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                          if (!emailRegex.hasMatch(value)) {
                            return 'Invalid Email';
                          }
                          return null;
                        },
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusPassword);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1F4C77), width: 2)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Phone",
                          icon: Icon(Icons.phone, color: Color(0xFF144c83)),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.phone,
                        onSaved: (String? value) {
                          _formData['phone'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Phone No. is required';
                          }
                          final phoneRegex = RegExp(r'^[0-9]{10}$');
                          if (!phoneRegex.hasMatch(value)) {
                            return 'Invalid Phone Number';
                          }
                          return null;
                        },
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusPassword);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1F4C77), width: 2)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "DOB",
                          icon: Icon(Icons.calendar_month, color: Color(0xFF144c83)),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.datetime,
                        onSaved: (String? value) {
                          _formData['dob'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'DOB is required';
                          }
                          final dobRegex = RegExp(r'^(0[1-9]|[12][0-9]|3[01])-(0[1-9]|1[0-2])-(19|20)\d{2}$');
                          if (!dobRegex.hasMatch(value)) {
                            return 'Invalid DOB, try entering dd-mm-yyyy format ';
                          }
                          return null;
                        },
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusPassword);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1F4C77), width: 2)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          icon: Icon(Icons.password, color: Color(0xFF144c83)),
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.visiblePassword,
                        onSaved: (String? value) {
                          _formData['password'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Password is required';
                          }
                          return null;
                        },
                        maxLines: 1,
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusPassword);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Text(
                        "Enter your Bio",
                        style: TextStyle(color: Color(0xFF1F4C77), fontSize: 15, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 10, bottom: 30),
                      decoration:
                          BoxDecoration(borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFF1F4C77), width: 2)),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          fillColor: Colors.white,
                          border: InputBorder.none,
                        ),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onSaved: (String? value) {
                          _formData['bio'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Your Bio is required';
                          }
                          return null;
                        },
                        textInputAction: TextInputAction.newline,
                        onFieldSubmitted: (v) {
                          FocusScope.of(context).requestFocus(focusPassword);
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        _selectFile();
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 70),
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF1F4C77),
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.upload_rounded,
                              size: 30,
                              color: Colors.white,
                            ),
                            if (_selectedFile != null)
                              Text(
                                'Selected PDF: $fileName',
                                style: const TextStyle(color: Colors.white, overflow: TextOverflow.ellipsis),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40.0),
                    InkWell(
                        onTap: _signupUser,
                        child: Align(
                            alignment: Alignment.center,
                            child: Container(
                                height: 50.0,
                                width: 220,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F4C77),
                                  boxShadow: const [BoxShadow(color: Colors.grey, blurRadius: 5.0, spreadRadius: 1.0, offset: Offset(-2.0, 2.0))],
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
                                            "Create Account",
                                            style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.bold),
                                          )),
                                    )),
                                    Container(
                                      height: double.infinity,
                                      width: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(topRight: Radius.circular(6), bottomRight: Radius.circular(6)),
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
              ]),
            )
          ],
        ),
      ),
    );
  }

  void _signupUser() async {
    final form = _formKey.currentState;
    if (form?.validate() == false) {
      Utility.showSnack(
        'Please check all the field are correct',
        _scaffoldKey,
      );
      return;
    }
    form!.save();
    _apiResponse =
        await httpService.signup(_formData['name'], _formData['email'], _formData['password'], _formData['phone'], _formData['bio'], _selectedFile);
    final loginResponse = _apiResponse.Data as LoginResponse;
    Utility.showSnack(loginResponse.message.toString(), _scaffoldKey);
    if (loginResponse.message != null && loginResponse.success == true) {
      Navigator.pushNamed(context, '/login');
    } else {
      final message = loginResponse.message ?? 'Please try again later';
      Utility.showSnack(message, _scaffoldKey);
    }
  }

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      fileName = path.basename(result.files.single.path!);
      setState(() {
        _selectedFile = File(result.files.single.path!);
      });
    }
  }
}
