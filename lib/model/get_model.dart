import 'dart:convert';
import 'package:api_access/pages/Register.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:api_access/pages/HomeProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class HttpProvider with ChangeNotifier {
  Map<String, dynamic> _data = {};

  Map<String, dynamic> get data => _data;

  int get jumlahData => _data.length;

  void connectAPI(String username, String password) async {
    Uri url = Uri.parse("http://libra.akhdani.net:54125/api/auth/login");

    var hasilResponse = await http.post(
      url,
      body: {
        "username": username,
        "password": password,
      },
    );

    _data = json.decode(hasilResponse.body);
    notifyListeners();
    if (hasilResponse.statusCode == 200) {
      Fluttertoast.showToast(
          msg: "Berhasil Login",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16);
      Get.to(MyRegister());
    } else {
      Fluttertoast.showToast(
          msg: "Gagal Login",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16);
    }
  }
}
