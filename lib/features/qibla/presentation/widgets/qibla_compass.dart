import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

class QiblaCompass extends StatelessWidget {
  const QiblaCompass({super.key, required this.bearing});

  final double bearing;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 260),
        child: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.surface,
              border: Border.all(color: AppColors.lime, width: 3),
            ),
            child: Stack(
              children: [
                CustomPaint(painter: const _DialPainter()),
                const Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: _CardinalLabel('U'),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: _CardinalLabel('T'),
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 12),
                    child: _CardinalLabel('S'),
                  ),
                ),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: _CardinalLabel('B'),
                  ),
                ),
                Transform.rotate(
                  angle: bearing * math.pi / 180,
                  child: Center(
                    child: CustomPaint(
                      size: const Size(120, 170),
                      painter: const _NeedlePainter(),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: AppColors.lime,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColors.dark, width: 3),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _CardinalLabel extends StatelessWidget {
  const _CardinalLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(
          color: AppColors.dark,
          fontWeight: FontWeight.w800,
          fontSize: 15,
        ),
      );
}

class _DialPainter extends CustomPainter {
  const _DialPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2;
    final paint = Paint()
      ..color = AppColors.lime.withValues(alpha: 0.45)
      ..strokeWidth = 1.5;

    for (var index = 0; index < 24; index++) {
      final angle = index * 15 * math.pi / 180;
      final direction = Offset(math.sin(angle), -math.cos(angle));
      final isMajor = index % 6 == 0;
      paint.strokeWidth = isMajor ? 2.5 : 1.2;
      canvas.drawLine(
        center + direction * (radius - (isMajor ? 22 : 14)),
        center + direction * (radius - 6),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _NeedlePainter extends CustomPainter {
  const _NeedlePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    final tip = Path()
      ..moveTo(centerX, centerY - size.height / 2 + 8)
      ..lineTo(centerX - 15, centerY + 12)
      ..lineTo(centerX + 15, centerY + 12)
      ..close();
    canvas.drawPath(
      tip,
      Paint()..color = AppColors.dark,
    );

    final tail = Path()
      ..moveTo(centerX, centerY + size.height / 2 - 8)
      ..lineTo(centerX - 11, centerY + 12)
      ..lineTo(centerX + 11, centerY + 12)
      ..close();
    canvas.drawPath(
      tail,
      Paint()..color = AppColors.lime.withValues(alpha: 0.55),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
