import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../products/models/product_model.dart';
import '../models/cart_model.dart';

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addItem(ProductModel product, {int quantity = 1}) {
    final existingIndex =
        state.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      final newList = List<CartItem>.from(state);
      newList[existingIndex] =
          newList[existingIndex].copyWith(quantity: newList[existingIndex].quantity + quantity);
      state = newList;
    } else {
      state = [...state, CartItem(product: product, quantity: quantity)];
    }
  }

  void removeItem(int productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeItem(productId);
      return;
    }

    final newList = state.map((item) {
      if (item.product.id == productId) {
        return item.copyWith(quantity: quantity);
      }
      return item;
    }).toList();
    state = newList;
  }

  void increment(int productId) {
    final item = state.firstWhere((i) => i.product.id == productId);
    updateQuantity(productId, item.quantity + 1);
  }

  void decrement(int productId) {
    final item = state.firstWhere((i) => i.product.id == productId);
    updateQuantity(productId, item.quantity - 1);
  }

  void clearCart() {
    state = [];
  }

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);

  int get totalPrice =>
      state.fold(0, (sum, item) => sum + item.subtotal);
}