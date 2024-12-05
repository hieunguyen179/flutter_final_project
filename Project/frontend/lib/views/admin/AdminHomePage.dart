import 'package:flutter/material.dart';
import 'package:frontend/views/admin/addProduct.dart';
import 'ListProducts.dart';
import 'HistoryView.dart';
class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Xin chào Admin'),),
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
              title: const Text('Thêm sản phẩm'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AddProduct()
              ));
              },
            ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
              title: const Text('Danh sách sản phẩm'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ListProductsView()));
              },
            ),
            ),

            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
              title: const Text('Lịch sử bán hàng'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HistoryView()));
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
      body: Center(
        child: Text('HOME', style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,
                  color: Colors.blue),),
      )
    );
  }
}