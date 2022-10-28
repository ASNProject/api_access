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
  final String apiUrl = "http://libra.akhdani.net:54125/api/trx/perdin/list";
  late Future<List<User>> futurePost;

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

    /*     return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dashboard',
      home: Scaffold(
        body: Column(
          children: <Widget>[headers],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                new MaterialPageRoute(builder: (context) => new PerdinBaru()));
          },
          child: const Icon(Icons.add),
        ),//
      ),
    );
*/
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

          /*  child: Column(
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
          ), */
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
                          Text(users[index].nama_pegawai),
                          Text(users[index].uang_saku),
                          Text(users[index].nrp),
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
