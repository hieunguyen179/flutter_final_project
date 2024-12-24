import 'dart:convert';
import '../admin/AdminHomePage.dart';
import '../user/UserHomePage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// class AdminPage extends StatelessWidget {
//   const AdminPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       //debugShowCheckedModeBanner: false,
//       routes: <String,WidgetBuilder>{
//         '/adminPage' : (BuildContext context) => const AdminHomePage()
//       }
//     );
//   }
// }

// class UserPage extends StatelessWidget {
//   const UserPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       //debugShowCheckedModeBanner: false,
//       routes: <String,WidgetBuilder>{
//         '/userPage' : (BuildContext context) => const UserHomePage()
//       }
//     );
//   }
// }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController nameLoginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _headers = {'Content-Type': 'application/json'};

  String msg = ''; // thông báo đăng kí
  String msg_login = ''; // thông báo đăng nhập

  String getBackendUrl() {
    // if(Platform.isAndroid){
    //   return 'http://10.0.2.2:8080';
    // }
    return 'http://192.168.42.2:8080';
  }

  Future<void> Login() async {
    //final apiUrl = "http://192.168.42.2:8080/api/v1/login";
    //var apiUrl = 'http://192.168.42.2:8080/api/v1/login';
    var apiUrl = '${getBackendUrl()}/api/v1/login';
    try {
      var res = await http
          .post(Uri.parse(apiUrl),
              headers: _headers,
              body: jsonEncode({
                'name': nameLoginController.text,
                'password': passwordController.text,
              }))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['message'] == 'empty') {
          setState(() {
            msg_login = 'Thông tin đăng nhập không chính xác';
          });
          if (!mounted) return;
          showSnackBar(context);
          return;
        }
        String role = data['role'];
        String name = data['name'];
        print('Dang nhap thanh cong ban la $name');
        if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/adminPage');
        } else {
          Navigator.pushReplacementNamed(context, '/userPage', arguments: {
            'name': name,
          });
        }
      }
    } catch (e) {
      print('loi ${e.toString()}');
    }
  }

  Future<void> Register(String name, String password, String rePassWord) async {
    if (name.isEmpty || password.isEmpty || rePassWord.isEmpty) {
      setState(() {
        msg = 'Không để trống thông tin !';
      });
      return;
    }
    if (password != rePassWord) {
      setState(() {
        msg = 'Mật khẩu không khớp !';
      });
      return;
    }
    var apiUrl = '${getBackendUrl()}/api/v1/register';
    try {
      var res = await http
          .post(Uri.parse(apiUrl),
              headers: _headers,
              body: jsonEncode({
                'name': name,
                'password': password,
              }))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        setState(() {
          msg = 'Đăng kí thành công !';
        });
      } else {
        setState(() {
          msg = 'Đăng kí thất bại';
        });
      }
    } catch (e) {
      msg = 'Đăng kí thất bại ! Lỗi ${e.toString()}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Đăng nhập'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/assets/images.png",
              width: 300,
            ),
            Container(
              margin: const EdgeInsets.all(12.0),
              child: TextField(
                controller: nameLoginController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Tên đăng nhập'),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12.0),
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Mật khẩu'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      onPressed: Login,
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Đăng nhập')),
                ),
                Container(
                  margin: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                      onPressed: showDiaLog,
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: Text('Đăng kí')),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void showDiaLog() {
    TextEditingController _nameController = TextEditingController();
    TextEditingController _passwordController = TextEditingController();
    TextEditingController _rePasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        String localMsg =
            msg; // Tạo một biến cục bộ để lưu thông điệp cho dialog

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              title: const Text('Nhập thông tin'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Text(
                        localMsg,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Tên đăng nhập',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Mật khẩu',
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _rePasswordController,
                        obscureText: true,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Nhập lại mật khẩu',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Hủy'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    await Register(
                      _nameController.text,
                      _passwordController.text,
                      _rePasswordController.text,
                    );

                    // Cập nhật thông báo trong dialog
                    setDialogState(() {
                      localMsg =
                          msg; // Gán thông báo từ biến `msg` bên ngoài vào biến cục bộ
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Đăng kí'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  showSnackBar(context) {
    SnackBar snackBar = SnackBar(
      content: Text(
        msg_login,
        style: const TextStyle(fontSize: 20),
      ),
      backgroundColor: Colors.indigo,
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
