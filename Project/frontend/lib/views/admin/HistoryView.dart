import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../model/Bill.dart';
import 'AdminHomePage.dart';
import 'addProduct.dart';
import 'ListProducts.dart';
import '../../model/BillDetail.dart';

class HistoryView extends StatefulWidget {
  const HistoryView({super.key});

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  //List<Map<String, dynamic>> list = [];
  List<BillDetail> list = [];
  DateTime now = DateTime.now();

  final _headers = {'Content-Type': 'application/json'};
  String getBackendUrl() {
    // if(Platform.isAndroid){
    //   return 'http://10.0.2.2:8080';
    // }
    return 'http://192.168.42.2:8080';
  }

  Future<void> fetHistory() async {
    final apiUrl = '${getBackendUrl()}/api/v1/history';
    try {
      var res = await http
          .get(Uri.parse(apiUrl))
          .timeout(const Duration(seconds: 6));

      if (res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        setState(() {
          list = data.map((item) => BillDetail.fromMap(item)).toList();
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
    fetHistory();
  }

  int _currenPage = 0;
  final int _perPage = 10;

  @override
  Widget build(BuildContext context) {
    int startIndex = _currenPage * _perPage;
    int endIndex = startIndex + _perPage;
    var mq = MediaQuery.of(context).size;
    String time = DateFormat('dd/MM/yyyy').format(now);
    List<BillDetail> sub_list = list.sublist(
      startIndex,
      endIndex > list.length ? list.length : endIndex,
    );
    //fetchProducts();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hàng đã bán'),
      ),
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
              title: const Text('Trang chủ'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminHomePage()));
              },
            ),
            ),

            Container(
              margin: const EdgeInsets.all(16.0),
              color: Colors.grey,
              child: ListTile(
              title: const Text('Thêm sản phẩm'),
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AddProduct()));
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
              itemCount: sub_list.length,
              itemBuilder: (context,index) {
                BillDetail item = sub_list[index];
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
                    margin: EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.memory(
                              Uint8List.fromList(
                                  base64Decode(item.image_data)),
                              width: 150,
                              height: 180,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(width: 10,),
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
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Số lượng: ${item.quantity.toString()}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                   Text(
                                    'Người mua: ${item.user_name}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Thời gian: ${item.time}',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item.done! ? 'Hoàn thành' : 'Đang giao',
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
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
              Text("Page ${_currenPage + 1}",style: TextStyle(fontSize: 17),),
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
