// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CartDetail {
  int? id;
  String? user_name;
  String? name_product;
  String? size;
  int? price;
  dynamic image_data;
  int? id_product;
  int? quantity;
  CartDetail({
    this.id,
    this.user_name,
    this.name_product,
    this.size,
    this.price,
    required this.image_data,
    this.id_product,
    this.quantity,
  });

  CartDetail copyWith({
    int? id,
    String? user_name,
    String? name_product,
    String? size,
    int? price,
    dynamic? image_data,
    int? id_product,
    int? quantity,
  }) {
    return CartDetail(
      id: id ?? this.id,
      user_name: user_name ?? this.user_name,
      name_product: name_product ?? this.name_product,
      size: size ?? this.size,
      price: price ?? this.price,
      image_data: image_data ?? this.image_data,
      id_product: id_product ?? this.id_product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user_name': user_name,
      'name_product': name_product,
      'size': size,
      'price': price,
      'image_data': image_data,
      'id_product': id_product,
      'quantity': quantity,
    };
  }

  factory CartDetail.fromMap(Map<String, dynamic> map) {
    return CartDetail(
      id: map['id'] != null ? map['id'] as int : null,
      user_name: map['user_name'] != null ? map['user_name'] as String : null,
      name_product: map['name_product'] != null ? map['name_product'] as String : null,
      size: map['size'] != null ? map['size'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      image_data: map['image_data'] as dynamic,
      id_product: map['id_product'] != null ? map['id_product'] as int : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartDetail.fromJson(String source) => CartDetail.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartDetail(id: $id, user_name: $user_name, name_product: $name_product, size: $size, price: $price, image_data: $image_data, id_product: $id_product, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant CartDetail other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user_name == user_name &&
      other.name_product == name_product &&
      other.size == size &&
      other.price == price &&
      other.image_data == image_data &&
      other.id_product == id_product &&
      other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user_name.hashCode ^
      name_product.hashCode ^
      size.hashCode ^
      price.hashCode ^
      image_data.hashCode ^
      id_product.hashCode ^
      quantity.hashCode;
  }
}
