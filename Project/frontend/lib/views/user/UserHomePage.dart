import 'package:flutter/material.dart';
import 'UserHistotyView.dart';
import 'ListProductView.dart';
import 'CartView/CartView.dart';
import 'ListProductCategory.dart';
import 'package:carousel_slider/carousel_slider.dart';

class UserHomePage extends StatefulWidget {
  const UserHomePage({super.key});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  @override
  Widget build(BuildContext context) {
    final data =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    String name = data!['name'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Xin chào $name'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
                title: const Text('Danh sách sản phẩm'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ListProductsView(name: name)));
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
                      builder: (context) => CartView(name: name)));
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
                      builder: (context) => HistoryView(name: name)));
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
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 1),
              child: Text(
                'Cửa Hàng Thời Trang ABC',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 460,
                  enableInfiniteScroll: true,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: [
                  InkWell(
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return ListProductCategory(
                              category: 'quan_jean', name: name);
                        }),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'lib/assets/Screenshot 2024-12-24 193328.png',
                              height: 310,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Quần Jean',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onLongPress: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) {
                          return ListProductCategory(
                              category: 'so_mi', name: name);
                        }),
                      );
                    },
                    child: Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Expanded(
                            child: Image.asset(
                              'lib/assets/so_mi.png',
                              height: 310,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Text(
                              'Áo Sơ Mi',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
