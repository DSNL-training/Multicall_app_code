import 'package:flutter/material.dart';

class DashedDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashGap;
  final Color color;

  const DashedDivider({
    super.key,
    this.height = 1,
    this.dashWidth = 5,
    this.dashGap = 3,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        final dashPaint = Paint()
          ..color = color
          ..strokeWidth = height;
        final dash = <Widget>[];
        double remainingWidth = boxWidth;
        while (remainingWidth > 0) {
          final dashAndGapWidth = dashWidth + dashGap;
          if (remainingWidth >= dashAndGapWidth) {
            dash.add(SizedBox(
              width: dashWidth,
              height: height,
              child: CustomPaint(
                painter: _DashedLinePainter(dashPaint),
              ),
            ));
            dash.add(SizedBox(width: dashGap));
            remainingWidth -= dashAndGapWidth;
          } else {
            dash.add(SizedBox(
              width: remainingWidth,
              height: height,
              child: CustomPaint(
                painter: _DashedLinePainter(dashPaint),
              ),
            ));
            remainingWidth = 0;
          }
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: dash,
        );
      },
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final Paint _paint;

  _DashedLinePainter(this._paint);

  @override
  void paint(Canvas canvas, Size size) {
    double startY = size.height / 2;
    canvas.drawLine(Offset(0, startY), Offset(size.width, startY), _paint);
  }

  @override
  bool shouldRepaint(_DashedLinePainter oldDelegate) {
    return false;
  }
}
