import 'package:ecom/features/cart/model/cart_item_model.dart';
import 'package:ecom/features/product_list/model/product_model.dart';
import 'package:ecom/utils/cart_database_service.dart';
import 'package:flutter/material.dart';

class CartViewModel extends ChangeNotifier {
  final List<CartItemModel> cartItems = [];

  int get subtotal {
    return cartItems.fold(0, (sum, item) => sum + item.totalPrice);
  }

  int get deliveryFee {
    if (cartItems.isEmpty) return 0;
    return subtotal < 500 ? 50 : 0;
  }

  int get total => subtotal + deliveryFee;

  Future<void> loadCart() async {
    cartItems
      ..clear()
      ..addAll(await CartDatabaseService.getCartItems());
    notifyListeners();
  }

  Future<void> addToCart(ProductModel product) async {
    await CartDatabaseService.addToCart(product);
    await loadCart();
  }

  Future<void> increaseQuantity(CartItemModel item) async {
    await CartDatabaseService.updateQuantity(
      item.product.id,
      item.quantity + 1,
    );
    await loadCart();
  }

  Future<void> decreaseQuantity(CartItemModel item) async {
    if (item.quantity == 1) return;

    await CartDatabaseService.updateQuantity(
      item.product.id,
      item.quantity - 1,
    );
    await loadCart();
  }

  Future<void> deleteItem(CartItemModel item) async {
    await CartDatabaseService.deleteItem(item.product.id);
    await loadCart();
  }
}
