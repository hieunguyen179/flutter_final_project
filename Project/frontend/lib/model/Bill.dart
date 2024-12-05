// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class Bill {
  int? id;
  String? user_name;
  int? id_product;
  int? quantity;
  String? address;
  int? price;
  bool? done;
  String? time;
  Bill({
    this.id,
    this.user_name,
    this.id_product,
    this.quantity,
    this.address,
    this.price,
    this.done,
    this.time,
  });

  Bill copyWith({
    int? id,
    String? user_name,
    int? id_product,
    int? quantity,
    String? address,
    int? price,
    bool? done,
    String? time,
  }) {
    return Bill(
      id: id ?? this.id,
      user_name: user_name ?? this.user_name,
      id_product: id_product ?? this.id_product,
      quantity: quantity ?? this.quantity,
      address: address ?? this.address,
      price: price ?? this.price,
      done: done ?? this.done,
      time: time ?? this.time,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_name': user_name,
      'id_product': id_product,
      'quantity': quantity,
      'address': address,
      'price': price,
      'done': done,
      'time': time,
    };
  }

  factory Bill.fromMap(Map<String, dynamic> map) {
    return Bill(
      id: map['id'] != null ? map['id'] as int : null,
      user_name: map['user_name'] != null ? map['user_name'] as String : null,
      id_product: map['id_product'] != null ? map['id_product'] as int : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      address: map['address'] != null ? map['address'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      done: map['done'] != null ? map['done'] as bool : null,
      time: map['time'] != null ? map['time'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Bill.fromJson(String source) => Bill.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Bill(id: $id, user_name: $user_name, id_product: $id_product, quantity: $quantity, address: $address, price: $price, done: $done, time: $time)';
  }

  @override
  bool operator ==(covariant Bill other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user_name == user_name &&
      other.id_product == id_product &&
      other.quantity == quantity &&
      other.address == address &&
      other.price == price &&
      other.done == done &&
      other.time == time;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user_name.hashCode ^
      id_product.hashCode ^
      quantity.hashCode ^
      address.hashCode ^
      price.hashCode ^
      done.hashCode ^
      time.hashCode;
  }
}
