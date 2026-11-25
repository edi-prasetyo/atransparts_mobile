import 'package:flutter/material.dart';

/// Garis putus-putus horizontal. Dipakai di TicketVoucherCard untuk
/// meniru sobekan tiket, tapi dibuat generic supaya bisa dipakai
/// di widget lain juga (misal pembatas struk/invoice).
class DashedDivider extends StatelessWidget {
  final Color color;
  final double dashWidth;
  final double dashGap;
  final double height;

  const DashedDivider({
    super.key,
    this.color = const Color(0xFFE3E5F0),
    this.dashWidth = 6,
    this.dashGap = 4,
    this.height = 1,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final dashCount = (constraints.maxWidth / (dashWidth + dashGap))
            .floor();
        return Flex(
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return Padding(
              padding: EdgeInsets.only(right: dashGap),
              child: Container(width: dashWidth, height: height, color: color),
            );
          }),
        );
      },
    );
  }
}
