import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utility {
  static void showAlert(BuildContext context, String text) {
    var alert = AlertDialog(
      content: Row(
        children: <Widget>[Text(text)],
      ),
      actions: <Widget>[
        ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "OK",
              style: TextStyle(color: Colors.white),
            ))
      ],
    );

    showDialog(
        context: context,
        builder: (_) {
          return alert;
        });
  }

  static void showSnack(String msg, GlobalKey<ScaffoldState> scaffoldKey) {
    final snackBarContent = SnackBar(content: Text(msg));
    ScaffoldMessenger.of(scaffoldKey.currentState!.context)
        .showSnackBar(snackBarContent);
  }

  static String formatNumberIndianStyle(double number) {
    if (number >= 10000000) {
      return '${(number / 10000000).toStringAsFixed(1)}Cr';
    } else if (number >= 100000) {
      return '${(number / 100000).toStringAsFixed(1)}L';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    } else {
      return number.toStringAsFixed(0);
    }
  }

  addStringToSharedPreferences(String key, String msg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, msg);
  }
}

class SharedPref {
  read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString(key).toString());
  }

  saveModel(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
