import 'package:ecom/features/cart/view_model/cart_view_model.dart';
import 'package:ecom/features/product_detail/view/product_detail_screen.dart';
import 'package:ecom/features/product_list/model/product_model.dart';
import 'package:ecom/features/product_list/view_model/product_list_view_model.dart';
import 'package:ecom/features/theme/view/theme_toggle_button.dart';
import 'package:ecom/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: const [ThemeToggleButton()],
      ),
      body: Consumer<ProductListViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.products.isEmpty && viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 200) {
                viewModel.getProducts();
              }
              return false;
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount:
                  (viewModel.products.length / 2).ceil() +
                  (viewModel.isLoading ? 1 : 0),
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final rowCount = (viewModel.products.length / 2).ceil();

                if (index == rowCount) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final firstIndex = index * 2;
                final secondIndex = firstIndex + 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: _ProductCard(
                        product: viewModel.products[firstIndex],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: secondIndex < viewModel.products.length
                          ? _ProductCard(
                              product: viewModel.products[secondIndex],
                            )
                          : const SizedBox(),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border.all(color: AppColors.themedBorder(context)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(8),
                    ),
                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return ColoredBox(
                          color: AppColors.themedImagePlaceholder(context),
                          child: Icon(
                            Icons.image_not_supported_outlined,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: Material(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    child: IconButton(
                      icon: const Icon(Icons.add_shopping_cart),
                      color: Theme.of(context).colorScheme.onPrimary,
                      iconSize: 20,
                      onPressed: () async {
                        await context.read<CartViewModel>().addToCart(product);
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Added to cart')),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
