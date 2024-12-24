import 'dart:convert';
import '../../model/ProductModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;

class DetaiProduct extends StatefulWidget {
  String name;
  String type;
  String size;
  String id;
  //ProductModel product = ProductModel();
  DetaiProduct({super.key, required this.name, required this.type, required this.size, required this.id});

  @override
  State<DetaiProduct> createState() => _DetaiProductState();
}

class _DetaiProductState extends State<DetaiProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController sizeController = TextEditingController();

  final _headers = {'Content-Type': 'application/json'};

    String getBackendUrl() {
    // if(Platform.isAndroid){
    //   return 'http://10.0.2.2:8080';
    // }
    return 'http://192.168.42.2:8080';
  }

  Future<void> updateProduct(String id) async {
    if(nameController.text.isEmpty || typeController.text.isEmpty || sizeController.text.isEmpty){
      return;
    }
    final apiUrl = '${getBackendUrl()}/api/v1/product';
    try{
      final res = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: _headers,
        body: jsonEncode({
          'name' : nameController.text,
          'type' : typeController.text,
          'size' : sizeController.text,
        })
      );
      if(res.statusCode == 200) {
        print('Update thanh cong');
        setState(() {
           Navigator.of(context).pop(true);
        });
      }
      else{
        print('Update khong thanh cong');
      }
    }
    catch(e){
      print('Loi ${e.toString()}');
    }
  }

  Future<void> deleteProduct(int id) async {
    final apiUrl = '${getBackendUrl()}/api/v1/product';
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
    nameController = TextEditingController(text: widget.name);
    typeController = TextEditingController(text: widget.type);
    sizeController = TextEditingController(text: widget.size.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiêt sản phẩm'),),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
                controller: nameController,
                decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Tên sản phẩm'),
            ),
          ),
          const SizedBox(height: 15,),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
                controller: typeController,
                decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Loại sản phẩm'),
            ),
          ),
          const SizedBox(height: 15,),
          Container(
            margin: EdgeInsets.all(10),
            child: TextField(
                controller: sizeController,
                decoration: const InputDecoration(border: OutlineInputBorder(),labelText: 'Size'),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.all(13),
                child: ElevatedButton(onPressed: () {
                    updateProduct(widget.id);
                    //if(!mounted) return;
                    //Navigator.of(context).pop(true);
                   //Navigator.pop(context,'reload');
                },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                 child: const Text('Lưu sản phẩm')),
              ),
              Container(
                margin: EdgeInsets.all(13),
                child: ElevatedButton(onPressed: () {
                  deleteProduct(int.parse(widget.id));
                },
                style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                 child: Text('Xóa sản phẩm')),
              )
            ],
          ),
        ],
      ),
    );
  }
}