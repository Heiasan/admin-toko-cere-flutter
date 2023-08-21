// import 'package:flutter/widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:login_dio/session.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class Session {
//   final SharedPreferences prefs;

//   Session(this.prefs);

//   Future<void> setToken(String token) async {
//     await prefs.setString('token', token);
//   }

//   String? getToken() {
//     return prefs.getString('token');
//   }

//   Future<void> setData(String data) async {
//     await prefs.setString('data', data);
//   }

//   String? getData() {
//     return prefs.getString('data');
//   }
// }

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   final session = Session(prefs);

//   // Simpan token
//   String token =
//       'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIxIiwianRpIjoiMzFiNDFiMjY4MmEyYmQyZTg5NDhkZDVmYmNlMmJmMDQwMmI1ZDFlMWMzZDcxZmIyYjUwZjdkYWVkYWZkZjJhNTc1OTYyZjk1NzIwOGJmNWUiLCJpYXQiOjE2OTEzOTQwNDguMDAyMTE3LCJuYmYiOjE2OTEzOTQwNDguMDAyMTE5LCJleHAiOjE3MjMwMTY0NDcuOTkxNDc3LCJzdWIiOiI1Iiwic2NvcGVzIjpbXX0.RFTHvsu0JQSgzUxwnlfduv0gApdI1atsuoFI5NGlUxzi2bjApOcrOaNJ6aeABuo0mEwYjsRWhKU1oPoQKuFm1R-01W9Tpp0LdthmHrMQVAFetzquPHCZSTSowmnNwDj9N-D1h_a0Vi_T2RjPBzPERIMZeWECdjROBjWmpY2lk2qZp70yYi1LffbHpKwrW6B61lQeTd8RzNsarnSNuUNMdREtrPiaEDePDPeCZuw9gTRZcRj57qRgZSPipT1XufbMV-0ZIaM3Qiyhr_47vxRwLMaoK3DywXeSH6v5xWH88ed1jtIuyu_473LkBnFSxVAoZzQtFhC4Qt3dALy8ZHe9HRQdG6do--1kcVorlRch39_kgtwSGnG55JqhtLETp-MPi3aI7mByK8zQANSNAeaWIchIj-h7pl-CDVSR4UK_TipAWclCNchtbhi5IK4DUaXxAS-wywopzbRJ_gOCHQiiZDHgH0D6K-zDOKQoifsCVpnQT8ZfqaRdmAWiXmCYGYr5NcB98WEjSQETU4V9JmrggKxIZFFqRDORrJVUshdi3AH_zXYnD3uGc08gHvhBP8pGW74tPyk7uiU2Uu0a5jLucYCGuk6eeJ6cSwo3a1ERtITHF1Yqq2D_w779tH107EvEmlp4cwF5e6iFMqqxGzkpTn6Kb7B837PNzWJvzAoXaeU';
//   session.setToken(token);

//   // Simpan Data
//   session.setData('Start');

//   // Dapatkan token dan Data
//   String? retrievedToken = session.getToken();
//   String? retrievedData = session.getData();

//   print('Retrieved Token: $retrievedToken');
//   print('Retrieved Data: $retrievedData');
// }
