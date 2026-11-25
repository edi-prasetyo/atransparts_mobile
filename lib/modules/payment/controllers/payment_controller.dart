import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../bills/models/bill_model.dart';
import '../../checkout/controllers/checkout_controller.dart';
import '../models/payment_model.dart';

final selectedPaymentMethodProvider =
    StateProvider<PaymentMethod?>((ref) => null);

/// Saat user membayar tagihan tempo, set bill ini. Jika null, pembayaran
/// berasal dari checkout cart biasa.
final billPaymentProvider = StateProvider<BillModel?>((ref) => null);

/// Total amount yang dipakai di halaman select payment & pay.
/// Mengambil dari tagihan jika sedang bayar tagihan, atau dari checkout cart.
final paymentAmountProvider = Provider<int>((ref) {
  final bill = ref.watch(billPaymentProvider);
  if (bill != null) return bill.total;
  return ref.watch(checkoutSummaryProvider).total;
});

final paymentDetailProvider = Provider<PaymentDetail?>((ref) {
  final method = ref.watch(selectedPaymentMethodProvider);
  final amount = ref.watch(paymentAmountProvider);

  if (method == null) return null;

  final adminFee = _getAdminFee(method.id);
  final vaNumber = _generateVaNumber(method.id, amount);

  return PaymentDetail(
    paymentMethodId: method.id,
    paymentMethodName: method.name,
    amount: amount,
    adminFee: adminFee,
    totalAmount: amount + adminFee,
    vaNumber: vaNumber,
    billCode: _generateBillCode(),
    expiredAt: DateTime.now().add(const Duration(hours: 24)),
    status: 'pending',
  );
});

int _getAdminFee(String methodId) {
  switch (methodId) {
    case 'bca_va':
      return 4000;
    case 'mandiri_va':
    case 'bni_va':
    case 'bri_va':
      return 3000;
    case 'gopay':
    case 'ovo':
    case 'dana':
      return 1500;
    case 'credit_card':
      return 2500;
    default:
      return 0;
  }
}

String _generateVaNumber(String methodId, int amount) {
  final methods = availablePaymentMethods;
  final method = methods.firstWhere((m) => m.id == methodId);
  final prefix = method.vaPrefix ?? '0000';
  final suffix = amount.toString().padLeft(10, '0');
  return '$prefix$suffix';
}

String _generateBillCode() {
  final now = DateTime.now();
  return '${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
}