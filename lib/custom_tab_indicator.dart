import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTabIndicator extends Decoration {

  @override
  _CustomPainter createBoxPainter([VoidCallback? onChanged]) {
    assert(onChanged != null);
    return _CustomPainter(this, onChanged!);
  }
}

class _CustomPainter extends BoxPainter {
  final CustomTabIndicator decoration;

  _CustomPainter(this.decoration, VoidCallback onChanged)
      : assert(decoration != null),
        super(onChanged);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    assert(configuration.size != null);

    //offset is the position from where the decoration should be drawn.
    //configuration.size tells us about the height and width of the tab.
    // final Rect rect = offset & configuration.size!;
    double indicatorHeight = 35;
    final Rect rect = Offset(offset.dx + (configuration.size!.width/2) - indicatorHeight/2, ((configuration.size!.height / 2)-indicatorHeight/2)) & Size(indicatorHeight, indicatorHeight);
    final Paint paint = Paint();
    paint.color = Color(0xFF25BBA0);
    paint.style = PaintingStyle.fill;
    
    canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(10.0)), paint);
  }

}
