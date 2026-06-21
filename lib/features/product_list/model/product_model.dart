class ProductModel {
  final int id;
  final String title;
  final String slug;
  final int price;
  final String description;
  final ProductCategoryModel category;
  final List<String> images;
  final String image;

  ProductModel({
    required this.id,
    required this.title,
    required this.slug,
    required this.price,
    required this.description,
    required this.category,
    required this.images,
    required this.image,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final images = json['images'] as List<dynamic>? ?? [];

    return ProductModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      slug: json['slug'] ?? '',
      price: json['price'] ?? 0,
      description: json['description'] ?? '',
      category: ProductCategoryModel.fromJson(json['category'] ?? {}),
      images: images.map((image) => image.toString()).toList(),
      image: images.isNotEmpty ? images.first.toString() : '',
    );
  }
}

class ProductCategoryModel {
  final int id;
  final String name;
  final String slug;
  final String image;

  ProductCategoryModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.image,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
