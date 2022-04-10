import 'package:flutter/material.dart';

/// Indicador personalizado utilizado un canvas
class CustomTabIndicator extends Decoration {
  final double separation;
  final double radius;

  CustomTabIndicator({this.separation = 0.0, this.radius = 24.0});

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _IndicatorPainter(
      separation: separation,
      radius: radius, 
      onChanged: onChanged
    );
  }
}

class _IndicatorPainter extends BoxPainter {
  final double separation;
  final double radius;

  const _IndicatorPainter({
    required this.separation, 
    required this.radius,
    VoidCallback? onChanged
  }) : super(onChanged);

  static const _icon = 24.0;
  static const _margin = 10.0;
  static const _text = 14.0;
  static const _space = (72.0 - _icon -_margin - _text) / 2;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final paint = Paint()..color = Colors.white24;

    final center = Offset(offset.dx + (configuration.size!.width/2) - (radius/2) , _space - (separation/2));

    final Rect rect = center & Size(radius, _icon);    

    // canvas.drawRRect(RRect.fromRectAndRadius(rect, Radius.circular(0.0)), paint);
    canvas.drawCircle(rect.center, radius / 2, paint);
  }
}