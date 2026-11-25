import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/order_model.dart';

final ordersProvider = Provider<List<OrderModel>>((ref) {
  return _dummyOrders;
});

final orderDetailProvider = Provider.family<OrderModel?, int>((ref, id) {
  try {
    return _dummyOrders.firstWhere((o) => o.id == id);
  } catch (_) {
    return null;
  }
});

final pendingOrdersProvider = Provider<List<OrderModel>>((ref) {
  return ref.watch(ordersProvider).where((o) => o.status == OrderStatus.pending).toList();
});

final deliveredOrdersProvider = Provider<List<OrderModel>>((ref) {
  return ref.watch(ordersProvider).where((o) => o.status == OrderStatus.delivered).toList();
});

final finishedOrdersProvider = Provider<List<OrderModel>>((ref) {
  return ref.watch(ordersProvider).where((o) => o.status == OrderStatus.finished).toList();
});

final cancelledOrdersProvider = Provider<List<OrderModel>>((ref) {
  return ref.watch(ordersProvider).where((o) => o.status == OrderStatus.cancelled).toList();
});

final List<OrderModel> _dummyOrders = [
  OrderModel(
    id: 1,
    orderNumber: 'ORD-20241120-001',
    status: OrderStatus.pending,
    items: [
      OrderItem(
        productId: 1,
        productName: 'Filter Oli Denso',
        brand: 'Denso',
        imageUrl: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc',
        price: 85000,
        quantity: 2,
        subtotal: 170000,
      ),
      OrderItem(
        productId: 4,
        productName: 'Premium Engine Oil 5W-30',
        brand: 'Castrol',
        imageUrl: 'https://images.unsplash.com/photo-1635784061836-38d7e8e5d4b3',
        price: 310000,
        quantity: 1,
        subtotal: 310000,
      ),
    ],
    subtotal: 480000,
    shippingCost: 20000,
    adminFee: 4000,
    discount: 0,
    total: 504000,
    paymentMethod: 'BCA Virtual Account',
    paymentVaNumber: '3901234567890',
    shippingAddress: 'Jl. Sudirman No. 123, Jakarta Selatan, DKI Jakarta 12190',
    createdAt: DateTime(2024, 11, 20, 10, 30),
    paidAt: null,
  ),
  OrderModel(
    id: 2,
    orderNumber: 'ORD-20241119-002',
    status: OrderStatus.delivered,
    items: [
      OrderItem(
        productId: 3,
        productName: 'Brake Pad Ceramic',
        brand: 'Brembo',
        imageUrl: 'https://images.unsplash.com/photo-1503736334956-4c8f8e92946d',
        price: 420000,
        quantity: 1,
        subtotal: 420000,
      ),
    ],
    subtotal: 420000,
    shippingCost: 15000,
    adminFee: 3000,
    discount: 20000,
    total: 418000,
    paymentMethod: 'GoPay',
    shippingAddress: 'Jl. Gatot Subroto No. 456, Jakarta Selatan, DKI Jakarta 12930',
    createdAt: DateTime(2024, 11, 19, 14, 20),
    paidAt: DateTime(2024, 11, 19, 14, 25),
    shippedAt: DateTime(2024, 11, 19, 16, 0),
    deliveredAt: null,
  ),
  OrderModel(
    id: 3,
    orderNumber: 'ORD-20241118-003',
    status: OrderStatus.finished,
    items: [
      OrderItem(
        productId: 5,
        productName: 'Busi Iridium Racing',
        brand: 'NGK',
        imageUrl: 'https://images.unsplash.com/photo-1542362567-b07e54358753',
        price: 165000,
        quantity: 4,
        subtotal: 660000,
      ),
      OrderItem(
        productId: 2,
        productName: 'Air Filter High Performance',
        brand: 'BRT',
        imageUrl: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7',
        price: 185000,
        quantity: 1,
        subtotal: 185000,
      ),
    ],
    subtotal: 845000,
    shippingCost: 0,
    adminFee: 4000,
    discount: 50000,
    total: 799000,
    paymentMethod: 'Mandiri Virtual Account',
    paymentVaNumber: '8950987654321',
    shippingAddress: 'Jl. Tebet Barat No. 789, Jakarta Selatan, DKI Jakarta 12810',
    createdAt: DateTime(2024, 11, 18, 9, 15),
    paidAt: DateTime(2024, 11, 18, 9, 20),
    shippedAt: DateTime(2024, 11, 18, 13, 30),
    deliveredAt: DateTime(2024, 11, 19, 10, 0),
  ),
  OrderModel(
    id: 4,
    orderNumber: 'ORD-20241117-004',
    status: OrderStatus.cancelled,
    items: [
      OrderItem(
        productId: 6,
        productName: 'Aki MF Premium 12V',
        brand: 'Yuasa',
        imageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
        price: 920000,
        quantity: 1,
        subtotal: 920000,
      ),
    ],
    subtotal: 920000,
    shippingCost: 20000,
    adminFee: 4000,
    discount: 0,
    total: 944000,
    paymentMethod: 'OVO',
    shippingAddress: 'Jl. Kemang Raya No. 321, Jakarta Selatan, DKI Jakarta 12730',
    createdAt: DateTime(2024, 11, 17, 16, 45),
    paidAt: null,
  ),
];