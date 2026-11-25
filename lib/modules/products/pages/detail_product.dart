import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../carts/controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_bottom_bar.dart';
import '../widgets/product_description_section.dart';
import '../widgets/product_detail_header.dart';
import '../widgets/product_price_section.dart';

class ProductDetailPage extends ConsumerWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final product = ref.watch(productDetailProvider(productId));

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: AppColors.muted,
              ),
              const SizedBox(height: 8),
              Text(
                'Produk tidak ditemukan',
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? AppColors.muted : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProductDetailHeader(product: product),
                          const SizedBox(height: 16),
                          ProductPriceSection(product: product),
                          const SizedBox(height: 16),
                          ProductDescriptionSection(
                            description: product.description,
                            specifications: product.specifications,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ProductBottomBar(
              onAddToCart: () {
                ref.read(cartProvider.notifier).addItem(product);
                _showMessage(context, '${product.name} ditambahkan ke keranjang');
              },
              onBuyNow: () {
                ref.read(cartProvider.notifier).addItem(product);
                context.push(AppRoutes.checkout);
              },
            ),
          ],
        ),
      ),
    );
  }
}