import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../carts/controllers/cart_controller.dart';
import '../../products/controllers/product_controller.dart';
import '../../products/pages/detail_product.dart';
import '../controllers/home_controller.dart';
import '../models/home_model.dart';
import '../widgets/home_category_list.dart';
import '../widgets/home_product_card.dart';
import '../widgets/home_promo_card.dart';
import '../widgets/home_section_header.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final controller = ref.watch(homeControllerProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          'assets/images/logo-home.png',
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () => _showMessage(
                            context,
                            'Belum ada notifikasi baru',
                          ),
                          icon: const Icon(Icons.notifications_none_rounded),
                        ),
                        IconButton(
                          onPressed: () => context.go(AppRoutes.cart),
                          icon: const Icon(Icons.shopping_cart_outlined),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    TextField(
                      readOnly: true,
                      onTap: () => _showMessage(
                        context,
                        'Pencarian produk akan segera dibuka',
                      ),
                      decoration: InputDecoration(
                        hintText: 'Cari oli, aki, kampas rem...',
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.muted,
                        ),
                        suffixIcon: Container(
                          margin: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        filled: true,
                        fillColor: isDark
                            ? AppColors.cardDark
                            : AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.muted.withValues(alpha: 0.2)
                                : AppColors.divider,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.muted.withValues(alpha: 0.2)
                                : AppColors.divider,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    HomePromoCard(
                      promotion: controller.promotions.first,
                      onPressed: () =>
                          _showMessage(context, 'Promo gratis ongkir dipilih'),
                    ),
                    const SizedBox(height: 20),
                    HomeSectionHeader(
                      title: 'Kategori',
                      onSeeAll: () => _showMessage(context, 'Semua kategori'),
                    ),
                    const SizedBox(height: 10),
                    HomeCategoryList(
                      categories: controller.categories,
                      onTap: (category) =>
                          _showMessage(context, 'Kategori ${category.name}'),
                    ),
                    const SizedBox(height: 12),
                    HomeSectionHeader(
                      title: 'Produk Populer',
                      onSeeAll: () => context.push(AppRoutes.products),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final product = controller.popularProducts[index];
                  return HomeProductCard(
                    product: product,
                    onTap: () {
                      final productModel = ref
                          .read(productListProvider)
                          .firstWhere(
                            (p) => p.name == product.name,
                            orElse: () => ref.read(productListProvider).first,
                          );
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailPage(
                            productId: productModel.id,
                          ),
                        ),
                      );
                    },
                    onAddToCart: () {
                      final productModel = ref
                          .read(productListProvider)
                          .firstWhere(
                            (p) => p.name == product.name,
                            orElse: () => ref.read(productListProvider).first,
                          );
                      ref.read(cartProvider.notifier).addItem(productModel);
                      _showMessage(
                        context,
                        '${product.name} ditambahkan ke keranjang',
                      );
                    },
                  );
                }, childCount: controller.popularProducts.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.68,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 22, 16, 30),
                child: Column(
                  children: [
                    HomeSectionHeader(
                      title: 'Rekomendasi untuk Anda',
                      onSeeAll: () => context.push(AppRoutes.products),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.recommendedProducts.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.68,
                          ),
                      itemBuilder: (context, index) {
                        final HomeProduct product =
                            controller.recommendedProducts[index];
                        return HomeProductCard(
                          product: product,
                          onTap: () {
                            final productModel = ref
                                .read(productListProvider)
                                .firstWhere(
                                  (p) => p.name == product.name,
                                  orElse: () =>
                                      ref.read(productListProvider).first,
                                );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailPage(
                                  productId: productModel.id,
                                ),
                              ),
                            );
                          },
                          onAddToCart: () {
                            final productModel = ref
                                .read(productListProvider)
                                .firstWhere(
                                  (p) => p.name == product.name,
                                  orElse: () =>
                                      ref.read(productListProvider).first,
                                );
                            ref.read(cartProvider.notifier).addItem(productModel);
                            _showMessage(
                              context,
                              '${product.name} ditambahkan ke keranjang',
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
