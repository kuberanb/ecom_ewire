import 'package:ecom/features/product_list/model/product_model.dart';
import 'package:ecom/utils/api_end_points.dart';
import 'package:ecom/utils/api_service.dart';
import 'package:flutter/material.dart';

class ProductListViewModel extends ChangeNotifier {
  final List<ProductModel> products = [];
  final int limit = 10;

  bool isLoading = false;
  bool hasMore = true;

  Future<void> getProducts() async {
    if (isLoading || !hasMore) return;

    isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get(
        ApiEndPoints.products,
        queryParameters: {
          'offset': products.length,
          'limit': limit,
        },
      );

      final data = response.data as List<dynamic>;
      final newProducts = data
          .map((item) => ProductModel.fromJson(item as Map<String, dynamic>))
          .toList();

      products.addAll(newProducts);
      hasMore = newProducts.length == limit;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
