import 'dart:convert';
//import 'dart:js_interop';
import 'dart:typed_data';
import 'package:frontend/views/admin/addProduct.dart';

import 'AdminHomePage.dart';
import 'HistoryView.dart';
import 'detaiProduct.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../model/ProductModel.dart';

class ListProductsView extends StatefulWidget {
  const ListProductsView({super.key});

  @override
  State<ListProductsView> createState() => _ListProductsViewState();
}

class _ListProductsViewState extends State<ListProductsView> {
  //List<Map<String, dynamic>> list = [];
  List<ProductModel> list = [];
  String getBackendUrl() {
    // if(Platform.isAndroid){
    //   return 'http://10.0.2.2:8080';
    // }
    return 'http://192.168.42.2:8080';
  }

  Future<void> fetchProducts() async {
    final apiUrl = '${getBackendUrl()}/api/v1/product';
    try {
      final res = await http.get(Uri.parse(apiUrl));
      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        setState(() {
          //list = data.map((item) => Map<String,dynamic>.from(item)).toList();
          list = data.map((item) => ProductModel.fromMap(item)).toList();
          //print(list[0]['quantity']);
        });
      } else {
        print('Loi ${res.statusCode}');
      }
    } catch (e) {
      print('Loi ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  int _currenPage = 0;
  final int _perPage = 3;

  @override
  Widget build(BuildContext context) {
    int startIndex = _currenPage * _perPage;
    int endIndex = startIndex + _perPage;
    List<ProductModel> list_products = list.sublist(
      startIndex,
      endIndex > list.length ? list.length : endIndex,
    );
    var mq = MediaQuery.of(context).size;
    //fetchProducts();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Danh sách sản phẩm'),
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
                title: const Text('Trang chủ'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AdminHomePage()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
                title: const Text('Thêm sản phẩm'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddProduct()));
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
                title: const Text('Lịch sử bán hàng'),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const HistoryView()));
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list_products.length,
              itemBuilder: (context, index) {
                ProductModel product = list_products[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    // gradient: LinearGradient(
                    //   colors: [Colors.blue[50]!, Colors.blue[100]!],
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    // ),
                  ),
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: InkWell(
                      onLongPress: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return DetaiProduct(
                              name: product.name!,
                              type: product.type!,
                              size: product.size!,
                              id: product.id.toString());
                        })).then((value) {
                          if (value == true) {
                            fetchProducts();
                          }
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.memory(
                              Uint8List.fromList(
                                  base64Decode(product.image_data)),
                              width: 150,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name!,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    "${product.price.toString()}\$",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: _currenPage > 0
                    ? () {
                        setState(() {
                          _currenPage--;
                        });
                      }
                    : null,
                child: const Text('Previous'),
              ),
              Text("Page ${_currenPage + 1}"),
              TextButton(
                onPressed: endIndex < list.length
                    ? () {
                        setState(() {
                          _currenPage++;
                        });
                      }
                    : null,
                child: const Text("Next"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
