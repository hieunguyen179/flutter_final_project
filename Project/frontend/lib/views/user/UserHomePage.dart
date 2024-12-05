import 'package:flutter/material.dart';
import 'UserHistotyView.dart';
import 'ListProductView.dart';
import 'CartView/CartView.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)?.settings.arguments as Map<String,dynamic>?;
   String name = data!['name'];
    return Scaffold(
      appBar: AppBar(title:  Text('Xin chao $name'),),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Menu',style: TextStyle(color: Colors.white,fontSize: 20),),
              decoration: BoxDecoration(color: Colors.blue),
            ),

            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
              title: const Text('Danh sách sản phẩm'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ListProductsView(name:name)
              ));
              },
            ),
            ),

            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
              title: const Text('Xem giỏ hàng'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => CartView(name:name)
              ));
              },
            ),
            ),

            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
              title: const Text('Xem sản phẩm đã mua'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => HistoryView(name:name)
              ));
              },
            ),
            ),

            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
              title: const Text('Đăng xuất'),
              onTap: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/',
                  (Route<dynamic> route) => false,
                );
              },
            ),
            ),
          ],
        ),
      ),
      body: const Center(
        child:Text('HOME', style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,
                  color: Colors.blue),),
      ),
    );
  }
}