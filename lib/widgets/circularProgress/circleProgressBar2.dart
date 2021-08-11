import 'dart:math' as Math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

/// Draws a circular animated progress bar.
class CircleProgressBar2 extends StatefulWidget {
  final Duration animationDuration;
  final Color backgroundColor;
  final Color foregroundColor;
  final double value;
  final double value2;
  final double extraStrokeWidth;
  final double innerStrokeWidth;
  final Widget center;

  const CircleProgressBar2({
    Key key,
    this.animationDuration,
    this.backgroundColor,
    this.extraStrokeWidth=3.0,
    this.innerStrokeWidth=3.0,
    this.center,
    @required this.foregroundColor,
    @required this.value,
    @required this.value2,
  }) : super(key: key);

  @override
  CircleProgressBarState2 createState() {
    return CircleProgressBarState2();
  }
}

class CircleProgressBarState2 extends State<CircleProgressBar2> with TickerProviderStateMixin {
  // Used in tweens where a backgroundColor isn't given.
  static const TRANSPARENT = Color(0x00000000);
  AnimationController _controller,_controller2;
  Animation<double> curve,curve2;
  Tween<double> valueTween,valueTween2;
  Tween<Color> backgroundColorTween;
  Tween<Color> foregroundColorTween;

  @override
  void initState() {
    super.initState();

    this._controller = AnimationController(duration: this.widget.animationDuration ?? const Duration(seconds: 1), vsync: this,);
    curve = Tween<double>(begin: 0, end: widget.value).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    curve2 = Tween<double>(begin: widget.value, end: widget.value2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    this._controller.forward();

  }

  @override
  void didUpdateWidget(CircleProgressBar2 oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (this.widget.value != oldWidget.value) {

      double beginValue = this.valueTween?.evaluate(this.curve) ?? oldWidget?.value ?? 0;

      curve = Tween<double>(begin: 0, end: widget.value).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      curve2 = Tween<double>(begin: widget.value, end: widget.value2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

   //   this.valueTween = Tween<double>(begin: beginValue, end: this.widget.value ?? 1,);

      this._controller
        ..value = 0
        ..forward();
    }
    if (this.widget.value2 != oldWidget.value2) {

      double beginValue = this.valueTween2?.evaluate(this.curve2) ?? oldWidget?.value2 ?? 0;

      curve = Tween<double>(begin: 0, end: widget.value).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      curve2 = Tween<double>(begin: widget.value, end: widget.value2).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

//      this.valueTween2 = Tween<double>(begin: beginValue, end: this.widget.value2 ?? 1,);


      this._controller
        ..value = 0
        ..forward();
    }
  }

  @override
  void dispose() {
    this._controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: _controller,
        child:widget.center,
        builder: (context, child) {
          final backgroundColor = this.backgroundColorTween?.evaluate(this.curve) ?? this.widget.backgroundColor;
          final foregroundColor = this.foregroundColorTween?.evaluate(this.curve) ?? this.widget.foregroundColor;

          return CustomPaint(
            child: child,
            foregroundPainter: CircleProgressBarPainter(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                percentage:curve.value,
                extraStrokeWidth: widget.extraStrokeWidth,
                innerStrokeWidth: widget.innerStrokeWidth,
                percentage2: curve2.value
              // percentage2:this.valueTween2.evaluate(this.curve2),
            ),
          );
        },
      ),
    );
    return AspectRatio(
      aspectRatio: 1,
      child: AnimatedBuilder(
        animation: this.curve,
        child: Container(),
        builder: (context, child) {
          final backgroundColor = this.backgroundColorTween?.evaluate(this.curve) ?? this.widget.backgroundColor;
          final foregroundColor = this.foregroundColorTween?.evaluate(this.curve) ?? this.widget.foregroundColor;

          return CustomPaint(
            child: child,
            foregroundPainter: CircleProgressBarPainter(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                percentage: this.valueTween.evaluate(this.curve),
                extraStrokeWidth: widget.extraStrokeWidth,
                innerStrokeWidth: widget.innerStrokeWidth,
                percentage2: widget.value2
               // percentage2:this.valueTween2.evaluate(this.curve2),
            ),
          );
        },
      ),
    );
  }
}

// Draws the progress bar.
class CircleProgressBarPainter extends CustomPainter {
  final double percentage;
  final double percentage2;
  final double strokeWidth;
  final double extraStrokeWidth;
  final Color backgroundColor;
  final Color foregroundColor;
  final double innerStrokeWidth;
  CircleProgressBarPainter({
    this.backgroundColor,
    this.extraStrokeWidth,
    this.innerStrokeWidth,
    @required this.foregroundColor,
    @required this.percentage,
    @required this.percentage2,
    double strokeWidth,
  }) : this.strokeWidth = strokeWidth ?? 6;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero);
    final Size constrainedSize =
        size - Offset(this.strokeWidth, this.strokeWidth);
    final shortestSide =
    Math.min(constrainedSize.width, constrainedSize.height);
    final foregroundPaint = Paint()
      ..color = Colors.green
      ..strokeWidth = this.strokeWidth+this.extraStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final foregroundPaint2 = Paint()
      ..color = Colors.red
      ..strokeWidth = this.strokeWidth+this.extraStrokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final radius = (shortestSide / 2);

    // Start at the top. 0 radians represents the right edge
    final double startAngle = -(2 * Math.pi * 0.25);
    final double sweepAngle = (2 * Math.pi * (this.percentage ?? 0));

    // Don't draw the background if we don't have a background color
    if (this.backgroundColor != null) {
      final backgroundPaint = Paint()
        ..color = this.backgroundColor
        ..strokeWidth = this.innerStrokeWidth
        ..style = PaintingStyle.stroke;
      canvas.drawCircle(center, radius, backgroundPaint);
    }
   // print(percentage);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      foregroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      sweepAngle+4.9,
     // (2 * Math.pi * (percentage2??0.0)),
      (2 * Math.pi * (percentage2??0.0))-0.35,
      false,
      foregroundPaint2,
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    // return true;
    final oldPainter = (oldDelegate as CircleProgressBarPainter);
    return oldPainter.percentage != this.percentage ||
        oldPainter.percentage2 != this.percentage2 ||
        oldPainter.backgroundColor != this.backgroundColor ||
        oldPainter.foregroundColor != this.foregroundColor ||
        oldPainter.strokeWidth != this.strokeWidth;
  }
}
