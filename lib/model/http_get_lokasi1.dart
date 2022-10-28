import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HttpProvider with ChangeNotifier {
  Map<String, dynamic> _data = {};
  Map<String, dynamic> get data => _data;

  int get jumlahData => _data.length;

  void connectApi(String id) async {
    Uri url =
        Uri.parse("http://libra.akhdani.net:54125/api/master/lokasi" + '1');

    var hasilResponse = await http.get(url);

    _data = (json.decode(hasilResponse.body))["data"];
    notifyListeners();
  }
}
