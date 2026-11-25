import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../routes/app_router.dart';
import '../controllers/checkout_controller.dart';
import '../models/checkout_model.dart';
import '../widgets/checkout_address_widget.dart';
import '../widgets/checkout_bottom_bar.dart';
import '../widgets/checkout_item_widget.dart';
import '../widgets/checkout_summary_widget.dart';

class CheckoutPage extends ConsumerWidget {
  const CheckoutPage({super.key});

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final checkoutItems = ref.watch(checkoutItemsProvider);
    final summary = ref.watch(checkoutSummaryProvider);
    final address = ref.watch(checkoutAddressProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Checkout',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              children: [
                CheckoutAddressWidget(
                  address: address,
                  onEdit: () {
                    _showAddressModal(context, ref);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Produk Dipesan (${checkoutItems.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                ...checkoutItems.map(
                  (item) => CheckoutItemWidget(item: item),
                ),
                const SizedBox(height: 16),
                Text(
                  'Ringkasan Pembayaran',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                CheckoutSummaryWidget(summary: summary),
                const SizedBox(height: 24),
              ],
            ),
          ),
          CheckoutBottomBar(
            totalPrice: summary.total,
            onCheckout: () {
              if (address == null) {
                _showMessage(context, 'Tambahkan alamat pengiriman terlebih dahulu');
                return;
              }
              context.push(AppRoutes.selectPayment);
            },
          ),
        ],
      ),
    );
  }

  void _showAddressModal(BuildContext context, WidgetRef ref) {
    final recipientController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();
    final cityController = TextEditingController();
    final provinceController = TextEditingController();
    final postalController = TextEditingController();

    final existingAddress = ref.read(checkoutAddressProvider);
    if (existingAddress != null) {
      recipientController.text = existingAddress.recipientName;
      phoneController.text = existingAddress.phoneNumber;
      addressController.text = existingAddress.address;
      cityController.text = existingAddress.city;
      provinceController.text = existingAddress.province;
      postalController.text = existingAddress.postalCode;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              existingAddress == null ? 'Tambah Alamat' : 'Ubah Alamat',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: recipientController,
              decoration: const InputDecoration(
                labelText: 'Nama Penerima',
                hintText: 'Masukkan nama penerima',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Nomor Telepon',
                hintText: 'Masukkan nomor telepon',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: addressController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Alamat',
                hintText: 'Masukkan alamat lengkap',
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: cityController,
                    decoration: const InputDecoration(
                      labelText: 'Kota',
                      hintText: 'Kota',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: provinceController,
                    decoration: const InputDecoration(
                      labelText: 'Provinsi',
                      hintText: 'Provinsi',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: postalController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Kode Pos',
                hintText: 'Kode pos',
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  if (recipientController.text.isEmpty ||
                      phoneController.text.isEmpty ||
                      addressController.text.isEmpty ||
                      cityController.text.isEmpty ||
                      provinceController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Lengkapi semua field alamat'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }

                  final newAddress = CheckoutAddress(
                    recipientName: recipientController.text,
                    phoneNumber: phoneController.text,
                    address: addressController.text,
                    city: cityController.text,
                    province: provinceController.text,
                    postalCode: postalController.text,
                  );

                  ref.read(checkoutAddressProvider.notifier).state = newAddress;
                  Navigator.pop(context);
                },
                child: const Text(
                  'Simpan Alamat',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}