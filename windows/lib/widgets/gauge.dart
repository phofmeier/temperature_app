import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class DoubleGaugeTest extends StatefulWidget {
  const DoubleGaugeTest({
    super.key,
  });

  @override
  State<DoubleGaugeTest> createState() => _DoubleGaugeTestState();
}

class _DoubleGaugeTestState extends State<DoubleGaugeTest> {
  double _outerValue = 0;
  double _innerValue = 0;

  void setInnerValue(double newInnerValue) {
    setState(() {
      _innerValue = ((_innerValue + 0.5) % 20);
      // _innerValue = pi / 2.0;
      // _innerValue = newInnerValue;
    });
  }

  void setOuterValue(double newOuterValue) {
    setState(() {
      _outerValue = ((_outerValue - 0.5) % 20.0);
      // _outerValue = newOuterValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DoubleGauge(
          innerValue: _innerValue,
          outerValue: _outerValue,
        ),
        TextButton(
            onPressed: () {
              setInnerValue(100);
              setOuterValue(100);
            },
            child: const Text("Press")),
      ],
    );
  }
}

class DoubleGauge extends StatelessWidget {
  const DoubleGauge({
    super.key,
    required this.innerValue,
    required this.outerValue,
    this.width = 300,
    this.innerScale = const Pair<double>(0, 20),
    this.outerScale = const Pair<double>(0, 20),
    this.unitNameInner = "",
    this.unitNameOuter = "",
  });
  final double innerValue;
  final double outerValue;
  final double width;
  final String unitNameInner;
  final String unitNameOuter;
  final Pair<double> innerScale;
  final Pair<double> outerScale;

  @override
  Widget build(BuildContext context) {
    int numberTicks = ((outerScale.second - outerScale.first) / 10).round() * 5;
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ValuedGauge(
            gauge: TickedLabeledGauge(
              value: outerValue,
              width: width,
              scale: outerScale,
              arrowOffsetMultiplier: 0.35,
              numberTicks: numberTicks,
            ),
            unitName: unitNameOuter,
          ),
          ValuedGauge(
            gauge: Gauge(
              value: innerValue,
              width: width * 0.3,
              scale: innerScale,
              arrowOffsetMultiplier: 0.45,
              // numberTicks: 1,
              // majorTickMultiple: 1,
            ),
            unitName: unitNameInner,
          ),
        ],
      ),
    );
  }
}

class GaugeArrowPainter extends CustomPainter {
  GaugeArrowPainter({this.angle = 0, this.arrowOffsetMultiplier = 1.0});
  final double angle;
  final double arrowOffsetMultiplier;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.black;
    final path = Path();
    canvas.save();
    canvas.translate(size.width / 2.0, size.height);
    canvas.rotate(angle);
    canvas.translate(-size.width / 2.0, -size.height);
    path.moveTo(0, size.height * arrowOffsetMultiplier);
    path.lineTo(size.width / 2.0, 0);
    path.lineTo(size.width, size.height * arrowOffsetMultiplier);
    path.close();
    canvas.drawPath(path, paint);
    canvas.drawCircle(
        Offset(size.width / 2, size.height * arrowOffsetMultiplier),
        size.width / 2.0,
        paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class GaugeScalePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2.0, size.height);
    final widthArc = 0.15 * size.width / 2.0;
    final rect = Rect.fromCircle(
        center: center, radius: (size.width / 2) - widthArc / 2);
    const gradient = SweepGradient(
      colors: [Colors.green, Colors.yellow, Colors.red],
      stops: [0.5, 0.7, 0.9],
    );
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = widthArc
      // Use [PaintingStyle.fill] if you want the circle to be filled.
      ..style = PaintingStyle.stroke;
    canvas.drawArc(rect, pi, pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class GaugeScaleTicksPainter extends CustomPainter {
  GaugeScaleTicksPainter({
    this.numberTicks = 30,
    this.ticksLength = 20,
    this.majorTickMultiple = 5,
  });
  final int numberTicks;
  final double ticksLength;
  final int majorTickMultiple;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2.0, size.height);
    final double radius = (size.width / 2.0);
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2;
    // Use [PaintingStyle.fill] if you want the circle to be filled.
    // ..style = PaintingStyle.stroke;
    for (var i = 0; i <= numberTicks; i++) {
      double angle = i * pi / numberTicks;
      double mainTick = ticksLength;
      if ((i % majorTickMultiple) == 0) {
        mainTick = 0;
      }
      Offset p1 = center - Offset(cos(angle), sin(angle)) * (radius - mainTick);
      Offset p2 =
          center - Offset(cos(angle), sin(angle)) * (radius - 2 * ticksLength);
      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class GaugeScaleTicksLabelPainter extends CustomPainter {
  GaugeScaleTicksLabelPainter(
      {this.numberTicks = 30,
      this.scale = const Pair<double>(0, 1),
      this.majorTickMultiple = 5,
      this.textStyle = const TextStyle(
        color: Colors.black,
        fontSize: 30,
      )});
  final int numberTicks;
  final Pair<double> scale;
  final int majorTickMultiple;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2.0, size.height);
    final double radius = (size.width / 2.0);

    for (var i = 0; i <= numberTicks; i++) {
      double angle = i * pi / numberTicks;

      if ((i % majorTickMultiple) == 0) {
        String label = (scale.first + angle * (scale.second - scale.first) / pi)
            .toStringAsPrecision(3);
        TextSpan textSpan = TextSpan(
          text: label,
          style: textStyle,
        );
        TextPainter textPainter = TextPainter(
            text: textSpan,
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center);
        textPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
        );

        Offset p = center - Offset(cos(angle), sin(angle)) * (radius);
        Offset textOffset = Offset(
                textPainter.width / 2.0, textPainter.height / 2.0) -
            Offset(
                cos(angle) * textPainter.width / 2,
                sin(angle) * textPainter.height / 2 -
                    (0.5 * cos(2.0 * angle) + 0.5) * textPainter.height / 2);

        textPainter.paint(canvas, p - textOffset);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Gauge extends StatelessWidget {
  const Gauge(
      {super.key,
      required this.value,
      required this.width,
      required this.scale,
      this.arrowOffsetMultiplier = 1});
  final double value;
  final double width;
  final double arrowOffsetMultiplier;
  final Pair<double> scale;

  @override
  Widget build(BuildContext context) {
    final double angle = clampDouble(
        ((value - scale.first) / (scale.second - scale.first)) * pi - pi / 2.0,
        -pi / 2.0,
        pi / 2.0);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          painter: GaugeScalePainter(),
          size: Size((width), (width) / 2),
        ),
        CustomPaint(
          painter: GaugeArrowPainter(
            angle: angle,
            arrowOffsetMultiplier: arrowOffsetMultiplier,
          ),
          size: Size(0.04 * (width), 0.5 * (width)),
        ),
      ],
    );
  }
}

class TickedLabeledGauge extends Gauge {
  const TickedLabeledGauge({
    super.key,
    required super.value,
    required super.width,
    required super.scale,
    super.arrowOffsetMultiplier = 1,
    this.numberTicks = 30,
    this.majorTickMultiple = 5,
  });

  final int numberTicks;
  final int majorTickMultiple;

  @override
  Widget build(BuildContext context) {
    final double ticksLength = 0.025 * width;
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Gauge(
          value: value,
          width: width - 6 * ticksLength,
          scale: scale,
          arrowOffsetMultiplier: arrowOffsetMultiplier,
        ),
        CustomPaint(
          painter: GaugeScaleTicksPainter(
            numberTicks: numberTicks,
            ticksLength: ticksLength,
            majorTickMultiple: majorTickMultiple,
          ),
          size: Size((width - 2 * ticksLength), (width - 2 * ticksLength) / 2),
        ),
        CustomPaint(
          painter: GaugeScaleTicksLabelPainter(
              numberTicks: numberTicks,
              scale: scale,
              majorTickMultiple: majorTickMultiple,
              textStyle: Theme.of(context).textTheme.bodyLarge!),
          size: Size(width, width / 2),
        )
      ],
    );
  }
}

class ValuedGauge extends StatelessWidget {
  const ValuedGauge({
    super.key,
    required this.gauge,
    this.unitName = "",
  });

  final String unitName;
  final Gauge gauge;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        gauge,
        Positioned(
            top: (gauge.arrowOffsetMultiplier * gauge.width / 2.0) +
                0.15 * gauge.width / 2.0,
            child: Text(
              gauge.value.toStringAsPrecision(4) + unitName,
              style: Theme.of(context).textTheme.bodyLarge,
            ))
      ],
    );
  }
}
