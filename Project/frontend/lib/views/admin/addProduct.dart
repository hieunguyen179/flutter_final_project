import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/views/admin/AdminHomePage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../model/ProductModel.dart';
import 'ListProducts.dart';
import 'HistoryView.dart';
class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController nameController = TextEditingController();
  TextEditingController sizeController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController typeController = TextEditingController();

  String msg = '';

  File? imagePath;
  String? imageData;
  String? imageName;
  ImagePicker imagePicker = ImagePicker();
  final _headers = {'Content-Type': 'application/json'};

  Future<void> getImage() async {
    var getImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      imagePath = File(getImage!.path);
      imageName = nameController.text;
      imageData = base64Encode(imagePath!.readAsBytesSync());
    });
  }

  String getBackendUrl() {
    // if(Platform.isAndroid){
    //   return 'http://10.0.2.2:8080';
    // }
    return 'http://192.168.42.2:8080';
  }

  Future<void> upLoad() async {
    if(nameController.text.isEmpty || sizeController.text.isEmpty || imagePath == null
      || quantityController.text.isEmpty || typeController.text.isEmpty){
      setState(() {
        msg = 'Không để trống thông tin';
      });
      if(!mounted) return;
      showSnackBar(context);
      return;
    }
    String apiUrl = '${getBackendUrl()}/api/v1/product';
    ProductModel newProduct = ProductModel(
      id: 1,
      name: nameController.text,
      type: typeController.text,
      price: 10000,
      quantity: int.parse(quantityController.text),
      size: sizeController.text,
      image_data: imageData,
    );
    try {
      var res = await http.post(
        Uri.parse(apiUrl),
        headers: _headers,
        body: jsonEncode(
           //{    
                newProduct.toMap()
            // 'name': nameController.text,
            // "type": "So mi",
            // "price": 100000,
            // "quantity": int.parse(quantityController.text),
            // "size": sizeController.text,
            // 'image_data' : imageData
           //},
        ),
      ).timeout(const Duration(seconds: 5));
      if (res.statusCode == 200) {
        print('Da gui qua server thanh cong');
        setState(() {
          msg = 'Thêm sản phẩm thành công';
        });
        if(!mounted) return;
        showSnackBar(context);
      } else {
        print('Gui khong thanh cong');
      }
    } catch (e) {
      print('Loi ${e.toString()}');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm sản phẩm'),
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
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(5.0),
            child: TextFormField(
            controller: nameController,
            decoration: const InputDecoration( border: OutlineInputBorder(),labelText: 'Tên sản phẩm'),
          ),
          ),

          Container(
            margin: const EdgeInsets.all(5.0),
            child: TextFormField(
            controller: sizeController,
            decoration: const InputDecoration( border: OutlineInputBorder(),labelText: 'Size'),
          ),
          ),

          Container(
            margin: const EdgeInsets.all(5.0),
            child: TextFormField(
            controller: quantityController,
            decoration: const InputDecoration( border: OutlineInputBorder(),labelText: 'Số lượng'),
          ),
          ),

          Container(
            margin: const EdgeInsets.all(5.0),
            child: TextFormField(
            controller: typeController,
            decoration: const InputDecoration( border: OutlineInputBorder(),labelText: 'Loại'),
          ),
          ),

          const SizedBox(
            height: 7,
          ),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: imagePath == null
                ? const Center(
                    child: Text('Chưa có ảnh !'),
                  )
                : Image.file(
                    imagePath!,
                    fit: BoxFit.contain,
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
          Center(
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: ElevatedButton(
                    onPressed: getImage,
                    style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                    child: const Text('Chọn ảnh')),
                ),
                Container(
                   margin: EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(onPressed: () {
                    upLoad();
                    
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text('Thêm sản phẩm'))
                ),
              ],
            ),
          ),
          //Text(msg,style: const TextStyle(fontSize: 16),),
        ],
      ),
    );
  }

  showSnackBar(context) {
    SnackBar snackBar = SnackBar(
      content: Text(msg,
          style: const TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.indigo,
        dismissDirection: DismissDirection.up,
        behavior: SnackBarBehavior.floating,
        margin:  EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
          left: 10,
          right: 10
        ),
        duration: const Duration(seconds: 1),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

}
