import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class PaymentTimerWidget extends StatefulWidget {
  final DateTime expiredAt;
  final VoidCallback? onExpired;

  const PaymentTimerWidget({
    super.key,
    required this.expiredAt,
    this.onExpired,
  });

  @override
  State<PaymentTimerWidget> createState() => _PaymentTimerWidgetState();
}

class _PaymentTimerWidgetState extends State<PaymentTimerWidget> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _isExpired = false;

  @override
  void initState() {
    super.initState();
    _updateRemaining();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemaining();
    });
  }

  void _updateRemaining() {
    if (!mounted) return;

    final now = DateTime.now();
    final remaining = widget.expiredAt.difference(now);

    if (remaining.isNegative || remaining.inSeconds <= 0) {
      setState(() {
        _remaining = Duration.zero;
        _isExpired = true;
      });
      _timer?.cancel();
      widget.onExpired?.call();
    } else {
      setState(() {
        _remaining = remaining;
        _isExpired = false;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _isExpired
            ? AppColors.danger.withValues(alpha: 0.1)
            : AppColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _isExpired
              ? AppColors.danger.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _isExpired ? Icons.error_outline_rounded : Icons.timer_outlined,
                size: 20,
                color: _isExpired ? AppColors.danger : AppColors.warning,
              ),
              const SizedBox(width: 8),
              Text(
                _isExpired ? 'Waktu pembayaran habis' : 'Selesaikan pembayaran sebelum',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: _isExpired
                      ? AppColors.danger
                      : (isDark ? Colors.white : AppColors.ink),
                ),
              ),
            ],
          ),
          if (!_isExpired)
            Text(
              _formatDuration(_remaining),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.warning,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
        ],
      ),
    );
  }
}