import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../carts/controllers/cart_controller.dart';
import '../controllers/product_controller.dart';
import '../widgets/product_card_widget.dart';
import '../widgets/product_filter_bar.dart';

class ProductPage extends ConsumerStatefulWidget {
  const ProductPage({super.key});

  @override
  ConsumerState<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends ConsumerState<ProductPage> {
  String? _selectedCategory;
  String? _selectedBrand;
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allProducts = ref.watch(productListProvider);

    final filteredProducts = allProducts.where((product) {
      final matchesSearch =
          _searchQuery.isEmpty ||
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCategory =
          _selectedCategory == null || product.category == _selectedCategory;
      final matchesBrand =
          _selectedBrand == null || product.brand == _selectedBrand;
      return matchesSearch && matchesCategory && matchesBrand;
    }).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Produk',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: InputDecoration(
                    hintText: 'Cari produk...',
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: AppColors.muted,
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
                const SizedBox(height: 12),
                ProductFilterBar(
                  selectedCategory: _selectedCategory,
                  selectedBrand: _selectedBrand,
                  onFilterTap: () {
                    _showFilterModal();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${filteredProducts.length} produk',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = null;
                      _selectedBrand = null;
                    });
                  },
                  icon: const Icon(
                    Icons.clear_rounded,
                    size: 14,
                    color: AppColors.muted,
                  ),
                  label: const Text(
                    'Reset',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.muted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: filteredProducts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 48,
                          color: AppColors.muted,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Produk tidak ditemukan',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark
                                ? AppColors.muted
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: filteredProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.68,
                        ),
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];
                      return ProductCardWidget(
                        product: product,
                        onTap: () {
                          context.push(
                            '/products/detail/${product.id}',
                          );
                        },
                        onAddToCart: () {
                          ref.read(cartProvider.notifier).addItem(product);
                          _showMessage(
                            '${product.name} ditambahkan ke keranjang',
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _showFilterModal() {
    final categories = ref.read(productListProvider).map((p) => p.category).toSet().toList();
    final brands = ref.read(productListProvider).map((p) => p.brand).toSet().toList();

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter Produk',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Kategori',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return FilterChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          _selectedCategory = selected ? cat : null;
                        });
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.primary,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Brand',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: brands.map((brand) {
                    final isSelected = _selectedBrand == brand;
                    return FilterChip(
                      label: Text(brand),
                      selected: isSelected,
                      onSelected: (selected) {
                        setModalState(() {
                          _selectedBrand = selected ? brand : null;
                        });
                      },
                      selectedColor: AppColors.primary.withValues(alpha: 0.15),
                      checkmarkColor: AppColors.primary,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                    child: const Text('Terapkan Filter'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}