class CheckoutAddress {
  final String recipientName;
  final String phoneNumber;
  final String address;
  final String city;
  final String province;
  final String postalCode;

  CheckoutAddress({
    required this.recipientName,
    required this.phoneNumber,
    required this.address,
    required this.city,
    required this.province,
    required this.postalCode,
  });

  factory CheckoutAddress.fromJson(Map<String, dynamic> json) {
    return CheckoutAddress(
      recipientName: json['recipient_name'] as String,
      phoneNumber: json['phone_number'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      province: json['province'] as String,
      postalCode: json['postal_code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipient_name': recipientName,
      'phone_number': phoneNumber,
      'address': address,
      'city': city,
      'province': province,
      'postal_code': postalCode,
    };
  }
}

class CheckoutItem {
  final int productId;
  final String productName;
  final String brand;
  final String imageUrl;
  final int price;
  final int quantity;
  final int subtotal;

  CheckoutItem({
    required this.productId,
    required this.productName,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory CheckoutItem.fromJson(Map<String, dynamic> json) {
    return CheckoutItem(
      productId: json['product_id'] as int,
      productName: json['product_name'] as String,
      brand: json['brand'] as String,
      imageUrl: json['image_url'] as String,
      price: json['price'] as int,
      quantity: json['quantity'] as int,
      subtotal: json['subtotal'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'brand': brand,
      'image_url': imageUrl,
      'price': price,
      'quantity': quantity,
      'subtotal': subtotal,
    };
  }
}

class CheckoutSummary {
  final int subtotal;
  final int shippingCost;
  final int discount;
  final int total;

  CheckoutSummary({
    required this.subtotal,
    required this.shippingCost,
    required this.discount,
    required this.total,
  });

  factory CheckoutSummary.fromJson(Map<String, dynamic> json) {
    return CheckoutSummary(
      subtotal: json['subtotal'] as int,
      shippingCost: json['shipping_cost'] as int,
      discount: json['discount'] as int,
      total: json['total'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
      'discount': discount,
      'total': total,
    };
  }
}