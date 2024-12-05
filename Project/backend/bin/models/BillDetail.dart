// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class BillDetail {
  int? id;
  String? user_name;
  String? name_product;
  String? id_product;
  String? type;
  String? size;
  int? price;
  int? quantity;
  dynamic image_data;
  String? time;
  bool? done;
  String? address;
  BillDetail({
    this.id,
    this.user_name,
    this.name_product,
    this.id_product,
    this.type,
    this.size,
    this.price,
    this.quantity,
    required this.image_data,
    this.time,
    this.done,
    this.address,
  });

  BillDetail copyWith({
    int? id,
    String? user_name,
    String? name_product,
    String? id_product,
    String? type,
    String? size,
    int? price,
    int? quantity,
    dynamic? image_data,
    String? time,
    bool? done,
    String? address,
  }) {
    return BillDetail(
      id: id ?? this.id,
      user_name: user_name ?? this.user_name,
      name_product: name_product ?? this.name_product,
      id_product: id_product ?? this.id_product,
      type: type ?? this.type,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      image_data: image_data ?? this.image_data,
      time: time ?? this.time,
      done: done ?? this.done,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_name': user_name,
      'name_product': name_product,
      'id_product': id_product,
      'type': type,
      'size': size,
      'price': price,
      'quantity': quantity,
      'image_data': image_data,
      'time': time,
      'done': done,
      'address': address,
    };
  }

  factory BillDetail.fromMap(Map<String, dynamic> map) {
    return BillDetail(
      id: map['id'] != null ? map['id'] as int : null,
      user_name: map['user_name'] != null ? map['user_name'] as String : null,
      name_product: map['name_product'] != null ? map['name_product'] as String : null,
      id_product: map['id_product'] != null ? map['id_product'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      size: map['size'] != null ? map['size'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      image_data: map['image_data'] as dynamic,
      time: map['time'] != null ? map['time'] as String : null,
      done: map['done'] != null ? map['done'] as bool : null,
      address: map['address'] != null ? map['address'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory BillDetail.fromJson(String source) => BillDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'BillDetail(id: $id, user_name: $user_name, name_product: $name_product, id_product: $id_product, type: $type, size: $size, price: $price, quantity: $quantity, image_data: $image_data, time: $time, done: $done, address: $address)';
  }

  @override
  bool operator ==(covariant BillDetail other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user_name == user_name &&
      other.name_product == name_product &&
      other.id_product == id_product &&
      other.type == type &&
      other.size == size &&
      other.price == price &&
      other.quantity == quantity &&
      other.image_data == image_data &&
      other.time == time &&
      other.done == done &&
      other.address == address;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user_name.hashCode ^
      name_product.hashCode ^
      id_product.hashCode ^
      type.hashCode ^
      size.hashCode ^
      price.hashCode ^
      quantity.hashCode ^
      image_data.hashCode ^
      time.hashCode ^
      done.hashCode ^
      address.hashCode;
  }
}
