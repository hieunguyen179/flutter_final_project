import 'dart:async';
import 'dart:convert';
import 'package:mysql_client/mysql_client.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:mysql1/mysql1.dart';
import '../models/ProductModel.dart';
import '../models/CartModel.dart';
import '../models/Bill.dart';
import '../DBService/DBService.dart';
import '../models/CartDetail.dart';
import '../models/BillDetail.dart';

class ProductRouter {
  Router get router {
    final router = Router();

    router.get('/product', _getProductHandler);
    router.get('/product/<category>', _getProductCategoryHandler);
    router.post('/product', _addProductHandler);
    router.delete('/product/<id>', _deleteProductHandler);
    router.put('/product/<id>', _updateProductHandler);

    router.get('/cart/<name>', _getCartHandler);
    router.post('/cart', _addCartHandler);
    router.delete('/cart/<id>', _DeleteCartHandler);

    router.get('/history', _getAllHistory);
    router.get('/history/<name>', _getHistoryHandler);
    router.post('/history', _addHistoryHandler);
    router.put('/history/<name>', _UpdateUserHistoryHandler);

    router.post('/login', _LoginHandler);
    router.post('/register', _RegisTerHandler);

    return router;
  }

  static final _headers = {'Content-Type': 'application/json'};

  Mysql service = Mysql();

  Future<Response> _getProductHandler(Request req) async {
    try {
      final conn = await service.getConnect();
      await conn.connect();
      var result = await conn.execute("SELECT * FROM products");
      List<ProductModel> productList = [];
      for (var row in result.rows) {
        productList.add(ProductModel(
            id: int.tryParse(row.colAt(0)!),
            name: row.colAt(1),
            type: row.colAt(2),
            price: int.tryParse(row.colAt(3)!),
            quantity: int.tryParse(row.colAt(4)!),
            size: row.colAt(5),
            image_data: row.colAt(6)));
      }
      conn.close();
      return Response.ok(
          jsonEncode(productList.map((product) => product.toMap()).toList()),
          headers: _headers);
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getProductCategoryHandler(Request req, String category) async {
    try {
      final conn = await service.getConnect();
      await conn.connect();
      category = category.replaceAll('_', ' ');
      var result = await conn.execute("SELECT * FROM products WHERE type = :category", {"category" : category});
      List<ProductModel> productList = [];
      for (var row in result.rows) {
        productList.add(ProductModel(
            id: int.tryParse(row.colAt(0)!),
            name: row.colAt(1),
            type: row.colAt(2),
            price: int.tryParse(row.colAt(3)!),
            quantity: int.tryParse(row.colAt(4)!),
            size: row.colAt(5),
            image_data: row.colAt(6)));
      }
      conn.close();
      return Response.ok(
          jsonEncode(productList.map((product) => product.toMap()).toList()),
          headers: _headers);
    }
    catch(e) {
       return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _addProductHandler(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = json.decode(payload);
      ProductModel newProduct = ProductModel.fromMap(data);
      final conn = await service.getConnect();
      await conn.connect();
      var res = await conn.execute(
        "INSERT INTO products (name, type,price,quantity,size,image_data) VALUES (:name, :type,:price, :quantity, :size, :image_data)",
        {
          "name": newProduct.name, //name,
          "type": newProduct.type, // type,
          "price": newProduct.price, // price,
          "quantity": newProduct.quantity, // quantity,
          "size": newProduct.size, // size,
          "image_data": newProduct.image_data // imageData,
        },
      );
      print(res.affectedRows);
      conn.close();
      return Response.ok(jsonEncode({'message': 'succesfully'}));
    } catch (e) {
      print('Loi : ${e.toString()}');
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _deleteProductHandler(Request req, String _id) async {
    int id = int.parse(_id);
    try {
      final conn = await service.getConnect();
      await conn.connect();
      var result = await conn
          .execute("DELETE FROM products WHERE id = :id  ", {"id": id});
      conn.close();
      return Response.ok(jsonEncode({'message': 'succesfully'}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _updateProductHandler(Request req, String _id) async {
    int id = int.parse(_id);
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);
      String newName = data['name'];
      String newType = data['type'];
      String newSize = data['size'];
      final conn = await service.getConnect();
      await conn.connect();
      var res = await conn.execute(
          "UPDATE products SET name = :name, type = :type, size = :size WHERE id = :id",
          {"name": newName, "type": newType, "size": newSize, "id": id});
      conn.close();
      return Response.ok(jsonEncode({'message': 'successfully'}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getCartHandler(Request req, String name) async {
    try {
      final conn = await service.getConnect();
      await conn.connect();
      var result = await conn.execute(
          "SELECT cart.id,cart.name,products.name,products.size,products.price,products.image_data,cart.id_product,cart.quantity FROM cart,products WHERE cart.name = :name AND cart.id_product = products.id",
          {"name": name});
      List<CartDetail> list = [];
      for (var row in result.rows) {
        list.add(CartDetail(
          id : int.tryParse(row.colAt(0)!),
          user_name: row.colAt(1),
          name_product: row.colAt(2),
          size: row.colAt(3),
          price: int.tryParse(row.colAt(4)!),
          image_data: row.colAt(5),
          id_product: int.tryParse(row.colAt(6)!),
          quantity: int.tryParse(row.colAt(7)!)
        ));
      }
      conn.close();
      return Response.ok(jsonEncode(list.map((e) => e.toMap()).toList()),
          headers: _headers);
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _addCartHandler(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);
      CartModel item = CartModel.fromMap(data);
      final conn = await service.getConnect();
      await conn.connect();
      var res = await conn.execute(
          "INSERT INTO cart (name,id_product,quantity) VALUES (:name, :id_product, :quantity)",
          {
            "name": item.name,
            "id_product": item.id_product, //id_product,
            "quantity": item.quantity
          });
      print(res.affectedRows);
      conn.close();
      return Response.ok(jsonEncode({'message': 'successfully'}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _DeleteCartHandler(Request req, String _id) async {
    int id = int.parse(_id);
    try {
      final conn = await service.getConnect();
      await conn.connect();
      var result =
          await conn.execute("DELETE FROM cart WHERE id = :id  ", {"id": id});
      conn.close();
      return Response.ok(jsonEncode({'message': 'succesfully'}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getAllHistory(Request req) async {
    try {
      final conn = await service.getConnect();
      await conn.connect();
      var res = await conn.execute('''SELECT bill.id,bill.name,products.name,bill.id_product,products.type,
      products.size,products.price,bill.quantity,
      products.image_data,bill.time,bill.done,bill.address 
      FROM bill,products 
      WHERE bill.id_product = products.id''');
      List<BillDetail> list = [];
      for (var row in res.rows) {
        list.add(BillDetail(
          id: int.tryParse(row.colAt(0)!),
          user_name: row.colAt(1),
          name_product: row.colAt(2),
          id_product: row.colAt(3),
          type: row.colAt(4),
          size: row.colAt(5),
          price: int.tryParse(row.colAt(6)!),
          quantity: int.tryParse(row.colAt(7)!),
          image_data: row.colAt(8),
          time: row.colAt(9),
          done: row.colAt(10) == "0" ? false : true,
          address: row.colAt(11),
        ));
      }
      conn.close();
      return Response.ok(jsonEncode(list.map((e) => e.toMap()).toList()),
          headers: _headers);
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _getHistoryHandler(Request req, String name) async {
    try {
      final conn = await service.getConnect();
      await conn.connect();
      var res = await conn.execute('''SELECT bill.id,bill.name,products.name,bill.id_product,products.type,
      products.size,products.price,bill.quantity,
      products.image_data,bill.time,bill.done,bill.address 
      FROM bill,products 
      WHERE bill.id_product = products.id AND bill.name = :name''', {"name" : name});
      List<BillDetail> list = [];
      for (var row in res.rows) {
        list.add(BillDetail(
          id: int.tryParse(row.colAt(0)!),
          user_name: row.colAt(1),
          name_product: row.colAt(2),
          id_product: row.colAt(3),
          type: row.colAt(4),
          size: row.colAt(5),
          price: int.tryParse(row.colAt(6)!),
          quantity: int.tryParse(row.colAt(7)!),
          image_data: row.colAt(8),
          time: row.colAt(9),
          done: row.colAt(10) == "0" ? false : true,
          address: row.colAt(11),
        ));
      }
      conn.close();
      return Response.ok(jsonEncode(list.map((e) => e.toMap()).toList()),
          headers: _headers);
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString}));
    }
  }

  Future<Response> _addHistoryHandler(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);
      Bill item = Bill.fromMap(data);
      final conn = await service.getConnect();
      await conn.connect();
      var res = await conn.execute(
          "INSERT INTO bill(name,id_product,quantity,address,price,done,time) VALUES (:name,:id_product,:quantity,:address,:price,:done,:time)",
          {
            "name": item.user_name,
            "id_product": item.id_product,
            "quantity": item.quantity,
            "address": item.address,
            "price": item.price,
            "done": item.done,
            "time": item.time,
          });
      // var sql = await conn.execute(
      //     "SELECT quantity FROM products WHERE id = :id LIMIT 1",
      //     {"id": item.id_product});
      // int? total_quantity;
      // for (var row in sql.rows) {
      //   total_quantity = int.tryParse(row.colAt(0)!);
      // }
      // int quantity = total_quantity! - item.quantity!;
      // var res2 = await conn.execute(
      //     "UPDATE products SET quantity = :quantity WHERE id = :id",
      //     {"quantity": quantity, "id": item.id_product});
      conn.close();
      return Response.ok(jsonEncode({'message': 'successfully'}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _UpdateUserHistoryHandler(Request req, String name) async {
    try {
      String done = "1";
      final payload = await req.readAsString();
      final data = jsonDecode(payload);
      int id = data['id'];
      final conn = await service.getConnect();
      await conn.connect();
      var res = await conn.execute(
          "UPDATE bill SET done = :done WHERE name = :name AND id = :id",
          {"done": done, "name": name, "id": id});
      await conn.close();
      return Response.ok(jsonEncode({'message': 'successfully'}));
    } catch (e) {
      return Response.internalServerError(body: jsonEncode({'error'}));
    }
  }

  Future<Response> _LoginHandler(Request req) async {
    try {
      final payload = await req.readAsString();
      final data = jsonDecode(payload);
      String name = data['name'];
      String password = data['password'];
      final conn = await service.getConnect();
      await conn.connect();
      var res = await conn.execute(
          "SELECT * FROM user WHERE name = :name AND password = :password",
          {"name": name, "password": password});
      String? role = '';
      String? name0 = '';
      for (var row in res.rows) {
        role = row.colAt(2);
        name0 = row.colAt(0);
      }
      if (role!.isEmpty && name0!.isEmpty) {
        return Response.ok(jsonEncode({'message': 'empty'}));
      }
      conn.close();
      return Response.ok(jsonEncode({
        'role': role,
        'name': name0,
      }));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }

  Future<Response> _RegisTerHandler(Request req) async {
    try {
      final conn = await service.getConnect();
      await conn.connect();
      final payload = await req.readAsString();
      final data = jsonDecode(payload);
      String name = data['name'];
      String password = data['password'];
      var res = await conn.execute(
          "INSERT INTO user (name,password,role) VALUES (:name, :password, :role)",
          {
            "name": name,
            "password": password,
            "role": "user",
          });
      await conn.close();
      return Response.ok(jsonEncode({'message': 'successfully'}));
    } catch (e) {
      return Response.internalServerError(
          body: jsonEncode({'error': e.toString()}));
    }
  }
}
