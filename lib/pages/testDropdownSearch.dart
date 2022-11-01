import 'dart:convert';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  _MyTest createState() => _MyTest();
}

class _MyTest extends State<Test> {
  List _get = [];
  String provinsi = '';
  int? kodeProvinsi;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Dropdown Search"),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownSearch<dynamic>(
                  //you can design textfield here as you want
                  dropdownSearchDecoration: InputDecoration(
                    labelText: "Provinsi",
                    hintText: "Pilih Provinsi",
                  ),

                  //have two mode: menu mode and dialog mode
                  mode: Mode.MENU,
                  //if you want show search box
                  showSearchBox: true,

                  //get data from the internet
                  onFind: (text) async {
                    var response = await http.get(Uri.parse(
                        "https://dev.farizdotid.com/api/daerahindonesia/provinsi"));

                    if (response.statusCode == 200) {
                      final data = jsonDecode(response.body);

                      setState(() {
                        _get = data['provinsi'];
                      });
                    }

                    return _get as List<dynamic>;
                  },

                  //what do you want anfter item clicked
                  onChanged: (value) {
                    setState(() {
                      provinsi = value['nama'];
                      kodeProvinsi = value['id'];
                    });
                  },

                  //this data appear in dropdown after clicked
                  itemAsString: (item) => item['nama'],
                ),
                SizedBox(
                  height: 10,
                ),
                //show data in text
                Text(
                  "Provinsi yang Dipilih: ${provinsi}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Kode Provinsi yang Dipilih: ${kodeProvinsi}",
                  style: TextStyle(fontSize: 18),
                ),
                //  showSearchBox()

                /*   DropdownSearch<dynamic>(
                          
                          //you can design textfield here as you want
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                            labelText: "Provinsi",
                            hintText: "Pilih Provinsi",
                          ),
                          
                           ),
                                  //have two mode: menu mode and dialog mode
                          mode: Mode.MENU,
                          //if you want show search box
                          showSearchBox: true,
        
                          //get data from the internet 
                          onFind: (text) async {
                            var response = await http.get(Uri.parse(
                                "https://dev.farizdotid.com/api/daerahindonesia/provinsi"));
        
                            if (response.statusCode == 200) {
                              final data = jsonDecode(response.body);
        
                              setState(() {
                                _get = data['provinsi'];
                              });
                            }
        
                            return _get as List<dynamic>;
                          },

        
                          //what do you want anfter item clicked
                          onChanged: (value) {
                            setState(() {                      
                              provinsi = value['nama'];
                              kodeProvinsi = value['id'];
                            });
                          },
                          
                          //this data appear in dropdown after clicked
                          itemAsString: (item) => item['nama'],
                        ),
                        */
                SizedBox(
                  height: 10,
                ),
                //show data in text
                Text(
                  "Provinsi yang Dipilih: ${provinsi}",
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Kode Provinsi yang Dipilih: ${kodeProvinsi}",
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
