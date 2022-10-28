import 'package:api_access/model/perdin_model.dart';
import 'package:api_access/pages/PerdinBaru.dart';
import 'package:api_access/pages/Register.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:api_access/api_service/apiservice.dart';
import 'package:api_access/pages/ui_list.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _MyDashboard createState() => _MyDashboard();
}

class _MyDashboard extends State<Dashboard> {
  final String apiUrl =
      "http://libra.akhdani.net:54125/api/trx/perdin/list?limit=1000&offset=0";
  late Future<List<User>> futurePost;

  void deleteperdin(String id) async {
    try {
      Response response = await delete(
        Uri.parse("http://libra.akhdani.net:54125/api/trx/perdin/" + id),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {});
        print("Berhasil dihapus");
        print(response.statusCode);
      } else {
        print("Gagal hapus");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  TextEditingController txtpegawai = TextEditingController();
  TextEditingController txtkotaasal = TextEditingController();
  TextEditingController txtkotatujuan = TextEditingController();
  TextEditingController txttanggalberangkat = TextEditingController();
  TextEditingController txttanggalpulang = TextEditingController();
  TextEditingController txttujuanperdin = TextEditingController();
  String nama = '';

  String? dropdownvalue;

  @override
  void initState() {
    super.initState();
    readData();
  }

  void readData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() => nama = pref.getString('nama')!);
    print(nama);
  }

  @override
  Widget build(BuildContext context) {
    //Interface
    Widget headers = Container(
      padding: const EdgeInsets.only(top: 60),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: const Text(
                    'Hallo,',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    '$nama',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600),
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
              onPressed: () {},
              child: Text(
                'Logout',
                style: TextStyle(fontFamily: 'Poppins', color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
    //LISTVIEW
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            'Perdinku',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 22),
          ),
        ),
        leadingWidth: 200,
        actions: <Widget>[
          Container(
            // padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.logout),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(5),
          child: Container(
            height: 5,
          ),
        ),
      ),
      body: Container(
        color: Colors.blueGrey[50],
        padding: const EdgeInsets.all(8),
        child: FutureBuilder<List<User>>(
          future: fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<User> users = snapshot.data as List<User>;
              return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(8),
                      color: Colors.white,
                      child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Icon(Icons.account_circle),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  users[index].nama_pegawai,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 10, top: 5),
                                child: Text(
                                  "Data perjalanan dinas",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      decoration: TextDecoration.underline),
                                ),
                              ),
                              Expanded(child: Container()),
                              Container(
                                padding: const EdgeInsets.only(right: 0),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.edit),
                                ),
                              ),
                              Container(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: IconButton(
                                    onPressed: () {
                                      deleteperdin(
                                          (users[index].id).toString());
                                      print(users[index].id);
                                    },
                                    icon: Icon(Icons.delete),
                                    color: Colors.red,
                                  )),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5),
                                    child: Text("Tanggal perjalanan dinas"),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Icon(
                                          Icons.date_range_rounded,
                                          size: 16,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          users[index].tanggal_berangkat,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5),
                                    child: Icon(
                                      Icons.east,
                                      size: 18,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Icon(
                                          Icons.date_range_rounded,
                                          size: 16,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 2),
                                        child: Text(
                                          users[index].tanggal_pulang,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5, top: 5),
                                    child: Text("Kota perjalanan dinas"),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Icon(
                                          Icons.location_on,
                                          size: 14,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 1),
                                        child: Text(
                                          users[index].lokasi_asal,
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      left: 5,
                                    ),
                                    child: Icon(
                                      Icons.east,
                                      size: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        child: Icon(
                                          Icons.location_on,
                                          size: 14,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.only(left: 1),
                                        child: Text(
                                          users[index].lokasi_tujuan,
                                          style: TextStyle(fontSize: 11),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 5, top: 5),
                                    child: Text("Tujuan perjalanan dinas"),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(Icons.arrow_right),
                                  ),
                                  Container(
                                    child: Text(users[index].maksud),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      "Kalkulasi perjalanan",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          decoration: TextDecoration.underline),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(Icons.arrow_right),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(left: 1),
                                    child: Text("Durasi perjalanan"),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 30, top: 5),
                                    child: Icon(
                                      Icons.calendar_today,
                                      size: 16,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 5),
                                    child: Text(users[index].durasi + " Hari"),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 5),
                                    child: Icon(Icons.arrow_right),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 1, top: 5),
                                    child: Text("Jarak perjalanan"),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 30, top: 5),
                                    child: Icon(
                                      Icons.sync_alt,
                                      size: 16,
                                    ),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 5),
                                    child: Text(users[index].durasi + " Hari"),
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Icon(Icons.arrow_right),
                                  ),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 1, top: 5),
                                    child: Text("Uang saku"),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.only(bottom: 20),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 30, top: 5),
                                      child: Icon(
                                        Icons.payments,
                                        size: 16,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        left: 5,
                                        top: 5,
                                      ),
                                      child:
                                          Text("Rp. " + users[index].uang_saku),
                                    )
                                  ],
                                ),
                              )
                            ],
                          )
                          //       Text(users[index].nama_pegawai),
                          //       Text(users[index].uang_saku),
                          //      Text(users[index].nrp),
                        ],
                      ),
                    );
                  });
            }
            if (snapshot.hasError) {
              print(snapshot.error.toString());
              return Text('error');
            }
            return CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              new MaterialPageRoute(builder: (context) => new PerdinBaru()));
        },
        child: const Icon(Icons.add),
      ), //
    );
  }

  Future<List<User>> fetchUsers() async {
    var response = await http.get(Uri.parse(apiUrl));
    return (json.decode(response.body)['data'] as List)
        .map((e) => User.fromJson(e))
        .toList();
  }
}
