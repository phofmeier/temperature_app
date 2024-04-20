import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class GaugeSettings {
  final Pair<double> scale;
  final String unitName;
  double? targetVal;
  double? targetTolLow;
  double? targetTolHigh;

  GaugeSettings(
      {required this.scale,
      required this.unitName,
      this.targetVal,
      this.targetTolLow,
      this.targetTolHigh});

  double clipColorGrad(double val) {
    return min(1.0, max(0.5, val));
  }

  SweepGradient getColorGradient() {
    if (targetVal == null) {
      return const SweepGradient(
        colors: [
          Colors.red,
          Colors.green,
          Colors.red,
        ],
        stops: [0.5, 0.75, 1.0],
      );
    }
    double targetScaled =
        (targetVal! - scale.first) / (scale.second - scale.first) / 2.0 + 0.5;
    double tolLowScaled =
        ((targetTolLow ?? 0.10) / (scale.second - scale.first)) / 2.0;
    double tolHighScaled =
        ((targetTolHigh ?? 0.10) / (scale.second - scale.first)) / 2.0;

    return SweepGradient(
      colors: const [
        Colors.red,
        Colors.red,
        Colors.orange,
        Colors.green,
        Colors.green,
        Colors.green,
        Colors.orange,
        Colors.red,
        Colors.red,
      ],
      stops: [
        0.5,
        clipColorGrad(targetScaled - 2.0 * tolLowScaled),
        clipColorGrad(targetScaled - 1.1 * tolLowScaled),
        clipColorGrad(targetScaled - 0.9 * tolLowScaled),
        clipColorGrad(targetScaled),
        clipColorGrad(targetScaled + 0.9 * tolHighScaled),
        clipColorGrad(targetScaled + 1.1 * tolHighScaled),
        clipColorGrad(targetScaled + 2.0 * tolHighScaled),
        1.0,
      ],
    );
  }
}

class DoubleGauge extends StatelessWidget {
  const DoubleGauge({
    super.key,
    required this.innerValue,
    required this.outerValue,
    required this.innerSettings,
    required this.outerSettings,
    this.width = 300,
  });
  final double innerValue;
  final double outerValue;
  final double width;
  final GaugeSettings innerSettings;
  final GaugeSettings outerSettings;

  @override
  Widget build(BuildContext context) {
    int numberTicks =
        ((outerSettings.scale.second - outerSettings.scale.first) / 10)
                .round() *
            5;
    return Container(
      padding: const EdgeInsets.all(8.0),
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ValuedGauge(
            gauge: TickedLabeledGauge(
              value: outerValue,
              width: width,
              settings: outerSettings,
              arrowOffsetMultiplier: 0.35,
              numberTicks: numberTicks,
            ),
            unitName: outerSettings.unitName,
          ),
          ValuedGauge(
            gauge: Gauge(
              value: innerValue,
              width: width * 0.3,
              settings: innerSettings,
              arrowOffsetMultiplier: 0.45,
              // numberTicks: 1,
              // majorTickMultiple: 1,
            ),
            unitName: innerSettings.unitName,
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
  final SweepGradient colorGradient;
  GaugeScalePainter({
    required this.colorGradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2.0, size.height);
    final widthArc = 0.15 * size.width / 2.0;
    final rect = Rect.fromCircle(
        center: center, radius: (size.width / 2) - widthArc / 2);
    final paint = Paint()
      ..shader = colorGradient.createShader(rect)
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
          // textAlign: TextAlign.center,
        );
        textPainter.layout(
          minWidth: 0,
          maxWidth: size.width,
        );

        Offset p = center - Offset(cos(angle), sin(angle)) * (radius);
        Offset textOffset =
            Offset(textPainter.width / 2.0, textPainter.height / 2.0) -
                Offset(cos(angle) * textPainter.width / 2.0,
                    -(0.5 * cos(2.0 * angle) + 0.5) * textPainter.height / 2.0);

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
  const Gauge({
    super.key,
    required this.value,
    required this.width,
    required this.settings,
    this.arrowOffsetMultiplier = 1,
  });
  final double value;
  final double width;
  final double arrowOffsetMultiplier;
  final GaugeSettings settings;

  @override
  Widget build(BuildContext context) {
    final double angle = clampDouble(
        ((value - settings.scale.first) /
                    (settings.scale.second - settings.scale.first)) *
                pi -
            pi / 2.0,
        -pi / 2.0,
        pi / 2.0);

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CustomPaint(
          painter:
              GaugeScalePainter(colorGradient: settings.getColorGradient()),
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
    required super.settings,
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
          settings: settings,
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
              scale: settings.scale,
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
          child: FittedBox(
            child: Text(
              gauge.value.toStringAsPrecision(3) + unitName,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        )
      ],
    );
  }
}
