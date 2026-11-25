import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/bill_model.dart';

final billsProvider = Provider<List<BillModel>>((ref) {
  return _dummyBills;
});

final billDetailProvider = Provider.family<BillModel?, int>((ref, id) {
  try {
    return _dummyBills.firstWhere((b) => b.id == id);
  } catch (_) {
    return null;
  }
});

final unpaidBillsProvider = Provider<List<BillModel>>((ref) {
  return ref.watch(billsProvider).where((b) => b.status != BillStatus.paid).toList();
});

final List<BillModel> _dummyBills = [
  BillModel(
    id: 1,
    billNumber: 'BILL-20241101-001',
    status: BillStatus.unpaid,
    items: [
      BillItem(
        productId: 1,
        productName: 'Filter Oli Denso',
        brand: 'Denso',
        imageUrl: 'https://images.unsplash.com/photo-1487754180451-c456f719a1fc',
        price: 85000,
        quantity: 2,
        subtotal: 170000,
      ),
      BillItem(
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
    adminFee: 5000,
    total: 485000,
    issuedAt: DateTime(2024, 11, 1, 9, 0),
    dueDate: DateTime(2024, 12, 1, 23, 59),
  ),
  BillModel(
    id: 2,
    billNumber: 'BILL-20241005-002',
    status: BillStatus.dueSoon,
    items: [
      BillItem(
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
    adminFee: 5000,
    total: 425000,
    issuedAt: DateTime(2024, 10, 5, 10, 30),
    dueDate: DateTime(2024, 11, 25, 23, 59),
  ),
  BillModel(
    id: 3,
    billNumber: 'BILL-20240905-003',
    status: BillStatus.overdue,
    items: [
      BillItem(
        productId: 5,
        productName: 'Busi Iridium Racing',
        brand: 'NGK',
        imageUrl: 'https://images.unsplash.com/photo-1542362567-b07e54358753',
        price: 165000,
        quantity: 4,
        subtotal: 660000,
      ),
      BillItem(
        productId: 6,
        productName: 'Aki MF Premium 12V',
        brand: 'Yuasa',
        imageUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
        price: 920000,
        quantity: 1,
        subtotal: 920000,
      ),
    ],
    subtotal: 1580000,
    adminFee: 5000,
    total: 1585000,
    issuedAt: DateTime(2024, 9, 5, 11, 15),
    dueDate: DateTime(2024, 10, 5, 23, 59),
  ),
  BillModel(
    id: 4,
    billNumber: 'BILL-20240805-004',
    status: BillStatus.paid,
    items: [
      BillItem(
        productId: 2,
        productName: 'Air Filter High Performance',
        brand: 'BRT',
        imageUrl: 'https://images.unsplash.com/photo-1492144534655-ae79c964c9d7',
        price: 185000,
        quantity: 2,
        subtotal: 370000,
      ),
    ],
    subtotal: 370000,
    adminFee: 5000,
    total: 375000,
    issuedAt: DateTime(2024, 8, 5, 14, 0),
    dueDate: DateTime(2024, 9, 5, 23, 59),
    paidAt: DateTime(2024, 8, 20, 10, 30),
  ),
];