enum BillStatus {
  unpaid, // belum jatuh tempo
  dueSoon, // mendekati jatuh tempo
  overdue, // sudah lewat jatuh tempo
  paid, // sudah dibayar
}

class BillItem {
  final int productId;
  final String productName;
  final String brand;
  final String imageUrl;
  final int price;
  final int quantity;
  final int subtotal;

  BillItem({
    required this.productId,
    required this.productName,
    required this.brand,
    required this.imageUrl,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory BillItem.fromJson(Map<String, dynamic> json) {
    return BillItem(
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

class BillModel {
  final int id;
  final String billNumber;
  final BillStatus status;
  final List<BillItem> items;
  final int subtotal;
  final int adminFee;
  final int total;
  final DateTime issuedAt;
  final DateTime dueDate;
  final DateTime? paidAt;

  BillModel({
    required this.id,
    required this.billNumber,
    required this.status,
    required this.items,
    required this.subtotal,
    required this.adminFee,
    required this.total,
    required this.issuedAt,
    required this.dueDate,
    this.paidAt,
  });

  String get statusLabel {
    switch (status) {
      case BillStatus.unpaid:
        return 'Belum Jatuh Tempo';
      case BillStatus.dueSoon:
        return 'Segera Jatuh Tempo';
      case BillStatus.overdue:
        return 'Jatuh Tempo';
      case BillStatus.paid:
        return 'Lunas';
    }
  }

  bool get canPay => status != BillStatus.paid;

  int get daysUntilDue {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final due = DateTime(dueDate.year, dueDate.month, dueDate.day);
    return due.difference(today).inDays;
  }

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      id: json['id'] as int,
      billNumber: json['bill_number'] as String,
      status: BillStatus.values.byName(json['status'] as String),
      items: (json['items'] as List)
          .map((e) => BillItem.fromJson(e))
          .toList(),
      subtotal: json['subtotal'] as int,
      adminFee: json['admin_fee'] as int,
      total: json['total'] as int,
      issuedAt: DateTime.parse(json['issued_at'] as String),
      dueDate: DateTime.parse(json['due_date'] as String),
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'bill_number': billNumber,
      'status': status.name,
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'admin_fee': adminFee,
      'total': total,
      'issued_at': issuedAt.toIso8601String(),
      'due_date': dueDate.toIso8601String(),
      'paid_at': paidAt?.toIso8601String(),
    };
  }
}