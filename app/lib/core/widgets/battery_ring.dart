import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BatteryRing extends StatelessWidget {
  final int percent;
  final double size;
  const BatteryRing({super.key, required this.percent, this.size = 96});

  @override
  Widget build(BuildContext context) {
    final color = percent > 20 ? AppColors.green : AppColors.red;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox.expand(
            child: CircularProgressIndicator(
              value: percent / 100,
              strokeWidth: 8,
              strokeCap: StrokeCap.round,
              backgroundColor: Colors.blueGrey.shade50,
              color: color,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$percent%',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.navy,
                ),
              ),
              const Text(
                'Bateria',
                style: TextStyle(fontSize: 11, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }
}