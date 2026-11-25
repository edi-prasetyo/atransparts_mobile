import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/exceptions/validation_exception.dart';
import '../../../core/providers/auth_provider.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../routes/app_router.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  // API field name -> form field key. Backend menggunakan key:
  //   - email
  //   - phone
  //   - name
  //   - password
  //   - password_confirmation
  String? _serverError(String apiKey) => _serverErrors[apiKey];
  Map<String, String> _serverErrors = {};

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _decoration({
    required String label,
    required IconData icon,
    String? apiKey,
    Widget? suffixIcon,
  }) {
    final errorText = apiKey == null ? null : _serverError(apiKey);
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: const OutlineInputBorder(),
      suffixIcon: suffixIcon,
      errorText: errorText,
    );
  }

  Future<void> _handleRegister() async {
    setState(() => _serverErrors = {});

    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authControllerProvider.notifier)
          .register(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            phone: _phoneController.text.trim(),
            password: _passwordController.text,
            passwordConfirmation: _confirmPasswordController.text,
          );

      final authState = ref.read(authControllerProvider);
      authState.whenOrNull(
        data: (_) {
          if (!mounted) return;
          final authData = ref.read(authControllerProvider).asData?.value;
          final isVerified = authData?.isVerified ?? 0;
          final auth = ref.read(authProvider);
          // print(
          //   'DEBUG: [REGISTER_PAGE] isLoggedIn=${auth.isLoggedIn}, isVerified=$isVerified',
          // );
          if (!mounted) return;
          if (isVerified == 0) {
            // print('DEBUG: [REGISTER_PAGE] Navigating to /verify');
            context.go(
              '${AppRoutes.verify}?email=${_emailController.text.trim()}',
              extra: {'password': _passwordController.text},
            );
          } else {
            // print('DEBUG: [REGISTER_PAGE] Navigating to /home');
            context.go(AppRoutes.home);
          }
        },
      );
    } on ValidationException catch (e) {
      if (!mounted) return;
      // Map setiap error API -> field di form. Simpan hanya error pertama
      // per-field agar Flutter menampilkan satu pesan (errorText tidak
      // mendukung list). Warna border akan otomatis merah karena errorText
      // tidak null.
      final mapped = <String, String>{};
      e.fieldErrors.forEach((key, msgs) {
        if (msgs.isNotEmpty) mapped[key] = msgs.first;
      });
      setState(() => _serverErrors = mapped);
      _formKey.currentState?.validate();
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Text(
                  'Buat Akun',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Isi data di bawah untuk mendaftar',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _nameController,
                  decoration: _decoration(
                    label: 'Nama Lengkap',
                    icon: Icons.person_outline,
                    apiKey: 'name',
                  ),
                  validator: (value) {
                    final server = _serverError('name');
                    if (server != null) return server;
                    if (value == null || value.isEmpty)
                      return 'Nama wajib diisi';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: _decoration(
                    label: 'Email',
                    icon: Icons.email_outlined,
                    apiKey: 'email',
                  ),
                  validator: (value) {
                    final server = _serverError('email');
                    if (server != null) return server;
                    if (value == null || value.isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!value.contains('@')) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: _decoration(
                    label: 'Nomor Whatsapp',
                    icon: Icons.phone_outlined,
                    apiKey: 'phone',
                  ),
                  validator: (value) {
                    final server = _serverError('phone');
                    if (server != null) return server;
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor telepon wajib diisi';
                    }
                    final digits = value.trim().replaceAll(RegExp(r'[\D]'), '');
                    if (digits.length < 8 || digits.length > 15) {
                      return 'Masukkan nomor telepon yang valid';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: _decoration(
                    label: 'Password',
                    icon: Icons.lock_outline,
                    apiKey: 'password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                  validator: (value) {
                    final server = _serverError('password');
                    if (server != null) return server;
                    if (value == null || value.isEmpty)
                      return 'Password wajib diisi';
                    if (value.length < 6) return 'Minimal 6 karakter';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscurePassword,
                  decoration: _decoration(
                    label: 'Konfirmasi Password',
                    icon: Icons.lock_outline,
                    apiKey: 'password_confirmation',
                  ),
                  validator: (value) {
                    final server = _serverError('password_confirmation');
                    if (server != null) return server;
                    if (value != _passwordController.text) {
                      return 'Password tidak sama';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                FilledButton(
                  onPressed: _isLoading ? null : _handleRegister,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Daftar'),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Sudah punya akun?'),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.login),
                      child: const Text('Masuk'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}