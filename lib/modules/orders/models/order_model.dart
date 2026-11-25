enum OrderStatus {
  pending,
  delivered,
  finished,
  cancelled,
}

class OrderItem {
  final int productId;
  final String productName;
  final String brand;
  final String imageUrl;
  final int price;
  final int quantity;
  final int subtotal;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
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

class OrderModel {
  final int id;
  final String orderNumber;
  final OrderStatus status;
  final List<OrderItem> items;
  final int subtotal;
  final int shippingCost;
  final int adminFee;
  final int discount;
  final int total;
  final String paymentMethod;
  final String? paymentVaNumber;
  final String shippingAddress;
  final DateTime createdAt;
  final DateTime? paidAt;
  final DateTime? shippedAt;
  final DateTime? deliveredAt;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.shippingCost,
    required this.adminFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    this.paymentVaNumber,
    required this.shippingAddress,
    required this.createdAt,
    this.paidAt,
    this.shippedAt,
    this.deliveredAt,
  });

  String get statusLabel {
    switch (status) {
      case OrderStatus.pending:
        return 'Menunggu Pembayaran';
      case OrderStatus.delivered:
        return 'Dalam Pengiriman';
      case OrderStatus.finished:
        return 'Selesai';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
    }
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      orderNumber: json['order_number'] as String,
      status: OrderStatus.values.byName(json['status'] as String),
      items: (json['items'] as List)
          .map((e) => OrderItem.fromJson(e))
          .toList(),
      subtotal: json['subtotal'] as int,
      shippingCost: json['shipping_cost'] as int,
      adminFee: json['admin_fee'] as int,
      discount: json['discount'] as int,
      total: json['total'] as int,
      paymentMethod: json['payment_method'] as String,
      paymentVaNumber: json['payment_va_number'] as String?,
      shippingAddress: json['shipping_address'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      shippedAt: json['shipped_at'] != null ? DateTime.parse(json['shipped_at']) : null,
      deliveredAt: json['delivered_at'] != null ? DateTime.parse(json['delivered_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status.name,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'shipping_cost': shippingCost,
      'admin_fee': adminFee,
      'discount': discount,
      'total': total,
      'payment_method': paymentMethod,
      'payment_va_number': paymentVaNumber,
      'shipping_address': shippingAddress,
      'created_at': createdAt.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
      'shipped_at': shippedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
    };
  }
}