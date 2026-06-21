import 'dart:convert';

import 'package:ecom/features/product_list/model/product_model.dart';

class CartItemModel {
  final ProductModel product;
  final int quantity;

  CartItemModel({
    required this.product,
    required this.quantity,
  });

  int get totalPrice => product.price * quantity;

  factory CartItemModel.fromMap(Map<String, Object?> map) {
    final images = (jsonDecode(map['images'] as String) as List<dynamic>)
        .map((image) => image.toString())
        .toList();

    return CartItemModel(
      quantity: (map['quantity'] as int?) ?? 1,
      product: ProductModel(
        id: (map['product_id'] as int?) ?? 0,
        title: (map['title'] as String?) ?? '',
        slug: (map['slug'] as String?) ?? '',
        price: (map['price'] as int?) ?? 0,
        description: (map['description'] as String?) ?? '',
        category: ProductCategoryModel(
          id: (map['category_id'] as int?) ?? 0,
          name: (map['category_name'] as String?) ?? '',
          slug: (map['category_slug'] as String?) ?? '',
          image: (map['category_image'] as String?) ?? '',
        ),
        images: images,
        image: (map['image'] as String?) ?? '',
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'product_id': product.id,
      'title': product.title,
      'slug': product.slug,
      'price': product.price,
      'description': product.description,
      'category_id': product.category.id,
      'category_name': product.category.name,
      'category_slug': product.category.slug,
      'category_image': product.category.image,
      'images': jsonEncode(product.images),
      'image': product.image,
      'quantity': quantity,
    };
  }
}
