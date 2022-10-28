import 'dart:convert';
import 'package:api_access/model/perdin_model.dart';
import 'package:http/http.dart' show Client;

class User {
  String nrp;
  String nama_pegawai;
  String jarak;
  String uang_saku;

  User(
      {required this.nrp,
      required this.nama_pegawai,
      required this.jarak,
      required this.uang_saku});

  factory User.fromJson(Map<String, dynamic> json) => User(
      nrp: json['nrp'],
      nama_pegawai: json['nama_pegawai'],
      jarak: json['jarak'],
      uang_saku: json['uang_saku']);
}
