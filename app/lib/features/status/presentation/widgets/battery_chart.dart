import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../battery_history_controller.dart';

class BatteryChart extends StatelessWidget {
  final List<BatterySample> samples;
  const BatteryChart({super.key, required this.samples});

  @override
  Widget build(BuildContext context) {
    if (samples.length < 2) {
      return const SizedBox(
        height: 160,
        child: Center(
          child: Text(
            'Coletando dados...',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      );
    }

    return SizedBox(
      height: 160,
      width: double.infinity,
      child: CustomPaint(painter: _ChartPainter(samples)),
    );
  }
}

class _ChartPainter extends CustomPainter {
  final List<BatterySample> samples;
  _ChartPainter(this.samples);

  static const _leftPad = 40.0;
  static const _bottomPad = 20.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chart = Rect.fromLTWH(
      _leftPad,
      4,
      size.width - _leftPad - 4,
      size.height - _bottomPad - 4,
    );

    final gridPaint = Paint()
      ..color = Colors.blueGrey.shade50
      ..strokeWidth = 1;

    // Linhas de grade e rótulos do eixo Y (0%, 50%, 100%)
    for (final v in [0, 50, 100]) {
      final y = chart.bottom - chart.height * v / 100;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
      _text(canvas, '$v%', Offset(0, y - 6));
    }

    // Pontos da linha
    final n = samples.length;
    final points = <Offset>[
      for (var i = 0; i < n; i++)
        Offset(
          chart.left + chart.width * i / (n - 1),
          chart.bottom - chart.height * samples[i].percent / 100,
        ),
    ];

    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      line.lineTo(p.dx, p.dy);
    }

    // Área preenchida sob a linha
    final area = Path.from(line)
      ..lineTo(points.last.dx, chart.bottom)
      ..lineTo(points.first.dx, chart.bottom)
      ..close();
    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.blue.withValues(alpha: 0.25),
            AppColors.blue.withValues(alpha: 0.0),
          ],
        ).createShader(chart),
    );

    // Linha
    canvas.drawPath(
      line,
      Paint()
        ..color = AppColors.blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeJoin = StrokeJoin.round,
    );

    // Ponto atual
    canvas.drawCircle(points.last, 4, Paint()..color = AppColors.blue);

    // Rótulos do eixo X (primeira e última leitura)
    _text(canvas, _hhmmss(samples.first.time), Offset(chart.left, chart.bottom + 4));
    final last = _hhmmss(samples.last.time);
    _text(canvas, last, Offset(chart.right - 46, chart.bottom + 4));
  }

  String _hhmmss(DateTime t) =>
      '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}:${t.second.toString().padLeft(2, '0')}';

  void _text(Canvas canvas, String s, Offset o) {
    final tp = TextPainter(
      text: TextSpan(
        text: s,
        style: const TextStyle(fontSize: 10, color: AppColors.textMuted),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, o);
  }

  @override
  bool shouldRepaint(covariant _ChartPainter old) => old.samples != samples;
}