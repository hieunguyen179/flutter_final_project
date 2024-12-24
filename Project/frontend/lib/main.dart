import 'package:flutter/material.dart';
import 'views/admin/addProduct.dart';
import 'views/admin/AdminHomePage.dart';
import 'views/Login/LoginPage.dart';
import 'views/user/UserHomePage.dart';
void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: {
        '/' : (context) => const LoginPage(),
        '/adminPage' : (context) => const AdminHomePage(),
        '/userPage' : (context) => const UserHomePage()
      },
    );
  }
}
