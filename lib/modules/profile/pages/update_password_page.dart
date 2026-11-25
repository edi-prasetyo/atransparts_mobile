import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({super.key});

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_newPasswordController.text != _confirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi kata sandi tidak cocok'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Kata sandi berhasil diubah'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
        ),
        title: const Text(
          'Ubah Kata Sandi',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _oldPasswordController,
            obscureText: _obscureOld,
            decoration: InputDecoration(
              labelText: 'Kata Sandi Lama',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscureOld = !_obscureOld),
                icon: Icon(_obscureOld ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _newPasswordController,
            obscureText: _obscureNew,
            decoration: InputDecoration(
              labelText: 'Kata Sandi Baru',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscureNew = !_obscureNew),
                icon: Icon(_obscureNew ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _confirmController,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              labelText: 'Konfirmasi Kata Sandi',
              prefixIcon: const Icon(Icons.lock_outline_rounded),
              suffixIcon: IconButton(
                onPressed: () => setState(() => _obscureConfirm = !_obscureConfirm),
                icon: Icon(_obscureConfirm ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: _submit,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Simpan',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}