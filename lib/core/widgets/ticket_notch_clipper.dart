import 'package:flutter/material.dart';

/// Membentuk 2 lubang setengah lingkaran di sisi kiri & kanan card,
/// pada posisi vertikal [notchPositionRatio] dari tinggi total.
/// Ini yang membuat card terlihat seperti tiket/boarding pass sobek.
class TicketNotchClipper extends CustomClipper<Path> {
  final double notchRadius;
  final double notchPositionRatio;

  const TicketNotchClipper({
    this.notchRadius = 12,
    this.notchPositionRatio = 0.62,
  });

  @override
  Path getClip(Size size) {
    final notchY = size.height * notchPositionRatio;
    final path = Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final leftNotch = Path()
      ..addOval(
        Rect.fromCircle(center: Offset(0, notchY), radius: notchRadius),
      );
    final rightNotch = Path()
      ..addOval(
        Rect.fromCircle(
          center: Offset(size.width, notchY),
          radius: notchRadius,
        ),
      );

    return Path.combine(
      PathOperation.difference,
      path,
      Path.combine(PathOperation.union, leftNotch, rightNotch),
    );
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
