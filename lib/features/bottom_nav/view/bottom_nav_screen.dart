import 'package:ecom/features/bottom_nav/view_model/bottom_nav_view_model.dart';
import 'package:ecom/features/cart/view/cart_screen.dart';
import 'package:ecom/features/product_list/view/product_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomNavScreen extends StatelessWidget {
  const BottomNavScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screens = [
      const ProductListScreen(),
      const CartScreen(),
    ];

    return Consumer<BottomNavViewModel>(
      builder: (context, viewModel, child) {
        return Scaffold(
          body: IndexedStack(
            index: viewModel.selectedIndex,
            children: screens,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: viewModel.selectedIndex,
            onTap: viewModel.changeIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                activeIcon: Icon(Icons.shopping_cart),
                label: 'Cart',
              ),
            ],
          ),
        );
      },
    );
  }
}
