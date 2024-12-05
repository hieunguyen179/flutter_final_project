import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../model/CartModel.dart';
import '../../model/Bill.dart';
import '../../model/ProductModel.dart';

class DetaiProduct extends StatefulWidget {
  String? name;
  String name_product;
  String size;
  String type;
  String price;
  dynamic image_data;
  int id_product;
  int quantity;
  DetaiProduct(
      {super.key,
      required this.name,
      required this.name_product,
      required this.size,
      required this.type,
      required this.price,
      required this.image_data,
      required this.id_product,
      required this.quantity});
  @override
  State<DetaiProduct> createState() => _DetaiProductState();
}

class _DetaiProductState extends State<DetaiProduct> {
  String address = '';
  String msg = '';
  TextEditingController controller = TextEditingController();
  DateTime now = DateTime.now();
  final _headers = {'Content-Type': 'application/json'};

  String getBackendUrl() {
    // if(Platform.isAndroid){
    //   return 'http://10.0.2.2:8080';
    // }
    return 'http://192.168.42.2:8080';
  }

  Future<void> addCart() async {
    if (int.parse(controller.text) > widget.quantity) {
      setState(() {
        msg = 'Quá số lượng';
      });
      if (!mounted) return;
      showSnackBar(context);
      return;
    }
    String apiUrl = '${getBackendUrl()}/api/v1/cart';
    CartModel item = CartModel(
      id: 1,
      name: widget.name,
      id_product: widget.id_product,
      quantity: int.parse(controller.text),
    );
    try {
      var res = await http.post(Uri.parse(apiUrl),
          headers: _headers,
          body: jsonEncode(
              //{
              item.toMap()
              // 'name' : widget.name,
              // 'name_product' : widget.name_product,
              // 'size' : widget.size,
              // 'price' : int.parse(widget.price),
              // 'image_data' : widget.image_data,
              // 'id_product' : widget.id_product,
              // 'quantity' : int.parse(controller.text)
              //}
              ));

      if (res.statusCode == 200) {
        print('Them vao gio hang thanh cong');
        setState(() {
          msg = 'Thêm vào giỏ hàng thành công';
        });
        if (!mounted) return;
        showSnackBar(context);
      } else {
        print('Them vao gio hang that bai');
      }
    } catch (e) {
      print('Loi ${e.toString()}');
    }
  }

  Future<void> addHistory() async {
    if (address.isEmpty) return;
    String time = DateFormat('dd/MM/yyyy').format(now);
    Bill item = Bill(
      id: 1,
      user_name: widget.name,
      id_product: widget.id_product,
      quantity: int.parse(controller.text),
      address: address,
      price: int.parse(widget.price),
      done: false,
      time: time,
    );
    String apiUrl = '${getBackendUrl()}/api/v1/history';

    try {
      var res = await http
          .post(Uri.parse(apiUrl),
              headers: _headers, body: jsonEncode(item.toMap()))
          .timeout(Duration(seconds: 6));
      if (res.statusCode == 200) {
        print('Mua hang thanh cong');
        setState(() {
          msg = 'Mua hàng thành công !';
        });
        if (!mounted) return;
        showSnackBar(context);
      } else {
        print('Mua hang that bai');
      }
    } catch (e) {
      print('Loi ${e.toString()}');
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: "1");
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail product'),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 250,
              width: 200,
              margin: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                child: Image.memory(
                    Uint8List.fromList(base64Decode(widget.image_data)),
                    fit: BoxFit.fill,
                    height: mq.height * 0.3,
                    width: mq.width),
              ),
            ),
            Container(
              margin: EdgeInsets.all(12.0),
              child: Text('Tên: ' + widget.name_product),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
                margin: EdgeInsets.all(12.0),
                child: Text('Size: ' + widget.size.toString())),
            const SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.all(12.0),
              child: Text('Giá: ' + widget.price),
            ),

            // const SizedBox(height: 10,),
            Container(
              //margin: EdgeInsets.all(8.0),
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Số lượng'),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: addCart,
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Thêm vào giỏ hàng')),
                ),
                Container(
                  margin: EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: showDiaLog,
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Mua sản phẩm')),
                )
              ],
            ),
            // Container(
            //   margin: EdgeInsets.all(12.0),
            //   child: Text(msg,style: TextStyle(fontSize: 16,),)
            // )
          ],
        ),
      ),
    );
  }

  void showDiaLog() {
    TextEditingController controller = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Nhập địa chỉ'),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(
                labelText: 'Nhập địa chỉ',
                border: OutlineInputBorder(),
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Hủy')),
              ElevatedButton(
                  onPressed: () {
                    setState(() {
                      address = controller.text;
                      addHistory();
                    });
                    Navigator.of(context).pop();
                  },
                  child: Text('Xác nhận'))
            ],
          );
        });
  }

  showSnackBar(context) {
    //FocusScope.of(context).unfocus(); // Ẩn bàn phím
    SnackBar snackBar = SnackBar(
      content: Text(
        msg,
        style: const TextStyle(fontSize: 16),
      ),
      backgroundColor: Colors.indigo,
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 50, left: 10, right: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Tạo góc bo tròn
      ),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
