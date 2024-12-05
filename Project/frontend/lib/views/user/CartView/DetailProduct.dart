import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../../../model/CartModel.dart';
import '../../../model/Bill.dart';
import '../../../model/ProductModel.dart';

class DetaiProduct extends StatefulWidget {
  int id;
  String? name;
  String name_product;
  String size;
  String price;
  dynamic image_data;
  int id_product;
  int quantity;
  DetaiProduct({super.key,required this.id,required this.name, required this.name_product, required this.size,
   required this.price, required this.image_data,required this.id_product, required this.quantity});
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

  Future<void> deleteProductFromCart(String id) async {
    final apiUrl = '${getBackendUrl()}/api/v1/cart';
    try{
      final res = await http.delete(
        Uri.parse('$apiUrl/$id'),
      );
      if(res.statusCode == 200) {
        setState(() {
          Navigator.of(context).pop(true);
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
    controller = TextEditingController(text: "1");
  }

  @override
  Widget build(BuildContext context) {
    var mq = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text('Detail product'),),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 250,
              width: 200,
              margin: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius:const BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
                child: Image.memory(Uint8List.fromList(base64Decode(widget.image_data)),fit: BoxFit.fill,height: mq.height * 0.3,width: mq.width),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(12.0),
              child: Text('Tên: ' + widget.name_product ,style: const TextStyle(fontSize: 18),),
            ),
            const SizedBox(height: 15,),
            Container(
              margin: const EdgeInsets.all(12.0),
              child: Text('Size: ' + widget.size.toString(),style: const TextStyle(fontSize: 18),)
            ),
            const SizedBox(height: 15,),
            Container(
              margin: const EdgeInsets.all(12.0),
              child: Text('Giá: ' + widget.price,style: const TextStyle(fontSize: 18),),
            ),

           // const SizedBox(height: 10,),
            Container(
              margin: const EdgeInsets.all(12.0),
              child: Text('Số lượng: ' + widget.quantity.toString(),style: const TextStyle(fontSize: 18),),
              // child: TextField(
              //   controller: controller,
              //   decoration: InputDecoration(labelText: 'Số lượng'),
              // ),
            ),
            Center(
                  child: ElevatedButton(onPressed: () {
                     deleteProductFromCart(widget.id.toString()!);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                   child: const Text('Xóa khỏi giỏ hàng')),
            ),
          ],
        ),
      ),
    );
  }

  void showDiaLog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Nhập xác nhận xóa'),
          actions: [
            TextButton(onPressed: () {
              Navigator.of(context).pop();
            }, child: const Text('Hủy')
            ),
            ElevatedButton(
            onPressed: () {
              //setState(() {
                // deleteProductFromCart(widget.id.toString());
                // Navigator.of(context).pop();
              //});
            },
             child: const Text('Xác nhận')
             )

          ],
        );
      }
    );
  }
}