// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ProductModel {
  int? id;
  String? name;
  String? type;
  int? price;
  int? quantity;
  String? size;
  dynamic image_data;
  ProductModel({
    this.id,
    this.name,
    this.type,
    this.price,
    this.quantity,
    this.size,
    required this.image_data,
  });

  ProductModel copyWith({
    int? id,
    String? name,
    String? type,
    int? price,
    int? quantity,
    String? size,
    dynamic? image_data,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      size: size ?? this.size,
      image_data: image_data ?? this.image_data,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'quantity': quantity,
      'size': size,
      'image_data': image_data,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      type: map['type'] != null ? map['type'] as String : null,
      price: map['price'] != null ? map['price'] as int : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
      size: map['size'] != null ? map['size'] as String : null,
      image_data: map['image_data'] as dynamic,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'ProductModel(id: $id, name: $name, type: $type, price: $price, quantity: $quantity, size: $size, image_data: $image_data)';
  }

  @override
  bool operator ==(covariant ProductModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.type == type &&
      other.price == price &&
      other.quantity == quantity &&
      other.size == size &&
      other.image_data == image_data;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      type.hashCode ^
      price.hashCode ^
      quantity.hashCode ^
      size.hashCode ^
      image_data.hashCode;
  }
}
