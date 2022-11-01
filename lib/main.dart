import 'package:api_access/pages/Login.dart';
import 'package:api_access/pages/Register.dart';
import 'package:api_access/pages/test.dart';
import 'package:api_access/pages/testDropdownSearch.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:api_access/pages/Dashboard.dart';
import 'package:api_access/pages/PerdinBaru.dart';
import 'package:api_access/pages/Edit_Perdin.dart';

import './model/get_model.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Test(),
    routes: {
      'register': (context) => MyRegister(),
      'login': (context) => MyLogin(),
      'dashboard': (context) => Dashboard(),
      'perdinbaru': (context) => PerdinBaru(),
      'editperdin': (context) => EditPerdin(),
      'test': ((context) => Test())
    },
  ));
  //runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChangeNotifierProvider(
          create: (context) => HttpProvider(), child: MyLogin()),
    );
  }
}
