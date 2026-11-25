import '../../products/models/product_model.dart';

class CartItem {
  final ProductModel product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  int get subtotal => product.price * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }
}