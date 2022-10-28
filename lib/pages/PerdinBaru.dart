import 'dart:math' as Math;

import 'package:api_access/pages/Register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';

class PerdinBaru extends StatefulWidget {
  const PerdinBaru({Key? key}) : super(key: key);

  @override
  _MyPerdinBaru createState() => _MyPerdinBaru();
}

class _MyPerdinBaru extends State<PerdinBaru> {
  TextEditingController kotaasal = TextEditingController();
  TextEditingController kotatujuan = TextEditingController();
  TextEditingController keperluan = TextEditingController();
  TextEditingController dateBerangkat = TextEditingController();
  TextEditingController datePulang = TextEditingController();

  String _baseUrl = "http://libra.akhdani.net:54125/api/master/pegawai/list";
  String _baseUrl2 = "http://libra.akhdani.net:54125/api/master/lokasi/list";
  String _valPegawai = '';
  String _valLokasi = '';
  String _valLokasiId = '';
  String _valLokasiProv = '';
  String _valLokasiId2 = '';
  String _valLokasi2 = '';

  List<dynamic> _dataPegawai = List.empty();
  List<dynamic> _dataLokasi = List.empty();
  List<dynamic> _dataLokasi2 = List.empty();

  //GET DATA LOKASI ASAL
  void getLokasiApi1(String id) async {
    try {
      Response response = await get(
        Uri.parse("http://libra.akhdani.net:54125/api/master/lokasi/" + id),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final pref = await SharedPreferences.getInstance();
        print('berhasil');

        await pref.setString('provinsi', data["provinsi"]);
        await pref.setString('lon1', data["lon"]);
        await pref.setString('lat1', data["lat"]);
      } else {
        print("tidak bisa");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  ///GET DATA LOKASI TUJUAN
  void getLokasiApi2(String id) async {
    try {
      Response response = await get(
        Uri.parse("http://libra.akhdani.net:54125/api/master/lokasi/" + id),
      );
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        final pref = await SharedPreferences.getInstance();
        print('berhasil');

        await pref.setString('provinsi2', data["provinsi"]);
        await pref.setString('lon2', data["lon"]);
        await pref.setString('lat2', data["lat"]);
      } else {
        print("tidak bisa");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //GET LIST DATA PEGAWAI DI DROPDOWN
  void getPegawai() async {
    final response = await http.get(Uri.parse(_baseUrl));
    var lisData = jsonDecode(response.body);
    setState(() {
      _dataPegawai = lisData["data"];
      _valPegawai = _dataPegawai.first['nama'];
    });
    print("data : $lisData");
  }

  //GET LIST DATA LOKASI ASAL DI DROPDOWN
  void getLokasi() async {
    final response = await http.get(Uri.parse(_baseUrl2));
    var lisData2 = jsonDecode(response.body);
    setState(() {
      _dataLokasi = lisData2["data"];
      _valLokasi = _dataLokasi.first["nama"];
      _valLokasiId = _dataLokasi.first["id"];
      _valLokasiProv = _dataLokasi.first["provinsi"];
    });
    print("data : $lisData2");
  }

  //GET LIST DATA LOKASI TUJUAN DI DROPDOWN
  void getLokasi2() async {
    final response = await http.get(Uri.parse(_baseUrl2));
    var lisData3 = jsonDecode(response.body);
    setState(() {
      _dataLokasi2 = lisData3["data"];
      _valLokasi2 = _dataLokasi2.first["nama"];
      _valLokasiId2 = _dataLokasi2.first["id"];
    });
    print("data : $lisData3");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPegawai();
    getLokasi();
    getLokasi2();
    dateBerangkat.text = "";
    datePulang.text = "";
  }

  @override
  Widget build(BuildContext context) {
    Widget inputdata = Column(
      children: [
        //TEXT NAMA
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 20),
          child: Text(
            "Nama",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
        //DROPDOWN PEGAWAI
        Container(
          padding: const EdgeInsets.only(right: 20),
          child: DropdownButton(
            isExpanded: true,
            menuMaxHeight: 600,
            borderRadius: BorderRadius.circular(20),
            hint: Text("Pilih Pegawai"),
            value: _valPegawai,
            items: _dataPegawai.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                child: Text(item['nama']),
                value: item['nama'],
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _valPegawai = value.toString();
              });
            },
          ),
        ),
        //TEXT KOTA ASAL
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Kota Asal",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
        //DROPDOWN KOTA ASAL
        Container(
          padding: const EdgeInsets.only(right: 20),
          child: DropdownButton(
            isExpanded: true,
            menuMaxHeight: 600,
            borderRadius: BorderRadius.circular(20),
            hint: Text("Pilih Kota Asal"),
            value: _valLokasiId,
            items: _dataLokasi.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                child: Text(item['nama']),
                value: item['id'],
              );
            }).toList(),
            onChanged: (value) async {
              setState(() {
                _valLokasiId = value.toString();
                print("ID Asal " + _valLokasiId);
              });
            },
          ),
        ),
        //TEXT KOTA TUJUAN
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Kota Tujuan",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
        //DROPDOWN KOTA TUJUAN
        Container(
          padding: const EdgeInsets.only(right: 20),
          child: DropdownButton(
            isExpanded: true,
            menuMaxHeight: 600,
            borderRadius: BorderRadius.circular(20),
            hint: Text("Pilih Kota Tujuan"),
            value: _valLokasiId2,
            items: _dataLokasi2.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                child: Text(item['nama']),
                value: item['id'],
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _valLokasiId2 = value.toString();
                print("ID Tujuan " + _valLokasiId2);
              });
            },
          ),
        ),
        //TEXT TANGGAL BERANGKAT
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Tanggal Berangkat",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
        //SET TANGGAL BERANGKAT
        Container(
          padding: EdgeInsets.only(top: 10, right: 20),
          child: Center(
              child: TextField(
            controller: dateBerangkat,
            decoration: InputDecoration(
              icon: Icon(Icons.calendar_today),
              labelText: "Masukkan Tanggal",
            ),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now());
              if (pickedDate != null) {
                //  print(pickedDate);
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                print(formattedDate);
                setState(() {
                  dateBerangkat.text = formattedDate;
                });
              } else {}
            },
          )),
        ),
        //TEXT TANGGAL PULANG
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Tanggal Pulang",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
        //SET TANGGAL PULANG
        Container(
          padding: EdgeInsets.only(top: 10, right: 20),
          child: Center(
              child: TextField(
            controller: datePulang,
            decoration: InputDecoration(
                icon: Icon(Icons.calendar_today),
                labelText: "Masukkan Tanggal"),
            readOnly: true,
            onTap: () async {
              DateTime? pickedDate = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2100),
                  initialDate: DateTime.now());
              if (pickedDate != null) {
                print(pickedDate);
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);
                print(formattedDate);
                setState(() {
                  datePulang.text = formattedDate;
                });
              } else {}
            },
          )),
        ),
        //KEPERLUAN
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(top: 10),
          child: Text(
            "Keperluan",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16),
          ),
        ),
        //BUTTON SUBMIT
        Container(
          padding: const EdgeInsets.only(top: 10, right: 20),
          child: TextFormField(
            minLines: 2,
            controller: keperluan,
            onSaved: (String? val) {
              keperluan.text = val!;
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
                fillColor: Colors.grey.shade100,
                filled: true,
                hintText: "Tuliskan keperluan perjalanan dinas ...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        TextButton(
          style: TextButton.styleFrom(backgroundColor: Colors.blue),
          onPressed: () async {
            //MENGHITUNG JARAK
            getLokasiApi1(_valLokasiId);
            getLokasiApi2(_valLokasiId2);

            final prefs = await SharedPreferences.getInstance();
            final String? lon = prefs.getString('lon1');
            final String? lat = prefs.getString('lat1');
            //  print("Longitude pada lokasi 1 adalah " + lon.toString());
            //  print("Latitude pada lokasi 1 adalah " + lat.toString());
            final String? lon2 = prefs.getString('lon2');
            final String? lat2 = prefs.getString('lat2');
            //  print("Longitude pada lokasi 2 adalah " + lon2.toString());
            //  print("Latitude pada lokasi 2 adalah " + lat2.toString());

            var lonA = double.parse('$lon');
            var latA = double.parse('$lat');
            var lonB = double.parse('$lon2');
            var latB = double.parse('$lat2');

            double deg2rad(deg) {
              return deg * (Math.pi / 180);
            }

            var R = 6371; //Radius bumi dalam kilometer
            var dLat = deg2rad(latB - latA);
            var dLon = deg2rad(lonB - lonA);
            var a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                Math.cos(deg2rad(latA)) *
                    Math.cos(deg2rad(latB)) *
                    Math.sin(dLon / 2) *
                    Math.sin(dLon / 2);
            var c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
            var d = R * c; //Menghitung Jarak dalam Km

            int jarak = d.toInt();

            print("Jarak= " + jarak.toString());

            //MENGHITUNG JUMLAH HARI

            DateTime dt1 = DateTime.parse(dateBerangkat.text);
            DateTime dt2 = DateTime.parse(datePulang.text);

            Duration diff = dt2.difference(dt1);
            var i = diff.inDays + 1;
            print("Jumlah hari = " + i.toString());

            //MENGHITUNG UANG SAKU

            var uangsaku = 0;

            if (jarak < 60) {
              uangsaku = i * 0;
            } else {
              uangsaku = i * 100000;
            }

            print(uangsaku);
          },
          child: Text(
            'Simpan',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins'),
          ),
        ),
      ],
    );
    //SCAFFOLD
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 60, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Tambah Data Perdin Baru",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 24),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            inputdata,
          ],
        ),
      ),
    );
  }
}
