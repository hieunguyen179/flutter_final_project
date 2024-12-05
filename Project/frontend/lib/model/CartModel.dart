// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class CartModel {
  int? id;
  String? name;
  int? id_product;
  int? quantity;
  CartModel({
    this.id,
    this.name,
    this.id_product,
    this.quantity,
  });

  CartModel copyWith({
    int? id,
    String? name,
    int? id_product,
    int? quantity,
  }) {
    return CartModel(
      id: id ?? this.id,
      name: name ?? this.name,
      id_product: id_product ?? this.id_product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'id_product': id_product,
      'quantity': quantity,
    };
  }

  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      id: map['id'] != null ? map['id'] as int : null,
      name: map['name'] != null ? map['name'] as String : null,
      id_product: map['id_product'] != null ? map['id_product'] as int : null,
      quantity: map['quantity'] != null ? map['quantity'] as int : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartModel.fromJson(String source) => CartModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CartModel(id: $id, name: $name, id_product: $id_product, quantity: $quantity)';
  }

  @override
  bool operator ==(covariant CartModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.name == name &&
      other.id_product == id_product &&
      other.quantity == quantity;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      id_product.hashCode ^
      quantity.hashCode;
  }
}
