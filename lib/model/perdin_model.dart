import 'dart:convert';
import 'package:api_access/model/perdin_model.dart';
import 'package:http/http.dart' show Client;

class User {
  String nrp;
  String nama_pegawai;
  String jarak;
  String uang_saku;
  String lokasi_asal;
  String lokasi_tujuan;
  String tanggal_berangkat;
  String tanggal_pulang;
  String durasi;
  String maksud;

  User(
      {required this.nrp,
      required this.nama_pegawai,
      required this.jarak,
      required this.uang_saku,
      required this.lokasi_asal,
      required this.lokasi_tujuan,
      required this.tanggal_berangkat,
      required this.tanggal_pulang,
      required this.durasi,
      required this.maksud});

  factory User.fromJson(Map<String, dynamic> json) => User(
      nrp: json['nrp'],
      nama_pegawai: json['nama_pegawai'],
      jarak: json['jarak'],
      uang_saku: json['uang_saku'],
      lokasi_asal: json['lokasi_asal'],
      lokasi_tujuan: json['lokasi_tujuan'],
      tanggal_berangkat: json['tanggal_berangkat'],
      tanggal_pulang: json['tanggal_pulang'],
      durasi: json['lama_hari'],
      maksud: json['maksud']);
}
