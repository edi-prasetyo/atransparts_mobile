import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../carts/controllers/cart_controller.dart';
import '../../carts/models/cart_model.dart';
import '../models/checkout_model.dart';

final checkoutProvider = Provider<CheckoutState>((ref) {
  return CheckoutState();
});

final checkoutItemsProvider = Provider<List<CheckoutItem>>((ref) {
  final cartItems = ref.watch(cartProvider);
  return cartItems.map((item) => _cartItemToCheckoutItem(item)).toList();
});

final checkoutSummaryProvider = Provider<CheckoutSummary>((ref) {
  final cartItems = ref.watch(cartProvider);
  final subtotal = cartItems.fold(0, (sum, item) => sum + item.subtotal);
  final shippingCost = 20000;
  final discount = 0;
  final total = subtotal + shippingCost - discount;

  return CheckoutSummary(
    subtotal: subtotal,
    shippingCost: shippingCost,
    discount: discount,
    total: total,
  );
});

final checkoutAddressProvider = StateProvider<CheckoutAddress?>((ref) {
  return null;
});

CheckoutItem _cartItemToCheckoutItem(CartItem item) {
  return CheckoutItem(
    productId: item.product.id,
    productName: item.product.name,
    brand: item.product.brand,
    imageUrl: item.product.imageUrl,
    price: item.product.price,
    quantity: item.quantity,
    subtotal: item.subtotal,
  );
}

class CheckoutState {
  final bool isLoading;
  final String? error;

  CheckoutState({
    this.isLoading = false,
    this.error,
  });

  CheckoutState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return CheckoutState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}