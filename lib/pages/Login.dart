import 'package:api_access/pages/Dashboard.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:api_access/model/get_model.dart';
import 'package:provider/provider.dart';
import 'package:api_access/pages/Register.dart';

class MyLogin extends StatefulWidget {
  const MyLogin({Key? key}) : super(key: key);

  @override
  _MyLoginState createState() => _MyLoginState();
}

class _MyLoginState extends State<MyLogin> {
  TextEditingController txtEditUsername = TextEditingController();
  TextEditingController txtEditPass = TextEditingController();

  // Map<String, dynamic> _data = {};
  // Map<String, dynamic> get data => _data;
  // int get jumlahData => _data.length;

  void login(String usename, password) async {
    try {
      Response response = await post(
          Uri.parse('http://libra.akhdani.net:54125/api/auth/login'),
          body: {
            'username': usename,
            'password': password,
          });
      //   _data = json.decode(response.body);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body.toString());
        final pref = await SharedPreferences.getInstance();
        // await pref.setString('id', $);
        print(data["id"]); //get data
        await pref.setString('id', data["id"]);
        await pref.setString('nama', data["nama"]);
        await pref.setString('email', data["email"]);
        await pref.setString('status', data["status"]);
        await pref.setString('username', data["username"]);
        final String? action = pref.getString('id');
        print("Data Idnya adalah " + action.toString());
        //Retrive data from API
        print('Login Berhasil');
        Navigator.push(context,
            new MaterialPageRoute(builder: (context) => new Dashboard()));
      } else {
        print("Login Gagal");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    //final dataProvider = Provider.of<HttpProvider>(context, listen: false);
    return Container(
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Positioned.fill(
                child: Image(
              image: AssetImage('assets/login.png'),
              fit: BoxFit.fill,
            )),
            Container(
              padding: EdgeInsets.only(left: 35, top: 155),
              child: Text(
                'Selamat\nDatang',
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 35, right: 35),
                      child: Column(
                        children: [
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            controller: txtEditUsername,
                            onSaved: (String? val) {
                              txtEditUsername.text = val!;
                            },
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Username",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(),
                            obscureText: true,
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            validator: (String? arg) {
                              if (arg == null || arg.isEmpty) {
                                return 'Password harus diisi';
                              } else {
                                return null;
                              }
                            },
                            controller: txtEditPass,
                            onSaved: (String? val) {
                              txtEditPass.text = val!;
                            },
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                backgroundColor: Colors.blue),
                            onPressed: () {
                              //  dataProvider.connectAPI(
                              //      txtEditUsername.text, txtEditPass.text);
                              login(txtEditUsername.text, txtEditPass.text);
                            },
                            child: Text(
                              'Masuk',
                              style: TextStyle(
                                  color: Colors.white, fontFamily: 'Poppins'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Belum punya akun?'),
                  TextButton(
                    onPressed: () {
                      //Navigate pindah halaman
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new MyRegister()));
                    },
                    child: Text('Daftar'),
                  ),
                  //Image.asset('assets/login.png')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
