import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../model/CartModel.dart';
import '../ListProductView.dart';
import '../UserHistotyView.dart';
import 'DetailProduct.dart';
import '../../../model/CartDetail.dart';

class CartView extends StatefulWidget {
  String name;
  CartView({super.key, required this.name});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView > {

    List<CartDetail> list = [];
    String msg = '';

    String getBackendUrl() {
    // if(Platform.isAndroid){
    //   return 'http://10.0.2.2:8080';
    // }
    return 'http://192.168.42.2:8080';
  }
  

  Future<void> fetchProductsFromCart(String name) async {
    final apiUrl = '${getBackendUrl()}/api/v1/cart';
    try{
      final res = await http.get(Uri.parse('$apiUrl/$name'));
      if(res.statusCode == 200) {
        final List<dynamic> data = jsonDecode(res.body);
        setState(() {
          list = data.map((e) => CartDetail.fromMap(e)).toList();
          if(list.isEmpty) {
            msg = 'Trống !';
          }
          //print(list[0]['quantity']);
        });
      }
      else{
        print('Loi ${res.statusCode}');
      }
    }
    catch(e) {
      print('Loi ${e.toString()}');
    }
  }

  Future<void> deleteProductFromCart(String id) async {
    final apiUrl = '${getBackendUrl()}/api/v1/cart';
    try{
      final res = await http.delete(
        Uri.parse('$apiUrl/$id'),
      );
      if(res.statusCode == 200) {
        setState(() {
          fetchProductsFromCart(widget.name.toString());
        });
      }
      else{
        print('Xoa that bai');
      }

    }
    catch(e) {
      print('Loi ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProductsFromCart(widget.name);
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    //fetchProducts();
    return Scaffold(
      appBar: AppBar(title: Text('Giỏ hàng của bạn: ' + msg),),
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
                String name = widget.name!;
                Navigator.pushReplacementNamed(context,'/userPage',arguments : {'name' : name,});
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
                builder: (context) => ListProductsView(name:name)
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
                String name = widget.name!;
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: list.length,
              itemBuilder: (context, index) {
                CartDetail item = list[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      )
                    ]
                  ),
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.all(8.0),
                    color: Colors.white,
                    child: InkWell(
                      onLongPress: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) {
                            return DetaiProduct(
                              id: item.id!, 
                              name: item.user_name, 
                              name_product: item.name_product!, 
                              size: item.size!, 
                              price: item.price.toString(), 
                              image_data: item.image_data, 
                              id_product: item.id_product!, 
                              quantity: item.quantity!
                            );
                          }
                        )).then((value) {
                          if(value == true) {
                            fetchProductsFromCart(item.user_name!);
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
                                base64Decode(item.image_data)
                              ),
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
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),

                                  Text(
                                    "${item.price.toString()}\$",
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),

                                  Text('Số lượng: ' + item.quantity.toString(),
                                        style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),)
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
          )
        ],
      )
    );
  }
}