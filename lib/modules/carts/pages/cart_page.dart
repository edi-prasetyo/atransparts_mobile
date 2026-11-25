import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_router.dart';
import '../../carts/models/cart_model.dart';
import '../controllers/cart_controller.dart';
import '../widgets/cart_bottom_bar.dart';
import '../widgets/cart_empty_widget.dart';
import '../widgets/cart_item_widget.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cartItems = ref.watch<List<CartItem>>(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: Text(
          'Keranjang${cartItems.isNotEmpty ? ' (${cartItems.length})' : ''}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: cartItems.isEmpty
          ? CartEmptyWidget(
              onStartShopping: () => context.go(AppRoutes.products),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return CartItemWidget(
                        item: item,
                        onIncrement: () =>
                            cartNotifier.increment(item.product.id),
                        onDecrement: () =>
                            cartNotifier.decrement(item.product.id),
                        onRemove: () {
                          cartNotifier.removeItem(item.product.id);
                          _showMessage(
                            context,
                            '${item.product.name} dihapus dari keranjang',
                          );
                        },
                      );
                    },
                  ),
                ),
                CartBottomBar(
                  totalItems: cartNotifier.totalItems,
                  totalPrice: cartNotifier.totalPrice,
                  onCheckout: () {
                    context.push(AppRoutes.checkout);
                  },
                ),
              ],
            ),
    );
  }
}
