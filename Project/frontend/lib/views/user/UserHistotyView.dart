import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../model/Bill.dart';
import 'CartView/CartView.dart';
import 'ListProductView.dart';
import '../../model/BillDetail.dart';

class HistoryView extends StatefulWidget {
  String? name;
  HistoryView({super.key, required this.name});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  List<BillDetail> list = [];

  DateTime now = DateTime.now();

  final _headers = {'Content-Type': 'application/json'};
  String getBackendUrl() {
    // if(Platform.isAndroid){
    //   return 'http://10.0.2.2:8080';
    // }
    return 'http://192.168.42.2:8080';
  }

  Future<void> fetHistory(String name) async {
    final apiUrl = '${getBackendUrl()}/api/v1/history';
    try {
      var res = await http
          .get(Uri.parse('$apiUrl/$name'))
          .timeout(const Duration(seconds: 6));

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        setState(() {
          ///list = data.map((item) => Map<String,dynamic>.from(item)).toList();
          list = data.map((item) => BillDetail.fromMap(item)).toList();
        });
      } else {
        print('Loi ${res.statusCode}');
      }
    } catch (e) {
      print('Loi ${e.toString()}');
    }
  }

  Future<void> updateUserHistoty(String name, int id) async {
    final apiUrl = '${getBackendUrl()}/api/v1/history';
    try {
      var res = await http
          .put(Uri.parse('$apiUrl/$name'),
              headers: _headers, body: jsonEncode({"id": id}))
          .timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        print('Cap nhat thanh cong');
      } else {
        print('Cap nhat that bai');
      }
    } catch (e) {
      print('Loi ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    //fetchProducts();
    fetHistory(widget.name!);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    String time = DateFormat('dd/MM/yyyy').format(now);
    //fetchProducts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm đã mua'),
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
                  String name = widget.name!;
                  Navigator.pushReplacementNamed(context, '/userPage',
                      arguments: {
                        'name': name,
                      });
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
                title: const Text('Danh sách sản phẩm'),
                onTap: () {
                  String name = widget.name!;
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
                  String name = widget.name!;
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CartView(name: name)));
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
              itemCount: list.length,
              itemBuilder: (context, index) {
                BillDetail item = list[index];
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
                  ),
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.memory(
                              Uint8List.fromList(base64Decode(item.image_data)),
                              width: 150,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.name_product!,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    'Số lượng : ${item.quantity.toString()}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                                  Text(
                                    'Thời gian : ${item.time}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 5,),
                                  ElevatedButton(
                                    onPressed: item.done! ? null : () {
                                      setState(() {
                                        item.done = true;
                                        updateUserHistoty(item.user_name!, item.id!);
                                      });
                                    } , 
                                    child: Text(item.done! ? 'Hoàn thành' : 'Đã nhận hàng'),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  bool isDone(String done) {
    if (done == "0") return false;
    return true;
  }
}
