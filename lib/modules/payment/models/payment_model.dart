import 'package:flutter/material.dart';

class PaymentMethod {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;
  final String? vaPrefix;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
    this.vaPrefix,
  });
}

class PaymentDetail {
  final String paymentMethodId;
  final String paymentMethodName;
  final int amount;
  final int adminFee;
  final int totalAmount;
  final String? vaNumber;
  final String? billCode;
  final DateTime expiredAt;
  final String status;

  PaymentDetail({
    required this.paymentMethodId,
    required this.paymentMethodName,
    required this.amount,
    required this.adminFee,
    required this.totalAmount,
    this.vaNumber,
    this.billCode,
    required this.expiredAt,
    required this.status,
  });

  factory PaymentDetail.fromJson(Map<String, dynamic> json) {
    return PaymentDetail(
      paymentMethodId: json['payment_method_id'] as String,
      paymentMethodName: json['payment_method_name'] as String,
      amount: json['amount'] as int,
      adminFee: json['admin_fee'] as int,
      totalAmount: json['total_amount'] as int,
      vaNumber: json['va_number'] as String?,
      billCode: json['bill_code'] as String?,
      expiredAt: DateTime.parse(json['expired_at'] as String),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment_method_id': paymentMethodId,
      'payment_method_name': paymentMethodName,
      'amount': amount,
      'admin_fee': adminFee,
      'total_amount': totalAmount,
      'va_number': vaNumber,
      'bill_code': billCode,
      'expired_at': expiredAt.toIso8601String(),
      'status': status,
    };
  }
}

const List<PaymentMethod> availablePaymentMethods = [
  PaymentMethod(
    id: 'bca_va',
    name: 'BCA Virtual Account',
    description: 'Pembayaran melalui Virtual Account BCA',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF0060AF),
    vaPrefix: '3901',
  ),
  PaymentMethod(
    id: 'mandiri_va',
    name: 'Mandiri Virtual Account',
    description: 'Pembayaran melalui Virtual Account Mandiri',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF003D79),
    vaPrefix: '8950',
  ),
  PaymentMethod(
    id: 'bni_va',
    name: 'BNI Virtual Account',
    description: 'Pembayaran melalui Virtual Account BNI',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF005B9F),
    vaPrefix: '8808',
  ),
  PaymentMethod(
    id: 'bri_va',
    name: 'BRI Virtual Account',
    description: 'Pembayaran melalui Virtual Account BRI',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF00529C),
    vaPrefix: '8810',
  ),
  PaymentMethod(
    id: 'gopay',
    name: 'GoPay',
    description: 'Pembayaran melalui GoPay',
    icon: Icons.account_balance_wallet_rounded,
    color: Color(0xFF00AED1),
  ),
  PaymentMethod(
    id: 'ovo',
    name: 'OVO',
    description: 'Pembayaran melalui OVO',
    icon: Icons.account_balance_wallet_rounded,
    color: Color(0xFF4C3494),
  ),
  PaymentMethod(
    id: 'dana',
    name: 'DANA',
    description: 'Pembayaran melalui DANA',
    icon: Icons.account_balance_wallet_rounded,
    color: Color(0xFF118EEA),
  ),
  PaymentMethod(
    id: 'credit_card',
    name: 'Kartu Kredit',
    description: 'Visa, Mastercard, JCB',
    icon: Icons.credit_card_rounded,
    color: Color(0xFF1A1A71),
  ),
];