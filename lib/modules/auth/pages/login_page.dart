import 'dart:developer' as dev;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/providers/pending_navigation_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../modules/profile/controllers/profile_controller.dart';
import '../../../routes/app_router.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends ConsumerStatefulWidget {
  final String? redirectTo;

  const LoginPage({super.key, this.redirectTo});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final auth = ref.read(authProvider);
      if (auth.isLoggedIn) {
        final pendingExtra = ref.read(pendingNavigationExtraProvider);
        final target = widget.redirectTo;
        if (target != null && target.isNotEmpty) {
          if (pendingExtra != null && pendingExtra.isNotEmpty) {
            context.go(target, extra: pendingExtra);
          } else {
            context.go(target);
          }
        } else {
          context.go(AppRoutes.home);
        }
        ref.read(pendingNavigationExtraProvider.notifier).set(null);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref
          .read(authControllerProvider.notifier)
          .login(_emailController.text.trim(), _passwordController.text);

      if (!mounted) return;

      final authState = ref.read(authControllerProvider);
      authState.whenOrNull(
        error: (error, _) {
          final raw = error.toString().replaceFirst('Exception: ', '');
          final message = raw.contains('DioException')
              ? 'Terjadi kesalahan jaringan, coba lagi'
              : raw;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              duration: const Duration(seconds: 4),
            ),
          );
        },
        data: (_) {
          dev.log('✅ Login success, invalidating profile...');
          ref.invalidate(profileControllerProvider);
          final authData = ref.read(authControllerProvider).asData?.value;
          final pendingExtra = ref.read(pendingNavigationExtraProvider);
          final target = widget.redirectTo;
          dev.log('🎯 Redirect target: $target, pendingExtra: $pendingExtra');

          // untuk kirim fcm_token setelah OTP berhasil.
          if (authData != null && authData.isVerified != 1) {
            final email = authData.email ?? _emailController.text.trim();
            dev.log('🔑 Belum terverifikasi, ke /verify');
            context.go(
              '${AppRoutes.verify}?email=$email',
              extra: {'email': email, 'password': _passwordController.text},
            );
            return;
          }

          if (target != null && target.isNotEmpty) {
            if (pendingExtra != null && pendingExtra.isNotEmpty) {
              dev.log('🚀 Navigating to $target with extra: $pendingExtra');
              context.go(target, extra: pendingExtra);
            } else {
              dev.log('🚀 Navigating to $target without extra');
              context.go(target);
            }
            ref.read(pendingNavigationExtraProvider.notifier).set(null);
          } else {
            dev.log('🏠 Navigating to home');
            context.go(AppRoutes.home);
          }
        },
      );
    } catch (e) {
      if (!mounted) return;
      final raw = e.toString().replaceFirst('Exception: ', '');
      final message = raw.contains('DioException')
          ? 'Terjadi kesalahan jaringan, coba lagi'
          : raw;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        leading: (widget.redirectTo != null || context.canPop())
            ? IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  if (widget.redirectTo != null &&
                      !AuthGuard.requiresLogin(widget.redirectTo!)) {
                    context.go(widget.redirectTo!);
                  } else {
                    context.go(AppRoutes.home);
                  }
                },
              )
            : null,
        title: const Text(
          'Login',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: isDark ? AppColors.textLight : AppColors.textDark,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 48),
                Text(
                  'Masuk',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masuk untuk melanjutkan',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                ),
                const SizedBox(height: 32),

                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'No Whatsapp / Email',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email atau nomor telepon wajib diisi';
                    }
                    final trimmed = value.trim();
                    // Email
                    if (trimmed.contains('@')) return null;
                    // Phone: terima +, spasi, - serta digit (8-15 digit)
                    final digits = trimmed.replaceAll(RegExp(r'[\D]'), '');
                    if (digits.length >= 8 && digits.length <= 15) {
                      return null;
                    }
                    return 'Masukkan email atau nomor telepon yang valid';
                  },
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    border: const OutlineInputBorder(),
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
                    if (value == null || value.isEmpty) {
                      return 'Password wajib diisi';
                    }
                    if (value.length < 6) {
                      return 'Minimal 6 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 0),
                TextButton(
                  onPressed: () => context.push(AppRoutes.forgotPassword),
                  child: const Text('Lupa Password?'),
                ),
                const SizedBox(height: 8),

                CustomButton(
                  text: 'Masuk',
                  isLoading: _isLoading,
                  onPressed: _handleLogin,
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Belum punya akun?'),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.register),
                      child: const Text('Daftar'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                CustomButton(
                  text: 'Lewati & Lihat Profil',
                  variant: CustomButtonVariant.outline,
                  prefixIcon: Icons.skip_next_rounded,
                  onPressed: () => context.go(AppRoutes.profile),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
