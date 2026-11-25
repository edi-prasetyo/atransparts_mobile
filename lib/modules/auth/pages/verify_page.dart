import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/providers/auth_provider.dart';
import '../../../core/services/secure_service.dart';
import '../../../modules/auth/controllers/auth_controller.dart';
import '../../../modules/profile/controllers/profile_controller.dart';
import '../../../routes/app_router.dart';

class VerifyPage extends ConsumerStatefulWidget {
  const VerifyPage({super.key});

  @override
  ConsumerState<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends ConsumerState<VerifyPage> {
  final _otpControllers = List.generate(6, (_) => TextEditingController());
  final _otpFocusNodes = List.generate(6, (_) => FocusNode());

  bool _isLoading = false;
  bool _isResendLoading = false;
  bool _isInitialCheckLoading = true;
  int _resendCountdown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final authData = ref.read(authControllerProvider).asData?.value;
      final otpExpiresAt = authData?.otpExpiresAt;
      _resendCountdown = _calculateRemainingSeconds(otpExpiresAt);
      _startResendTimer();
      setState(() => _isInitialCheckLoading = false); // <-- tambahkan ini
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _otpControllers) {
      c.dispose();
    }
    for (final f in _otpFocusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  int _calculateRemainingSeconds(String? otpExpiresAt) {
    if (otpExpiresAt == null || otpExpiresAt.isEmpty) return 30;
    try {
      final expiresAt = DateTime.parse(otpExpiresAt).toUtc();
      final now = DateTime.now().toUtc();
      final diff = expiresAt.difference(now).inSeconds;
      return diff > 0 ? diff : 0;
    } catch (e) {
      return 30;
    }
  }

  void _startResendTimer() {
    _resendCountdown = _resendCountdown;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown <= 0) {
        timer.cancel();
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  String _buildSubtitle({String? email, String? phone}) {
    final hasEmail = email != null && email.isNotEmpty;
    final hasPhone = phone != null && phone.isNotEmpty;

    if (hasEmail && hasPhone) {
      return 'Kode verifikasi telah dikirim ke $email atau ke whatsapp $phone';
    }
    if (hasEmail) {
      return 'Kode verifikasi telah dikirim ke $email';
    }
    if (hasPhone) {
      return 'Kode verifikasi telah dikirim ke $phone';
    }
    return 'Masukkan kode verifikasi yang telah dikirim';
  }

  Future<void> _handleVerify() async {
    if (_otpCode.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Masukkan 6 digit kode verifikasi')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(authControllerProvider.notifier).verifyOtp(_otpCode);

      if (!mounted) return;

      final extra = GoRouterState.of(context).extra as Map<String, dynamic>?;
      final identifier =
          (extra?['email']?.toString() ??
                  GoRouterState.of(context).uri.queryParameters['email'])
              ?.trim();
      final password = extra?['password']?.toString();

      if (identifier != null &&
          identifier.isNotEmpty &&
          password != null &&
          password.isNotEmpty) {
        await ref
            .read(authControllerProvider.notifier)
            .login(identifier, password);
      } else {
        final token =
            ref.read(authControllerProvider).asData?.value?.accessToken ?? '';
        if (token.isNotEmpty) {
          ref.read(authProvider.notifier).login(token, isVerified: 1);
        }
      }

      if (!mounted) return;
      ref.invalidate(profileControllerProvider);
      context.go('${AppRoutes.home}?verified=1');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Verifikasi gagal: ${e.toString().replaceFirst('Exception: ', '')}',
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleResend() async {
    if (_resendCountdown > 0 || _isResendLoading) return;

    setState(() => _isResendLoading = true);
    final storage = ref.read(secureStorageProvider);
    final queryEmail = GoRouterState.of(context).uri.queryParameters['email'];

    final pendingEmail = await storage.getPendingOtpEmail();
    final pendingPhone = await storage.getPendingOtpPhone();
    final effectiveEmail =
        pendingEmail ??
        queryEmail ??
        ref.read(authControllerProvider).asData?.value?.email;

    if ((effectiveEmail == null || effectiveEmail.isEmpty) &&
        (pendingPhone == null || pendingPhone.isEmpty)) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email atau nomor telepon tidak ditemukan'),
        ),
      );
      setState(() => _isResendLoading = false);
      return;
    }

    try {
      final responseData = await ref
          .read(authControllerProvider.notifier)
          .resendOtp(email: effectiveEmail, phone: pendingPhone);
      if (!mounted) return;

      String? newOtpExpiresAt;
      if (responseData != null) {
        newOtpExpiresAt =
            (responseData['user']?['otp_expires_at'] ??
                    responseData['otp_expires_at'])
                ?.toString();
      }

      final countdown = _calculateRemainingSeconds(newOtpExpiresAt);
      setState(() => _resendCountdown = countdown);
      _startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kode verifikasi telah dikirim ulang')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal mengirim ulang kode: $e')));
    } finally {
      if (mounted) setState(() => _isResendLoading = false);
    }
  }

  void _onOtpChanged(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }
    if (_otpCode.length == 6) {
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final email = GoRouterState.of(context).uri.queryParameters['email'];
    final authData = ref.watch(authControllerProvider).asData?.value;
    final phone = authData?.phone;

    if (_isInitialCheckLoading) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
        ),
        body: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            children: [
              Text(
                'Verifikasi Akun',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _buildSubtitle(email: email, phone: phone),
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 48,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _otpFocusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: Theme.of(context).textTheme.titleLarge,
                      decoration: const InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => _onOtpChanged(index, value),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),

              FilledButton(
                onPressed: _isLoading ? null : _handleVerify,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Verifikasi'),
              ),
              const SizedBox(height: 16),

              Center(
                child: TextButton(
                  onPressed: (_resendCountdown == 0 && !_isResendLoading)
                      ? _handleResend
                      : null,
                  child: _isResendLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _resendCountdown > 0
                              ? 'Kirim ulang kode dalam ${_resendCountdown}s'
                              : 'Kirim ulang kode',
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
