import 'package:flutter/material.dart';
import 'package:temperature_app/utils.dart';

class LineChartTest extends StatelessWidget {
  const LineChartTest({super.key});

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    List<Measurement> data = [];
    for (var i = -10000; i < 10000; i++) {
      data.add(Measurement(now.add(Duration(seconds: i * 1)),
          -10.0 * i * i + 0.1 * i + 0.1 * i * i * i));
    }
    return LineChart(data: data);
  }
}

class LineChart extends StatelessWidget {
  const LineChart({
    super.key,
    required this.data,
  });
  final List<Measurement> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            painter: DataPainter(data: data),
            size: Size.infinite,
          ),
          CustomPaint(
            painter: CoordinatePainter(),
            size: Size.infinite,
          )
        ],
      ),
    );
  }
}

class DataPainter extends CustomPainter {
  const DataPainter({required this.data});
  final List<Measurement> data;

  @override
  void paint(Canvas canvas, Size size) {
    var minX = data[0].timestamp;
    var maxX = data.last.timestamp;

    var xMultiplier = size.width /
        (maxX.microsecondsSinceEpoch - minX.microsecondsSinceEpoch);

    var minY = data
        .reduce((current, next) => current.value < next.value ? current : next)
        .value;
    var maxY = data
        .reduce((current, next) => current.value > next.value ? current : next)
        .value;
    var yMultiplier = size.height / (maxY - minY);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();

    double xInCanvas(DateTime timestamp) =>
        (timestamp.microsecondsSinceEpoch - minX.microsecondsSinceEpoch) *
        xMultiplier;

    double yInCanvas(double value) => (-1.0 * value + maxY) * yMultiplier;

    path.moveTo(xInCanvas(data[0].timestamp), yInCanvas(data[0].value));
    for (var i = 1; i < data.length; i++) {
      path.lineTo(xInCanvas(data[i].timestamp), yInCanvas(data[i].value));
    }

    // path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class CoordinatePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.fill;

    canvas.drawLine(const Offset(0, 0), Offset(0, size.height), paint);
    var path = Path();
    path.moveTo(0, 0);
    path.lineTo(0 + 4, 12);
    path.lineTo(0 - 4, 12);
    path.close();

    canvas.drawLine(
        Offset(size.width, size.height), Offset(0, size.height), paint);
    path.moveTo(size.width, size.height);
    path.lineTo(size.width - 12, size.height + 4);
    path.lineTo(size.width - 12, size.height - 4);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
